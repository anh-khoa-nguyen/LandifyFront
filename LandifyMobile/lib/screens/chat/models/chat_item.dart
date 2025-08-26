class ChatItem {
  final String avatarUrl; // Dùng URL thật thay cho initial
  final String name;
  final String message;
  final String time;
  final bool hasUnread;
  final bool isSendingFailed;
  final bool verified;

  ChatItem({
    required this.avatarUrl,
    required this.name,
    required this.message,
    required this.time,
    this.hasUnread = false,
    this.isSendingFailed = false,
    this.verified = false,
  });
}