// ============================================================
// API Key 设置页面
// 用户输入自己的智谱AI Key，存储到本地 SharedPreferences
// 注册地址：https://open.bigmodel.cn
// ============================================================
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/chat_service.dart';

class ApiKeySettingsScreen extends StatefulWidget {
  const ApiKeySettingsScreen({super.key});

  @override
  State<ApiKeySettingsScreen> createState() => _ApiKeySettingsScreenState();
}

class _ApiKeySettingsScreenState extends State<ApiKeySettingsScreen> {
  final TextEditingController _keyController = TextEditingController();
  bool _isSaving = false;
  bool _isValidating = false;
  String? _savedKey;
  String? _statusMessage;
  bool _hasExistingKey = false;

  @override
  void initState() {
    super.initState();
    _loadExistingKey();
  }

  @override
  void dispose() {
    _keyController.dispose();
    super.dispose();
  }

  Future<void> _loadExistingKey() async {
    final prefs = await SharedPreferences.getInstance();
    final key = prefs.getString('zhipu_api_key');
    if (key != null && key.isNotEmpty) {
      setState(() {
        _savedKey = '${key.substring(0, 8)}...${key.substring(key.length - 4)}';
        _hasExistingKey = true;
      });
    }
  }

  Future<void> _saveKey() async {
    final key = _keyController.text.trim();
    if (key.isEmpty) {
      setState(() => _statusMessage = '请输入 API Key');
      return;
    }
    if (!key.contains('.')) {
      setState(() => _statusMessage = 'API Key 格式不正确，智谱的 Key 通常包含 "."');
      return;
    }

    setState(() {
      _isValidating = true;
      _statusMessage = '正在验证 Key...';
    });

    final isValid = await validateApiKey(key);

    setState(() => _isValidating = false);

    if (!isValid) {
      setState(() => _statusMessage = 'Key 验证失败，请检查是否正确复制');
      return;
    }

    setState(() => _isSaving = true);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('zhipu_api_key', key);

    setState(() {
      _isSaving = false;
      _savedKey = '${key.substring(0, 8)}...${key.substring(key.length - 4)}';
      _hasExistingKey = true;
      _statusMessage = 'Key 验证成功，已保存！';
    });

    // 延迟返回
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) Navigator.pop(context, true);
  }

  Future<void> _deleteKey() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('删除 API Key？'),
        content: const Text('删除后升学顾问功能将无法使用，需要重新设置 Key。'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('取消')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('删除')),
        ],
      ),
    );

    if (confirm == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('zhipu_api_key');
      setState(() {
        _savedKey = null;
        _hasExistingKey = false;
        _statusMessage = 'Key 已删除';
        _keyController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('设置 AI Key'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 说明卡片
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.colorScheme.primary.withOpacity(0.15)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.psychology, color: theme.colorScheme.primary, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        '升学顾问需要 AI Key',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '升学顾问功能需要调用 AI 模型来回答你的问题。\n'
                    '每个用户注册自己的智谱AI账号，获取免费的 API Key。\n'
                    '各用各的 Key，互不冲突，无需排队等待。',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14, height: 1.5),
                  ),
                  const SizedBox(height: 16),
                  _buildStep('1', '用手机浏览器打开 open.bigmodel.cn，点击右上角「注册」，输入手机号，接收验证码完成注册。（如果已有账号，直接登录即可）'),
                  _buildStep('2', '登录后进入「控制台」，点击左侧菜单「API Keys」，然后点击「创建新的 API Key」，随便填个名称（比如「升学规划」），点击「创建」'),
                  _buildStep('3', '创建成功后，页面上会显示一串以英文句点分隔的字符（类似 sk-xxxxxx.xxxxxx）。点击「复制」按钮，把这串字符完整复制下来。注意：Key 只显示一次，关闭页面后将无法再次查看'),
                  _buildStep('4', '回到本页面，把复制的 Key 粘贴到下方输入框，点击「验证并保存」。系统会自动检测 Key 是否有效，验证通过立即生效'),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 已有 Key 提示
            if (_hasExistingKey) ...[
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green[600], size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '已保存 Key：$_savedKey',
                        style: TextStyle(color: Colors.green[700], fontSize: 14),
                      ),
                    ),
                    GestureDetector(
                      onTap: _deleteKey,
                      child: Text(
                        '删除',
                        style: TextStyle(color: Colors.red[400], fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // 输入框
            TextField(
              controller: _keyController,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: '粘贴你的智谱AI API Key',
                labelText: 'API Key',
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
                contentPadding: const EdgeInsets.all(16),
              ),
              style: const TextStyle(fontSize: 15, fontFamily: 'monospace'),
            ),

            const SizedBox(height: 16),

            // 保存按钮
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: (_isSaving || _isValidating) ? null : _saveKey,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey[300],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                child: _isValidating
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : _isSaving
                        ? const Text('保存中...', style: TextStyle(fontSize: 16))
                        : const Text('验证并保存', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),

            const SizedBox(height: 12),

            // 状态提示
            if (_statusMessage != null)
              Text(
                _statusMessage!,
                style: TextStyle(
                  color: _statusMessage!.contains('成功') ? Colors.green : Colors.orange[700],
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
              ),

            const SizedBox(height: 40),

            // 底部说明
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '常见问题',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Colors.grey[800]),
                  ),
                  const SizedBox(height: 12),
                  _buildFaq(
                    '为什么要自己注册？',
                    '智谱 AI 的 GLM-4.7-Flash 模型永久免费，但每个账号有 1 个并发限制（同一时间只能处理 1 个请求）。如果大家都用同一个 Key，就会出现排队等待。每人注册自己的账号、用自己的 Key，就能各用各的，互不干扰，不用排队。',
                  ),
                  _buildFaq(
                    '注册需要花钱吗？',
                    '完全不需要。注册智谱 AI 账号不需要任何费用，也不需要绑定支付方式。GLM-4.7-Flash 模型永久免费，不消耗 token 余额。新用户注册后赠送的 2000 万 token 是给其他付费模型用的，你用免费的 Flash 模型不会扣任何 token。',
                  ),
                  _buildFaq(
                    '我的 Key 安全吗？会被别人看到吗？',
                    'Key 只保存在你的手机本地存储中，不会上传到任何第三方服务器。App 发送聊天请求时，直接从你的手机调用智谱 AI 的接口，数据不经过我们的服务器。只要你不把自己的 Key 分享给别人，就是安全的。',
                  ),
                  _buildFaq(
                    '忘记 Key 或者 Key 丢了怎么办？',
                    '如果 Key 丢失或泄露，登录智谱 AI 控制台（open.bigmodel.cn），在「API Keys」页面删除旧的 Key，重新创建一个新的，然后在本页面更新即可。旧的 Key 被删除后会立即失效。',
                  ),
                  _buildFaq(
                    '换了手机怎么办？',
                    '换了新手机需要重新设置。在新手机上安装 App 后，如果还记得之前的 Key，直接粘贴保存即可。如果忘记了，去智谱 AI 控制台重新创建一个新 Key。',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            margin: const EdgeInsets.only(top: 1),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            alignment: Alignment.center,
            child: Text(
              number,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: TextStyle(color: Colors.grey[700], fontSize: 13, height: 1.55)),
          ),
        ],
      ),
    );
  }

  Widget _buildFaq(String question, String answer) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            answer,
            style: TextStyle(color: Colors.grey[500], fontSize: 13, height: 1.55),
          ),
        ],
      ),
    );
  }
}