import 'package:flutter/material.dart';
import 'package:landifymobile/screens/chat/models/chat_item.dart';

class ChatListTile extends StatelessWidget {
  final ChatItem item;
  final VoidCallback? onTap;

  const ChatListTile({
    super.key,
    required this.item,
    this.onTap, // Thêm vào constructor
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Stack(
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundImage: NetworkImage(item.avatarUrl),
          ),
          if (item.verified)
            Positioned(
              right: -2,
              bottom: -2,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.verified, color: Colors.orange, size: 18),
              ),
            ),
        ],
      ),
      title: Text(
        item.name,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
      ),
      subtitle: Text(
        item.message,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: item.hasUnread ? Colors.black : Colors.grey[600],
          fontWeight: item.hasUnread ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            item.time,
            style: TextStyle(
              color: item.isSendingFailed ? Colors.orange.shade700 : Colors.grey[600],
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          if (item.hasUnread)
            Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
            )
          else
            const SizedBox(height: 10),
        ],
      ),
      onTap: onTap,
    );
  }
}