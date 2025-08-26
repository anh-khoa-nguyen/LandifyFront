import 'package:flutter/material.dart';
import 'package:landifymobile/utils/theme/app_colors.dart';


class ChatListAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatListAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.primaryOrange,
      elevation: 0,
      title: Row(
        children: [
          const Icon(Icons.search, color: Colors.white, size: 28),
          const SizedBox(width: 16),
          Text(
            'Tìm kiếm',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 18,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.add, color: Colors.white),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}