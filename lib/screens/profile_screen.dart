// ============================================================
// 个人中心页 —— 账号信息 / 编辑昵称 / 修改密码 / 退出
// ============================================================
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';
import '../models/route_data.dart';
import 'auth_screen.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback? onEditProfile;

  const ProfileScreen({super.key, this.onEditProfile});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AppUser? _user;
  bool _isLoggedIn = false;
  bool _checked = false;
  UserProfile? _onboardingProfile;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final loggedIn = await AuthService.isLoggedIn;
    final user = await AuthService.currentUser;
    final profile = await _loadOnboardingProfile();
    if (mounted) {
      setState(() {
        _isLoggedIn = loggedIn;
        _user = user;
        _onboardingProfile = profile;
        _checked = true;
      });
    }
  }

  Future<UserProfile?> _loadOnboardingProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = prefs.getString('user_profile');
      if (json != null && json.isNotEmpty) {
        return UserProfile.fromJson(jsonDecode(json));
      }
    } catch (_) {}
    return null;
  }

  Future<void> _goToLogin() async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const AuthScreen()),
    );
    if (result == true && mounted) {
      _checkAuth();
    }
  }

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('退出登录'),
        content: const Text('确定要退出登录吗？'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('取消')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('确定', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await AuthService.logout();
      if (mounted) {
        setState(() {
          _isLoggedIn = false;
          _user = null;
        });
      }
    }
  }

  Future<void> _editNickname() async {
    final controller = TextEditingController(text: _user?.nickname ?? '');
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('修改昵称'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: '请输入新昵称',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('取消')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: const Text('保存'),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty && mounted) {
      await AuthService.updateNickname(result);
      _checkAuth();
    }
  }

  Future<void> _changeAvatar() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 85,
    );
    if (picked == null) return;

    final file = File(picked.path);
    await AuthService.updateAvatar(file);
    if (mounted) _checkAuth();
  }

  Future<void> _upgradeFromGuest() async {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmController = TextEditingController();
    final nicknameController = TextEditingController(text: _user?.nickname ?? '');

    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('绑定邮箱'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nicknameController,
                decoration: const InputDecoration(
                  labelText: '昵称',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: '邮箱',
                  hintText: '请输入要绑定的邮箱',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: '密码（至少6位）',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: confirmController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: '确认密码',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('取消')),
          TextButton(
            onPressed: () {
              final email = emailController.text.trim();
              final password = passwordController.text;
              final confirm = confirmController.text;
              if (email.isEmpty || !email.contains('@')) {
                ScaffoldMessenger.of(ctx).showSnackBar(
                  const SnackBar(content: Text('请输入有效邮箱')),
                );
                return;
              }
              if (password != confirm) {
                ScaffoldMessenger.of(ctx).showSnackBar(
                  const SnackBar(content: Text('两次密码不一致')),
                );
                return;
              }
              Navigator.pop(ctx, {
                'email': email,
                'password': password,
                'nickname': nicknameController.text.trim(),
              });
            },
            child: const Text('绑定'),
          ),
        ],
      ),
    );

    if (result != null && mounted) {
      final error = await AuthService.upgradeGuest(
        email: result['email']!,
        password: result['password']!,
        nickname: result['nickname']!,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error == null ? '绑定成功，已升级为正式账号' : error),
            backgroundColor: error == null ? Colors.green : Colors.red[400],
          ),
        );
        if (error == null) _checkAuth();
      }
    }
  }

  Future<void> _changePassword() async {
    final oldPwdController = TextEditingController();
    final newPwdController = TextEditingController();
    final confirmPwdController = TextEditingController();

    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('修改密码'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: oldPwdController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: '原密码',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: newPwdController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: '新密码（至少6位）',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: confirmPwdController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: '确认新密码',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('取消')),
          TextButton(
            onPressed: () {
              final oldPwd = oldPwdController.text;
              final newPwd = newPwdController.text;
              final confirmPwd = confirmPwdController.text;
              if (newPwd != confirmPwd) {
                ScaffoldMessenger.of(ctx).showSnackBar(
                  const SnackBar(content: Text('两次密码不一致')),
                );
                return;
              }
              Navigator.pop(ctx, {'old': oldPwd, 'new': newPwd});
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );

    if (result != null && mounted) {
      final error = await AuthService.changePassword(result['old']!, result['new']!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error == null ? '密码修改成功' : error),
            backgroundColor: error == null ? Colors.green : Colors.red[400],
          ),
        );
      }
    }
  }

  Future<void> _editOnboardingProfile() async {
    if (_onboardingProfile == null) return;
    if (widget.onEditProfile != null) {
      widget.onEditProfile!();
    }
  }

  String _formatDate(DateTime dt) {
    return '${dt.year}年${dt.month}月${dt.day}日';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('我的', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 用户信息卡片
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.primary.withOpacity(0.7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: _isLoggedIn && _user != null
                ? Column(
                    children: [
                      GestureDetector(
                        onTap: _changeAvatar,
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.white.withOpacity(0.25),
                              backgroundImage: _user!.avatarPath != null &&
                                      File(_user!.avatarPath!).existsSync()
                                  ? FileImage(File(_user!.avatarPath!))
                                  : null,
                              child: _user!.avatarPath == null ||
                                      !File(_user!.avatarPath!).existsSync()
                                  ? Text(
                                      _user!.nickname.isNotEmpty
                                          ? _user!.nickname[0].toUpperCase()
                                          : '?',
                                      style: const TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    )
                                  : null,
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                width: 26,
                                height: 26,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: theme.colorScheme.primary,
                                    width: 2,
                                  ),
                                ),
                                child: Icon(
                                  Icons.camera_alt,
                                  size: 14,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _user!.nickname,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      if (_user!.isGuest)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            '游客',
                            style: TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w500),
                          ),
                        ),
                      const SizedBox(height: 4),
                      Text(
                        _user!.isGuest ? '游客账号' : _user!.email,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${_formatDate(_user!.createdAt)} 加入',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      CircleAvatar(
                        radius: 36,
                        backgroundColor: Colors.white.withOpacity(0.25),
                        child: const Icon(Icons.person_outline, size: 36, color: Colors.white),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        '未登录',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '登录后可同步你的升学规划数据',
                        style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.7)),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _goToLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: theme.colorScheme.primary,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('登录 / 注册', style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
          ),

          const SizedBox(height: 20),

          // 升学信息
          if (_onboardingProfile != null)
            _buildSectionCard(
              theme: theme,
              icon: Icons.school,
              title: '升学档案',
              children: [
                _buildInfoRow('当前年级', _onboardingProfile!.grade),
                _buildInfoRow('院校', _onboardingProfile!.schoolName),
                _buildInfoRow('层次', _onboardingProfile!.schoolTier),
                _buildInfoRow('专业', _onboardingProfile!.major),
                _buildInfoRow('GPA', _onboardingProfile!.gpa.isEmpty ? '暂无成绩' : _onboardingProfile!.gpa),
                _buildInfoRow('英语水平', _onboardingProfile!.english.isEmpty ? '暂无' : _onboardingProfile!.english),
                if (_onboardingProfile!.wantsTransfer)
                  _buildInfoRow('转专业方向', _onboardingProfile!.targetMajorCategory ?? '未设置'),
                const SizedBox(height: 8),
                Center(
                  child: TextButton.icon(
                    icon: const Icon(Icons.edit_note, size: 18),
                    label: const Text('修改问卷信息'),
                    onPressed: _editOnboardingProfile,
                  ),
                ),
              ],
            ),

          const SizedBox(height: 16),

          // 账号设置
          if (_isLoggedIn)
            _buildSectionCard(
              theme: theme,
              icon: Icons.settings,
              title: '账号设置',
              children: [
                _buildActionTile(
                  icon: Icons.badge,
                  title: '修改昵称',
                  subtitle: _user?.nickname ?? '',
                  onTap: _editNickname,
                  theme: theme,
                ),
                if (_user?.isGuest == true) ...[
                  const Divider(height: 1),
                  _buildActionTile(
                    icon: Icons.email_outlined,
                    title: '绑定邮箱',
                    subtitle: '升级为正式账号',
                    onTap: _upgradeFromGuest,
                    theme: theme,
                  ),
                ] else ...[
                  const Divider(height: 1),
                  _buildActionTile(
                    icon: Icons.lock_outline,
                    title: '修改密码',
                    subtitle: '保护账号安全',
                    onTap: _changePassword,
                    theme: theme,
                  ),
                ],
                const Divider(height: 1),
                _buildActionTile(
                  icon: Icons.logout,
                  title: '退出登录',
                  subtitle: '',
                  onTap: _logout,
                  theme: theme,
                  destructive: true,
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required ThemeData theme,
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: [
                Icon(icon, size: 20, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14, color: theme.colorScheme.onSurfaceVariant),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required ThemeData theme,
    bool destructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(
              icon,
              size: 22,
              color: destructive ? Colors.red[400] : theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: destructive
                          ? Colors.red[400]
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                  if (subtitle.isNotEmpty)
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
                    ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: theme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}