import 'package:flutter/material.dart';

class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController searchController;

  const SearchAppBar({
    super.key,
    required this.searchController,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.5,
      // Dùng IconButton để có hiệu ứng khi nhấn
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black87),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      title: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: TextField(
          controller: searchController, // Sử dụng controller được truyền vào
          decoration: const InputDecoration(
            hintText: 'Tìm kiếm...',
            prefixIcon: Icon(Icons.search, color: Colors.grey),
            suffixIcon: Icon(Icons.close, color: Colors.grey),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 10),
          ),
        ),
      ),
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.favorite_border)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.chat_bubble_outline)),
      ],
    );
  }

  /// Bắt buộc phải override getter này khi implement PreferredSizeWidget.
  /// kToolbarHeight là chiều cao tiêu chuẩn của một AppBar trong Flutter.
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}