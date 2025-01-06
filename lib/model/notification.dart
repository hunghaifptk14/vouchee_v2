class NotificationReceiver {
  final String id;
  late final bool seen;
  final String receiverName;
  final String receiverImage;
  final String? senderName; // Nullable
  final String? senderImage; // Nullable
  final DateTime createDate;
  final String receiverId;
  final String title;
  final String body;

  NotificationReceiver({
    required this.id,
    required this.seen,
    required this.receiverName,
    required this.receiverImage,
    this.senderName, // Nullable
    this.senderImage, // Nullable
    required this.createDate,
    required this.receiverId,
    required this.title,
    required this.body,
  });

  // Factory constructor to create NotificationReceiver from JSON
  factory NotificationReceiver.fromJson(Map<String, dynamic> json) {
    return NotificationReceiver(
      id: json['id'] ?? '', // Default to empty string if null
      seen: json['seen'] ?? false, // Default to false if null
      receiverName:
          json['receiverName'] ?? '', // Default to empty string if null
      receiverImage:
          json['receiverImage'] ?? '', // Default to empty string if null
      senderName: json['senderName'], // Nullable
      senderImage: json['senderImage'], // Nullable
      createDate: DateTime.parse(json['createDate'] ??
          DateTime.now().toString()), // Default to current time if null
      receiverId: json['receiverId'] ?? '', // Default to empty string if null
      title: json['title'] ?? '', // Default to empty string if null
      body: json['body'] ?? '', // Default to empty string if null
    );
  }

  // Method to convert NotificationReceiver object back to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'seen': seen,
      'receiverName': receiverName,
      'receiverImage': receiverImage,
      'senderName': senderName,
      'senderImage': senderImage,
      'createDate': createDate.toIso8601String(),
      'receiverId': receiverId,
      'title': title,
      'body': body,
    };
  }
}
