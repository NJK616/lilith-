// ============================================================
// 主界面 —— 底部 Tab 导航
// 首页 / 社区 / 我的
// ============================================================
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/route_data.dart';
import '../data/routes_data.dart';
import 'route_dashboard_screen.dart';
import 'route_recommendation_screen.dart';
import 'community_placeholder_screen.dart';
import 'profile_screen.dart';
import 'onboarding_screen.dart';

class MainShell extends StatefulWidget {
  final UserProfile profile;
  final RoutePlan? selectedRoute;
  final int? startSemesterIndex;

  const MainShell({
    super.key,
    required this.profile,
    this.selectedRoute,
    this.startSemesterIndex,
  });

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  bool _showRouteDashboard;
  RoutePlan? _currentRoute;
  int? _startSemesterIndex;

  _MainShellState()
      : _showRouteDashboard = false,
        _currentRoute = null,
        _startSemesterIndex = null;

  @override
  void initState() {
    super.initState();
    _showRouteDashboard = widget.selectedRoute != null;
    _currentRoute = widget.selectedRoute;
    _startSemesterIndex = widget.startSemesterIndex;
  }

  /// 切换到路线推荐页
  void _switchToRecommendation() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('selected_route_id');
    await prefs.remove('start_semester_index');
    if (mounted) {
      setState(() {
        _showRouteDashboard = false;
        _currentRoute = null;
        _startSemesterIndex = null;
      });
    }
  }

  /// 选择了一条路线
  void _onRouteSelected(RoutePlan route, int startSemesterIndex) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_route_id', route.id);
    await prefs.setInt('start_semester_index', startSemesterIndex);
    if (mounted) {
      setState(() {
        _showRouteDashboard = true;
        _currentRoute = route;
        _startSemesterIndex = startSemesterIndex;
      });
    }
  }

  /// 编辑问卷
  void _editProfile() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => OnboardingScreen(existingProfile: widget.profile),
      ),
    );
  }

  Widget _buildHomePage() {
    if (_showRouteDashboard && _currentRoute != null) {
      return RouteDashboardScreen(
        route: _currentRoute!,
        startSemesterIndex: _startSemesterIndex ?? 0,
        userGrade: widget.profile.grade,
        majorCategoryId: widget.profile.majorCategory,
        schoolTier: widget.profile.schoolTier,
        wantsTransfer: widget.profile.wantsTransfer,
        targetMajorCategory: widget.profile.targetMajorCategory,
        onSwitchRoute: _switchToRecommendation,
      );
    }
    return RouteRecommendationScreen(
      profile: widget.profile,
      onRouteSelected: _onRouteSelected,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildHomePage(),
          const CommunityPlaceholderScreen(),
          ProfileScreen(onEditProfile: _editProfile),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        backgroundColor: theme.colorScheme.surface,
        indicatorColor: theme.colorScheme.primary.withOpacity(0.15),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: '首页',
          ),
          NavigationDestination(
            icon: Icon(Icons.forum_outlined),
            selectedIcon: Icon(Icons.forum),
            label: '社区',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: '我的',
          ),
        ],
      ),
    );
  }
}