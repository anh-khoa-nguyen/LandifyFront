class NotificationModel {
  final String avatarUrl;
  final String overlayIconUrl;
  final String title;
  final String subtitle;
  final String timestamp;
  final bool isRead;

  NotificationModel({
    required this.avatarUrl,
    required this.overlayIconUrl,
    required this.title,
    required this.subtitle,
    required this.timestamp,
    required this.isRead,
  });
}