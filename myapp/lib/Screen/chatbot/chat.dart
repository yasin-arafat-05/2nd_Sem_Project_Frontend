// ignore_for_file: avoid_print, use_build_context_synchronously
import 'package:geolocator/geolocator.dart';

import '../../alert_mesg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:myapp/Screen/chatbot/chat_back.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../ConnectSideBar/load_chat_msg_for_thread_id_back.dart';
import '../profile/edit_profile.dart';

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
  final VoidCallback? onLocationShare;
  const ChatBubble({super.key, required this.message, this.onLocationShare});

  @override
  Widget build(BuildContext context) {
    final isUser = message.sender == 'user';

    // ================= If locaiton _request is occur ==============
    if (message.text == '__location_request__') {
      return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 13, 9, 9),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '📍 Location প্রয়োজন',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'কাছের দোকান খুঁজতে location দরকার।',
                style: TextStyle(color: Colors.white60, fontSize: 14),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: onLocationShare,
                icon: const Icon(Iconsax.location, size: 18),
                label: const Text('Location Share করুন'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 2, 5, 37),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

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

/*
//
# ================= ChatInput Button =================
//
*/

class ChatInput extends StatefulWidget {
  final TextEditingController controller;
  final Function(String workflowType) onSend;
  const ChatInput({super.key, required this.controller, required this.onSend});

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  String _selectedWorkflow = "social_media_posting";
  void _handleSend() {
    if (widget.controller.text.trim().isNotEmpty) {
      widget.onSend(_selectedWorkflow);
    }
  }

  @override
  Widget build(BuildContext context) {
    final commonBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(25),
      borderSide: const BorderSide(color: Colors.white30, width: 1),
    );

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(color: Color.fromARGB(255, 43, 30, 30)),
      child: Row(
        children: [
          // <--- select button ➕ --->
          PopupMenuButton<String>(
            color: Colors.black45,
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 9, 3, 27).withAlpha(200),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _selectedWorkflow == "social_media_posting"
                    ? Iconsax.magicpen
                    : Iconsax.search_status,
                color: Colors.white,
                size: 22,
              ),
            ),
            tooltip: "Select Workflow",
            onSelected: (String value) {
              setState(() {
                _selectedWorkflow = value;
              });

              //<--------While uesr workflow then send message to the users:------>
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Switched to ${value == 'social_media_posting' ? 'Social Media Posting' : 'Local Search'}",
                  ),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'social_media_posting',
                child: Row(
                  children: [
                    Icon(Iconsax.instagram, color: Colors.white, size: 20.0),
                    const SizedBox(width: 8),
                    const Text(
                      'Social Media Posting',
                      style: TextStyle(color: Colors.white54),
                    ),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'local_search',
                child: Row(
                  children: [
                    Icon(
                      Iconsax.search_status,
                      color: Colors.white,
                      size: 20.0,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Local Search',
                      style: TextStyle(color: Colors.white54),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),

          // <------------- Text-Input-Field ----------------->
          Expanded(
            child: TextField(
              controller: widget.controller,
              style: const TextStyle(color: Colors.white),
              maxLines: null,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _handleSend(),
              decoration: InputDecoration(
                hintText: _selectedWorkflow == "social_media_posting"
                    ? "Write social media prompt..."
                    : "Enter product name or details...",
                hintStyle: const TextStyle(color: Colors.white30),
                filled: true,
                fillColor: const Color.fromARGB(255, 34, 23, 23),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                border: commonBorder,
                enabledBorder: commonBorder,
                focusedBorder: commonBorder.copyWith(
                  borderSide: const BorderSide(
                    color: Colors.white60,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // <--- Send Button --->
          Material(
            color: const Color.fromARGB(255, 2, 5, 37),
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: _handleSend,
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: Icon(Iconsax.send_1, color: Colors.white, size: 20),
              ),
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
  bool _waitingForLocation = false;
  String _currentWorkflowType = "social_media_posting";
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

  // location নিয়ে resume করো
  Future<void> _resumeWithLocation() async {
    try {
      Position position = await getCurrentLocation();

      setState(() {
        _waitingForLocation = false;
        _isLoading = true;
        _streamingText = "";
        // location card টা replace করো
        if (_messages.isNotEmpty &&
            _messages.last.text == '__location_request__') {
          _messages.last.text = '📍 Location shared!';
        }
      });

      Chat.resumeWithLocation(
        _checkpointId,
        position.latitude,
        position.longitude,
        _currentWorkflowType,
      ).listen((data) {
        setState(() {
          switch (data['type']) {
            case 'content':
              _streamingText += data['content'] ?? "";
              if (_messages.isNotEmpty && _messages.last.sender == 'bot') {
                _messages.last.text = _streamingText;
              } else {
                _messages.add(ChatMessage(text: _streamingText, sender: 'bot'));
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
      }, onDone: () => setState(() => _isLoading = false));
    } catch (e) {
      setState(() {
        _waitingForLocation = false;
        _isLoading = false;
        _messages.add(
          ChatMessage(text: '❌ Location can not be fetch: $e', sender: 'bot'),
        );
      });
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

  /*
  ========================================================
  ===============SendMessage==============================
  ========================================================
  */

  Future<void> _sendMessage(String workflowType) async {
    if (_messageController.text.trim().isEmpty) {
      showMessge("Please enter a message");
      return;
    }
    _currentWorkflowType = workflowType;
    String userMessage = _messageController.text.trim();
    _messageController.clear();

    setState(() {
      _messages.add(ChatMessage(text: userMessage, sender: 'user'));
      _isLoading = true;
      _streamingText = "";
    });

    _scrollToBottom();

    // ===================================================================
    // =================== Send Backend Request ==========================
    // ======================== Stream Listen ============================
    Chat.sendMessage(userMessage, _checkpointId, workflowType).listen(
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

            case 'request_location':
              _isLoading = false;
              _waitingForLocation = true;
              _messages.add(
                ChatMessage(text: '__location_request__', sender: 'bot'),
              );
              break;

            //
            // ====================== Workflow node ===========================
            //
            case 'analyzing_requirements':
              if (_messages.isEmpty || _messages.last.sender != 'bot') {
                _messages.add(
                  ChatMessage(
                    text: '🔍 Analyzing requirements...',
                    sender: 'bot',
                  ),
                );
              }
              break;

            case 'clarifying_requirements':
              if (_messages.isEmpty || _messages.last.sender != 'bot') {
                _messages.add(
                  ChatMessage(text: '💬 Clarifying goals...', sender: 'bot'),
                );
              }
              break;

            case 'researching_content':
              if (_messages.isEmpty || _messages.last.sender != 'bot') {
                _messages.add(
                  ChatMessage(
                    text: '📚 Researching trend and topics...',
                    sender: 'bot',
                  ),
                );
              }
              break;

            case 'generating_media':
            case 'generating_media_content':
              if (_messages.isEmpty || _messages.last.sender != 'bot') {
                _messages.add(
                  ChatMessage(
                    text: '🎨 Generating media design...',
                    sender: 'bot',
                  ),
                );
              }
              break;

            case 'creating_content':
              if (_messages.isEmpty || _messages.last.sender != 'bot') {
                _messages.add(
                  ChatMessage(
                    text: '✍️ Drafting creative copy...',
                    sender: 'bot',
                  ),
                );
              }
              break;

            case 'quality_check':
            case 'checking_quality':
              if (_messages.isEmpty || _messages.last.sender != 'bot') {
                _messages.add(
                  ChatMessage(
                    text: '🛡️ Checking output quality...',
                    sender: 'bot',
                  ),
                );
              }
              break;

            case 'posting_content':
              if (_messages.isEmpty || _messages.last.sender != 'bot') {
                _messages.add(
                  ChatMessage(
                    text: '🚀 Dispatching to platforms...',
                    sender: 'bot',
                  ),
                );
              }
              break;

            // --- প্রোডাক্ট রিসার্চ ওয়ার্কফ্লো নোডসমূহ ---
            case 'fetching_product_info':
              if (_messages.isEmpty || _messages.last.sender != 'bot') {
                _messages.add(
                  ChatMessage(
                    text: '📦 Fetching core product info...',
                    sender: 'bot',
                  ),
                );
              }
              break;

            case 'analyzing_competitors':
              if (_messages.isEmpty || _messages.last.sender != 'bot') {
                _messages.add(
                  ChatMessage(
                    text: '📊 Analyzing market competitors...',
                    sender: 'bot',
                  ),
                );
              }
              break;

            case 'processing':
              String nodeName = data['node'] ?? 'Processing';
              if (_messages.isEmpty || _messages.last.sender != 'bot') {
                _messages.add(
                  ChatMessage(
                    text: '⚙️ Working on: $nodeName...',
                    sender: 'bot',
                  ),
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
                ChatMessage(
                  text: '❌ Error from send message: ${data['content']}',
                  sender: 'bot',
                ),
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
                      return ChatBubble(
                        message: _messages[index],
                        onLocationShare: _waitingForLocation
                            ? _resumeWithLocation
                            : null,
                      );
                    },
                  ),
          ),
          ChatInput(
            controller: _messageController,
            onSend: (workflowType) => _sendMessage(workflowType),
          ),
        ],
      ),
    );
  }
}
