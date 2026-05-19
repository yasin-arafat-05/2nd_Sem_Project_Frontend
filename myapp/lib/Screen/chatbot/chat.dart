// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'chat_back.dart';
import '../../alert_mesg.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;
  String _streamingText = "";
  String _checkpointId = "";

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) {
      showMessge("Please enter a message");
      return;
    }

    String userMessage = _messageController.text.trim();
    _messageController.clear();

    // Add user message to chat
    setState(() {
      _messages.add({'text': userMessage, 'sender': 'user'});
      _isLoading = true;
      _streamingText = "";
    });

    _scrollToBottom();

    // ================= Send message to backend brohter===============
    Chat.sendMessage(userMessage, _checkpointId).listen(
      (data) {
        setState(() {
          switch (data['type']) {
            case 'checkpoint':
              _checkpointId = data['checkpoint_id'] ?? "";
              break;

            case 'content':
              _streamingText += data['content'] ?? "";
              if (_messages.isNotEmpty && _messages.last['sender'] == 'bot') {
                _messages.last['text'] = _streamingText;
              } else {
                _messages.add({'text': _streamingText, 'sender': 'bot'});
              }
              break;

            case 'queue_status':
              _streamingText = data['message'] ?? "Please wait...";
              if (_messages.isNotEmpty && _messages.last['sender'] == 'bot') {
                _messages.last['text'] = _streamingText;
              } else {
                _messages.add({'text': _streamingText, 'sender': 'bot'});
              }
              break;

            case 'analyzing_requirements':
              if (_messages.isEmpty || _messages.last['sender'] != 'bot') {
                _messages.add({'text': '🔍 Analyzing...', 'sender': 'bot'});
              }
              break;

            case 'end':
              _isLoading = false;
              _streamingText = "";
              break;

            case 'error':
              _isLoading = false;
              _messages.add({
                'text': '❌ Error: ${data['content']}',
                'sender': 'bot',
              });
              break;
          }
        });
        _scrollToBottom();
      },
      onError: (e) {
        setState(() {
          _isLoading = false;
          _messages.add({'text': '❌ Connection error: $e', 'sender': 'bot'});
        });
      },
      onDone: () {
        setState(() => _isLoading = false);
      },
    );
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Chat messages area
          Expanded(
            child: _messages.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Iconsax.message, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          "Start a conversation",
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length + (_isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _messages.length && _isLoading) {
                        return const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(width: 16),
                              Text("Bot is typing..."),
                            ],
                          ),
                        );
                      }

                      final message = _messages[index];
                      final isUser = message['sender'] == 'user';

                      return Align(
                        alignment: isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: isUser
                                ? const Color.fromARGB(255, 2, 5, 37)
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.7,
                          ),
                          child: Text(
                            message['text']!,
                            style: TextStyle(
                              color: isUser ? Colors.white : Colors.black87,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          // Input area
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            // =========================Message send brohter===================
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Type your message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    maxLines: null,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 2, 5, 37),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Iconsax.send_1, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
