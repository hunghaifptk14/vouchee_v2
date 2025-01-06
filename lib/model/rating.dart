// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Rating {
  String orderId;
  String modalId;
  int qualityStar;
  int serviceStar;
  int sellerStar;
  String comment;

  Rating({
    required this.orderId,
    required this.modalId,
    required this.qualityStar,
    required this.serviceStar,
    required this.sellerStar,
    required this.comment,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'orderId': orderId,
      'modalId': modalId,
      'qualityStar': qualityStar,
      'serviceStar': serviceStar,
      'sellerStar': sellerStar,
      'comment': comment,
    };
  }

  factory Rating.fromMap(Map<String, dynamic> map) {
    return Rating(
      orderId: map['orderId'] as String,
      modalId: map['modalId'] as String,
      qualityStar: map['qualityStar'] as int,
      serviceStar: map['serviceStar'] as int,
      sellerStar: map['sellerStar'] as int,
      comment: map['comment'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Rating.fromJson(String source) =>
      Rating.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Media {
  String url;

  Media({required this.url});
}
