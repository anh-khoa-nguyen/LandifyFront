import 'package:flutter/material.dart';

class ChatListTabs extends StatelessWidget {
  const ChatListTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                _buildTab('Ưu tiên', isSelected: true),
                const SizedBox(width: 24),
                _buildTab('Khác', isSelected: false),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.filter_list, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String text, {bool isSelected = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: 17,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.black : Colors.grey.shade600,
          ),
        ),
        if (isSelected)
          Container(
            margin: const EdgeInsets.only(top: 6),
            height: 3,
            width: 30,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
      ],
    );
  }
}