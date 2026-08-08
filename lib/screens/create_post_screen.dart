// ============================================================
// 发帖页 —— 表单 + 敏感词过滤
// ============================================================
import 'package:flutter/material.dart';
import '../services/leancloud_service.dart';
import '../services/profanity_filter.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  String _selectedCategory = '考研';
  bool _isSubmitting = false;

  final List<String> _categories = ['考研', '保研', '出国', '考公', '就业', '转专业', '其他'];

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  bool get _canSubmit =>
      _titleController.text.trim().isNotEmpty &&
      _contentController.text.trim().isNotEmpty &&
      !_isSubmitting;

  Future<void> _submit() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty || content.isEmpty) return;

    // 本地敏感词过滤
    final titleCheck = ProfanityFilter.check(title);
    if (titleCheck != null) {
      _showError('标题审核不通过: $titleCheck');
      return;
    }
    final contentCheck = ProfanityFilter.check(content);
    if (contentCheck != null) {
      _showError('内容审核不通过: $contentCheck');
      return;
    }

    setState(() => _isSubmitting = true);

    final success = await LeanCloudService.createPost(
      title: title,
      content: content,
      category: _selectedCategory,
    );

    if (mounted) {
      setState(() => _isSubmitting = false);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('发布成功'), backgroundColor: Colors.green),
        );
        Navigator.of(context).pop(true);
      } else {
        _showError('发布失败，请检查网络后重试');
      }
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red[400]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('发布帖子'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _canSubmit ? _submit : null,
            child: _isSubmitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    '发布',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _canSubmit ? theme.colorScheme.primary : Colors.grey[400],
                    ),
                  ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 分类选择
            Text(
              '选择分类',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey[600]),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _categories.map((cat) {
                final selected = cat == _selectedCategory;
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = cat),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: selected
                          ? theme.colorScheme.primary.withOpacity(0.1)
                          : Colors.grey[100],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: selected ? theme.colorScheme.primary : Colors.grey[300]!,
                      ),
                    ),
                    child: Text(
                      cat,
                      style: TextStyle(
                        fontSize: 14,
                        color: selected ? theme.colorScheme.primary : Colors.grey[600],
                        fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // 标题
            Text(
              '标题',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey[600]),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _titleController,
              maxLength: 60,
              decoration: InputDecoration(
                hintText: '一句话概括你的经验/问题',
                filled: true,
                fillColor: Colors.grey[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[200]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
                ),
                contentPadding: const EdgeInsets.all(16),
                counterText: '',
              ),
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            // 内容
            Text(
              '内容',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey[600]),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _contentController,
              maxLines: 10,
              maxLength: 2000,
              decoration: InputDecoration(
                hintText: '分享你的经验，越详细对其他同学越有帮助...',
                filled: true,
                fillColor: Colors.grey[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[200]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
                ),
                contentPadding: const EdgeInsets.all(16),
                alignLabelWithHint: true,
              ),
              style: const TextStyle(fontSize: 15, height: 1.6),
            ),
            const SizedBox(height: 12),

            // 提示
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.06),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.orange.withOpacity(0.2)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, size: 16, color: Colors.orange[600]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '发布内容会经过自动审核，请勿包含联系方式、广告、违规信息',
                      style: TextStyle(fontSize: 12, color: Colors.orange[700], height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}