import 'package:flutter/material.dart';
import '../services/chat_service.dart';

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, this.isUser = false});
}

class ChatPopup extends StatefulWidget {
  const ChatPopup({Key? key}) : super(key: key);

  @override
  _ChatPopupState createState() => _ChatPopupState();
}

class _ChatPopupState extends State<ChatPopup> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final List<ChatMessage> _messages = [
    ChatMessage(
      text: 'Jai Ganesh! 🙏\nI am your Ganesha assistant. How may I help you with Ganesh Chaturthi or Lord Ganesha today?',
      isUser: false,
    )
  ];
  bool _isLoading = false;

  void _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(text: message, isUser: true));
      _isLoading = true;
    });

    _messageController.clear();

    try {
      final response = await _chatService.sendMessage(message);
      
      setState(() {
        _messages.add(ChatMessage(text: response));
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(
          text: 'Sorry, I encountered an error. Please try again.',
        ));
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.7,
        width: MediaQuery.of(context).size.width * 0.9,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Festival Assistant',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF333333),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Color(0xFF666666)),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const Divider(),
            
            // Messages
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return _buildMessageBubble(message);
                },
              ),
            ),
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.only(bottom: 16.0),
                child: Center(child: CircularProgressIndicator()),
              ),
            
            // Input field
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F8F8),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Ask about Ganesh Chaturthi...',
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        hintStyle: TextStyle(color: const Color(0xFF999999)),
                      ),
                      textInputAction: TextInputAction.send,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.sentences,
                      enableSuggestions: true,
                      enableInteractiveSelection: true,
                      onSubmitted: (_) => _sendMessage(),
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontFamily: 'Noto Sans', // This font supports multiple scripts
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send, color: const Color(0xFFFF9B00)),
                    onPressed: _isLoading ? null : _sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: message.isUser 
              ? const Color(0xFFFF9B00).withOpacity(0.1) 
              : const Color(0xFFF0F0F0),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: const Color(0xFF333333),
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
}
