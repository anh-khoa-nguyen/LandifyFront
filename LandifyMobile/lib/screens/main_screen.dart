// lib/screens/main_screen.dart
import 'package:flutter/material.dart';
import 'package:landifymobile/screens/create/create_listing.dart';
import 'package:landifymobile/screens/home/home_screen.dart';
import 'package:landifymobile/screens/account/account_screen.dart';
import 'package:landifymobile/screens/chat/chat_screen.dart';
import 'package:landifymobile/screens/chat/chat_list.dart';
import 'package:landifymobile/screens/saved/saved_listings.dart';

class MainScreen extends StatefulWidget {
  static const String routeName = '/main';

  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // Danh sách các trang chính của ứng dụng
  static final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(), // Trang chủ
    const SavedListingsScreen(), // THAY THẾ Ở ĐÂY
    const Placeholder(), // Placeholder
    const ChatListScreen(), // Placeholder
    const AccountScreen(), // THAY THẾ Ở ĐÂY
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomAppBar(
        // VẤN ĐỀ NẰM Ở ĐÂY - HÃY SỬA LẠI NHƯ SAU:
        color: Colors.white, // 1. Đặt màu nền là màu trắng
        surfaceTintColor: Colors.transparent, // 2. Vô hiệu hóa hiệu ứng nhuộm màu
        elevation: 10.0,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0, // Giữ lại notch margin hợp lý
        padding: EdgeInsets.zero,
        height: 65,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildBottomNavItem(icon: Icons.home, label: 'Trang chủ', index: 0),
            _buildBottomNavItem(icon: Icons.bookmark_border, label: 'Quản lý tin', index: 1),
            const SizedBox(width: 48),
            _buildBottomNavItem(icon: Icons.chat_bubble_outline, label: 'Chat', index: 3),
            _buildBottomNavItem(icon: Icons.person_outline, label: 'Tài khoản', index: 4),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(CreateListingScreen.routeName);
        },
        backgroundColor: Colors.yellow.shade700,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.black, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  // Widget helper để xây dựng một mục trong BottomAppBar, giờ đã có thể bấm được
  Widget _buildBottomNavItem({required IconData icon, required String label, required int index}) {
    final isSelected = _selectedIndex == index;
    final color = isSelected ? Colors.orange.shade700 : Colors.grey.shade600;
    return Expanded(
      child: InkWell(
        onTap: () => _onItemTapped(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(color: color, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}