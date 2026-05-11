import 'package:flutter/material.dart';
import 'package:truthlens/core/theme/design_system.dart';

class CommunityGuidelinesScreen extends StatelessWidget {
  const CommunityGuidelinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: const Text('Community Guidelines'),
        backgroundColor: AppColors.surfaceDark,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Our Community Standards',
              style: AppTypography.heading2,
            ),
            const SizedBox(height: 8),
            const Text(
              'To ensure a safe and accurate environment for all users, please adhere to the following rules when using TruthLens.',
              style: AppTypography.caption,
            ),
            const SizedBox(height: 32),
            _buildGuideline(
              title: '1. Accurate Reporting',
              content: 'Only report content that you genuinely suspect to be a scam. False reports dilute the accuracy of our collective threat intelligence.',
              icon: Icons.check_circle_outline,
            ),
            _buildGuideline(
              title: '2. Privacy Respect',
              content: 'When reporting messages or documents, redact sensitive personal information of non-scammers (e.g., family names, private home addresses).',
              icon: Icons.privacy_tip_outlined,
            ),
            _buildGuideline(
              title: '3. Professional Language',
              content: 'Maintain a professional and respectful tone when interacting with the community and our support team.',
              icon: Icons.message_outlined,
            ),
            _buildGuideline(
              title: '4. No Self-Promotion',
              content: 'Do not use TruthLens to promote your own services, products, or websites.',
              icon: Icons.block_flipped,
            ),
            _buildGuideline(
              title: '5. Collective Intelligence',
              content: 'Contribute constructively by voting on reports you have experience with. Your input helps train our AI models.',
              icon: Icons.groups_outlined,
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primaryBlue.withValues(alpha: 0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: AppColors.primaryBlue),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Violating these guidelines may result in temporary or permanent suspension of your account.',
                      style: TextStyle(color: Colors.white, fontSize: 13, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildGuideline({
    required String title,
    required String content,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white12,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.primaryBlue, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
