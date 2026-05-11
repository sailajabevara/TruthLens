import 'package:flutter/material.dart';
import 'package:truthlens/core/theme/design_system.dart';

class AboutTruthLensScreen extends StatelessWidget {
  const AboutTruthLensScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: const Text('About TruthLens'),
        backgroundColor: AppColors.surfaceDark,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            const SizedBox(height: 24),
            const Icon(Icons.shield, color: AppColors.primaryBlue, size: 80),
            const SizedBox(height: 16),
            const Text(
              'TruthLens AI',
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Version 1.0.0',
              style: TextStyle(color: Colors.white54, fontSize: 14),
            ),
            const SizedBox(height: 32),
            const Text(
              'TruthLens is a decentralized, edge-first threat intelligence platform engineered to detect and mitigate social engineering, credential harvesting, and financial fraud. Our proprietary hybrid engine combines cloud-based intent recognition with localized heuristic modeling to provide sub-100ms threat analysis.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 48),
            _buildSection(
              title: 'Our Mission',
              content: 'To democratize cybersecurity by delivering computational risk modeling and Explainable AI (XAI) directly to the mobile attack surface.',
            ),
            const Divider(color: Colors.white12, height: 48),
            _buildSection(
              title: 'Tech Stack',
              content: 'Built using Flutter, Node.js, and OpenRouter API. Utilizing Shannon Entropy for DGA detection and asyptotic decay for risk aggregation.',
            ),
            const Divider(color: Colors.white12, height: 48),
            const Text(
              '© 2026 TruthLens Cybersecurity Startup. All rights reserved.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white24, fontSize: 12),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Text(
          content,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.4),
        ),
      ],
    );
  }
}
