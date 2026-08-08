// ============================================================
// 数据模型 —— 定义整个 App 用到的数据结构
// ============================================================

import '../data/school_tier_database.dart';

/// 用户问卷答案（升级版：加入年级、院校层次、现状、转专业等多维度）
class UserProfile {
  final String grade;          // 大一 / 大二 / 大三 / 大四
  final String schoolName;     // 学校名称（用户自由输入）
  final String schoolTier;     // 院校层次（自动识别）：985 / 211 / 双一流 / 普通本科
  final String major;          // 具体专业名称（用户自由输入）
  final String majorCategory;  // 专业大类（数据库 id）
  final String economy;        // 家庭经济：富裕 / 中等 / 一般
  final String value;          // 看重什么：高薪 / 稳定 / 兴趣 / 社会地位
  final String gpa;            // 3.5+ / 3.0-3.5 / 3.0以下
  final String english;        // 很好 / 一般 / 不太好
  final bool isPartyMember;    // 是否已经是党员（或预备党员）
  final bool hasResearch;      // 是否有科研/实验室经历
  final bool hasInternship;    // 是否有实习经历
  final bool wantsTransfer;    // 是否想转专业（仅大一有效）
  final String? targetMajorCategory; // 目标专业大类（想转去什么专业）

  UserProfile({
    required this.grade,
    required this.schoolName,
    required this.schoolTier,
    required this.major,
    required this.majorCategory,
    required this.economy,
    required this.value,
    required this.gpa,
    required this.english,
    required this.isPartyMember,
    required this.hasResearch,
    required this.hasInternship,
    this.wantsTransfer = false,
    this.targetMajorCategory,
  });

  /// 序列化为 JSON（用于 SharedPreferences 持久化）
  Map<String, dynamic> toJson() => {
    'grade': grade,
    'schoolName': schoolName,
    'schoolTier': schoolTier,
    'major': major,
    'majorCategory': majorCategory,
    'economy': economy,
    'value': value,
    'gpa': gpa,
    'english': english,
    'isPartyMember': isPartyMember,
    'hasResearch': hasResearch,
    'hasInternship': hasInternship,
    'wantsTransfer': wantsTransfer,
    'targetMajorCategory': targetMajorCategory,
  };

  /// 从 JSON 反序列化
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      grade: json['grade'] as String? ?? '',
      schoolName: json['schoolName'] as String? ?? '',
      schoolTier: json['schoolTier'] as String? ?? '',
      major: json['major'] as String? ?? '',
      majorCategory: json['majorCategory'] as String? ?? '',
      economy: json['economy'] as String? ?? '',
      value: json['value'] as String? ?? '',
      gpa: json['gpa'] as String? ?? '',
      english: json['english'] as String? ?? '',
      isPartyMember: json['isPartyMember'] as bool? ?? false,
      hasResearch: json['hasResearch'] as bool? ?? false,
      hasInternship: json['hasInternship'] as bool? ?? false,
      wantsTransfer: json['wantsTransfer'] as bool? ?? false,
      targetMajorCategory: json['targetMajorCategory'] as String?,
    );
  }
}

/// 推荐结果 —— 每条路线附带匹配度、标签和警告
class RouteRecommendation {
  final RoutePlan route;
  final int score;                   // 0-100 匹配度
  final String matchLabel;           // 如 "强烈推荐" / "适合你" / "可考虑" / "不太推荐"
  final List<String> reasons;        // 推荐理由
  final List<String> warnings;       // 注意事项/风险提示
  final int startSemesterIndex;      // 从第几个学期开始（根据年级计算）

  RouteRecommendation({
    required this.route,
    required this.score,
    required this.matchLabel,
    required this.reasons,
    required this.warnings,
    required this.startSemesterIndex,
  });
}

/// 学期阶段
class Semester {
  final String name;         // 如 "大一上学期"
  final List<PlanTask> tasks;

  Semester({required this.name, required this.tasks});
}

/// 具体规划任务
class PlanTask {
  final String title;        // 任务标题
  final String description;  // 详细说明
  final String priority;     // 高 / 中 / 低
  final String category;     // 学习 / 技能 / 社交 / 申请
  final String detailedAdvice; // 详细建议（长文本）

  const PlanTask({
    required this.title,
    required this.description,
    required this.priority,
    required this.category,
    required this.detailedAdvice,
  });
}

/// 升学路线
class RoutePlan {
  final String id;
  final String name;         // 如 "本科就业"
  final String icon;         // 图标（Material Icons 名称）
  final String description;  // 路线简介
  final String colorHex;     // 主题色
  final List<Semester> semesters; // 每个学期的规划

  RoutePlan({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
    required this.colorHex,
    required this.semesters,
  });
}

/// 年级到学期索引的映射
int gradeToSemesterIndex(String grade) {
  switch (grade) {
    case '大一': return 0;
    case '大二': return 2;
    case '大三': return 4;
    case '大四': return 6;
    default: return 0;
  }
}