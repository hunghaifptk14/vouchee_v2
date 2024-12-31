class Rating {
  String orderId;
  String modalId;
  List<Media> medias;
  int qualityStar;
  int serviceStar;
  int sellerStar;
  String comment;

  Rating({
    required this.orderId,
    required this.modalId,
    required this.medias,
    required this.qualityStar,
    required this.serviceStar,
    required this.sellerStar,
    required this.comment,
  });
}

class Media {
  String url;

  Media({required this.url});
}
