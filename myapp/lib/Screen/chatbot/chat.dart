// ignore_for_file: avoid_print, use_build_context_synchronously
import '../../alert_mesg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:myapp/Screen/chatbot/chat_back.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../ConnectSideBar/load_chat_msg_for_thread_id_back.dart';

class ChatMessage {
  String text;
  final String sender;
  final DateTime? createdAt;

  ChatMessage({required this.text, required this.sender, this.createdAt});

  factory ChatMessage.fromApi(Map<String, dynamic> json) {
    return ChatMessage(
      text: json['message'] ?? '',
      sender: json['sender_role'] == 'human' ? 'user' : 'bot',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
    );
  }
}

class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.sender == 'user';

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isUser
              ? const Color.fromARGB(255, 2, 5, 37)
              : const Color.fromARGB(255, 13, 9, 9),
          borderRadius: BorderRadius.circular(16),
        ),
        constraints: BoxConstraints(
          maxWidth: isUser
              ? MediaQuery.of(context).size.width * 0.75
              : MediaQuery.of(context).size.width * 0.85,
        ),
        child: isUser
            ? Text(
                message.text,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              )
            : MarkdownBody(
                data: message.text.replaceAll(r'\n', '\n'),
                selectable: true,
                styleSheet: MarkdownStyleSheet(
                  p: const TextStyle(color: Colors.white60, fontSize: 16),
                  listBullet: const TextStyle(
                    color: Colors.white60,
                    fontSize: 16,
                  ),
                  code: TextStyle(
                    color: Colors.red[700],
                    backgroundColor: const Color.fromARGB(255, 58, 39, 39),
                    fontSize: 14,
                  ),
                  codeblockDecoration: BoxDecoration(
                    color: Colors.white60,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
      ),
    );
  }
}

class ChatInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const ChatInput({super.key, required this.controller, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(color: Color.fromARGB(255, 43, 30, 30)),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              style: const TextStyle(color: Colors.white60),
              decoration: InputDecoration(
                hintText: "Type your message...",
                hintStyle: const TextStyle(color: Colors.white30),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: const BorderSide(color: Colors.white60),
                ),
                filled: true,
                fillColor: const Color.fromARGB(255, 43, 30, 30),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              maxLines: null,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => onSend(),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: onSend,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 2, 5, 37),
                shape: BoxShape.circle,
              ),
              child: const Icon(Iconsax.send_1, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatPage extends StatefulWidget {
  final int? conversationId;
  const ChatPage({super.key, this.conversationId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];

  bool _isLoading = false;
  bool _isHistoryLoading = false;
  String _streamingText = "";
  String _checkpointId = "";

  @override
  void initState() {
    super.initState();
    // if we get the conversation id then we will load the pages for old history:
    if (widget.conversationId != null) {
      _loadOldChatHistory(widget.conversationId!);
    }
  }

  // chat screen control with appbar:
  @override
  void didUpdateWidget(covariant ChatPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.conversationId != oldWidget.conversationId &&
        widget.conversationId != null) {
      _loadOldChatHistory(widget.conversationId!);
    }
  }

  // ========== Get data from database(Old message loading) ===============
  Future<void> _loadOldChatHistory(int convId) async {
    setState(() {
      _isHistoryLoading = true;
      _messages.clear();
      _checkpointId = "";
    });

    try {
      // get data from backend.
      LoadChatMsgForThreadIdBack lm = LoadChatMsgForThreadIdBack();
      final List<dynamic> historyData = await lm.getConvMsg(convId);

      setState(() {
        for (var item in historyData) {
          _messages.add(ChatMessage.fromApi(item));
        }
        if (historyData.isNotEmpty) {
          _checkpointId = historyData.first['thread_id'] ?? "";
          print("Thread_id load for old: $_checkpointId");
        }
      });

      // after loding the message scroll downlaod below:
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    } catch (e) {
      showMessge("Error loading logs: $e");
    } finally {
      setState(() => _isHistoryLoading = false);
    }
  }

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

    setState(() {
      _messages.add(ChatMessage(text: userMessage, sender: 'user'));
      _isLoading = true;
      _streamingText = "";
    });

    _scrollToBottom();

    // ================= Stream Listen =================
    Chat.sendMessage(userMessage, _checkpointId).listen(
      (data) {
        setState(() {
          switch (data['type']) {
            case 'checkpoint':
              _checkpointId = data['checkpoint_id'] ?? "";
              break;

            case 'content':
              _streamingText += data['content'] ?? "";
              if (_messages.isNotEmpty && _messages.last.sender == 'bot') {
                _messages.last.text = _streamingText;
              } else {
                _messages.add(ChatMessage(text: _streamingText, sender: 'bot'));
              }
              break;

            case 'queue_status':
              _streamingText = data['message'] ?? "Please wait...";
              if (_messages.isNotEmpty && _messages.last.sender == 'bot') {
                _messages.last.text = _streamingText;
              } else {
                _messages.add(ChatMessage(text: _streamingText, sender: 'bot'));
              }
              break;

            case 'analyzing_requirements':
              if (_messages.isEmpty || _messages.last.sender != 'bot') {
                _messages.add(
                  ChatMessage(text: '🔍 Analyzing...', sender: 'bot'),
                );
              }
              break;

            case 'end':
              _isLoading = false;
              _streamingText = "";
              break;

            case 'error':
              _isLoading = false;
              _messages.add(
                ChatMessage(text: '❌ Error: ${data['content']}', sender: 'bot'),
              );
              break;
          }
        });
        _scrollToBottom();
      },
      onError: (e) {
        setState(() {
          _isLoading = false;
          _messages.add(
            ChatMessage(text: '❌ Connection error: $e', sender: 'bot'),
          );
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
      backgroundColor: const Color.fromARGB(255, 43, 30, 30),
      body: Column(
        children: [
          // Chat messages area
          Expanded(
            child: _isHistoryLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  )
                : _messages.isEmpty
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
                        return _streamingText.isNotEmpty
                            ? const SizedBox.shrink()
                            : const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    Text(
                                      "Bot is typing...",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                      }
                      return ChatBubble(message: _messages[index]);
                    },
                  ),
          ),
          ChatInput(controller: _messageController, onSend: _sendMessage),
        ],
      ),
    );
  }
}

// // ignore_for_file: use_build_context_synchronously
// import 'chat_back.dart';
// import '../../alert_mesg.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_markdown/flutter_markdown.dart';

// class ChatPage extends StatefulWidget {
//   const ChatPage({super.key});

//   @override
//   State<ChatPage> createState() => _ChatPageState();
// }

// class _ChatPageState extends State<ChatPage> {
//   final TextEditingController _messageController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//   final List<Map<String, String>> _messages = [];
//   bool _isLoading = false;
//   String _streamingText = "";
//   String _checkpointId = "";

//   @override
//   void dispose() {
//     _messageController.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }

//   void _scrollToBottom() {
//     if (_scrollController.hasClients) {
//       _scrollController.animateTo(
//         _scrollController.position.maxScrollExtent,
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeOut,
//       );
//     }
//   }

//   Future<void> _sendMessage() async {
//     if (_messageController.text.trim().isEmpty) {
//       showMessge("Please enter a message");
//       return;
//     }

//     String userMessage = _messageController.text.trim();
//     _messageController.clear();

//     setState(() {
//       _messages.add({'text': userMessage, 'sender': 'user'});
//       _isLoading = true;
//       _streamingText = "";
//     });

//     _scrollToBottom();

//     // ================= Stream Listen করা হচ্ছে =================
//     Chat.sendMessage(userMessage, _checkpointId).listen(
//       (data) {
//         setState(() {
//           switch (data['type']) {
//             case 'checkpoint':
//               _checkpointId = data['checkpoint_id'] ?? "";
//               break;

//             case 'content':
//               _streamingText += data['content'] ?? "";
//               if (_messages.isNotEmpty && _messages.last['sender'] == 'bot') {
//                 _messages.last['text'] = _streamingText;
//               } else {
//                 _messages.add({'text': _streamingText, 'sender': 'bot'});
//               }
//               break;

//             case 'queue_status':
//               _streamingText = data['message'] ?? "Please wait...";
//               if (_messages.isNotEmpty && _messages.last['sender'] == 'bot') {
//                 _messages.last['text'] = _streamingText;
//               } else {
//                 _messages.add({'text': _streamingText, 'sender': 'bot'});
//               }
//               break;

//             case 'analyzing_requirements':
//               if (_messages.isEmpty || _messages.last['sender'] != 'bot') {
//                 _messages.add({'text': '🔍 Analyzing...', 'sender': 'bot'});
//               }
//               break;

//             case 'end':
//               _isLoading = false;
//               _streamingText = "";
//               break;

//             case 'error':
//               _isLoading = false;
//               _messages.add({
//                 'text': '❌ Error: ${data['content']}',
//                 'sender': 'bot',
//               });
//               break;
//           }
//         });
//         _scrollToBottom();
//       },
//       onError: (e) {
//         setState(() {
//           _isLoading = false;
//           _messages.add({'text': '❌ Connection error: $e', 'sender': 'bot'});
//         });
//       },
//       onDone: () {
//         setState(() => _isLoading = false);
//       },
//     );
//     _scrollToBottom();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 43, 30, 30),
//       body: Column(
//         children: [
//           // Chat messages area
//           Expanded(
//             child: _messages.isEmpty
//                 ? const Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(Iconsax.message, size: 64, color: Colors.grey),
//                         SizedBox(height: 16),
//                         Text(
//                           "Start a conversation",
//                           style: TextStyle(fontSize: 18, color: Colors.grey),
//                         ),
//                       ],
//                     ),
//                   )
//                 : ListView.builder(
//                     controller: _scrollController,
//                     padding: const EdgeInsets.all(16),
//                     itemCount: _messages.length + (_isLoading ? 1 : 0),
//                     itemBuilder: (context, index) {
//                       if (index == _messages.length && _isLoading) {
//                         return _streamingText.isNotEmpty
//                             ? const SizedBox.shrink()
//                             : const Padding(
//                                 padding: EdgeInsets.all(8.0),
//                                 child: Row(
//                                   children: [
//                                     SizedBox(
//                                       width: 16,
//                                       height: 16,
//                                       child: CircularProgressIndicator(
//                                         strokeWidth: 2,
//                                       ),
//                                     ),
//                                     SizedBox(width: 16),
//                                     Text(
//                                       "Bot is typing...",
//                                       style: TextStyle(
//                                         color: Color.fromARGB(255, 43, 30, 30),
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               );
//                       }

//                       // ----------------------Base on user change design------------------------
//                       final message = _messages[index];
//                       final isUser = message['sender'] == 'user';

//                       return Align(
//                         alignment: isUser
//                             ? Alignment.centerRight
//                             : Alignment.centerLeft,
//                         child: Container(
//                           margin: const EdgeInsets.only(bottom: 12),
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 16,
//                             vertical: 12,
//                           ),
//                           decoration: BoxDecoration(
//                             color: isUser
//                                 ? const Color.fromARGB(255, 2, 5, 37)
//                                 : const Color.fromARGB(255, 13, 9, 9),
//                             borderRadius: BorderRadius.circular(16),
//                           ),
//                           constraints: BoxConstraints(
//                             maxWidth: isUser
//                                 ? MediaQuery.of(context).size.width * 0.75
//                                 : MediaQuery.of(context).size.width * 0.85,
//                           ),
//                           // ================= Markdown Processing =================
//                           child: isUser
//                               ? Text(
//                                   message['text']!,
//                                   style: const TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 16,
//                                   ),
//                                 )
//                               : MarkdownBody(
//                                   data: message['text']!.replaceAll(
//                                     r'\n',
//                                     '\n',
//                                   ),
//                                   selectable: true,
//                                   styleSheet: MarkdownStyleSheet(
//                                     p: const TextStyle(
//                                       color: Colors.white60,
//                                       fontSize: 16,
//                                     ),
//                                     listBullet: const TextStyle(
//                                       color: Colors.white60,
//                                       fontSize: 16,
//                                     ),
//                                     code: TextStyle(
//                                       color: Colors.red[700],
//                                       backgroundColor: const Color.fromARGB(
//                                         255,
//                                         58,
//                                         39,
//                                         39,
//                                       ),
//                                       fontSize: 14,
//                                     ),
//                                     codeblockDecoration: BoxDecoration(
//                                       color: Colors.white60,
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                   ),
//                                 ),
//                         ),
//                       );
//                     },
//                   ),
//           ),

//           // Input area
//           Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: const Color.fromARGB(255, 43, 30, 30),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withValues(alpha: 0.2),
//                   spreadRadius: 1,
//                   blurRadius: 5,
//                   offset: const Offset(0, -2),
//                 ),
//               ],
//             ),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _messageController,
//                     style: TextStyle(color: Colors.white60),
//                     decoration: InputDecoration(
//                       hintText: "Type your message...",
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(25),
//                         borderSide: BorderSide(color: Colors.white60),
//                       ),
//                       filled: true,
//                       fillColor: const Color.fromARGB(255, 43, 30, 30),
//                       contentPadding: const EdgeInsets.symmetric(
//                         horizontal: 20,
//                         vertical: 12,
//                       ),
//                     ),
//                     maxLines: null,
//                     textInputAction: TextInputAction.send,
//                     onSubmitted: (_) => _sendMessage(),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 GestureDetector(
//                   onTap: _sendMessage,
//                   child: Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: const BoxDecoration(
//                       color: Color.fromARGB(255, 2, 5, 37),
//                       shape: BoxShape.circle,
//                     ),
//                     child: const Icon(
//                       Iconsax.send_1,
//                       color: Colors.white,
//                       size: 20,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
