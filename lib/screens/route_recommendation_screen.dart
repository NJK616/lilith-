// ============================================================
// 路线推荐页面（升级版）—— 展示匹配度、推荐理由、风险提示
// 新增：暗色模式、空状态处理
// ============================================================
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/route_data.dart';
import '../data/routes_data.dart';
import 'route_dashboard_screen.dart';
import 'agent_chat_screen.dart';
import 'onboarding_screen.dart';

class RouteRecommendationScreen extends StatelessWidget {
  final UserProfile profile;
  final void Function(RoutePlan route, int startSemesterIndex)? onRouteSelected;

  const RouteRecommendationScreen({
    super.key,
    required this.profile,
    this.onRouteSelected,
  });

  @override
  Widget build(BuildContext context) {
    final recommendations = recommendRoutes(profile);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('你的升学路线'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_note),
            tooltip: '修改问卷',
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('selected_route_id');
              await prefs.remove('start_semester_index');

              if (!context.mounted) return;
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => OnboardingScreen(existingProfile: profile),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.psychology),
            tooltip: '升学顾问',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => AgentChatScreen(profile: profile),
                ),
              );
            },
          ),
        ],
      ),
      body: recommendations.isEmpty
          ? _buildEmptyState(context)
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: recommendations.length,
              itemBuilder: (context, index) {
                final rec = recommendations[index];
                return _buildRecommendationCard(context, rec, index == 0);
              },
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.map,
              size: 72,
              color: theme.colorScheme.onSurfaceVariant.withOpacity(0.4),
            ),
            const SizedBox(height: 20),
            Text(
              '暂无推荐的升学路线',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '请尝试修改问卷信息，或联系升学顾问获取个性化建议',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('selected_route_id');
                if (!context.mounted) return;
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => OnboardingScreen(existingProfile: profile),
                  ),
                );
              },
              icon: const Icon(Icons.edit_note),
              label: const Text('修改问卷'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationCard(
    BuildContext context,
    RouteRecommendation rec,
    bool isTop,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final color = Color(int.parse(rec.route.colorHex.replaceFirst('#', '0xFF')));
    final scoreColor = rec.score >= 80
        ? Colors.green
        : rec.score >= 60
            ? Colors.blue
            : rec.score >= 35
                ? Colors.orange
                : Colors.red;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: () async {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('selected_route_id', rec.route.id);
          await prefs.setInt('start_semester_index', rec.startSemesterIndex);

          if (!context.mounted) return;
          if (onRouteSelected != null) {
            onRouteSelected!(rec.route, rec.startSemesterIndex);
          } else {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => RouteDashboardScreen(
                  route: rec.route,
                  startSemesterIndex: rec.startSemesterIndex,
                  userGrade: profile.grade,
                  majorCategoryId: profile.majorCategory,
                  schoolTier: profile.schoolTier,
                  wantsTransfer: profile.wantsTransfer,
                  targetMajorCategory: profile.targetMajorCategory,
                ),
              ),
            );
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isTop ? color.withOpacity(0.5) : theme.colorScheme.outlineVariant,
              width: isTop ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isTop
                    ? color.withOpacity(0.12)
                    : theme.colorScheme.onSurface.withOpacity(isDark ? 0.08 : 0.03),
                blurRadius: isTop ? 16 : 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 顶部：图标 + 名称 + 分数
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // 图标
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(_getIcon(rec.route.icon), color: color, size: 30),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      rec.route.name,
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: theme.colorScheme.onSurface,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  // 匹配度标签
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: scoreColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: scoreColor.withOpacity(0.3)),
                                    ),
                                    child: Text(
                                      rec.matchLabel,
                                      style: TextStyle(
                                        color: scoreColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                rec.route.description,
                                style: TextStyle(
                                  color: theme.colorScheme.onSurfaceVariant,
                                  fontSize: 13,
                                  height: 1.3,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // 匹配度进度条
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Text(
                          '匹配度',
                          style: TextStyle(
                              color: theme.colorScheme.onSurfaceVariant, fontSize: 13),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: rec.score / 100,
                              minHeight: 8,
                              backgroundColor: theme.colorScheme.surfaceContainerHighest,
                              valueColor: AlwaysStoppedAnimation<Color>(scoreColor),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${rec.score}%',
                          style: TextStyle(
                            color: scoreColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // 分割线
              Divider(height: 1, color: theme.colorScheme.outlineVariant),

              // 推荐理由
              if (rec.reasons.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.thumb_up_alt, size: 16, color: Colors.green),
                          const SizedBox(width: 6),
                          Text(
                            '推荐理由',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.green[700],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ...rec.reasons.map((r) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('• ',
                                    style: TextStyle(
                                        color: Colors.green, fontSize: 14)),
                                Expanded(
                                  child: Text(
                                    r,
                                    style: TextStyle(
                                      color: theme.colorScheme.onSurfaceVariant,
                                      fontSize: 13,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),

              // 风险提示
              if (rec.warnings.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.warning_amber, size: 16, color: Colors.orange),
                          const SizedBox(width: 6),
                          Text(
                            '注意事项',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.orange[300] : Colors.orange[700],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ...rec.warnings.map((w) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('• ',
                                    style: TextStyle(
                                        color: Colors.orange, fontSize: 14)),
                                Expanded(
                                  child: Text(
                                    w,
                                    style: TextStyle(
                                      color: theme.colorScheme.onSurfaceVariant,
                                      fontSize: 13,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),

              // 如果既没有理由也没有警告，加点间距
              if (rec.reasons.isEmpty && rec.warnings.isEmpty)
                const SizedBox(height: 16),

              // 底部：学期和任务标签
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildTag(
                      '从 ${profile.grade} 开始',
                      Icons.play_arrow,
                      color,
                    ),
                    _buildTag(
                      '${rec.route.semesters.length} 个学期',
                      Icons.school,
                      color,
                    ),
                    _buildTag(
                      '${rec.route.semesters.fold<int>(0, (sum, s) => sum + s.tasks.length)} 项任务',
                      Icons.assignment,
                      color,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTag(String text, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIcon(String iconName) {
    switch (iconName) {
      case 'work': return Icons.work;
      case 'school': return Icons.school;
      case 'account_balance': return Icons.account_balance;
      case 'flight': return Icons.flight;
      default: return Icons.help_outline;
    }
  }
}