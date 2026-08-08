// ============================================================
// 社区主页 —— 帖子列表 + 分类筛选
// ============================================================
import 'package:flutter/material.dart';
import 'package:leancloud_storage/leancloud.dart';
import '../services/leancloud_service.dart';
import 'post_detail_screen.dart';
import 'create_post_screen.dart';
import 'auth_screen.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final List<String> _categories = ['全部', '考研', '保研', '出国', '考公', '就业', '转专业', '其他'];
  String _selectedCategory = '全部';
  List<LCObject> _posts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    setState(() => _isLoading = true);
    final posts = await LeanCloudService.getPosts(
      category: _selectedCategory,
    );
    if (mounted) {
      setState(() {
        _posts = posts;
        _isLoading = false;
      });
    }
  }

  void _switchCategory(String cat) {
    if (cat == _selectedCategory) return;
    setState(() => _selectedCategory = cat);
    _loadPosts();
  }

  Future<void> _goToCreatePost() async {
    if (!(await LeanCloudService.isLoggedIn)) {
      final result = await Navigator.of(context).push<bool>(
        MaterialPageRoute(builder: (_) => const AuthScreen()),
      );
      if (result != true) return;
    }
    if (!mounted) return;
    final created = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const CreatePostScreen()),
    );
    if (created == true) {
      _loadPosts();
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
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('经验社区', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: '发帖',
            onPressed: _goToCreatePost,
          ),
        ],
      ),
      body: Column(
        children: [
          // 分类筛选
          Container(
            height: 48,
            margin: const EdgeInsets.only(bottom: 8),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final selected = cat == _selectedCategory;
                return GestureDetector(
                  onTap: () => _switchCategory(cat),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: selected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      cat,
                      style: TextStyle(
                        color: selected ? Colors.white : theme.colorScheme.onSurface,
                        fontSize: 14,
                        fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // 帖子列表
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _posts.isEmpty
                    ? _buildEmpty(theme)
                    : RefreshIndicator(
                        onRefresh: _loadPosts,
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          itemCount: _posts.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            return _buildPostCard(_posts[index], theme);
                          },
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToCreatePost,
        child: const Icon(Icons.edit),
      ),
    );
  }

  Widget _buildEmpty(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.forum_outlined, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            '还没有帖子',
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
          ),
          const SizedBox(height: 8),
          Text(
            '来分享你的经验吧',
            style: TextStyle(fontSize: 14, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }

  Widget _buildPostCard(LCObject post, ThemeData theme) {
    final title = post['title'] ?? '';
    final content = post['content'] ?? '';
    final authorName = post['authorName'] ?? '匿名用户';
    final category = post['category'] ?? '';
    final likeCount = post['likeCount'] ?? 0;
    final commentCount = post['commentCount'] ?? 0;
    final viewCount = post['viewCount'] ?? 0;
    final createdAt = post.createdAt;

    final catColors = {
      '考研': Colors.blue,
      '保研': Colors.green,
      '出国': Colors.purple,
      '考公': Colors.orange,
      '就业': Colors.teal,
      '转专业': Colors.pink,
      '其他': Colors.grey,
    };
    final catColor = catColors[category] ?? Colors.grey;

    return GestureDetector(
      onTap: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => PostDetailScreen(post: post),
          ),
        );
        _loadPosts();
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: theme.dividerColor.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 分类标签 + 时间
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: catColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    category,
                    style: TextStyle(fontSize: 11, color: catColor, fontWeight: FontWeight.w600),
                  ),
                ),
                const Spacer(),
                Text(
                  _formatTime(createdAt),
                  style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // 标题
            Text(
              title,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, height: 1.3),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            // 内容预览
            Text(
              content,
              style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.4),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            // 底部信息栏
            Row(
              children: [
                Icon(Icons.person_outline, size: 14, color: Colors.grey[400]),
                const SizedBox(width: 4),
                Text(authorName, style: TextStyle(fontSize: 12, color: Colors.grey[400])),
                const Spacer(),
                _buildStat(Icons.visibility_outlined, '$viewCount'),
                const SizedBox(width: 12),
                _buildStat(Icons.thumb_up_outlined, '$likeCount'),
                const SizedBox(width: 12),
                _buildStat(Icons.chat_bubble_outline, '$commentCount'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.grey[400]),
        const SizedBox(width: 3),
        Text(text, style: TextStyle(fontSize: 12, color: Colors.grey[400])),
      ],
    );
  }
}