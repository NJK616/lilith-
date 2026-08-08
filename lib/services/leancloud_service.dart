// ============================================================
// LeanCloud 服务层 —— 社区数据存储
// 用户认证、帖子CRUD、评论
// ============================================================
import 'package:leancloud_storage/leancloud.dart';

class LeanCloudService {
  static const String _appId = 'YOUR_LEANCLOUD_APP_ID';
  static const String _appKey = 'YOUR_LEANCLOUD_APP_KEY';
  static const String _serverUrl = 'https://YOUR_APP_ID.api.lncldglobal.com';

  static bool _initialized = false;

  /// 初始化 LeanCloud SDK
  static void init() {
    if (_initialized) return;
    LeanCloud.initialize(
      _appId,
      _appKey,
      server: _serverUrl,
    );
    _initialized = true;
  }

  // =============================================
  // 用户认证
  // =============================================

  /// 当前用户（惰性获取）
  static LCUser? _currentUser;

  static Future<LCUser?> get currentUser async {
    if (_currentUser != null) return _currentUser;
    try {
      _currentUser = await LCUser.getCurrent();
      return _currentUser;
    } catch (_) {
      return null;
    }
  }

  static Future<bool> get isLoggedIn async {
    final user = await currentUser;
    return user != null;
  }

  /// 匿名登录
  static Future<LCUser?> loginAnonymously() async {
    init();
    try {
      final user = await LCUser.loginAnonymously();
      _currentUser = user;
      return user;
    } catch (e) {
      return null;
    }
  }

  /// 手机号登录
  static Future<LCUser?> loginWithPhone(String phone, String password) async {
    init();
    try {
      final user = await LCUser.loginByMobilePhoneNumber(phone, password);
      _currentUser = user;
      return user;
    } catch (e) {
      return null;
    }
  }

  /// 手机号注册（使用短信验证码）
  static Future<LCUser?> signUpWithPhone(
      String phone, String smsCode, String password) async {
    init();
    try {
      final user = await LCUser.signUpOrLoginByMobilePhone(phone, smsCode);
      _currentUser = user;
      return user;
    } catch (e) {
      return null;
    }
  }

  /// 邮箱+密码注册（手动创建用户）
  static Future<LCUser?> signUpWithEmail(
      String email, String password) async {
    init();
    try {
      final user = LCUser();
      user.username = email;
      user.password = password;
      user.email = email;
      await user.signUp();
      _currentUser = user;
      return user;
    } catch (e) {
      return null;
    }
  }

  /// 邮箱登录
  static Future<LCUser?> loginWithEmail(String email, String password) async {
    init();
    try {
      final user = await LCUser.loginByEmail(email, password);
      _currentUser = user;
      return user;
    } catch (e) {
      return null;
    }
  }

  /// 退出登录
  static Future<void> logout() async {
    try {
      await LCUser.logout();
      _currentUser = null;
    } catch (_) {}
  }

  /// 更新用户昵称
  static Future<void> updateNickname(String nickname) async {
    final user = await currentUser;
    if (user == null) return;
    try {
      user['nickname'] = nickname;
      await user.save();
    } catch (_) {}
  }

  // =============================================
  // 帖子操作
  // =============================================

  /// 发帖
  static Future<bool> createPost({
    required String title,
    required String content,
    required String category,
  }) async {
    final user = await currentUser;
    if (user == null) return false;
    try {
      final post = LCObject('Post');
      post['title'] = title;
      post['content'] = content;
      post['category'] = category;
      post['author'] = user;
      post['authorName'] = user['nickname'] ?? '匿名用户';
      post['likeCount'] = 0;
      post['commentCount'] = 0;
      post['viewCount'] = 0;
      await post.save();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// 获取帖子列表
  static Future<List<LCObject>> getPosts({
    String? category,
    int limit = 20,
    int skip = 0,
  }) async {
    init();
    try {
      final query = LCQuery('Post')
        ..include('author')
        ..orderByDescending('createdAt')
        ..limit(limit)
        ..skip(skip);
      if (category != null && category != '全部') {
        query.whereEqualTo('category', category);
      }
      return await query.find() ?? [];
    } catch (e) {
      return [];
    }
  }

  /// 获取我的帖子
  static Future<List<LCObject>> getMyPosts({int limit = 50}) async {
    final user = await currentUser;
    if (user == null) return [];
    try {
      final query = LCQuery('Post')
        ..include('author')
        ..whereEqualTo('author', user)
        ..orderByDescending('createdAt')
        ..limit(limit);
      return await query.find() ?? [];
    } catch (e) {
      return [];
    }
  }

  /// 获取单个帖子
  static Future<LCObject?> getPostById(String objectId) async {
    init();
    try {
      final query = LCQuery('Post')..include('author');
      return await query.get(objectId);
    } catch (e) {
      return null;
    }
  }

  /// 删除帖子
  static Future<bool> deletePost(String objectId) async {
    try {
      final query = LCQuery('Post');
      final post = await query.get(objectId);
      if (post != null) {
        await post.delete();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// 点赞帖子（返回 true=已赞, false=未赞）
  static Future<bool> toggleLike(String postId) async {
    final user = await currentUser;
    if (user == null) return false;
    try {
      final query = LCQuery('Post');
      final post = await query.get(postId);
      if (post == null) return false;

      final likeQuery = LCQuery('Like')
        ..whereEqualTo('post', post)
        ..whereEqualTo('user', user);
      final existingLikes = await likeQuery.find() ?? [];

      if (existingLikes.isNotEmpty) {
        await existingLikes.first.delete();
        final currentCount = post['likeCount'] ?? 0;
        post['likeCount'] = (currentCount - 1).clamp(0, 999999);
        await post.save();
        return false;
      } else {
        final like = LCObject('Like');
        like['post'] = post;
        like['user'] = user;
        await like.save();
        final currentCount = post['likeCount'] ?? 0;
        post['likeCount'] = currentCount + 1;
        await post.save();
        return true;
      }
    } catch (e) {
      return false;
    }
  }

  /// 检查是否已点赞
  static Future<bool> isLiked(String postId) async {
    final user = await currentUser;
    if (user == null) return false;
    try {
      final query = LCQuery('Post');
      final post = await query.get(postId);
      if (post == null) return false;

      final likeQuery = LCQuery('Like')
        ..whereEqualTo('post', post)
        ..whereEqualTo('user', user);
      final likes = await likeQuery.find() ?? [];
      return likes.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// 增加浏览次数
  static Future<void> incrementViewCount(String postId) async {
    try {
      final query = LCQuery('Post');
      final post = await query.get(postId);
      if (post != null) {
        post['viewCount'] = (post['viewCount'] ?? 0) + 1;
        await post.save();
      }
    } catch (_) {}
  }

  // =============================================
  // 评论操作
  // =============================================

  /// 发表评论
  static Future<bool> createComment({
    required String postId,
    required String content,
  }) async {
    final user = await currentUser;
    if (user == null) return false;
    try {
      final query = LCQuery('Post');
      final post = await query.get(postId);
      if (post == null) return false;

      final comment = LCObject('Comment');
      comment['content'] = content;
      comment['post'] = post;
      comment['author'] = user;
      comment['authorName'] = user['nickname'] ?? '匿名用户';
      await comment.save();

      post['commentCount'] = (post['commentCount'] ?? 0) + 1;
      await post.save();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// 获取帖子评论
  static Future<List<LCObject>> getComments(String postId,
      {int limit = 50}) async {
    init();
    try {
      final query = LCQuery('Post');
      final post = await query.get(postId);
      if (post == null) return [];

      final commentQuery = LCQuery('Comment')
        ..include('author')
        ..whereEqualTo('post', post)
        ..orderByAscending('createdAt')
        ..limit(limit);
      return await commentQuery.find() ?? [];
    } catch (e) {
      return [];
    }
  }

  /// 删除评论
  static Future<bool> deleteComment(String commentId) async {
    try {
      final query = LCQuery('Comment');
      final comment = await query.get(commentId);
      if (comment != null) {
        await comment.delete();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}