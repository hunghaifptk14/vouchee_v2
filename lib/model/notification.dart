class NotificationReceiver {
  final String id;
  final bool seen;
  final String receiverName;
  final String receiverImage;
  final String senderName;
  final String senderImage;
  final DateTime createDate;
  final String receiverId;
  final String title;
  final String body;

  NotificationReceiver({
    required this.id,
    required this.seen,
    required this.receiverName,
    required this.receiverImage,
    required this.senderName,
    required this.senderImage,
    required this.createDate,
    required this.receiverId,
    required this.title,
    required this.body,
  });

  // Factory method to create an instance from JSON
  factory NotificationReceiver.fromJson(Map<String, dynamic> json) {
    return NotificationReceiver(
      id: json['id'],
      seen: json['seen'],
      receiverName: json['receiverName'],
      receiverImage: json['receiverImage'] ?? '',
      senderName: json['senderName'],
      senderImage: json['senderImage'],
      createDate: DateTime.parse(json['createDate']),
      receiverId: json['receiverId'],
      title: json['title'],
      body: json['body'],
    );
  }

  // Method to convert an instance to JSON
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
