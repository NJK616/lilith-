// ============================================================
// 本地敏感词过滤器
// ============================================================
class ProfanityFilter {
  static final Set<String> _blockedWords = {
    // 常见违规词
    '广告', '推广', '加微信', '加QQ', '微信号', 'qq号',
    '代考', '替考', '作弊', '答案', '枪手',
    '赌博', '彩票', '下注', '投注',
    '贷款', '套现', '借钱', '高利贷',
    '刷单', '兼职', '日结', '网赚',
    '色情', '约炮', '援交',
    '翻墙', 'VPN', '代理',
    '传销', '直销', '拉人头',
    // 拼音变体
    'weixin', 'wechat', 'wx',
    'daikao', 'zuobi', 'daan',
    'huise', 'heise',
  };

  static final List<RegExp> _patterns = [
    // 手机号
    RegExp(r'1[3-9]\d{9}'),
    // QQ号
    RegExp(r'[Qq]{2}[:\s]*\d{5,}'),
    // 微信号
    RegExp(r'[Ww][Xx][:\s]*[a-zA-Z][a-zA-Z0-9_-]{5,}'),
    // URL
    RegExp(r'https?://\S+|www\.\S+'),
  ];

  /// 检查文本是否包含敏感内容
  static String? check(String text) {
    if (text.isEmpty) return null;

    final lower = text.toLowerCase();

    // 检查关键词
    for (final word in _blockedWords) {
      if (lower.contains(word.toLowerCase())) {
        return '包含违规词汇: $word';
      }
    }

    // 检查正则模式
    for (final pattern in _patterns) {
      if (pattern.hasMatch(text)) {
        return '内容包含联系方式或链接，请移除后再发布';
      }
    }

    return null;
  }

  /// 是否通过审核
  static bool isClean(String text) => check(text) == null;
}