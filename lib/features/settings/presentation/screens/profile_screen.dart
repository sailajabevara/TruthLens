import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:truthlens/core/state/truthlens_provider.dart';
import 'package:truthlens/features/auth/data/datasources/firebase_auth_service.dart';
import 'package:truthlens/features/auth/presentation/screens/login_screen.dart';
import 'personal_info_screen.dart';
import 'security_settings_screen.dart';
import 'notification_settings_screen.dart';
import 'privacy_policy_screen.dart';
import 'help_center_screen.dart';
import 'community_guidelines_screen.dart';
import 'about_truthlens_screen.dart';

const Color _kDarkBg = Color(0xFF0A0E2B); // Very dark blue for the header

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TrustShieldProvider>(
      builder: (context, provider, _) {
        final user = FirebaseAuth.instance.currentUser;
        final displayName = user?.displayName?.trim();
        final email = user?.email?.trim();
        
        final profileName = (displayName == null || displayName.isEmpty)
            ? 'Rohit Kumar'
            : displayName;
        final profileEmail = (email == null || email.isEmpty)
            ? 'rohitkumar@gmail.com'
            : email;
            
        final isDarkTheme = provider.themeMode == ThemeMode.dark;
        final isDarkMode = isDarkTheme; 

        return Scaffold(
          backgroundColor: isDarkMode ? const Color(0xFF0F143A) : const Color(0xFFF4F8FF),
          body: Stack(
            children: [
              // Dark Header Curved Background
              Container(
                height: 380,
                decoration: const BoxDecoration(
                  color: _kDarkBg,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
              ),
              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Column(
                    children: [
                      // Header: Logo and Settings
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(width: 48), // Spacer to balance the settings icon
                            Expanded(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Icon(Icons.shield, color: Colors.cyanAccent.shade400, size: 36),
                                          const Icon(Icons.remove_red_eye, color: _kDarkBg, size: 18),
                                        ],
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        'TruthLens',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 26,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  const Text(
                                    'Real-Time Scam Detection & Alert System',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                provider.updateThemeMode(isDarkTheme ? ThemeMode.light : ThemeMode.dark);
                              },
                              icon: const Icon(Icons.settings_outlined, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Profile Picture
                      Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white24, width: 2),
                            ),
                            child: const CircleAvatar(
                              radius: 46,
                              backgroundColor: Colors.white12,
                              child: Icon(Icons.person, size: 50, color: Colors.white),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Color(0xFF10b981), // Emerald green
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // User Info
                      Text(
                        profileName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        profileEmail,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      // Verified Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF133045),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.verified, color: Color(0xFF10b981), size: 16),
                            SizedBox(width: 6),
                            Text(
                              'Verified User',
                              style: TextStyle(
                                color: Color(0xFF10b981),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 28),
                      
                      // Stats Row
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                            color: isDarkMode ? const Color(0xFF1A1F3D) : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _StatItem(
                                icon: Icons.description_outlined,
                                iconColor: Colors.deepPurple.shade300,
                                value: '12',
                                label: 'Reports\nSubmitted',
                                isDark: isDarkMode,
                              ),
                              _buildVerticalDivider(),
                              _StatItem(
                                icon: Icons.verified_user_outlined,
                                iconColor: Colors.green.shade400,
                                value: '8',
                                label: 'Reports\nVerified',
                                isDark: isDarkMode,
                              ),
                              _buildVerticalDivider(),
                              _StatItem(
                                icon: Icons.thumb_up_outlined,
                                iconColor: Colors.blue.shade400,
                                value: '24',
                                label: 'Helpful\nVotes',
                                isDark: isDarkMode,
                              ),
                              _buildVerticalDivider(),
                              _StatItem(
                                icon: Icons.star_outline,
                                iconColor: Colors.orange.shade400,
                                value: '120',
                                label: 'Reputation\nPoints',
                                isDark: isDarkMode,
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Account Section
                      _SectionHeader('Account', isDark: isDarkMode),
                      _SettingsCard(
                        isDark: isDarkMode,
                        children: [
                          _SettingsTile(
                            icon: Icons.person_outline,
                            iconColor: Colors.deepPurple.shade400,
                            iconBgColor: Colors.deepPurple.shade50,
                            title: 'Personal Information',
                            subtitle: 'View and edit your profile',
                            isDark: isDarkMode,
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PersonalInfoScreen())),
                          ),
                          _SettingsTile(
                            icon: Icons.lock_outline,
                            iconColor: Colors.blue.shade500,
                            iconBgColor: Colors.blue.shade50,
                            title: 'Security',
                            subtitle: 'Change password and security options',
                            isDark: isDarkMode,
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SecuritySettingsScreen())),
                          ),
                          _SettingsTile(
                            icon: Icons.notifications_none,
                            iconColor: Colors.green.shade500,
                            iconBgColor: Colors.green.shade50,
                            title: 'Notifications',
                            subtitle: 'Manage your notification preferences',
                            isDark: isDarkMode,
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationSettingsScreen())),
                          ),
                          _SettingsTile(
                            icon: Icons.shield_outlined,
                            iconColor: Colors.orange.shade400,
                            iconBgColor: Colors.orange.shade50,
                            title: 'Privacy & Policy',
                            subtitle: 'Privacy policy and terms of service',
                            showDivider: false,
                            isDark: isDarkMode,
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen())),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Support Section
                      _SectionHeader('Support', isDark: isDarkMode),
                      _SettingsCard(
                        isDark: isDarkMode,
                        children: [
                          _SettingsTile(
                            icon: Icons.help_outline,
                            iconColor: Colors.redAccent.shade400,
                            iconBgColor: Colors.red.shade50,
                            title: 'Help Center',
                            subtitle: 'Get help and support',
                            isDark: isDarkMode,
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HelpCenterScreen())),
                          ),
                          _SettingsTile(
                            icon: Icons.people_outline,
                            iconColor: Colors.indigo.shade400,
                            iconBgColor: Colors.indigo.shade50,
                            title: 'Community Guidelines',
                            subtitle: 'Read community rules',
                            isDark: isDarkMode,
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CommunityGuidelinesScreen())),
                          ),
                          _SettingsTile(
                            icon: Icons.info_outline,
                            iconColor: Colors.teal.shade500,
                            iconBgColor: Colors.teal.shade50,
                            title: 'About TruthLens',
                            subtitle: 'Version 1.0.0',
                            showDivider: false,
                            isDark: isDarkMode,
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutTruthLensScreen())),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Logout Button
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            gradient: LinearGradient(
                              colors: [
                                Colors.redAccent.shade400,
                                Colors.red.shade700,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.redAccent.shade400.withValues(alpha: 0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () async {
                                final shouldLogout = await showDialog<bool>(
                                  context: context,
                                  builder: (dialogContext) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                      title: const Text('Logout'),
                                      content: const Text('Do you want to logout now?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.of(dialogContext).pop(false),
                                          child: Text('Cancel', style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54)),
                                        ),
                                        TextButton(
                                          onPressed: () => Navigator.of(dialogContext).pop(true),
                                          child: const Text('Logout', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                                        ),
                                      ],
                                    );
                                  },
                                );
            
                                if (shouldLogout != true) return;
            
                                final authService = FirebaseAuthService();
                                final response = await authService.logout();
                                if (!context.mounted) return;
                                
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(response.message),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                );
                                if (!response.success) return;
                                
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
                                  (route) => false,
                                );
                              },
                              borderRadius: BorderRadius.circular(18),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.logout_rounded, color: Colors.white, size: 22),
                                    SizedBox(width: 12),
                                    Text(
                                      'Log Out',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.8,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      width: 1,
      height: 45,
      color: Colors.grey.withValues(alpha: 0.25),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title, {required this.isDark});
  final String title;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.children, required this.isDark});
  final List<Widget> children;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1D234A) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: children,
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    required this.subtitle,
    this.showDivider = true,
    required this.isDark,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final String subtitle;
  final bool showDivider;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bgColor = isDark ? iconColor.withValues(alpha: 0.15) : iconBgColor;
    
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(
              fontSize: 13,
              color: isDark ? Colors.white54 : Colors.black54,
            ),
          ),
          trailing: Icon(
            Icons.chevron_right,
            color: isDark ? Colors.white38 : Colors.grey.shade400,
          ),
          onTap: onTap,
        ),
        if (showDivider)
          Padding(
            padding: const EdgeInsets.only(left: 68, right: 16),
            child: Divider(
              height: 1,
              color: isDark ? Colors.white12 : Colors.grey.shade200,
            ),
          ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
    required this.isDark,
  });

  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              height: 1.2,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white60 : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}