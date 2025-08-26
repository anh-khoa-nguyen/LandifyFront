class DetailedPropertyListing {
  final String id; // <-- THUỘC TÍNH NÀY RẤ
  final String mainImage; final String image2; final String image3; final String image4;
  final String tag; final int imageCount; final int videoCount;
  final String title; final String price; final String area; final String pricePerSqm;
  final int beds; final int baths; final String location;
  final String agentAvatar; final String agentName; final String agentPhone;
  DetailedPropertyListing({ required this.id, required this.mainImage, required this.image2, required this.image3, required this.image4, required this.tag, this.imageCount = 0, this.videoCount = 0, required this.title, required this.price, required this.area, required this.pricePerSqm, required this.beds, required this.baths, required this.location, required this.agentAvatar, required this.agentName, required this.agentPhone });
}