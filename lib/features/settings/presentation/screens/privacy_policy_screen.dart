import 'package:flutter/material.dart';
import 'package:truthlens/core/theme/design_system.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: const Text('Privacy & Policy'),
        backgroundColor: AppColors.surfaceDark,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Privacy Policy',
              style: AppTypography.heading2,
            ),
            const SizedBox(height: 8),
            const Text(
              'Effective Date: May 11, 2026',
              style: AppTypography.caption,
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: '1. Information We Collect',
              content: 'We collect information you provide directly to us when you create an account, submit reports for analysis, or communicate with our AI assistant. This may include your name, email address, and the content you submit for scam verification.',
            ),
            _buildSection(
              title: '2. How We Use Your Information',
              content: 'We use the information we collect to provide, maintain, and improve our services, including our AI-powered scam detection engine. Your data helps us refine our heuristic models and improve detection accuracy for the entire community.',
            ),
            _buildSection(
              title: '3. Data Security',
              content: 'We implement industry-standard security measures to protect your data from unauthorized access, disclosure, or alteration. All communication with our servers is encrypted using SSL/TLS.',
            ),
            _buildSection(
              title: '4. Your Rights',
              content: 'You have the right to access, correct, or delete your personal information at any time. You can manage these settings directly from your profile or contact our support team for assistance.',
            ),
            _buildSection(
              title: '5. Updates to This Policy',
              content: 'We may update this Privacy Policy from time to time. We will notify you of any significant changes by posting the new policy on this page and updating the "Effective Date" at the top.',
            ),
            const SizedBox(height: 40),
            Center(
              child: TextButton(
                onPressed: () {
                  // Link to full website policy if needed
                },
                child: const Text(
                  'Read Full Terms of Service',
                  style: TextStyle(color: AppColors.primaryBlue),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 15,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
