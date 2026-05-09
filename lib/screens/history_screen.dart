import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_slider/providers/truthlens_provider.dart';
import 'result_screen.dart';

const Color _kCard = Color(0xFF171B3A);

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TrustShieldProvider>(
      builder: (context, provider, _) {
        if (provider.history.isEmpty) {
          return const Center(
            child: Text('No scans yet.', style: TextStyle(color: Colors.white70)),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: provider.history.length,
          itemBuilder: (context, index) {
            final item = provider.history[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: _kCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white12),
              ),
              child: ListTile(
                leading: const Icon(Icons.history, color: Colors.white),
                title: Text(item.scanType.label, style: const TextStyle(color: Colors.white)),
                subtitle: Text(
                  '${item.input}\n${item.scannedAt.toLocal()}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white70),
                ),
                trailing: Text('${item.trustScore}%', style: const TextStyle(color: Colors.white)),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: (_) => ResultScreen(record: item)),
                ),
              ),
            );
          },
        );
      },
    );
  }
}