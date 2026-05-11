import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:truthlens/core/state/truthlens_provider.dart';

const Color _kCard = Color(0xFF171B3A);
const Color _kAccent2 = Color(0xFF3D8BFF);

class AiChatAssistantScreen extends StatefulWidget {
  const AiChatAssistantScreen({super.key});

  @override
  State<AiChatAssistantScreen> createState() => _AiChatAssistantScreenState();
}

class _AiChatAssistantScreenState extends State<AiChatAssistantScreen> {
  final TextEditingController _chatController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isBotTyping = false;

  @override
  void dispose() {
    _chatController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (_isBotTyping) return;
    
    final text = _chatController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _chatController.clear();
      _isBotTyping = true;
    });
    _scrollToBottom();

    final provider = context.read<TrustShieldProvider>();
    
    try {
      await provider.sendChatMessage(text);
    } catch (e) {
      if (!mounted) return;
      // Show the actual error message so the user knows what's wrong (e.g., missing API key)
      final errorMessage = e.toString().replaceAll('Exception:', '').trim();
      provider.addAssistantChatMessage('⚠️ Error: $errorMessage');
    }

    if (!mounted) return;
    setState(() {
      _isBotTyping = false;
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) {
        return;
      }
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TrustShieldProvider>();
    final chatHistory = provider.chatHistory;
    final isTelugu = provider.language == AppLanguage.telugu;

    final messages = chatHistory
            .map((item) => (isUser: item['role'] == 'user', text: item['content']!))
            .toList();

    return Column(
      children: [
        Expanded(
          child: messages.isEmpty 
            ? Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.chat_bubble_outline, size: 64, color: Colors.white24),
                      const SizedBox(height: 16),
                      Text(
                        isTelugu ? 'AI తో చాట్ ప్రారంభించండి' : 'Start chatting with AI',
                        style: TextStyle(color: Colors.white54, fontSize: 18),
                      ),
                      const SizedBox(height: 24),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 8,
                        children: [
                          _SuggestionChip(
                            label: isTelugu ? 'స్కామ్ ఎలా గుర్తించాలి?' : 'How to spot a scam?',
                            onTap: () => _sendCustom(isTelugu ? 'నేను ఆన్‌లైన్ స్కామ్‌లను ఎలా గుర్తించగలను?' : 'How can I spot online scams?'),
                          ),
                          _SuggestionChip(
                            label: isTelugu ? 'ఉద్యోగ ఆఫర్ నిజమేనా?' : 'Is this job real?',
                            onTap: () => _sendCustom(isTelugu ? 'ఈ ఉద్యోగ ఆఫర్ నాకు అనుమానంగా ఉంది, సహాయం చేయండి.' : 'I got a suspicious job offer, help me.'),
                          ),
                          _SuggestionChip(
                            label: isTelugu ? 'జోక్ చెప్పండి' : 'Tell me a joke',
                            onTap: () => _sendCustom(isTelugu ? 'నాకు ఒక జోక్ చెప్పండి.' : 'Tell me a funny joke.'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            : ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(12),
                itemCount: messages.length + (_isBotTyping ? 1 : 0),
                itemBuilder: (context, index) {
                  if (_isBotTyping && index == messages.length) {
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _kCard,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Text(
                          'AI is typing...',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    );
                  }
                  final msg = messages[index];
                  return Align(
                    alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.all(12),
                      constraints: const BoxConstraints(maxWidth: 300),
                      decoration: BoxDecoration(
                        color: msg.isUser ? _kAccent2 : _kCard,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(msg.text, style: const TextStyle(color: Colors.white)),
                    ),
                  );
                },
              ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _chatController,
                  style: const TextStyle(color: Colors.white),
                  minLines: 1,
                  maxLines: 4,
                  onSubmitted: (_) => _send(),
                  decoration: InputDecoration(
                    hintText: isTelugu ? 'ఏదైనా అడగండి...' : 'Say something...',
                    hintStyle: const TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.1),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: Colors.white24),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: _kAccent2),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: _kAccent2,
                ),
                child: IconButton(
                  onPressed: _isBotTyping ? null : _send,
                  icon: const Icon(Icons.send, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _sendCustom(String text) async {
    _chatController.text = text;
    await _send();
  }
}

class _SuggestionChip extends StatelessWidget {
  const _SuggestionChip({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      backgroundColor: _kCard,
      side: const BorderSide(color: Colors.white12),
      label: Text(label, style: const TextStyle(color: Colors.white, fontSize: 13)),
      onPressed: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}