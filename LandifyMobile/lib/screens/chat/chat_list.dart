import 'package:flutter/material.dart';

import 'package:landifymobile/screens/chat/chat_screen.dart';
import 'package:landifymobile/screens/chat/models/chat_item.dart';
import 'package:landifymobile/screens/chat/widgets/chat_list/app_bar.dart';
import 'package:landifymobile/screens/chat/widgets/chat_list/list_tabs.dart';
import 'package:landifymobile/screens/chat/widgets/chat_list/list_title.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Dữ liệu giả, sử dụng ảnh thật
  // final List<ChatItem> items = [
  //   ChatItem(avatarUrl: 'https://i.imgur.com/4QfKuz1.jpg', name: 'Cloud của tôi', message: 'Bạn: [Hình ảnh]', time: '2 giờ', verified: true),
  //   ChatItem(avatarUrl: 'https://i.imgur.com/4QfKuz1.jpg', name: 'Nguyễn Vũ Gia Bảo', message: 'Okay', time: 'Chưa gửi', isSendingFailed: true),
  //   ChatItem(avatarUrl: 'https://i.imgur.com/4QfKuz1.jpg', name: 'Zalopay', message: '🤝 Chung tay vì nhân dân Cuba', time: '3 giờ', verified: true, hasUnread: true),
  //   ChatItem(avatarUrl: 'https://i.imgur.com/4QfKuz1.jpg', name: 'Media Box', message: 'Báo Mới: Toàn cảnh cuộc gặp lịch sử...', time: '16 giờ'),
  //   ChatItem(avatarUrl: 'https://i.imgur.com/4QfKuz1.jpg', name: 'Vũ BingChiling', message: 'Hình như fen cũng có đúng không', time: '17 giờ'),
  //   ChatItem(avatarUrl: 'https://i.imgur.com/4QfKuz1.jpg', name: 'Chị Lan (Én)', message: 'Bạn: đr', time: '21 giờ'),
  //   ChatItem(avatarUrl: 'https://i.imgur.com/4QfKuz1.jpg', name: 'QL Dự Án PM', message: 'Bạn: Tin nhắn đã được thu hồi', time: 'T6'),
  //   ChatItem(avatarUrl: 'https://i.imgur.com/4QfKuz1.jpg', name: 'A Mẹ lu ❤️', message: '[Cuộc gọi video đi]', time: 'T6'),
  //   ChatItem(avatarUrl: 'https://i.imgur.com/4QfKuz1.jpg', name: 'Lập trình CSDL', message: 'Nhắc hẹn: 15/08/2025 báo cáo ( phải ...', time: 'T6', hasUnread: true),
  // ];

  @override
  Widget build(BuildContext context) {
    final String? currentUserId = _auth.currentUser?.uid;

    if (currentUserId == null) {
      return const Scaffold(
        body: Center(child: Text("Vui lòng đăng nhập để xem tin nhắn.")),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const ChatListAppBar(),
      body: Column(
        children: [
          const ChatListTabs(),
          const Divider(height: 1, thickness: 1),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('chats')
                  .where('users', arrayContains: currentUserId)
                  .orderBy('lastMessageTimestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                print('Stream Connection State: ${snapshot.connectionState}');

                if (snapshot.hasError) {
                  print('STREAM ERROR: ${snapshot.error}'); // In ra lỗi cụ thể
                  return const Center(child: Text('Đã có lỗi xảy ra.'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  print('Stream is waiting for data...');
                  return const Center(child: CircularProgressIndicator());
                }

                print('Stream has data: ${snapshot.hasData}');
                if (snapshot.hasData) {
                  print('Documents found: ${snapshot.data!.docs.length}');
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('Bạn chưa có cuộc trò chuyện nào.'));
                }

                // Nếu có dữ liệu, hiển thị ListView
                final chatDocs = snapshot.data!.docs;
                return ListView.separated(
                  itemCount: chatDocs.length,
                  separatorBuilder: (context, index) => const Divider(height: 1, indent: 88, endIndent: 16),
                  itemBuilder: (context, index) {
                    // Xây dựng một widget cho mỗi cuộc trò chuyện
                    return _buildChatListItem(chatDocs[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatListItem(DocumentSnapshot chatDoc) {
    Map<String, dynamic> data = chatDoc.data() as Map<String, dynamic>;
    final String currentUserId = _auth.currentUser!.uid;

    // Lấy ID của người còn lại trong cuộc trò chuyện
    List<String> users = List<String>.from(data['users']);
    final String otherUserId = users.firstWhere((id) => id != currentUserId, orElse: () => '');

    if (otherUserId.isEmpty) {
      return const SizedBox.shrink(); // Bỏ qua nếu có lỗi dữ liệu
    }

    // SỬ DỤNG PHIÊN BẢN FUTUREBUILDER AN TOÀN HƠN
    return FutureBuilder<DocumentSnapshot>(
      future: _firestore.collection('users').doc(otherUserId).get(),
      builder: (context, userSnapshot) {
        // --- CÁC BƯỚC KIỂM TRA AN TOÀN ---

        // 1. Kiểm tra nếu có lỗi kết nối
        if (userSnapshot.hasError) {
          return const ListTile(title: Text("Lỗi tải dữ liệu người dùng."));
        }

        // 2. Kiểm tra nếu đang tải
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return const ListTile(title: Text("Đang tải..."));
        }

        // 3. (QUAN TRỌNG NHẤT) Kiểm tra nếu document không tồn tại
        if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
          return ListTile(title: Text("Không tìm thấy người dùng: $otherUserId"));
        }

        // --- KHI DỮ LIỆU AN TOÀN ---
        // Chỉ khi vượt qua tất cả các bước kiểm tra, chúng ta mới tiến hành đọc dữ liệu
        final userData = userSnapshot.data!.data() as Map<String, dynamic>;

        final chatItem = ChatItem(
          avatarUrl: userData['avatarUrl'] ?? 'https://i.imgur.com/4QfKuz1.jpg',
          name: userData['displayName'] ?? 'Người dùng không tên',
          message: data['lastMessage'] ?? '',
          time: 'T5', // TODO: Format lại timestamp
        );

        return ChatListTile(
          item: chatItem,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatScreen(
                  receiverId: otherUserId,
                  receiverName: chatItem.name,
                ),
              ),
            );
          },
        );
      },
    );
  }
}