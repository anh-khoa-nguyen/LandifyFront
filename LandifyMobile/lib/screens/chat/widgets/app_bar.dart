import 'package:flutter/material.dart';

const Color kPrimaryBlue = Color(0xFF165DFF);

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const ChatAppBar({
    super.key,
    required this.title, // 'required' để đảm bảo nó luôn được truyền vào
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black87), onPressed: () => Navigator.of(context).maybePop()),
      title: Row(
        children: [
          const CircleAvatar(radius: 18, backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=12')),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Trần Dung', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(height: 2),
                Text('Active 14h ago', style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.call, color: kPrimaryBlue)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.videocam, color: kPrimaryBlue)),
            ],
          )
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}