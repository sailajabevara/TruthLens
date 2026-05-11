import 'package:flutter/material.dart';
import 'package:truthlens/core/theme/design_system.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: const Text('Help Center'),
        backgroundColor: AppColors.surfaceDark,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          const Text(
            'Frequently Asked Questions',
            style: AppTypography.heading2,
          ),
          const SizedBox(height: 16),
          _buildFaqItem(
            'How does TruthLens detect scams?',
            'TruthLens uses a hybrid engine combining real-time AI analysis with advanced heuristics like Shannon Entropy and structural URL checks to identify fraud signatures.',
          ),
          _buildFaqItem(
            'Is my data secure?',
            'Yes, we use zero-trust validation and industry-standard encryption for all data transmissions. We do not store sensitive personal information without your consent.',
          ),
          _buildFaqItem(
            'What should I do if I find a bug?',
            'You can report bugs directly through our support portal or by emailing support@truthlens.app.',
          ),
          const SizedBox(height: 32),
          const Text(
            'Contact Support',
            style: AppTypography.heading2,
          ),
          const SizedBox(height: 16),
          _buildContactCard(
            icon: Icons.email_outlined,
            title: 'Email Support',
            subtitle: 'support@truthlens.app',
            onTap: () {
              // Logic to launch email app
            },
          ),
          const SizedBox(height: 12),
          _buildContactCard(
            icon: Icons.chat_outlined,
            title: 'Live Chat',
            subtitle: 'Available 24/7 for premium users',
            onTap: () {
              // Logic to open chat
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Theme(
      data: ThemeData.dark().copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        title: Text(
          question,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(
              answer,
              style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: AppColors.primaryBlue),
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.white54, fontSize: 13)),
        trailing: const Icon(Icons.chevron_right, color: Colors.white24),
      ),
    );
  }
}
