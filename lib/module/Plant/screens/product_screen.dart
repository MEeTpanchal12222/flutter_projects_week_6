import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_projects_week_6/core/base_model/product.dart';
import 'package:flutter_projects_week_6/utils/Extension/responsive_ui_extension.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductScreen extends StatelessWidget {
  final String productId;
  final Product? product;

  const ProductScreen({super.key, required this.productId, this.product});

  @override
  Widget build(BuildContext context) {
    final name = product?.name ?? "Monstera";
    final price = product?.price ?? 200;
    final image =
        product?.imageUrl ??
        "https://images.unsplash.com/photo-1614594975525-e45852b82481?q=80&w=2574&auto=format&fit=crop";
    final description =
        product?.description ??
        "Monstera is a genus of 40 to 60 tropical and warm temperate flowering annuals...";
    final rating = product?.rating ?? 5.0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        //centerTitle: ,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.widthPercentage(8),
            vertical: context.heightPercentage(2),
          ),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: context.heightPercentage(35),
                      width: context.widthPercentage(90),
                      child: CachedNetworkImage(
                        imageUrl: image,
                        fit: BoxFit.contain,
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error, size: 50, color: Colors.grey),
                      ),
                    ),
                    SizedBox(height: context.heightPercentage(3)),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: GoogleFonts.cabin(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: context.responsiveTextSize(30),
                              ),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.teal),
                            Text(
                              '$rating',
                              style: GoogleFonts.cabin(
                                textStyle: TextStyle(
                                  fontSize: context.responsiveTextSize(18),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              '/5',
                              style: GoogleFonts.cabin(
                                textStyle: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontWeight: FontWeight.bold,
                                  fontSize: context.responsiveTextSize(16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: context.heightPercentage(4)),

                    Text(
                      'Description',
                      style: GoogleFonts.cabin(
                        fontSize: context.responsiveTextSize(20),
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: context.heightPercentage(1.5)),
                    Text(
                      description,
                      style: GoogleFonts.cabin(
                        textStyle: TextStyle(
                          fontSize: context.responsiveTextSize(14),
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.8,
                        ),
                      ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),

                    SizedBox(height: context.heightPercentage(10)),
                  ],
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _StickyBottomDelegate(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Price', style: GoogleFonts.cabin(fontSize: 18)),
                            Text(
                              '\$ $price',
                              style: GoogleFonts.cabin(fontSize: 30, fontWeight: FontWeight.w900),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {},
                          child: Container(
                            height: 60,
                            width: context.widthPercentage(50),
                            decoration: BoxDecoration(
                              color: const Color(0xff50AD98),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Add to Cart',
                              style: GoogleFonts.cabin(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SliverFillRemaining(
                fillOverscroll: true,
                hasScrollBody: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: context.heightPercentage(5)),

                    Text(
                      'Reviews',
                      style: TextStyle(
                        fontSize: context.responsiveTextSize(20),
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _ReviewItem(
                      name: "Sarah L.",
                      rating: 5,
                      comment: "Beautiful plant, arrived safely!",
                    ),
                    _ReviewItem(
                      name: "Mike D.",
                      rating: 4,
                      comment: "Looks great in my living room.",
                    ),
                    Text(
                      'Similar Plants',
                      style: TextStyle(
                        fontSize: context.responsiveTextSize(20),
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      height: 120,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _SimilarPlantCard(
                            name: "Snake Plant",
                            price: "25",
                            color: Colors.green.shade50,
                          ),
                          _SimilarPlantCard(
                            name: "Aloe Vera",
                            price: "15",
                            color: Colors.teal.shade50,
                          ),
                          _SimilarPlantCard(
                            name: "Fiddle Leaf",
                            price: "55",
                            color: Colors.orange.shade50,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StickyBottomDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  _StickyBottomDelegate({required this.child});

  @override
  double get minExtent => 100.0;
  @override
  double get maxExtent => 100.0;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(color: Colors.white, alignment: Alignment.center, child: child);
  }

  @override
  bool shouldRebuild(covariant _StickyBottomDelegate oldDelegate) => true;
}

class _ReviewItem extends StatelessWidget {
  final String name;
  final int rating;
  final String comment;

  const _ReviewItem({required this.name, required this.rating, required this.comment});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    index < rating ? Icons.star : Icons.star_border,
                    size: 16,
                    color: Colors.amber,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(comment, style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
        ],
      ),
    );
  }
}

class _SimilarPlantCard extends StatelessWidget {
  final String name;
  final String price;
  final Color color;

  const _SimilarPlantCard({required this.name, required this.price, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(16)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.local_florist, color: Colors.black54),
          const SizedBox(height: 8),
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          Text("\$$price", style: const TextStyle(color: Colors.grey, fontSize: 11)),
        ],
      ),
    );
  }
}
