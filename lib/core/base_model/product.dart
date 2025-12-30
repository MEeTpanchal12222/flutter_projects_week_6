class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final double rating;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.rating,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      description: map['description'] ?? '',
      price: (map['price'] as num).toDouble(),
      imageUrl: map['image_url'] ?? '',
      rating: (map['rating'] as num).toDouble(),
    );
  }
}
