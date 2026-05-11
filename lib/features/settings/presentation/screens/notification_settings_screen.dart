import 'package:flutter/material.dart';
import 'package:truthlens/core/theme/design_system.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool _pushNotifications = true;
  bool _scamAlerts = true;
  bool _securityAlerts = true;
  bool _marketingEmails = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: AppColors.surfaceDark,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          const Text(
            'Alert Settings',
            style: AppTypography.heading2,
          ),
          const SizedBox(height: 8),
          const Text(
            'Choose what you want to be notified about.',
            style: AppTypography.caption,
          ),
          const SizedBox(height: 24),
          _buildSwitchTile(
            title: 'Push Notifications',
            subtitle: 'Enable or disable all push notifications',
            value: _pushNotifications,
            onChanged: (val) => setState(() => _pushNotifications = val),
          ),
          const Divider(color: Colors.white12, height: 32),
          _buildSwitchTile(
            title: 'Real-Time Scam Alerts',
            subtitle: 'Get notified when a high-risk scam is detected near you',
            value: _scamAlerts,
            onChanged: (val) => setState(() => _scamAlerts = val),
          ),
          const Divider(color: Colors.white12, height: 32),
          _buildSwitchTile(
            title: 'Security Alerts',
            subtitle: 'Get notified about suspicious login attempts',
            value: _securityAlerts,
            onChanged: (val) => setState(() => _securityAlerts = val),
          ),
          const Divider(color: Colors.white12, height: 32),
          _buildSwitchTile(
            title: 'Marketing & Tips',
            subtitle: 'Receive tips on how to stay safe online',
            value: _marketingEmails,
            onChanged: (val) => setState(() => _marketingEmails = val),
          ),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Last synchronized: ${DateTime.now().toString().split('.')[0]}',
              textAlign: TextAlign.center,
              style: AppTypography.caption.copyWith(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 13)),
      activeThumbColor: AppColors.primaryBlue,
      activeTrackColor: AppColors.primaryBlue.withValues(alpha: 0.5),
      contentPadding: EdgeInsets.zero,
    );
  }
}
