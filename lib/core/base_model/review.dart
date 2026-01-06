class Review {
  final String id;
  final String plantId;
  final String userId;
  final String userName;
  final String? userAvatar;
  final int rating;
  final String comment;
  final DateTime createdAt;
  const Review({
    required this.id,
    required this.plantId,
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory Review.fromMap(Map<String, dynamic> map) {
    final profile = map['profiles'] as Map<String, dynamic>? ?? {};

    return Review(
      id: map['id'],
      plantId: map['product_id'],
      userId: map['user_id'],
      userName: profile['full_name'] ?? 'Guest User',
      userAvatar: profile['avatar_url'],
      rating: map['rating'] ?? 0,
      comment: map['comment'] ?? '',
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {'product_id': plantId, 'user_id': userId, 'rating': rating, 'comment': comment};
  }
}
