// lib/services/chat_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Lấy stream tin nhắn real-time cho một cuộc trò chuyện
  Stream<QuerySnapshot> getMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  /// Hàm gửi tin nhắn chung (private)
  Future<void> _sendMessage(String chatId, Map<String, dynamic> messageData) async {
    // Thêm tin nhắn mới vào sub-collection 'messages'
    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(messageData);

    // Xác định mô tả cho tin nhắn cuối cùng
    String lastMessageText;
    switch (messageData['type']) {
      case 'text':
        lastMessageText = messageData['text'];
        break;
      case 'cooperation_request':
        lastMessageText = 'Đã gửi một đề nghị hợp tác.';
        break;
      case 'meeting_request':
        lastMessageText = 'Đã gửi một yêu cầu gặp mặt.';
        break;
      default:
        lastMessageText = '[Hành động mới]';
    }

    // Cập nhật thông tin cuộc trò chuyện
    await _firestore.collection('chats').doc(chatId).set({
      'lastMessage': lastMessageText,
      'lastMessageTimestamp': messageData['timestamp'],
    }, SetOptions(merge: true));
  }

  /// Gửi một tin nhắn văn bản
  Future<void> sendTextMessage(String chatId, String text, String senderId) async {
    if (text.trim().isEmpty) return;
    await _sendMessage(chatId, {
      'type': 'text',
      'text': text,
      'senderId': senderId,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  /// Gửi một yêu cầu hợp tác
  Future<void> sendCooperationRequest(String chatId, String senderId) async {
    await _sendMessage(chatId, {
      'type': 'cooperation_request',
      'senderId': senderId,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  /// Gửi một yêu cầu gặp mặt
  Future<void> sendMeetingRequest(String chatId, String senderId) async {
    await _sendMessage(chatId, {
      'type': 'meeting_request',
      'senderId': senderId,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  /// Gửi một yêu cầu dời hẹn
  Future<void> sendDelayRequest(String chatId, String senderId) async {
    await _sendMessage(chatId, {
      'type': 'delay_request',
      'senderId': senderId,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  /// Gửi một lời nhắc cuộc hẹn
  Future<void> sendMeetingReminder(String chatId, String senderId) async {
    await _sendMessage(chatId, {
      'type': 'meeting_reminder',
      'senderId': senderId,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}