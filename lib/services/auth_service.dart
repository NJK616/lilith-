// ============================================================
// 本地账号服务 —— 基于 SharedPreferences 的账号体系
// 支持邮箱注册/登录、密码哈希、昵称管理、头像
// ============================================================
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 本地用户模型
class AppUser {
  final String id;
  final String email;
  final String nickname;
  final String passwordHash;
  final DateTime createdAt;
  final String? avatarPath; // 头像本地路径
  final bool isGuest; // 是否游客

  AppUser({
    required this.id,
    required this.email,
    required this.nickname,
    required this.passwordHash,
    required this.createdAt,
    this.avatarPath,
    this.isGuest = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'nickname': nickname,
    'passwordHash': passwordHash,
    'createdAt': createdAt.toIso8601String(),
    'avatarPath': avatarPath,
    'isGuest': isGuest,
  };

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
    id: json['id'] as String,
    email: json['email'] as String,
    nickname: json['nickname'] as String,
    passwordHash: json['passwordHash'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String),
    avatarPath: json['avatarPath'] as String?,
    isGuest: json['isGuest'] as bool? ?? false,
  );

  AppUser copyWith({
    String? avatarPath,
    String? nickname,
    String? passwordHash,
    String? email,
    bool? isGuest,
  }) {
    return AppUser(
      id: id,
      email: email ?? this.email,
      nickname: nickname ?? this.nickname,
      passwordHash: passwordHash ?? this.passwordHash,
      createdAt: createdAt,
      avatarPath: avatarPath ?? this.avatarPath,
      isGuest: isGuest ?? this.isGuest,
    );
  }
}

class AuthService {
  static const String _accountsKey = 'local_accounts';
  static const String _currentUserIdKey = 'current_user_id';

  /// 简单的密码哈希（本地使用，非生产级安全）
  static String _hashPassword(String password) {
    const salt = 'lilith_2024_salt';
    final combined = '$salt$password';
    int hash = 0;
    for (int i = 0; i < combined.length; i++) {
      hash = ((hash << 5) - hash) + combined.codeUnitAt(i);
      hash = hash & hash;
    }
    return hash.toRadixString(16);
  }

  /// 生成随机ID
  static String _generateId() {
    final random = Random();
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    return List.generate(16, (_) => chars[random.nextInt(chars.length)]).join();
  }

  /// 获取所有账号
  static Future<List<AppUser>> _getAllAccounts() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_accountsKey);
    if (jsonStr == null || jsonStr.isEmpty) return [];
    try {
      final list = jsonDecode(jsonStr) as List;
      return list.map((e) => AppUser.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  /// 保存所有账号
  static Future<void> _saveAllAccounts(List<AppUser> accounts) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = jsonEncode(accounts.map((a) => a.toJson()).toList());
    await prefs.setString(_accountsKey, jsonStr);
  }

  /// 获取头像存储目录
  static Future<Directory> get _avatarDir async {
    final dir = await getApplicationDocumentsDirectory();
    final avatarDir = Directory('${dir.path}/avatars');
    if (!await avatarDir.exists()) {
      await avatarDir.create(recursive: true);
    }
    return avatarDir;
  }

  /// 保存头像文件，返回路径（覆盖已存在的旧头像）
  static Future<String?> saveAvatarFile(File sourceFile, String userId) async {
    try {
      final dir = await _avatarDir;
      final targetPath = '${dir.path}/avatar_$userId.jpg';
      final target = File(targetPath);
      if (await target.exists()) {
        await target.delete();
      }
      await sourceFile.copy(targetPath);
      return targetPath;
    } catch (_) {
      return null;
    }
  }

  /// 更新当前用户头像
  static Future<void> updateAvatar(File sourceFile) async {
    final user = await currentUser;
    if (user == null) return;

    final path = await saveAvatarFile(sourceFile, user.id);
    if (path == null) return;

    final accounts = await _getAllAccounts();
    final index = accounts.indexWhere((a) => a.id == user.id);
    if (index == -1) return;

    accounts[index] = user.copyWith(avatarPath: path);
    await _saveAllAccounts(accounts);
  }

  /// 注册新账号
  static Future<String?> register({
    required String email,
    required String password,
    required String nickname,
  }) async {
    final accounts = await _getAllAccounts();

    if (accounts.any((a) => a.email.toLowerCase() == email.toLowerCase())) {
      return '该邮箱已被注册';
    }

    if (password.length < 6) {
      return '密码至少6位';
    }

    final user = AppUser(
      id: _generateId(),
      email: email.trim().toLowerCase(),
      nickname: nickname.trim(),
      passwordHash: _hashPassword(password),
      createdAt: DateTime.now(),
    );

    accounts.add(user);
    await _saveAllAccounts(accounts);
    await _setCurrentUserId(user.id);

    return null;
  }

  /// 登录
  static Future<String?> login({
    required String email,
    required String password,
  }) async {
    final accounts = await _getAllAccounts();
    final user = accounts.cast<AppUser?>().firstWhere(
      (a) => a!.email.toLowerCase() == email.toLowerCase().trim(),
      orElse: () => null,
    );

    if (user == null) {
      return '账号不存在';
    }

    if (user.passwordHash != _hashPassword(password)) {
      return '密码错误';
    }

    await _setCurrentUserId(user.id);
    return null;
  }

  /// 退出登录
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserIdKey);
  }

  /// 游客登录 —— 无需邮箱，直接创建临时账号
  static Future<void> guestLogin() async {
    final id = _generateId();
    final guestNumber = id.hashCode.abs() % 10000;
    final user = AppUser(
      id: id,
      email: 'guest_$id',
      nickname: '游客${guestNumber.toString().padLeft(4, '0')}',
      passwordHash: '',
      createdAt: DateTime.now(),
      isGuest: true,
    );

    final accounts = await _getAllAccounts();
    accounts.add(user);
    await _saveAllAccounts(accounts);
    await _setCurrentUserId(user.id);
  }

  /// 游客升级为正式账号 —— 绑定邮箱和密码
  static Future<String?> upgradeGuest({
    required String email,
    required String password,
    required String nickname,
  }) async {
    final user = await currentUser;
    if (user == null || !user.isGuest) return '当前账号非游客';

    final accounts = await _getAllAccounts();

    if (accounts.any((a) => a.email.toLowerCase() == email.toLowerCase())) {
      return '该邮箱已被注册';
    }

    if (password.length < 6) {
      return '密码至少6位';
    }

    final index = accounts.indexWhere((a) => a.id == user.id);
    if (index == -1) return '账号不存在';

    accounts[index] = user.copyWith(
      email: email.trim().toLowerCase(),
      passwordHash: _hashPassword(password),
      nickname: nickname.trim().isNotEmpty ? nickname.trim() : user.nickname,
      isGuest: false,
    );
    await _saveAllAccounts(accounts);
    return null;
  }

  /// 是否已登录
  static Future<bool> get isLoggedIn async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString(_currentUserIdKey);
    return id != null && id.isNotEmpty;
  }

  /// 获取当前用户
  static Future<AppUser?> get currentUser async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString(_currentUserIdKey);
    if (id == null || id.isEmpty) return null;

    final accounts = await _getAllAccounts();
    return accounts.cast<AppUser?>().firstWhere(
      (a) => a!.id == id,
      orElse: () => null,
    );
  }

  /// 更新昵称
  static Future<void> updateNickname(String newNickname) async {
    final user = await currentUser;
    if (user == null) return;

    final accounts = await _getAllAccounts();
    final index = accounts.indexWhere((a) => a.id == user.id);
    if (index == -1) return;

    accounts[index] = user.copyWith(nickname: newNickname.trim());
    await _saveAllAccounts(accounts);
  }

  /// 修改密码
  static Future<String?> changePassword(String oldPassword, String newPassword) async {
    final user = await currentUser;
    if (user == null) return '未登录';

    if (user.passwordHash != _hashPassword(oldPassword)) {
      return '原密码错误';
    }

    if (newPassword.length < 6) {
      return '新密码至少6位';
    }

    final accounts = await _getAllAccounts();
    final index = accounts.indexWhere((a) => a.id == user.id);
    if (index == -1) return '账号不存在';

    accounts[index] = user.copyWith(passwordHash: _hashPassword(newPassword));
    await _saveAllAccounts(accounts);
    return null;
  }

  /// 设置当前登录用户ID
  static Future<void> _setCurrentUserId(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentUserIdKey, id);
  }
}