// ============================================================
// 任务详情页 — 查看每项任务的详细建议
// 新增：暗色模式支持
// ============================================================
import 'package:flutter/material.dart';
import '../models/route_data.dart';

class TaskDetailScreen extends StatelessWidget {
  final PlanTask task;
  final String semesterName;
  final Color routeColor;

  const TaskDetailScreen({
    super.key,
    required this.task,
    required this.semesterName,
    required this.routeColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final priorityColor = _getPriorityColor(task.priority);
    final categoryIcon = _getCategoryIcon(task.category);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('任务详情'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 学期标签
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: routeColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                semesterName,
                style: TextStyle(
                  color: routeColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 任务标题
            Text(
              task.title,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                height: 1.3,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),

            // 简介
            Text(
              task.description,
              style: TextStyle(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: 16,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),

            // 标签行
            Row(
              children: [
                // 优先级
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: priorityColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: priorityColor.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.flag, size: 16, color: priorityColor),
                      const SizedBox(width: 6),
                      Text(
                        task.priority + '优先级',
                        style: TextStyle(
                          color: priorityColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // 分类
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: routeColor.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: routeColor.withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(categoryIcon, size: 16, color: routeColor),
                      const SizedBox(width: 6),
                      Text(
                        task.category,
                        style: TextStyle(
                          color: routeColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // 详细建议标题
            Row(
              children: [
                Icon(Icons.lightbulb_outline, color: routeColor, size: 22),
                const SizedBox(width: 8),
                Text(
                  '详细建议',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: routeColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 详细建议内容
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.colorScheme.outlineVariant),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.onSurface.withOpacity(0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                task.detailedAdvice,
                style: TextStyle(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontSize: 15,
                  height: 1.8,
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
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
}