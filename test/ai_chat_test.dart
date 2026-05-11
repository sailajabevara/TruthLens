import 'package:flutter_test/flutter_test.dart';
import 'package:truthlens/core/state/truthlens_provider.dart';

void main() {
  test('Test AI Chat Message', () async {
    final provider = TrustShieldProvider();
    
    try {
      final reply = await provider.sendChatMessage("Is this job fake?");
      expect(reply, isNotEmpty);
    } catch (e) {
      fail('Caught Exception in ai_chat_test: $e');
    }
  });
}
