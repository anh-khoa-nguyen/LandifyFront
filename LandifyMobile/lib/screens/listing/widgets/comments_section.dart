import 'package:flutter/material.dart';
import 'package:landifymobile/screens/listing/models/comment.dart';

final List<Comment> mockComments = [
  Comment(
    avatarUrl: 'https://picsum.photos/seed/user1/100/100',
    name: 'Trần Minh Anh',
    text: 'Lô đất này vị trí đẹp quá, không biết có thương lượng thêm không ạ?',
    timeAgo: '2 giờ trước',
  ),
  Comment(
    avatarUrl: 'https://picsum.photos/seed/user2/100/100',
    name: 'Lê Hoàng',
    text: 'Đường trước nhà có bị ngập không bạn ơi?',
    timeAgo: '5 giờ trước',
  ),
];

class CommentsSection extends StatelessWidget {
  const CommentsSection({super.key});

  @override
  Widget build(BuildContext context) {
    // ***** THAY ĐỔI GIÁ TRỊ NÀY ĐỂ XEM CÁC GIAO DIỆN KHÁC NHAU *****
    // true: Hiển thị danh sách bình luận mẫu
    // false: Hiển thị giao diện "Chưa có bình luận nào"
    const bool hasComments = true;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: Colors.grey.shade200, width: 1.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tiêu đề "Bình luận"
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('Bình luận', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 16),

            // Hiển thị có điều kiện
            hasComments ? _buildCommentsList() : _buildNoCommentsView(),

            const SizedBox(height: 16),
            const Divider(height: 1, indent: 16, endIndent: 16),
            const SizedBox(height: 12),

            // Ô nhập liệu bình luận
            _buildCommentInputField(),
          ],
        ),
      ),
    );
  }

  /// Giao diện khi CÓ bình luận
  Widget _buildCommentsList() {
    return ListView.separated(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: mockComments.length,
      itemBuilder: (context, index) {
        return _buildCommentItem(mockComments[index]);
      },
      separatorBuilder: (context, index) => const SizedBox(height: 16),
    );
  }

  /// Giao diện cho MỘT bình luận
  Widget _buildCommentItem(Comment comment) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(comment.avatarUrl),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(comment.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text(comment.text, style: const TextStyle(color: Colors.black87, fontSize: 14)),
                const SizedBox(height: 6),
                Text(comment.timeAgo, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Giao diện khi CHƯA có bình luận
  Widget _buildNoCommentsView() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32.0),
      child: Center(
        child: Column(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: Colors.grey.shade100,
              child: Icon(Icons.chat_bubble_outline_rounded, color: Colors.grey.shade400, size: 30),
            ),
            const SizedBox(height: 16),
            Text(
              'Chưa có bình luận nào.',
              style: TextStyle(color: Colors.grey.shade700, fontSize: 15),
            ),
            const SizedBox(height: 4),
            Text(
              'Hãy để lại bình luận cho người bán.',
              style: TextStyle(color: Colors.grey.shade700, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }

  /// Ô nhập liệu bình luận ở dưới cùng
  Widget _buildCommentInputField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 16,
            backgroundColor: Colors.grey,
            child: Icon(Icons.person, size: 20, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Đăng nhập bằng SĐT để bình luận...',
                hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.send, color: Colors.grey.shade400),
        ],
      ),
    );
  }
}