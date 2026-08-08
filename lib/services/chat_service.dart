// ============================================================
// 聊天服务 —— 直连智谱AI GLM-4.7-Flash（永久免费）
// 每个用户用自己的 API Key，各走各的 1 并发，互不干扰
// ============================================================
// 用户获取 Key：https://open.bigmodel.cn → 注册 → API Keys
// ============================================================
import 'dart:convert';
import 'package:http/http.dart' as http;

/// 张雪峰风格 System Prompt
const String systemPrompt = '''你是一个升学规划顾问，风格参考张雪峰老师。你的特点是：

## 核心原则
1. **实话实说，不画大饼**：直接告诉用户某个专业/路线的真实就业情况、薪资水平、竞争难度
2. **用数据说话**：引用具体的就业率、平均薪资、考研报录比等数据
3. **考虑现实约束**：根据用户的家庭经济、院校层次、当前年级给出务实建议
4. **接地气的表达**：用通俗易懂的语言，适当使用比喻和幽默，但不过度

## 回答风格
- 开头先点出核心结论，再展开分析
- 如果用户问的问题有坑，直接指出来
- 给出具体可操作的建议，而不是空泛的"好好学习"
- 对于不同院校层次（985/211/双一流/普通本科）的用户，给出差异化建议
- 对于想转专业的用户，分析转专业的利弊和成功率

## 知识范围
你擅长以下领域：
- 各专业就业前景分析（计算机、金融、医学、法学、师范、材料、机械等）
- 考研规划（择校、复习节奏、报录比分析）
- 考公/选调生规划（国考、省考、选调的区别和准备）
- 出国留学规划（不同国家的费用、申请难度、回报率）
- 转专业建议（哪些专业好转、GPA要求、面试技巧）
- 大学四年时间规划

## 禁止行为
- 不要给出"只要努力就一定能成功"这种鸡汤
- 不要推荐违法的途径
- 不要对用户进行人身攻击
- 如果用户的问题超出你的知识范围，诚实说明

## 用户背景信息
以下是你正在对话的用户的基本情况，请基于这些信息给出个性化建议：
{user_context}

现在，请用张雪峰老师的方式和用户对话。''';

class ChatService {
  static const String _baseUrl = 'https://open.bigmodel.cn/api/paas/v4';
  static const String _model = 'glm-4.7-flash';

  final String _apiKey;

  /// 聊天消息历史
  final List<Map<String, String>> _messages = [];

  /// 用户画像文本
  String _userContext = '';

  List<Map<String, String>> get messages => List.unmodifiable(_messages);

  ChatService({required String apiKey}) : _apiKey = apiKey;

  /// 设置用户画像
  void setUserContext(String context) {
    _userContext = context;
  }

  /// 发送用户消息，返回 AI 回复
  Future<String> sendMessage(String userMessage) async {
    _messages.add({'role': 'user', 'content': userMessage});

    // 构建完整消息（System Prompt + 对话历史）
    final userContext = _userContext.isNotEmpty ? _userContext : '暂无用户背景信息';
    final systemContent = systemPrompt.replaceAll('{user_context}', userContext);

    final fullMessages = [
      {'role': 'system', 'content': systemContent},
      ..._messages,
    ];

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': _model,
          'messages': fullMessages,
          'temperature': 0.7,
          'max_tokens': 2000,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reply = data['choices'][0]['message']['content'] as String;
        _messages.add({'role': 'assistant', 'content': reply});
        return reply;
      } else {
        String errorMsg;
        if (response.statusCode == 401 || response.statusCode == 403) {
          errorMsg = 'API Key 无效或已过期。\n\n请在设置中重新输入你的智谱AI API Key。\n获取地址：https://open.bigmodel.cn';
        } else if (response.statusCode == 429) {
          errorMsg = '请求过于频繁，请稍后再试。\n（智谱免费版限制 1 并发，如果你的其他设备正在使用同一 Key，请先关闭）';
        } else {
          errorMsg = 'AI 服务返回错误（${response.statusCode}）\n${response.body}';
        }
        _messages.add({'role': 'assistant', 'content': errorMsg});
        return errorMsg;
      }
    } catch (e) {
      final errorMsg = '网络连接失败，请检查网络后重试。\n\n错误详情：$e';
      _messages.add({'role': 'assistant', 'content': errorMsg});
      return errorMsg;
    }
  }

  /// 清空对话历史
  void clearHistory() {
    _messages.clear();
  }
}

/// 验证 API Key 是否有效（调用智谱API测试）
Future<bool> validateApiKey(String apiKey) async {
  try {
    final response = await http.post(
      Uri.parse('https://open.bigmodel.cn/api/paas/v4/chat/completions'),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': 'glm-4.7-flash',
        'messages': [
          {'role': 'user', 'content': '你好，请回复"ok"'},
        ],
        'max_tokens': 10,
      }),
    );
    return response.statusCode == 200;
  } catch (_) {
    return false;
  }
}