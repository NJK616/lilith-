// ============================================================
// main.dart — App 入口
// 底部 Tab 导航：首页 / 社区 / 我的
// ============================================================
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/route_data.dart';
import 'data/routes_data.dart';
import 'screens/onboarding_screen.dart';
import 'screens/main_shell.dart';

void main() {
  runApp(const StudyPlannerApp());
}

class StudyPlannerApp extends StatelessWidget {
  const StudyPlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'lilith升学',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4B3FE3),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7B73FF),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const AppEntry(),
    );
  }
}

/// 启动入口：检查是否已有保存的问卷数据
class AppEntry extends StatefulWidget {
  const AppEntry({super.key});

  @override
  State<AppEntry> createState() => _AppEntryState();
}

class _AppEntryState extends State<AppEntry> {
  UserProfile? _profile;
  RoutePlan? _selectedRoute;
  int? _startSemesterIndex;
  bool _checked = false;

  @override
  void initState() {
    super.initState();
    _checkSavedProfile();
  }

  Future<void> _checkSavedProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString('user_profile');

    if (!mounted) return;

    if (jsonStr != null && jsonStr.isNotEmpty) {
      try {
        final profile = UserProfile.fromJson(jsonDecode(jsonStr));
        _profile = profile;

        final savedRouteId = prefs.getString('selected_route_id');
        if (savedRouteId != null && savedRouteId.isNotEmpty) {
          _selectedRoute = getAllRoutes().firstWhere(
            (r) => r.id == savedRouteId,
            orElse: () => getAllRoutes().first,
          );
          _startSemesterIndex =
              prefs.getInt('start_semester_index') ?? gradeToSemesterIndex(profile.grade);
        }
      } catch (_) {
        await prefs.remove('user_profile');
        await prefs.remove('selected_route_id');
      }
    }

    setState(() => _checked = true);
  }

  @override
  Widget build(BuildContext context) {
    if (!_checked) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_profile == null) {
      return const OnboardingScreen();
    }

    return MainShell(
      profile: _profile!,
      selectedRoute: _selectedRoute,
      startSemesterIndex: _startSemesterIndex,
    );
  }
}