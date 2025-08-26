import 'package:flutter/material.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:url_launcher/url_launcher.dart';
import 'delay_card.dart';

// Enum để quản lý trạng thái của các nút chính
enum MeetingStatus { none, arrived, notArrived, userNotArrived }

class MeetingReminderCard extends StatefulWidget {
  // Thêm callback để widget này có thể "gửi" một tin nhắn mới ra ngoài
  final Function(String type) onSendMessage;
  const MeetingReminderCard({super.key, required this.onSendMessage});

  @override
  State<MeetingReminderCard> createState() => _MeetingReminderCardState();
}

class _MeetingReminderCardState extends State<MeetingReminderCard> {
  // State variables
  MeetingStatus _selectedStatus = MeetingStatus.none;
  bool _isWaitingExpanded = false;
  bool _isUserLateOptionsExpanded = false;
  bool _isCountdownActive = false;

  /// Xử lý sự kiện khi nhấn nút "Gọi điện"
  Future<void> _makePhoneCall() async {
    // Thay bằng SĐT của người cần gọi
    final Uri launchUri = Uri(scheme: 'tel', path: '+84123456789');
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể thực hiện cuộc gọi.')),
      );
    }
  }

  /// Hiển thị hộp thoại xác nhận hủy hẹn
  void _showCancelDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Bạn có chắc là không muốn đợi nữa?'),
          content: const Text('Cuộc hẹn này sẽ bị hủy.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Từ chối'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Đồng ý'),
              onPressed: () {
                // TODO: Thêm logic hủy hẹn ở đây
                print('Cuộc hẹn đã bị hủy.');
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Hiển thị widget đếm ngược nếu đang active
    if (_isCountdownActive) {
      return _buildCountdownView();
    }

    // Giao diện ban đầu
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          const _RingingAlarmIcon(), // Icon đồng hồ rung
          const SizedBox(height: 16),
          const Text('Tới thời gian đã hẹn rồi!', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Hôm nay lúc 21:50', style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
          const SizedBox(height: 16),
          const Text('Người bạn hẹn đã tới hay chưa?', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 24),
          if (_selectedStatus == MeetingStatus.none)
            _buildMainActionButtons()
          else
            _buildSelectedStatusView(),
          // Hiệu ứng xổ ra/thu lại mượt mà cho các tùy chọn chờ
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: _isWaitingExpanded ? _buildWaitingOptions() : const SizedBox.shrink(),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: _isUserLateOptionsExpanded ? _buildUserLateOptions() : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  /// Xây dựng 3 nút bấm chính
  Widget _buildMainActionButtons() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8.0,
      runSpacing: 8.0,
      children: [
        _buildMainButton('Đã tới rồi', MeetingStatus.arrived),
        _buildMainButton('Chưa tới nữa', MeetingStatus.notArrived),
        _buildMainButton('Tôi chưa tới', MeetingStatus.userNotArrived),
      ],
    );
  }

  Widget _buildSelectedStatusView() {
    // Xác định label và status dựa trên lựa chọn
    String label = '';
    switch (_selectedStatus) {
      case MeetingStatus.arrived:
        label = 'Đã tới rồi';
        break;
      case MeetingStatus.notArrived:
        label = 'Chưa tới nữa';
        break;
      case MeetingStatus.userNotArrived:
        label = 'Tôi chưa tới';
        break;
      case MeetingStatus.none:
        break;
    }
    return _buildMainButton(label, _selectedStatus);
  }

  /// Widget helper để tạo một nút bấm chính
  Widget _buildMainButton(String label, MeetingStatus status) {
    bool isSelected = _selectedStatus == status;
    return OutlinedButton(
      onPressed: () {
        setState(() {
          // THAY ĐỔI 2: Thêm logic hủy chọn
          // Nếu nhấn vào nút đang được chọn, quay về trạng thái ban đầu
          if (isSelected) {
            _selectedStatus = MeetingStatus.none;
            _isWaitingExpanded = false;
            _isUserLateOptionsExpanded = false;
          } else {
            // Ngược lại, thực hiện lựa chọn mới
            _selectedStatus = status;
            _isWaitingExpanded = (status == MeetingStatus.notArrived);
            _isUserLateOptionsExpanded = (status == MeetingStatus.userNotArrived);
          }
        });
      },
      style: OutlinedButton.styleFrom(
        foregroundColor: isSelected ? Colors.white : Colors.black87,
        backgroundColor: isSelected
            ? (status == MeetingStatus.notArrived ? Colors.orange.shade800 : Colors.blue.shade800)
            : Colors.white,
        side: BorderSide(color: Colors.grey.shade300),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      child: Text(label),
    );
  }

  /// Xây dựng 3 tùy chọn khi người dùng chọn "Chưa tới nữa"
  Widget _buildWaitingOptions() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Divider(color: Colors.grey.shade200),
        ),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8.0,
          runSpacing: 8.0,
          children: [
            _buildSecondaryButton('Đợi thêm 15 phút', () {
              setState(() => _isCountdownActive = true);
            }),
            _buildSecondaryButton('Gọi điện', _makePhoneCall),
            // Sử dụng dialog mới
            _buildSecondaryButton('Không đợi nữa', () {
              showCancelWithReasonDialog(context, title: 'Bạn không muốn đợi nữa?');
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildUserLateOptions() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Divider(color: Colors.grey.shade200),
        ),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8.0,
          runSpacing: 8.0,
          children: [
            _buildSecondaryButton('Hẹn trễ 15p', () {
              // Gọi callback để gửi tin nhắn "delay_request"
              widget.onSendMessage('delay_request');
            }),
            _buildSecondaryButton('Gọi điện', _makePhoneCall),
            _buildSecondaryButton('Hủy hẹn', () {
              showCancelWithReasonDialog(context, title: 'Bạn muốn hủy hẹn?');
            }),
          ],
        ),
      ],
    );
  }

  /// Widget helper để tạo một nút bấm phụ
  Widget _buildSecondaryButton(String label, VoidCallback onPressed) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.black87,
        side: BorderSide(color: Colors.grey.shade300),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      // Tăng font size ở đây
      child: Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14)),
    );
  }

  /// Widget xây dựng giao diện đếm ngược
  Widget _buildCountdownView() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const _RingingAlarmIcon(isSmall: true),
          const SizedBox(width: 16),
          const Text('Thời gian đếm ngược: ', style: TextStyle(fontSize: 16)),
          Countdown(
            seconds: 900, // 15 phút
            build: (_, double time) {
              int minutes = (time / 60).floor();
              int seconds = (time % 60).floor();
              return Text(
                '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              );
            },
            onFinished: () {
              // TODO: Xử lý khi hết giờ đếm ngược
              print('Hết giờ!');
              setState(() => _isCountdownActive = false);
            },
          ),
        ],
      ),
    );
  }
}

/// Widget con tạo hiệu ứng đồng hồ rung
class _RingingAlarmIcon extends StatefulWidget {
  final bool isSmall;
  const _RingingAlarmIcon({this.isSmall = false});

  @override
  State<_RingingAlarmIcon> createState() => _RingingAlarmIconState();
}

class _RingingAlarmIconState extends State<_RingingAlarmIcon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: Tween<double>(begin: -0.05, end: 0.05).animate(_controller),
      child: Icon(
        Icons.alarm,
        color: Colors.red,
        size: widget.isSmall ? 32 : 48,
      ),
    );
  }
}