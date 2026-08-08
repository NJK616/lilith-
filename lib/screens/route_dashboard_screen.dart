// ============================================================
// 路线主页（升级版）—— 从用户当前年级开始，支持跳学期，专业差异化任务
// 新增：任务完成追踪、暗色模式、完整profile加载
// ============================================================
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/route_data.dart';
import '../data/major_specific_tasks.dart';
import 'task_detail_screen.dart';
import 'agent_chat_screen.dart';

class RouteDashboardScreen extends StatefulWidget {
  final RoutePlan route;
  final int startSemesterIndex;
  final String userGrade;
  final String majorCategoryId;
  final String schoolTier;
  final bool wantsTransfer;
  final String? targetMajorCategory;
  final VoidCallback? onSwitchRoute; // 切换路线回调

  const RouteDashboardScreen({
    super.key,
    required this.route,
    required this.startSemesterIndex,
    required this.userGrade,
    required this.majorCategoryId,
    required this.schoolTier,
    this.wantsTransfer = false,
    this.targetMajorCategory,
    this.onSwitchRoute,
  });

  @override
  State<RouteDashboardScreen> createState() => _RouteDashboardScreenState();
}

class _RouteDashboardScreenState extends State<RouteDashboardScreen> {
  late int _selectedSemesterIndex;
  UserProfile? _fullProfile;
  Set<String> _completedTaskIds = {};
  int _totalCompleted = 0;

  final ScrollController _taskScrollController = ScrollController();

  Color get _routeColor => Color(
        int.parse(widget.route.colorHex.replaceFirst('#', '0xFF')),
      );

  @override
  void initState() {
    super.initState();
    _selectedSemesterIndex = widget.startSemesterIndex;
    _loadPersistedData();
  }

  @override
  void dispose() {
    _taskScrollController.dispose();
    super.dispose();
  }

  Future<void> _loadPersistedData() async {
    final prefs = await SharedPreferences.getInstance();

    // 加载完整profile（修复数据流失问题）
    final profileJson = prefs.getString('user_profile');
    if (profileJson != null && profileJson.isNotEmpty) {
      try {
        _fullProfile = UserProfile.fromJson(jsonDecode(profileJson));
      } catch (_) {}
    }

    // 加载已完成任务
    final completedJson = prefs.getString('completed_tasks_${widget.route.id}');
    if (completedJson != null && completedJson.isNotEmpty) {
      try {
        final list = jsonDecode(completedJson) as List;
        _completedTaskIds = list.map((e) => e.toString()).toSet();
      } catch (_) {}
    }

    // 统计已完成数
    _refreshCompletedCount();

    if (mounted) setState(() {});
  }

  void _refreshCompletedCount() {
    _totalCompleted = 0;
    for (int i = 0; i < widget.route.semesters.length; i++) {
      for (final task in _getTasksForSemester(i)) {
        final key = _taskKey(i, task.title);
        if (_completedTaskIds.contains(key)) {
          _totalCompleted++;
        }
      }
    }
  }

  String _taskKey(int semesterIndex, String taskTitle) {
    return '${widget.route.id}_${semesterIndex}_$taskTitle';
  }

  Future<void> _toggleTaskCompletion(int semesterIndex, PlanTask task) async {
    final key = _taskKey(semesterIndex, task.title);
    setState(() {
      if (_completedTaskIds.contains(key)) {
        _completedTaskIds.remove(key);
      } else {
        _completedTaskIds.add(key);
      }
    });
    _refreshCompletedCount();

    // 持久化
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'completed_tasks_${widget.route.id}',
      jsonEncode(_completedTaskIds.toList()),
    );
  }

  /// 当前学期是否已过（在用户年级之前）
  bool _isPastSemester(int index) {
    return index < widget.startSemesterIndex;
  }

  /// 获取指定学期的合并任务列表（通用 + 转专业 + 专业差异化 + 院校层次差异化）
  List<PlanTask> _getTasksForSemester(int semesterIndex) {
    return getMergedTasks(
      routeId: widget.route.id,
      semesterIndex: semesterIndex,
      majorCategoryId: widget.majorCategoryId,
      schoolTier: widget.schoolTier,
      baseSemesters: widget.route.semesters,
      wantsTransfer: widget.wantsTransfer,
      targetMajorCategory: widget.targetMajorCategory,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final semesterTasks = _getTasksForSemester(_selectedSemesterIndex);
    final isPast = _isPastSemester(_selectedSemesterIndex);

    final pastTaskCount = List.generate(widget.startSemesterIndex, (i) => i)
        .fold<int>(0, (sum, i) => sum + _getTasksForSemester(i).length);

    final totalTasks = List.generate(widget.route.semesters.length, (i) => i)
        .fold<int>(0, (sum, i) => sum + _getTasksForSemester(i).length);

    final activeSemesters = widget.route.semesters.length - widget.startSemesterIndex;
    final activeTasks = totalTasks - pastTaskCount - _totalCompleted;
    final completedInRange = _totalCompleted;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(widget.route.name),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.psychology),
            tooltip: '升学顾问',
            onPressed: () {
              final profile = _fullProfile ?? _buildFallbackProfile();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => AgentChatScreen(profile: profile),
                ),
              );
            },
          ),
          if (widget.onSwitchRoute != null)
            IconButton(
              icon: const Icon(Icons.swap_horiz),
              tooltip: '切换其他路线',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('切换路线'),
                    content: const Text('将回到路线推荐页，你可以重新选择其他路线'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('取消'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          widget.onSwitchRoute?.call();
                        },
                        child: const Text('确定'),
                      ),
                    ],
                  ),
                );
              },
            ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showRouteInfo(context),
          ),
        ],
      ),
      body: CustomScrollView(
        controller: _taskScrollController,
        slivers: [
          // 顶部概览卡片（可收缩的 pinned header）
          SliverPersistentHeader(
            pinned: true,
            delegate: _DashboardHeaderDelegate(
              isPast: isPast,
              routeColor: _routeColor,
              userGrade: widget.userGrade,
              completedInRange: completedInRange,
              activeTasks: activeTasks,
              activeSemesters: activeSemesters,
              totalTasks: totalTasks,
              totalCompleted: _totalCompleted,
              pastTaskCount: pastTaskCount,
            ),
          ),

          // 转专业提示横幅
          if (widget.wantsTransfer)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: _buildTransferBanner(isDark),
              ),
            ),

          // 学期选择器
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
              child: _buildSemesterSelector(theme),
            ),
          ),

          // 已过阶段的提示
          if (isPast)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: _buildPastHint(theme),
              ),
            ),

          // 任务列表
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final task = semesterTasks[index];
                  return _buildTaskCard(context, task, index, isPast, isDark);
                },
                childCount: semesterTasks.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建备用profile（当SharedPreferences中没有完整profile时）
  UserProfile _buildFallbackProfile() {
    return UserProfile(
      grade: widget.userGrade,
      schoolName: '',
      schoolTier: widget.schoolTier,
      major: '',
      majorCategory: widget.majorCategoryId,
      economy: '',
      value: '',
      gpa: '',
      english: '',
      isPartyMember: false,
      hasResearch: false,
      hasInternship: false,
      wantsTransfer: widget.wantsTransfer,
      targetMajorCategory: widget.targetMajorCategory,
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  static Widget buildStatItemCompact(IconData icon, String value, String label, bool expanded) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: expanded ? 24 : 16),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: expanded ? 20 : 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: expanded ? 12 : 9,
          ),
        ),
      ],
    );
  }

  Widget _buildTransferBanner(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(isDark ? 0.15 : 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.orange.withOpacity(0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.swap_horiz, color: Colors.orange[700], size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '转专业规划模式',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.orange[300] : Colors.orange[800],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.targetMajorCategory != null
                      ? '大一阶段任务已包含转专业准备（GPA冲刺 + 政策了解 + 目标专业基础）。转专业成功后，后续规划将按目标专业执行。'
                      : '大一阶段任务已包含转专业准备。建议明确目标专业以获得更精准的规划。',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.orange[200] : Colors.orange[700],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSemesterSelector(ThemeData theme) {
    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: widget.route.semesters.length,
        itemBuilder: (context, index) {
          final isSelected = index == _selectedSemesterIndex;
          final isPastSem = _isPastSemester(index);
          final s = widget.route.semesters[index];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                setState(() => _selectedSemesterIndex = index);
                _taskScrollController.jumpTo(0);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isPastSem
                      ? theme.colorScheme.surfaceContainerHighest
                      : isSelected
                          ? _routeColor
                          : theme.colorScheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isPastSem)
                      Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: Icon(Icons.check, size: 14,
                            color: theme.colorScheme.onSurfaceVariant),
                      ),
                    Text(
                      s.name,
                      style: TextStyle(
                        color: isPastSem
                            ? theme.colorScheme.onSurfaceVariant
                            : isSelected
                                ? Colors.white
                                : theme.colorScheme.onSurface,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPastHint(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(Icons.history, size: 18, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 8),
          Text(
            '此阶段在 ${widget.userGrade} 之前，仅供参考回顾',
            style: TextStyle(
                color: theme.colorScheme.onSurfaceVariant, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(
      BuildContext context, PlanTask task, int index, bool isPast, bool isDark) {
    final priorityColor = _getPriorityColor(task.priority);
    final categoryIcon = _getCategoryIcon(task.category);
    final theme = Theme.of(context);
    final key = _taskKey(_selectedSemesterIndex, task.title);
    final isCompleted = _completedTaskIds.contains(key);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Opacity(
        opacity: isPast || isCompleted ? 0.65 : 1.0,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isCompleted
                  ? Colors.green.withOpacity(0.3)
                  : theme.colorScheme.outlineVariant,
            ),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.onSurface.withOpacity(isDark ? 0.05 : 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 完成勾选框 —— 独立手势区域，不被外层拦截
               GestureDetector(
                 onTap: () => _toggleTaskCompletion(_selectedSemesterIndex, task),
                 child: Container(
                   margin: const EdgeInsets.only(right: 10, top: 2),
                   child: isCompleted
                       ? const Icon(Icons.check_box, size: 26, color: Colors.green)
                       : isPast
                           ? Icon(Icons.check_box, size: 26, color: Colors.grey[400])
                           : Icon(Icons.check_box_outline_blank, size: 26, color: _routeColor.withOpacity(0.5)),
                 ),
               ),
              // 内容区域 —— 点击进入详情页
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => TaskDetailScreen(
                          task: task,
                          semesterName: widget.route.semesters[_selectedSemesterIndex].name,
                          routeColor: isPast ? Colors.grey : _routeColor,
                        ),
                      ),
                    );
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              task.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                height: 1.3,
                                color: (isPast || isCompleted)
                                    ? theme.colorScheme.onSurfaceVariant
                                    : theme.colorScheme.onSurface,
                                decoration:
                                    isCompleted ? TextDecoration.lineThrough : null,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              task.description,
                              style: TextStyle(
                                color: theme.colorScheme.onSurfaceVariant,
                                fontSize: 13,
                                height: 1.4,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isPast || isCompleted
                                        ? Colors.grey.withOpacity(0.08)
                                        : priorityColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    task.priority + '优先级',
                                    style: TextStyle(
                                      color: isPast || isCompleted
                                          ? theme.colorScheme.onSurfaceVariant
                                          : priorityColor,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isPast || isCompleted
                                        ? Colors.grey.withOpacity(0.06)
                                        : _routeColor.withOpacity(0.06),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        categoryIcon,
                                        size: 12,
                                        color: isPast || isCompleted
                                            ? theme.colorScheme.onSurfaceVariant
                                            : _routeColor,
                                      ),
                                      const SizedBox(width: 3),
                                      Text(
                                        task.category,
                                        style: TextStyle(
                                          color: isPast || isCompleted
                                              ? theme.colorScheme.onSurfaceVariant
                                              : _routeColor,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4, top: 2),
                        child: Icon(
                          Icons.chevron_right,
                          color: theme.colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case '高': return Colors.red;
      case '中': return Colors.orange;
      case '低': return Colors.green;
      default: return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case '学习': return Icons.menu_book;
      case '技能': return Icons.build;
      case '社交': return Icons.people;
      case '申请': return Icons.send;
      default: return Icons.circle;
    }
  }

  void _showRouteInfo(BuildContext context) {
    final theme = Theme.of(context);
    final activeSemesters = widget.route.semesters.length - widget.startSemesterIndex;
    final activeTasks = List.generate(
      widget.route.semesters.length - widget.startSemesterIndex,
      (i) => widget.startSemesterIndex + i,
    ).fold<int>(0, (sum, i) => sum + _getTasksForSemester(i).length);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurfaceVariant.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.route.name,
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface),
            ),
            const SizedBox(height: 12),
            Text(
              widget.route.description,
              style: TextStyle(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: 15,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                _buildInfoChip(Icons.flag, '当前：${widget.userGrade}'),
                const SizedBox(width: 12),
                _buildInfoChip(Icons.school, '$activeSemesters 个剩余学期'),
                const SizedBox(width: 12),
                _buildInfoChip(Icons.assignment, '$activeTasks 项待完成任务'),
              ],
            ),
            const SizedBox(height: 12),
            if (_totalCompleted > 0)
              _buildInfoChip(Icons.check_circle, '已完成 $_totalCompleted 项'),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _routeColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: _routeColor),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: _routeColor,
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// SliverPersistentHeaderDelegate：顶部概览卡片，随滚动收缩
// 展开 200px → 收缩 70px
// ============================================================
class _DashboardHeaderDelegate extends SliverPersistentHeaderDelegate {
  final bool isPast;
  final Color routeColor;
  final String userGrade;
  final int completedInRange;
  final int activeTasks;
  final int activeSemesters;
  final int totalTasks;
  final int totalCompleted;
  final int pastTaskCount;

  _DashboardHeaderDelegate({
    required this.isPast,
    required this.routeColor,
    required this.userGrade,
    required this.completedInRange,
    required this.activeTasks,
    required this.activeSemesters,
    required this.totalTasks,
    required this.totalCompleted,
    required this.pastTaskCount,
  });

  @override
  double get maxExtent => 200;

  @override
  double get minExtent => 70;

  @override
  bool shouldRebuild(covariant _DashboardHeaderDelegate oldDelegate) {
    return isPast != oldDelegate.isPast ||
        routeColor != oldDelegate.routeColor ||
        userGrade != oldDelegate.userGrade ||
        completedInRange != oldDelegate.completedInRange ||
        activeTasks != oldDelegate.activeTasks ||
        activeSemesters != oldDelegate.activeSemesters ||
        totalTasks != oldDelegate.totalTasks ||
        totalCompleted != oldDelegate.totalCompleted ||
        pastTaskCount != oldDelegate.pastTaskCount;
  }

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final progress = (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);
    final expanded = progress < 0.5;

    return Container(
      height: maxExtent,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20 - progress * 14,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isPast
              ? [Colors.grey, Colors.grey.withOpacity(0.7)]
              : [routeColor, routeColor.withOpacity(0.7)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 统计行 — 始终显示
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _RouteDashboardScreenState.buildStatItemCompact(
                Icons.flag,
                userGrade,
                '当前年级',
                expanded,
              ),
              _RouteDashboardScreenState.buildStatItemCompact(
                Icons.check_circle,
                completedInRange > 0 ? '$completedInRange' : '-',
                '已完成',
                expanded,
              ),
              _RouteDashboardScreenState.buildStatItemCompact(
                Icons.assignment,
                activeTasks > 0 ? '$activeTasks' : '0',
                '待完成',
                expanded,
              ),
              _RouteDashboardScreenState.buildStatItemCompact(
                Icons.school,
                '$activeSemesters',
                '剩余学期',
                expanded,
              ),
            ],
          ),

          // 展开时显示进度条和提示
          if (expanded) ...[
            const SizedBox(height: 12),

            if (totalTasks > 0)
              Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: totalCompleted / totalTasks,
                      minHeight: 6,
                      backgroundColor: Colors.white.withOpacity(0.25),
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '总体进度 $totalCompleted/$totalTasks',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),

            if (totalTasks > 0) const SizedBox(height: 6),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.info_outline, color: Colors.white.withOpacity(0.8), size: 16),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      pastTaskCount > 0
                          ? '$userGrade之前已有 $pastTaskCount 项任务，已自动跳过'
                          : '从 $userGrade 开始，一切刚刚好',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
}