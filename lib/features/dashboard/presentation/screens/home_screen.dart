import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:truthlens/core/state/truthlens_provider.dart';
import 'dashboard_screen.dart';
import 'package:truthlens/features/threat_intelligence/presentation/screens/analytics_screen.dart';
import 'package:truthlens/features/history/presentation/screens/history_screen.dart';
import 'package:truthlens/features/chat/presentation/screens/ai_chat_assistant_screen.dart';
import 'package:truthlens/features/settings/presentation/screens/profile_screen.dart';

const Color _kBg = Color(0xFF0D1028);
const Color _kAccent2 = Color(0xFF3D8BFF);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<TrustShieldProvider>().themeMode != ThemeMode.light;
    final pages = <Widget>[
      const DashboardScreen(),
      const AnalyticsScreen(),
      const HistoryScreen(),
      const AiChatAssistantScreen(),
      const ProfileScreen(),
    ];
    return Scaffold(
      backgroundColor: isDarkMode ? _kBg : const Color(0xFFF4F8FF),
      appBar: _index == 4 ? null : AppBar(
        backgroundColor: isDarkMode ? _kBg : Colors.white,
        title: Text(
          'TruthLens AI',
          style: TextStyle(color: isDarkMode ? Colors.white : const Color(0xFF102A43)),
        ),
        actions: [
          if (_index == 3) // AI Chat tab
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined),
              tooltip: 'Clear Chat',
              onPressed: () {
                context.read<TrustShieldProvider>().clearChatHistory();
              },
            ),
        ],
      ),
     body: pages[_index],
      bottomNavigationBar: NavigationBar(
        backgroundColor: isDarkMode ? const Color(0xFF141938) : Colors.white,
        surfaceTintColor: Colors.transparent,
        indicatorColor: _kAccent2.withValues(alpha: isDarkMode ? 0.25 : 0.18),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(color: _kAccent2, fontWeight: FontWeight.w600);
          }
          return TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54);
        }),
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home_outlined, color: isDarkMode ? Colors.white70 : Colors.black54),
            selectedIcon: const Icon(Icons.home, color: _kAccent2),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.security_outlined, color: isDarkMode ? Colors.white70 : Colors.black54),
            selectedIcon: const Icon(Icons.security, color: _kAccent2),
            label: 'Analytics',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_none, color: isDarkMode ? Colors.white70 : Colors.black54),
            selectedIcon: const Icon(Icons.notifications, color: _kAccent2),
            label: 'History',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline, color: isDarkMode ? Colors.white70 : Colors.black54),
            selectedIcon: const Icon(Icons.people, color: _kAccent2),
            label: 'Ai Chat',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline, color: isDarkMode ? Colors.white70 : Colors.black54),
            selectedIcon: const Icon(Icons.person, color: _kAccent2),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}