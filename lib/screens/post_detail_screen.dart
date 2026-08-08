// ============================================================
// 帖子详情页 —— 内容 + 评论列表
// ============================================================
import 'package:flutter/material.dart';
import 'package:leancloud_storage/leancloud.dart';
import '../services/leancloud_service.dart';
import 'auth_screen.dart';

class PostDetailScreen extends StatefulWidget {
  final LCObject post;

  const PostDetailScreen({super.key, required this.post});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  List<LCObject> _comments = [];
  bool _isLoading = true;
  bool _isLiked = false;
  int _likeCount = 0;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _likeCount = widget.post['likeCount'] ?? 0;
    _loadData();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    await Future.wait([
      _loadComments(),
      _checkLike(),
    ]);
    LeanCloudService.incrementViewCount(widget.post.objectId!);
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _loadComments() async {
    final comments = await LeanCloudService.getComments(widget.post.objectId!);
    if (mounted) setState(() => _comments = comments);
  }

  Future<void> _checkLike() async {
    final liked = await LeanCloudService.isLiked(widget.post.objectId!);
    if (mounted) setState(() => _isLiked = liked);
  }

  Future<void> _toggleLike() async {
    final result = await LeanCloudService.toggleLike(widget.post.objectId!);
    if (mounted) {
      setState(() {
        _isLiked = result;
        _likeCount += result ? 1 : -1;
        _likeCount = _likeCount.clamp(0, 999999);
      });
    }
  }

  Future<void> _sendComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    if (!(await LeanCloudService.isLoggedIn)) {
      final result = await Navigator.of(context).push<bool>(
        MaterialPageRoute(builder: (_) => const AuthScreen()),
      );
      if (result != true) return;
    }

    final success = await LeanCloudService.createComment(
      postId: widget.post.objectId!,
      content: text,
    );
    if (success && mounted) {
      _commentController.clear();
      await _loadComments();
      // 更新本地帖子评论数
      final currentCount = widget.post['commentCount'] ?? 0;
      widget.post['commentCount'] = currentCount + 1;
      setState(() {});
    }
  }

  String _formatTime(DateTime? dt) {
    if (dt == null) return '';
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return '刚刚';
    if (diff.inMinutes < 60) return '${diff.inMinutes} 分钟前';
    if (diff.inHours < 24) return '${diff.inHours} 小时前';
    if (diff.inDays < 7) return '${diff.inDays} 天前';
    return '${dt.month}/${dt.day}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = widget.post['title'] ?? '';
    final content = widget.post['content'] ?? '';
    final authorName = widget.post['authorName'] ?? '匿名用户';
    final category = widget.post['category'] ?? '';
    final viewCount = widget.post['viewCount'] ?? 0;
    final commentCount = widget.post['commentCount'] ?? 0;
    final createdAt = widget.post.createdAt;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('帖子详情'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 帖子内容区
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 分类标签
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            category,
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        // 标题
                        Text(
                          title,
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, height: 1.3),
                        ),
                        const SizedBox(height: 12),
                        // 作者信息
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                              child: Icon(Icons.person, size: 18, color: theme.colorScheme.primary),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(authorName, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface)),
                                Text(
                                  _formatTime(createdAt),
                                  style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Icon(Icons.visibility_outlined, size: 14, color: Colors.grey[400]),
                            const SizedBox(width: 4),
                            Text('$viewCount', style: TextStyle(fontSize: 12, color: Colors.grey[400])),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Divider(color: Colors.grey[200]),
                        const SizedBox(height: 16),
                        // 帖子正文
                        Text(
                          content,
                          style: TextStyle(fontSize: 16, color: theme.colorScheme.onSurface, height: 1.7),
                        ),
                        const SizedBox(height: 24),
                        // 点赞按钮
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: _toggleLike,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                                decoration: BoxDecoration(
                                  color: _isLiked
                                      ? theme.colorScheme.primary.withOpacity(0.1)
                                      : Colors.grey[100],
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: _isLiked ? theme.colorScheme.primary : Colors.grey[300]!,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      _isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                                      size: 18,
                                      color: _isLiked ? theme.colorScheme.primary : Colors.grey[500],
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      '$_likeCount',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: _isLiked ? theme.colorScheme.primary : Colors.grey[500],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(color: Colors.grey[200], height: 1),

                  // 评论区
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                    child: Row(
                      children: [
                        const Icon(Icons.chat_bubble_outline, size: 18),
                        const SizedBox(width: 6),
                        Text(
                          '评论 ($commentCount)',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  if (_comments.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(40),
                      child: Center(
                        child: Text(
                          '暂无评论，来发表第一条吧',
                          style: TextStyle(color: Colors.grey[400], fontSize: 14),
                        ),
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: _comments.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        return _buildCommentItem(_comments[index], theme);
                      },
                    ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),

          // 底部评论输入
          Container(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border(top: BorderSide(color: Colors.grey[200]!)),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        hintText: '写下你的评论...',
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                        isDense: true,
                      ),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: _sendComment,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.send, color: Colors.white, size: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentItem(LCObject comment, ThemeData theme) {
    final content = comment['content'] ?? '';
    final authorName = comment['authorName'] ?? '匿名用户';
    final createdAt = comment.createdAt;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: Colors.grey[200],
          child: Icon(Icons.person, size: 16, color: Colors.grey[500]),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    authorName,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _formatTime(createdAt),
                    style: TextStyle(fontSize: 11, color: Colors.grey[400]),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                content,
                style: TextStyle(fontSize: 14, color: theme.colorScheme.onSurface, height: 1.4),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

