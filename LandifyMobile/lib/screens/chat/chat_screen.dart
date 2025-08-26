// lib/screens/chat/chat_screen.dart
import 'package:flutter/material.dart';
import 'package:landifymobile/screens/chat/widgets/message.dart';
import 'package:landifymobile/screens/chat/widgets/product_card.dart';
import 'package:landifymobile/screens/chat/widgets/app_bar.dart';
import 'package:landifymobile/screens/chat/widgets/input_area.dart';
import 'package:landifymobile/screens/chat/widgets/message_bubble.dart';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:landifymobile/services/chat_service.dart';

const Color kBubbleGray = Color(0xFFF4F6F9);

class ChatScreen extends StatefulWidget {
  final String receiverId;
  final String receiverName;

  const ChatScreen({
    super.key,
    required this.receiverId,
    required this.receiverName,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _ctrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();

  final ChatService _chatService = ChatService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // final List<Message> _messages = [
  //   Message(sender: Sender.other, text: 'https://chotot.com/127098617.htm', containsPropertyPreview: true),
  //   Message(sender: Sender.other, text: 'Xin nhận tấm lòng của bạn 😄'),
  //   Message(sender: Sender.other, text: 'Kkk'),
  //
  //   Message(
  //     text: '', // Text có thể để trống vì nó sẽ không được sử dụng
  //     sender: Sender.other, // Đề nghị luôn đến từ người khác
  //     isCooperationRequest: true, // <-- Đặt thuộc tính này thành true
  //   ),
  //
  //   Message(
  //     text: '',
  //     sender: Sender.other,
  //     isMeetingRequest: true,
  //   ),
  //
  //   Message(
  //     text: '', // Text có thể để trống
  //     sender: Sender.other, // Lời nhắc thường đến từ hệ thống (hiển thị bên trái)
  //     isMeetingReminder: true, // <-- ĐẶT THUỘC TÍNH NÀY THÀNH TRUE
  //   ),
  //
  // ];

  final List<String> _quickReplies = [
    'Nhà này còn không ạ?',
    'Tình trạng giấy tờ như thế nào ạ?',
    'Giá có fix không?',
    'Xem nhà khi nào được?',
  ];

  bool _showBottomProduct = true;

  @override
  void dispose() {
    _ctrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  String _getChatId() {
    final String currentUserId = _auth.currentUser!.uid;
    List<String> ids = [currentUserId, widget.receiverId];
    ids.sort();
    return ids.join('_');
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;
    final String currentUserId = _auth.currentUser!.uid;
    String chatId = _getChatId(); // Sử dụng hàm helper

    // Gọi hàm sendTextMessage
    _chatService.sendTextMessage(chatId, text, currentUserId);

    _ctrl.clear();
  }

  void _handleReminderAction(String type) {
    if (type == 'delay_request') {
      final String currentUserId = _auth.currentUser!.uid;
      // Gửi một tin nhắn loại "delay_request" từ phía người nhận
      // Lưu ý: senderId ở đây sẽ là ID của người nhận (receiverId)
      _chatService.sendDelayRequest(_getChatId(), widget.receiverId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: ChatAppBar(title: widget.receiverName),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: _buildMessagesList()),
            _buildQuickReplies(),
            if (_showBottomProduct)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: BottomProductCard(
                  onClose: () => setState(() => _showBottomProduct = false),
                  onTap: () {},
                ),
              ),
            ChatInputArea(controller: _ctrl, onSend: _sendMessage),
          ],
        ),
      ),
    );
  }

  Widget _buildMessagesList() {
    final String currentUserId = _auth.currentUser!.uid;

    return StreamBuilder<QuerySnapshot>(
      stream: _chatService.getMessages(_getChatId()),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Đã có lỗi xảy ra.'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('Chưa có tin nhắn nào.'));
        }

        // Tự động cuộn xuống cuối khi có tin nhắn mới
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollCtrl.hasClients) {
            _scrollCtrl.jumpTo(_scrollCtrl.position.maxScrollExtent);
          }
        });

        return ListView(
          controller: _scrollCtrl,
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
          children: snapshot.data!.docs.map((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

            final sender = (data['senderId'] == currentUserId) ? Sender.me : Sender.other;
            final messageType = data['type'] as String? ?? 'text';

            Message msg;

            // "Định tuyến" dữ liệu từ Firestore sang đối tượng Message của UI
            switch (messageType) {
              case 'cooperation_request':
                msg = Message(sender: sender, text: '', isCooperationRequest: true);
                break;
              case 'meeting_request':
                msg = Message(sender: sender, text: '', isMeetingRequest: true);
                break;
              case 'meeting_reminder':
                msg = Message(sender: sender, text: '', isMeetingReminder: true);
                break;
              case 'delay_request':
                msg = Message(sender: sender, text: '', isDelayRequest: true);
                break;
              default: // 'text' và các trường hợp khác
                final text = data['text'] ?? '';
                msg = Message(
                  sender: sender,
                  text: text,
                  containsPropertyPreview: text.startsWith('https'),
                );
            }

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Align(
                alignment: msg.sender == Sender.other ? Alignment.centerLeft : Alignment.centerRight,
                child: MessageBubble(
                  message: msg,
                  onSendMessage: _handleReminderAction,
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildQuickReplies() {
    return Container(
      padding: const EdgeInsets.only(left: 12, right: 12, bottom: 8, top: 6),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _quickReplies.map((q) {
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ActionChip(
                label: Text(q, style: const TextStyle(fontSize: 13)),
                backgroundColor: Colors.white,
                elevation: 1,
                onPressed: () => _sendMessage(q),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}