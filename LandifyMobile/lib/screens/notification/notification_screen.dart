import 'package:flutter/material.dart';

// Import model (nếu bạn tạo file riêng)
import 'models/notification_model.dart';

// --- DỮ LIỆU MẪU ---

final List<NotificationModel> mockNotifications = [
  NotificationModel(
    avatarUrl: 'https://picsum.photos/seed/hk/100/100',
    overlayIconUrl: 'assets/images/chat_overlay.png', // Thay bằng đường dẫn đúng
    title: 'Bán lô đất 30m2 đường 3 tháng 2',
    subtitle: 'Bài đăng của bạn đã chạm mốc 1000 lượt xem, hãy tiếp tục cố gắng',
    timestamp: '2 giờ trước',
    isRead: false, // Thông báo chưa đọc
  ),
  NotificationModel(
    avatarUrl: 'https://picsum.photos/seed/game/100/100',
    overlayIconUrl: 'assets/images/chat_overlay.png', // Thay bằng đường dẫn đúng
    title: 'Hệ thống',
    subtitle: 'Chúc mừng, yêu cầu xin làm môi giới cho BĐS "Bán lô đất gần cây xăng Bồ Đề" đã được chấp thuận',
    timestamp: '5 giờ trước',
    isRead: true, // Thông báo đã đọc
  ),
];
// --- KẾT THÚC DỮ LIỆU MẪU ---

class NotificationScreen extends StatefulWidget {
  static const String routeName = '/notifications';
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // State để quản lý các thành phần UI
  int _selectedFilterIndex = 0;
  bool _isBannerVisible = true;

  // ***** THAY ĐỔI GIÁ TRỊ NÀY ĐỂ XEM CÁC GIAO DIỆN KHÁC NHAU *****
  // true: Hiển thị màn hình rỗng
  // false: Hiển thị danh sách thông báo
  final bool _showEmptyState = false;

  @override
  Widget build(BuildContext context) {
    // Lấy danh sách thông báo dựa trên trạng thái
    final notifications = _showEmptyState ? <NotificationModel>[] : mockNotifications;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        elevation: 0,
        leading: const BackButton(color: Colors.black87),
        title: const Text('Thông báo', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.check, color: Colors.black54)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings_outlined, color: Colors.black54)),
        ],
      ),
      body: Column(
        children: [
          // 1. Thanh Filter
          _FilterChipBar(
            selectedIndex: _selectedFilterIndex,
            onFilterSelected: (index) {
              setState(() {
                _selectedFilterIndex = index;
              });
            },
          ),

          // 2. Banner (hiển thị có điều kiện)
          if (_isBannerVisible)
            _DontMissBanner(
              onClose: () {
                setState(() {
                  _isBannerVisible = false;
                });
              },
            ),

          // 3. Danh sách thông báo hoặc màn hình rỗng
          Expanded(
            child: notifications.isEmpty
                ? const _EmptyState()
                : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                return _NotificationItem(notification: notifications[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

// --- CÁC WIDGET CON ---

class _FilterChipBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onFilterSelected;
  final List<String> filters = ['Tất cả', 'Tin đăng', 'Tài chính', 'Khuyến mãi', 'Cộng đồng'];

  _FilterChipBar({required this.selectedIndex, required this.onFilterSelected});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: List.generate(filters.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(filters[index]),
              selected: selectedIndex == index,
              onSelected: (selected) {
                if (selected) onFilterSelected(index);
              },
              backgroundColor: Colors.white,
              selectedColor: Colors.black87,
              labelStyle: TextStyle(color: selectedIndex == index ? Colors.white : Colors.black87),
              shape: const StadiumBorder(),
              side: BorderSide(color: Colors.grey.shade300),
            ),
          );
        }),
      ),
    );
  }
}

class _DontMissBanner extends StatelessWidget {
  final VoidCallback onClose;
  const _DontMissBanner({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Đừng bỏ lỡ thông tin quan trọng!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text('Chúng tôi sẽ gửi thông báo khi có tin quan trọng như khách hàng quan tâm, biến động số dư ...', style: TextStyle(color: Colors.grey.shade600)),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(padding: EdgeInsets.zero, alignment: Alignment.centerLeft),
                  child: const Text('Mở cài đặt', style: TextStyle(decoration: TextDecoration.underline, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Stack(
            alignment: Alignment.topRight,
            children: [
              Image.asset('assets/images/bell_image.png', height: 60), // Thay bằng đường dẫn đúng
              Positioned(
                right: -12,
                top: -12,
                child: IconButton(icon: const Icon(Icons.close, size: 18), onPressed: onClose),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/empty_notifications.png', height: 150, color: Colors.grey.shade300), // Thay bằng đường dẫn đúng
          const SizedBox(height: 24),
          Text('Hiện tại bạn không có thông báo nào!', style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
        ],
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final NotificationModel notification;
  const _NotificationItem({required this.notification});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        // Nền thay đổi dựa trên trạng thái isRead
        color: notification.isRead ? Colors.white : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage(notification.avatarUrl),
              ),
              Positioned(
                bottom: -4,
                right: -4,
                child: CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Image.asset(notification.overlayIconUrl),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          // Nội dung
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(notification.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(notification.subtitle, style: TextStyle(color: Colors.grey.shade700)),
                const SizedBox(height: 8),
                Text(notification.timestamp, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
              ],
            ),
          ),
          // Nút More
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_horiz, color: Colors.black54)),
        ],
      ),
    );
  }
}