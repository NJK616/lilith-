// ============================================================
// 问卷页面（升级版）—— 收集用户现状 + 院校 + 意愿 + 转专业，智能分流
// 问题顺序：年级 → 院校 → 专业 → 大类 → [转专业意愿(仅大一)] → [目标专业(若想转)] → GPA → 英语 → 经济 → 价值观 → 现状
// ============================================================
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/route_data.dart';
import '../data/major_database.dart';
import '../data/school_tier_database.dart';
import 'main_shell.dart';

class OnboardingScreen extends StatefulWidget {
  /// 编辑模式：传入已有 profile 可预填所有字段
  final UserProfile? existingProfile;

  const OnboardingScreen({super.key, this.existingProfile});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // 用户答案
  String _grade = '';
  String _schoolName = '';     // 学校名称（自由输入）
  String _schoolTier = '';     // 院校层次（自动识别）
  String _major = '';          // 专业名称（自由输入）
  String _majorCategory = '';  // 专业大类
  String _wantsTransfer = '';  // 转专业意愿：stay / transfer / unsure
  String _targetMajorCategory = ''; // 目标专业大类
  String _gpa = '';
  String _english = '';
  String _economy = '';
  String _value = '';
  bool _isPartyMember = false;
  bool _hasResearch = false;
  bool _hasInternship = false;

  // 输入框控制器
  final TextEditingController _schoolController = TextEditingController();
  final TextEditingController _majorController = TextEditingController();
  final TextEditingController _targetMajorSearchController = TextEditingController();
  String _targetMajorSearchQuery = '';

  @override
  void initState() {
    super.initState();
    _initFromProfile();
  }

  void _initFromProfile() {
    final p = widget.existingProfile;
    if (p == null) return;
    _grade = p.grade;
    _schoolName = p.schoolName;
    _schoolTier = p.schoolTier;
    _major = p.major;
    _majorCategory = p.majorCategory;
    _economy = p.economy;
    _value = p.value;
    _gpa = p.gpa;
    _english = p.english;
    _isPartyMember = p.isPartyMember;
    _hasResearch = p.hasResearch;
    _hasInternship = p.hasInternship;
    _wantsTransfer = p.wantsTransfer ? 'transfer' : 'stay';
    _targetMajorCategory = p.targetMajorCategory ?? '';
    _schoolController.text = p.schoolName;
    _majorController.text = p.major;
  }

  @override
  void dispose() {
    _schoolController.dispose();
    _majorController.dispose();
    _targetMajorSearchController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _goBack() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
      setState(() => _currentPage--);
    }
  }

  // =============================================
  // 动态页面列表（根据年级决定是否显示转专业相关页面）
  // =============================================
  List<String> get _steps {
    final steps = <String>['grade', 'schoolName', 'majorName'];
    // 只有大一/准大一用户才看到转专业选项
    if (_grade == '大一') {
      steps.add('transferIntention');
      if (_wantsTransfer == 'transfer') {
        steps.add('targetMajor');
      }
    }
    steps.addAll(['gpa', 'english', 'economy', 'value', 'status']);
    return steps;
  }

  String get _currentStep => _currentPage < _steps.length ? _steps[_currentPage] : '';

  int get _totalPages => _steps.length;

  bool _canProceed() {
    switch (_currentStep) {
      case 'grade': return _grade.isNotEmpty;
      case 'schoolName': return _schoolName.isNotEmpty;
      case 'majorName': return _major.isNotEmpty && isOfficialMajor(_major);
      case 'transferIntention': return _wantsTransfer.isNotEmpty;
      case 'targetMajor': return _targetMajorCategory.isNotEmpty;
      case 'gpa': return _gpa.isNotEmpty;
      case 'english': return _english.isNotEmpty;
      case 'economy': return _economy.isNotEmpty;
      case 'value': return _value.isNotEmpty;
      case 'status': return true;
      default: return false;
    }
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
      setState(() => _currentPage++);
    } else {
      _finishOnboarding();
    }
  }

  void _finishOnboarding() async {
    final tier = detectSchoolTier(_schoolName);
    final profile = UserProfile(
      grade: _grade,
      schoolName: _schoolName,
      schoolTier: tier.label,
      major: _major,
      majorCategory: _majorCategory,
      economy: _economy,
      value: _value,
      gpa: _gpa,
      english: _english,
      isPartyMember: _isPartyMember,
      hasResearch: _hasResearch,
      hasInternship: _hasInternship,
      wantsTransfer: _wantsTransfer == 'transfer',
      targetMajorCategory: _wantsTransfer == 'transfer' && _targetMajorCategory.isNotEmpty
          ? _targetMajorCategory
          : null,
    );

    // 持久化保存到 SharedPreferences
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_profile', jsonEncode(profile.toJson()));
    } catch (_) {
      // 保存失败不影响主流程
    }

    if (!mounted) return;

    // 编辑模式：保存后直接返回
    if (widget.existingProfile != null) {
      Navigator.of(context).pop(true);
      return;
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => MainShell(profile: profile),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = _totalPages > 0 ? (_currentPage + 1) / _totalPages : 0.0;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // 进度条
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '第 ${_currentPage + 1} / $_totalPages 步',
                        style: TextStyle(color: Colors.grey[500], fontSize: 14),
                      ),
                      if (_currentPage > 0)
                        GestureDetector(
                          onTap: _goBack,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.arrow_back, size: 16, color: Colors.grey[500]),
                              const SizedBox(width: 4),
                              Text(
                                '上一步',
                                style: TextStyle(color: Colors.grey[500], fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 6,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                    ),
                  ),
                ],
              ),
            ),

            // 页面内容（动态构建）
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: _buildPages(theme),
              ),
            ),

            // 底部按钮
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _canProceed() ? _nextPage : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey[300],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: Text(
                    _currentPage == _totalPages - 1 ? '查看推荐路线' : '下一步',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 动态构建页面列表
  List<Widget> _buildPages(ThemeData theme) {
    final pages = <Widget>[
      _buildGradePage(theme),
      _buildSchoolNamePage(theme),
      _buildMajorNamePage(theme),
    ];

    // 大一专属：转专业意愿
    if (_grade == '大一') {
      pages.add(_buildTransferIntentionPage(theme));
      if (_wantsTransfer == 'transfer') {
        pages.add(_buildTargetMajorPage(theme));
      }
    }

    pages.addAll([
      _buildGpaPage(theme),
      _buildEnglishPage(theme),
      _buildEconomyPage(theme),
      _buildValuePage(theme),
      _buildStatusPage(theme),
    ]);

    return pages;
  }

  // =============================================
  // 第 1 步：当前年级
  // =============================================
  Widget _buildGradePage(ThemeData theme) {
    return _buildQuestionPage(
      title: '你目前大几？',
      subtitle: '这决定了你能从哪个阶段开始规划',
      children: [
        _buildOption('大一', '刚入学，一切从零开始', Icons.school, _grade, theme),
        _buildOption('大二', '已适应大学，开始思考未来', Icons.auto_stories, _grade, theme),
        _buildOption('大三', '关键十字路口，需要做决定', Icons.turn_sharp_right, _grade, theme),
        _buildOption('大四', '即将毕业，需要紧急规划', Icons.flag, _grade, theme),
      ],
    );
  }

  // =============================================
  // 第 2 步：学校名称（自动识别层次）
  // =============================================
  Widget _buildSchoolNamePage(ThemeData theme) {
    final tierDetected = _schoolName.isNotEmpty ? detectSchoolTier(_schoolName) : null;
    final tierLabel = tierDetected?.label ?? '';
    final tierColor = switch (tierLabel) {
      '985' => Colors.red,
      '211' => Colors.blue,
      '双一流' => Colors.purple,
      _ => Colors.grey,
    };

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text(
            '你就读于哪所大学？',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, height: 1.3),
          ),
          const SizedBox(height: 8),
          Text(
            '输入学校全称，系统会自动识别院校层次',
            style: TextStyle(color: Colors.grey[500], fontSize: 16),
          ),
          const SizedBox(height: 40),
          TextField(
            controller: _schoolController,
            autofocus: true,
            onChanged: (v) {
              setState(() => _schoolName = v);
              if (v.isNotEmpty) {
                _schoolTier = detectSchoolTier(v).label;
              }
            },
            decoration: InputDecoration(
              hintText: '输入大学全称，如"北京大学""南京理工大学"',
              filled: true,
              fillColor: Colors.grey[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.grey[200]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
              ),
              contentPadding: const EdgeInsets.all(20),
            ),
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 16),
          // 自动识别结果展示
          if (_schoolName.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: tierColor.withOpacity(0.06),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: tierColor.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Icon(Icons.auto_awesome, color: tierColor, size: 20),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '识别结果：$tierLabel 高校',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: tierColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        tierDetected == SchoolTier.normal
                            ? '未在985/211/双一流名单中，识别为普通本科'
                            : '已自动识别，这将影响后续所有推荐和规划',
                        style: TextStyle(color: Colors.grey[500], fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // =============================================
  // 第 3 步：专业名称（自动识别大类）
  // =============================================
  Widget _buildMajorNamePage(ThemeData theme) {
    MajorCategoryEntry? detectedEntry;
    if (_major.isNotEmpty) {
      final catId = detectMajorCategory(_major);
      if (catId != null) {
        detectedEntry = findMajorEntry(catId);
      }
    }
    // 自动设置大类
    if (detectedEntry != null) {
      _majorCategory = detectedEntry.id;
    }

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text(
            '你的专业是什么？',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, height: 1.3),
          ),
          const SizedBox(height: 8),
          Text(
            '输入具体专业名称，系统会自动识别专业大类',
            style: TextStyle(color: Colors.grey[500], fontSize: 16),
          ),
          const SizedBox(height: 40),
          TextField(
            controller: _majorController,
            autofocus: true,
            onChanged: (v) {
              setState(() {
                _major = v;
                if (v.isNotEmpty) {
                  final catId = detectMajorCategory(v);
                  _majorCategory = catId ?? '';
                } else {
                  _majorCategory = '';
                }
              });
            },
            decoration: InputDecoration(
              hintText: '输入你的专业名称，如"计算机科学与技术""会计学"',
              filled: true,
              fillColor: Colors.grey[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.grey[200]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
              ),
              contentPadding: const EdgeInsets.all(20),
            ),
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 16),
          // 自动识别结果展示
          if (_major.isNotEmpty) ...[
            if (detectedEntry != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.colorScheme.primary.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.auto_awesome, color: theme.colorScheme.primary, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '已识别：${detectedEntry.name}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '包含：${detectedEntry.examples}',
                            style: TextStyle(color: Colors.grey[500], fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            else
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.cancel_outlined, color: Colors.red[600], size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '该专业不在教育部官方目录中',
                            style: TextStyle(
                              color: Colors.red[700],
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '请输入教育部《普通高等学校本科专业目录（2026年）》中的标准专业名称（共883个专业）。如"计算机科学与技术"而非"计科"。',
                            style: TextStyle(color: Colors.red[500], fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }

  // =============================================
  // 第 4 步（大一专属）：转专业意愿
  // =============================================
  Widget _buildTransferIntentionPage(ThemeData theme) {
    return _buildQuestionPage(
      title: '你对当前专业满意吗？',
      subtitle: '大一上学期末通常有转专业机会，提前了解有助于规划',
      children: [
        _buildOption(
          '满意，打算在本专业发展',
          '专注本专业，按照选定路线全力前进',
          Icons.thumb_up_alt,
          _wantsTransfer,
          theme,
          value: 'stay',
        ),
        _buildOption(
          '想转专业',
          '大一下学期申请转专业，需要提前准备',
          Icons.swap_horiz,
          _wantsTransfer,
          theme,
          value: 'transfer',
        ),
        _buildOption(
          '不确定，先看看',
          '先按本专业规划，大一结束时再决定',
          Icons.help_outline,
          _wantsTransfer,
          theme,
          value: 'unsure',
        ),
      ],
    );
  }

  // =============================================
  // 第 5 步（大一专属）：目标专业选择（带搜索）
  // =============================================
  Widget _buildTargetMajorPage(ThemeData theme) {
    // 过滤选项
    final allEntries = majorDatabase.where((e) => e.id != _majorCategory).toList();
    final filteredEntries = _targetMajorSearchQuery.isEmpty
        ? allEntries
        : allEntries.where((e) {
            final query = _targetMajorSearchQuery.toLowerCase();
            return e.name.toLowerCase().contains(query) ||
                e.examples.toLowerCase().contains(query);
          }).toList();

    // 图标映射
    IconData _iconForId(String id) {
      switch (id) {
        case 'medical': return Icons.medical_services;
        case 'law': return Icons.balance;
        case 'architecture': return Icons.architecture;
        case 'civil': return Icons.engineering;
        case 'education': return Icons.cast_for_education;
        case 'journalism': return Icons.newspaper;
        case 'foreign_language': return Icons.translate;
        case 'basic_science': return Icons.science;
        case 'economics': return Icons.trending_up;
        case 'accounting': return Icons.calculate;
        case 'mechanical': return Icons.precision_manufacturing;
        case 'cs': return Icons.computer;
        case 'electronics': return Icons.memory;
        case 'materials': return Icons.biotech;
        case 'electrical': return Icons.electric_bolt;
        case 'pharmacy': return Icons.medication;
        case 'nursing': return Icons.health_and_safety;
        case 'management': return Icons.business;
        case 'art': return Icons.palette;
        case 'agriculture': return Icons.eco;
        case 'history': return Icons.menu_book;
        case 'philosophy': return Icons.lightbulb;
        case 'chinese_literature': return Icons.auto_stories;
        case 'transportation': return Icons.flight;
        case 'environment': return Icons.eco;
        case 'cross_disciplinary': return Icons.hub;
        default: return Icons.school;
      }
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          const Text(
            '你想转到哪个专业大类？',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, height: 1.3),
          ),
          const SizedBox(height: 6),
          Text(
            '选择目标专业，系统将为你规划转专业路径',
            style: TextStyle(color: Colors.grey[500], fontSize: 15),
          ),
          const SizedBox(height: 16),

          // 搜索框
          TextField(
            controller: _targetMajorSearchController,
            onChanged: (v) => setState(() => _targetMajorSearchQuery = v),
            decoration: InputDecoration(
              hintText: '搜索专业大类，如"计算机""医学"',
              prefixIcon: const Icon(Icons.search, size: 22),
              suffixIcon: _targetMajorSearchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 20),
                      onPressed: () {
                        _targetMajorSearchController.clear();
                        setState(() => _targetMajorSearchQuery = '');
                      },
                    )
                  : null,
              filled: true,
              fillColor: Colors.grey[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.grey[200]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
          const SizedBox(height: 12),

          // 已选提示
          if (_targetMajorCategory.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle, size: 18, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    '已选择: ${majorDatabase.firstWhere((e) => e.id == _targetMajorCategory).name}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],

          // 可滚动选项列表
          Expanded(
            child: filteredEntries.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 48, color: Colors.grey[300]),
                        const SizedBox(height: 12),
                        Text(
                          '没有匹配的专业大类',
                          style: TextStyle(color: Colors.grey[400], fontSize: 14),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '试试其他关键词',
                          style: TextStyle(color: Colors.grey[300], fontSize: 12),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 8),
                    itemCount: filteredEntries.length,
                    itemBuilder: (context, index) {
                      final entry = filteredEntries[index];
                      final isSelected = entry.id == _targetMajorCategory;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: GestureDetector(
                          onTap: () => setState(() => _targetMajorCategory = entry.id),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? theme.colorScheme.primaryContainer
                                  : Colors.grey[50],
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isSelected
                                    ? theme.colorScheme.primary
                                    : Colors.grey[200]!,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? theme.colorScheme.primary.withOpacity(0.15)
                                        : Colors.grey[100],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    _iconForId(entry.id),
                                    size: 22,
                                    color: isSelected
                                        ? theme.colorScheme.primary
                                        : Colors.grey[500],
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        entry.name,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: isSelected
                                              ? theme.colorScheme.primary
                                              : theme.colorScheme.onSurface,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        entry.examples,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[500],
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                if (isSelected)
                                  Icon(Icons.check_circle, color: theme.colorScheme.primary, size: 22),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // ============================================
  // 第 4 步：GPA
  // =============================================
  Widget _buildGpaPage(ThemeData theme) {
    return _buildQuestionPage(
      title: '你的 GPA 水平？',
      subtitle: '绩点影响保研、留学申请和部分大厂校招',
      children: [
        _buildOption('3.5+', '3.5 以上（优秀）', Icons.emoji_events, _gpa, theme),
        _buildOption('3.0-3.5', '3.0 到 3.5（中等偏上）', Icons.trending_up, _gpa, theme),
        _buildOption('3.0以下', '3.0 以下（需要提升）', Icons.trending_down, _gpa, theme),
        _buildOption('暂无成绩', '大一新生，还没出过成绩', Icons.help_outline, _gpa, theme),
      ],
    );
  }

  // =============================================
  // 第 5 步：英语水平
  // =============================================
  Widget _buildEnglishPage(ThemeData theme) {
    return _buildQuestionPage(
      title: '你的英语水平？',
      subtitle: '影响出国留学和部分外企就业',
      children: [
        _buildOption('很好', 'CET-6 550+ / 雅思 6.5+ / 托福 90+', Icons.translate, _english, theme),
        _buildOption('一般', '过了 CET-4，日常阅读没问题', Icons.mic, _english, theme),
        _buildOption('不太好', '正在努力提升中', Icons.sentiment_neutral, _english, theme),
        _buildOption('暂时无法评估', '准大一/大一新生，还没考过四六级', Icons.help_outline, _english, theme),
      ],
    );
  }

  // =============================================
  // 第 6 步：家庭经济
  // =============================================
  Widget _buildEconomyPage(ThemeData theme) {
    return _buildQuestionPage(
      title: '家庭经济情况？',
      subtitle: '影响出国留学、考研报班等经济投入',
      children: [
        _buildOption('富裕', '可以支持留学等大额支出', Icons.savings, _economy, theme),
        _buildOption('中等', '可以支持国内读研，留学需精打细算', Icons.account_balance_wallet, _economy, theme),
        _buildOption('一般', '需要优先考虑经济实惠的路线', Icons.attach_money, _economy, theme),
      ],
    );
  }

  // =============================================
  // 第 7 步：价值观
  // =============================================
  Widget _buildValuePage(ThemeData theme) {
    return _buildQuestionPage(
      title: '你更看重什么？',
      subtitle: '选择最在意的核心价值观',
      children: [
        _buildOption('高薪', '希望获得较高的经济回报', Icons.monetization_on, _value, theme),
        _buildOption('稳定', '希望工作稳定、有保障', Icons.shield, _value, theme),
        _buildOption('兴趣', '希望做自己真正喜欢的事情', Icons.favorite, _value, theme),
        _buildOption('社会地位', '希望获得社会认可和尊重', Icons.star, _value, theme),
      ],
    );
  }

  // =============================================
  // 第 8 步：当前现状
  // =============================================
  Widget _buildStatusPage(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text(
            '你目前的现状？',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, height: 1.3),
          ),
          const SizedBox(height: 8),
          Text(
            '如实选择，这会影响不同路线的推荐度',
            style: TextStyle(color: Colors.grey[500], fontSize: 16),
          ),
          const SizedBox(height: 40),

          // 是否党员
          _buildSwitchTile(
            icon: Icons.flag,
            title: '是否已经是党员（或预备党员）？',
            subtitle: '党员身份对考公选调有明显优势',
            value: _isPartyMember,
            onChanged: (v) => setState(() => _isPartyMember = v),
            theme: theme,
          ),
          const SizedBox(height: 20),

          // 是否有科研
          _buildSwitchTile(
            icon: Icons.biotech,
            title: '是否有科研/实验室经历？',
            subtitle: '科研经历对考研复试和留学申请有帮助',
            value: _hasResearch,
            onChanged: (v) => setState(() => _hasResearch = v),
            theme: theme,
          ),
          const SizedBox(height: 20),

          // 是否有实习
          _buildSwitchTile(
            icon: Icons.work_history,
            title: '是否有实习经历？',
            subtitle: '实习经历对求职和秋招有直接帮助',
            value: _hasInternship,
            onChanged: (v) => setState(() => _hasInternship = v),
            theme: theme,
          ),
        ],
      ),
    );
  }

  // =============================================
  // 通用组件
  // =============================================

  Widget _buildQuestionPage({
    required String title,
    required String subtitle,
    required List<Widget> children,
  }) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, height: 1.3)),
          const SizedBox(height: 8),
          Text(subtitle, style: TextStyle(color: Colors.grey[500], fontSize: 16)),
          const SizedBox(height: 40),
          ...children,
        ],
      ),
    );
  }

  Widget _buildOption(
    String label,
    String description,
    IconData icon,
    String selectedValue,
    ThemeData theme, {
    String? value,
    String? warning,
    bool disabled = false,
  }) {
    final optionValue = value ?? label;
    final isSelected = optionValue == selectedValue;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: disabled ? null : () {
          switch (_currentStep) {
            case 'grade': setState(() => _grade = optionValue); break;
            case 'transferIntention': setState(() => _wantsTransfer = optionValue); break;
            case 'targetMajor': setState(() => _targetMajorCategory = optionValue); break;
            case 'gpa': setState(() => _gpa = optionValue); break;
            case 'english': setState(() => _english = optionValue); break;
            case 'economy': setState(() => _economy = optionValue); break;
            case 'value': setState(() => _value = optionValue); break;
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: disabled
                ? Colors.grey[100]
                : isSelected
                    ? theme.colorScheme.primaryContainer
                    : Colors.grey[50],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: disabled
                  ? Colors.grey[200]!
                  : isSelected
                      ? theme.colorScheme.primary
                      : Colors.grey[200]!,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: disabled
                    ? Colors.grey[300]
                    : isSelected
                        ? theme.colorScheme.primary
                        : Colors.grey[400],
                size: 28,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        color: disabled
                            ? Colors.grey[400]
                            : isSelected
                                ? theme.colorScheme.primary
                                : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 13,
                        color: disabled
                            ? Colors.grey[300]
                            : isSelected
                                ? theme.colorScheme.primary.withOpacity(0.7)
                                : Colors.grey[400],
                      ),
                    ),
                    if (warning != null) ...[
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          warning,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.orange[700],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (isSelected)
                Icon(Icons.check_circle, color: theme.colorScheme.primary),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required void Function(bool) onChanged,
    required ThemeData theme,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: value ? theme.colorScheme.primary.withOpacity(0.3) : Colors.grey[200]!,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: value ? theme.colorScheme.primary.withOpacity(0.1) : Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: value ? theme.colorScheme.primary : Colors.grey[400],
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                Text(subtitle, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: theme.colorScheme.primary,
          ),
        ],
      ),
    );
  }
}