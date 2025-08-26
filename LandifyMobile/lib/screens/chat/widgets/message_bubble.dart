import 'package:flutter/material.dart';
import 'package:landifymobile/screens/chat/widgets/meeting_card.dart';
import 'package:landifymobile/screens/chat/widgets/message.dart';
import 'package:landifymobile/screens/chat/widgets/preview_card.dart';
// Import thẻ đề nghị hợp tác lớn
import 'package:landifymobile/screens/chat/widgets/cooperation_card.dart';
import 'package:landifymobile/screens/chat/widgets/reminder_card.dart';
import 'delay_card.dart';

const Color kPrimaryBlue = Color(0xFF165DFF);

class MessageBubble extends StatelessWidget {
  final Message message;
  final Function(String)? onSendMessage;
  const MessageBubble({
    super.key,
    required this.message,
    this.onSendMessage,
  });

  @override
  Widget build(BuildContext context) {
    // BƯỚC 1: KIỂM TRA LOẠI TIN NHẮN ĐẶC BIỆT NGAY TẠI ĐÂY
    // Đây là "bộ định tuyến" quyết định widget nào sẽ được hiển thị.
    if (message.isCooperationRequest) {
      // Nếu là đề nghị hợp tác, trả về thẻ lớn và kết thúc.
      // Nó không bị giới hạn chiều rộng bởi ConstrainedBox.
      return const CooperationRequestCard();
    }

    if (message.isMeetingRequest) {
      // Nếu là đề nghị hợp tác, trả về thẻ lớn và kết thúc.
      // Nó không bị giới hạn chiều rộng bởi ConstrainedBox.
      return const MeetingRequestCard();
    }

    if (message.isMeetingReminder) {
      // THAY ĐỔI 3: Truyền callback đã nhận được xuống cho MeetingReminderCard
      // Thêm một assert để đảm bảo callback được cung cấp khi cần thiết
      assert(onSendMessage != null, 'onSendMessage must be provided for reminder messages');
      return MeetingReminderCard(onSendMessage: onSendMessage!);
    }

    if (message.isDelayRequest) {
      return const DelayRequestCard();
    }

    // Nếu không phải là đề nghị hợp tác, tiếp tục logic hiển thị bong bóng chat thông thường.
    return message.sender == Sender.me
        ? _buildMyBubble()
        : _buildOtherBubble();
  }

  /// Xây dựng bong bóng chat cho người khác (có thể chứa preview)
  Widget _buildOtherBubble() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 320),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hiển thị card preview nếu có
          if (message.containsPropertyPreview) const PropertyPreviewCard(),

          // THAY ĐỔI: Chỉ cần MỘT khối hiển thị bong bóng text
          // Nó chỉ hiển thị khi tin nhắn có text
          if (message.text.isNotEmpty)
            Container(
              // Thêm margin top chỉ khi có cả preview và text
              margin: EdgeInsets.only(top: message.containsPropertyPreview ? 8 : 0),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              decoration: const BoxDecoration(
                color: Color(0xFFF4F6F9),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(14),
                  topLeft: Radius.circular(14),
                  bottomRight: Radius.circular(14),
                ),
              ),
              child: Text(message.text, style: const TextStyle(fontSize: 15)),
            ),
        ],
      ),
    );
  }

  /// Xây dựng bong bóng chat cho chính mình.
  Widget _buildMyBubble() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 320),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
        decoration: const BoxDecoration(
          color: kPrimaryBlue,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(14),
            topLeft: Radius.circular(14),
            bottomLeft: Radius.circular(14),
          ),
        ),
        child: Text(message.text, style: const TextStyle(fontSize: 15, color: Colors.white)),
      ),
    );
  }
}