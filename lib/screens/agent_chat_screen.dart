// ============================================================
// 张雪峰风格 Agent 聊天页面
// 直连智谱AI，每个用户用自己的 Key，互不干扰
// ============================================================
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/route_data.dart';
import '../services/chat_service.dart';
import 'api_key_settings_screen.dart';

class AgentChatScreen extends StatefulWidget {
  final UserProfile profile;

  const AgentChatScreen({super.key, required this.profile});

  @override
  State<AgentChatScreen> createState() => _AgentChatScreenState();
}

class _AgentChatScreenState extends State<AgentChatScreen> {
  ChatService? _chatService;
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  bool _checkingKey = true;
  bool _hasKey = false;

  @override
  void initState() {
    super.initState();
    _checkApiKey();
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _checkApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    final key = prefs.getString('zhipu_api_key');

    if (key != null && key.isNotEmpty) {
      _chatService = ChatService(apiKey: key);
      _initChat();
      setState(() {
        _hasKey = true;
        _checkingKey = false;
      });
    } else {
      setState(() {
        _hasKey = false;
        _checkingKey = false;
      });
    }
  }

  void _initChat() {
    final p = widget.profile;
    final context = '''
- 年级：${p.grade}
- 院校：${p.schoolName}（${p.schoolTier}）
- 专业：${p.major}（${p.majorCategory}）
- GPA：${p.gpa}
- 英语水平：${p.english}
- 家庭经济：${p.economy}
- 价值观：${p.value}
- 党员：${p.isPartyMember ? '是' : '否'}
- 有科研经历：${p.hasResearch ? '是' : '否'}
- 有实习经历：${p.hasInternship ? '是' : '否'}
- 想转专业：${p.wantsTransfer ? '是（目标：${p.targetMajorCategory ?? "未指定"}）' : '否'}
''';

    _chatService!.setUserContext(context);
  }

  Future<void> _sendMessage() async {
    final text = _inputController.text.trim();
    if (text.isEmpty || _isLoading || _chatService == null) return;

    _inputController.clear();
    setState(() => _isLoading = true);

    await _chatService!.sendMessage(text);

    setState(() => _isLoading = false);
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _openSettings() async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const ApiKeySettingsScreen()),
    );
    if (result == true) {
      await _checkApiKey();
    }
  }

  /// 建议问题
  List<String> get _suggestedQuestions {
    final p = widget.profile;
    final questions = <String>[];

    if (p.wantsTransfer) {
      questions.add('我${p.major}想转到${p.targetMajorCategory ?? "其他专业"}，有什么建议？');
    }
    questions.add('${p.major}专业在${p.schoolTier}院校，走什么路线最合适？');
    questions.add('${p.grade}开始规划${p.value == "高薪" ? "就业" : p.value == "稳定" ? "考公" : "读研"}，还来得及吗？');

    return questions;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_checkingKey) {
      return Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: AppBar(title: const Text('升学顾问'), backgroundColor: Colors.transparent, elevation: 0),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (!_hasKey) {
      return _buildSetupPage(theme);
    }

    final messages = _chatService!.messages;
    final showWelcome = messages.isEmpty;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('升学顾问'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Key 设置',
            onPressed: _openSettings,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: '清空对话',
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('清空对话？'),
                  content: const Text('将清除所有聊天记录，开始新的对话'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('取消')),
                    TextButton(
                      onPressed: () {
                        _chatService!.clearHistory();
                        setState(() {});
                        Navigator.pop(ctx);
                      },
                      child: const Text('清空'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: showWelcome
                ? _buildWelcomePage(theme)
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    itemCount: messages.length + (_isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == messages.length) {
                        return _buildLoadingBubble(theme);
                      }
                      final msg = messages[index];
                      final isUser = msg['role'] == 'user';
                      return _buildMessageBubble(msg['content']!, isUser, theme);
                    },
                  ),
          ),
          _buildInputArea(theme),
        ],
      ),
    );
  }

  /// 未设置 Key 的引导页
  Widget _buildSetupPage(ThemeData theme) {
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('升学顾问'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.psychology, size: 44, color: theme.colorScheme.primary),
              ),
              const SizedBox(height: 24),
              Text(
                '开启升学顾问',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
              ),
              const SizedBox(height: 12),
              Text(
                '需要你设置一个免费的智谱AI API Key\n各用各的，互不影响，无需排队',
                style: TextStyle(color: Colors.grey[500], fontSize: 14, height: 1.5),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.withOpacity(0.2)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline, size: 18, color: Colors.orange[600]),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '注册很简单：打开 open.bigmodel.cn → 手机号注册 → 控制台创建 API Key → 复制粘贴到这里。全程免费，2 分钟搞定。',
                        style: TextStyle(color: Colors.orange[700], fontSize: 13, height: 1.5),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _openSettings,
                  icon: const Icon(Icons.vpn_key),
                  label: const Text('设置 API Key', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'GLM-4.7-Flash · 永久免费',
                style: TextStyle(color: Colors.grey[400], fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 欢迎页面（首次进入，有 Key 时）
  Widget _buildWelcomePage(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.psychology, size: 44, color: theme.colorScheme.primary),
          ),
          const SizedBox(height: 20),
          Text(
            '升学顾问 · 张雪峰风格',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
          ),
          const SizedBox(height: 8),
          Text(
            '基于你的个人情况，实话实说，给你最务实的升学建议',
            style: TextStyle(color: Colors.grey[500], fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.person, size: 18, color: Colors.grey[500]),
                    const SizedBox(width: 6),
                    Text('已读取你的画像', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey[600])),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${widget.profile.grade} · ${widget.profile.schoolTier} · ${widget.profile.major} · ${widget.profile.value}',
                  style: TextStyle(color: Colors.grey[500], fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Text('试试这些问题', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey[600])),
          const SizedBox(height: 12),
          ..._suggestedQuestions.map((q) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: GestureDetector(
                  onTap: () {
                    _inputController.text = q;
                    _sendMessage();
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Row(
                      children: [
                        Expanded(child: Text(q, style: TextStyle(color: Colors.grey[700], fontSize: 14, height: 1.3))),
                        Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey[300]),
                      ],
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  /// 聊天气泡
  Widget _buildMessageBubble(String content, bool isUser, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 36,
              height: 36,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.psychology, size: 20, color: theme.colorScheme.primary),
            ),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isUser ? theme.colorScheme.primary : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: isUser ? const Radius.circular(16) : const Radius.circular(4),
                  bottomRight: isUser ? const Radius.circular(4) : const Radius.circular(16),
                ),
                border: isUser ? null : Border.all(color: Colors.grey[200]!),
              ),
              child: isUser
                  ? Text(content, style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.5))
                  : MarkdownBody(
                      data: content,
                      selectable: true,
                      styleSheet: MarkdownStyleSheet(
                        p: TextStyle(color: Colors.grey[800], fontSize: 15, height: 1.6),
                        h2: TextStyle(color: Colors.grey[900], fontSize: 17, fontWeight: FontWeight.bold),
                        h3: TextStyle(color: Colors.grey[900], fontSize: 16, fontWeight: FontWeight.w600),
                        strong: const TextStyle(fontWeight: FontWeight.bold),
                        code: TextStyle(backgroundColor: Colors.grey[100], color: Colors.grey[800], fontSize: 13),
                        codeblockDecoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(8)),
                        listBullet: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: Colors.grey[200], shape: BoxShape.circle),
              child: Icon(Icons.person, size: 20, color: Colors.grey[500]),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLoadingBubble(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.psychology, size: 20, color: theme.colorScheme.primary),
          ),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
                bottomLeft: Radius.circular(4),
              ),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: theme.colorScheme.primary)),
                const SizedBox(width: 8),
                Text('正在思考...', style: TextStyle(color: Colors.grey[400], fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, -2))],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _inputController,
                onSubmitted: (_) => _sendMessage(),
                minLines: 1,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: '输入你的问题...',
                  filled: true,
                  fillColor: Colors.grey[50],
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                ),
                style: const TextStyle(fontSize: 15),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _isLoading ? null : _sendMessage,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _isLoading ? Colors.grey[300] : theme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}