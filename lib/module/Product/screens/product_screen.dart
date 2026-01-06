import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_projects_week_6/core/base_model/review.dart';
import 'package:flutter_projects_week_6/core/providers/cart_provider.dart';
import 'package:flutter_projects_week_6/core/services/di.dart';
import 'package:flutter_projects_week_6/utils/Extension/responsive_ui_extension.dart';
import 'package:flutter_projects_week_6/utils/theme/app_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/home_provider.dart';
import '../../../core/providers/product_details_provider.dart';

class ProductScreen extends StatelessWidget {
  final String productId;

  const ProductScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => getIt<HomeProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<CartProvider>()),
        ChangeNotifierProvider(
          create: (_) => getIt<PlantDetailProvider>()
            ..subscribeToProduct(productId)
            ..fetchReviews(productId, isRefresh: true),
        ),
      ],
      child: _ProductDetailsContent(productId: productId),
    );
  }
}

class _ProductDetailsContent extends StatelessWidget {
  final String productId;

  const _ProductDetailsContent({required this.productId});

  @override
  Widget build(BuildContext context) {
    final detailProvider = context.watch<PlantDetailProvider>();
    final product = detailProvider.product;

    if (detailProvider.isLoadingProduct) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (product == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text("Product not found")),
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
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
                    Stack(
                      children: [
                        SizedBox(
                          height: context.heightPercentage(35),
                          width: context.widthPercentage(90),
                          child: CachedNetworkImage(
                            imageUrl: product.imageUrl,
                            fit: BoxFit.contain,
                            placeholder: (context, url) =>
                                const Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error, size: 50, color: Colors.grey),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => context.read<HomeProvider>().toggleFavorite(product.id),
                          child: Align(
                            alignment: AlignmentGeometry.topLeft,
                            child: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                color: const Color(0xFF131811),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 5,
                                    color: Colors.grey.withValues(alpha: 0.2),
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: Icon(
                                product.isFavorite ? Icons.favorite : Icons.favorite_border_rounded,
                                color: product.isFavorite
                                    ? AppTheme.primary.withValues(alpha: 1)
                                    : Colors.white,
                                size: context.responsiveTextSize(24),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: context.heightPercentage(3)),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            product.name,
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
                              '${product.rating}',
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
                      product.description,
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
                              '\$ ${product.price}',
                              style: GoogleFonts.cabin(fontSize: 30, fontWeight: FontWeight.w900),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () async {
                            await getIt<CartProvider>().addToCart(product.id);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(" added to cart!"),
                                  duration: const Duration(seconds: 1),
                                  backgroundColor: AppTheme.primary,
                                ),
                              );
                            }
                          },
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

                    const SizedBox(height: 32),
                    _buildSimilarPlants(context),
                    const SizedBox(height: 32),
                    _buildReviews(context, productId),
                    const SizedBox(height: 100),
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
  final Review review;

  const _ReviewItem({required this.review});

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
              Text(review.userName, style: const TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    index < review.rating ? Icons.star : Icons.star_border,
                    size: 16,
                    color: Colors.amber,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(review.comment, style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
        ],
      ),
    );
  }
}

Widget _buildSimilarPlants(BuildContext context) {
  final provider = context.watch<PlantDetailProvider>();
  if (provider.isLoadingSimilar && provider.similarPlants.isEmpty) {
    return const Center(child: CircularProgressIndicator());
  }
  if (provider.similarPlants.isEmpty) return const SizedBox.shrink();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Similar Plants",
        style: TextStyle(fontSize: context.responsiveTextSize(18), fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 16),
      SizedBox(
        height: 190,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: provider.similarPlants.length,
          itemBuilder: (context, index) {
            final plant = provider.similarPlants[index];
            return GestureDetector(
              onTap: () => context.pushReplacement('/plant/${plant.id}'),
              child: Container(
                width: 130,
                margin: const EdgeInsets.only(right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        imageUrl: plant.imageUrl,
                        height: 120,
                        width: 130,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      plant.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "\$${plant.price}",
                      style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    ],
  );
}

Widget _buildReviews(BuildContext context, String productId) {
  final provider = context.watch<PlantDetailProvider>();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Reviews",
            style: TextStyle(fontSize: context.responsiveTextSize(18), fontWeight: FontWeight.bold),
          ),
          TextButton(onPressed: () {}, child: const Text("Write a Review")),
        ],
      ),
      const SizedBox(height: 12),
      if (provider.isLoadingReviews && provider.reviews.isEmpty)
        const Center(child: CircularProgressIndicator())
      else if (provider.reviews.isEmpty)
        const Text("No reviews yet.")
      else
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: provider.reviews.length,
          itemBuilder: (context, index) {
            final review = provider.reviews[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                      review.userAvatar ?? "https://ui-avatars.com/api/?name=${review.userName}",
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              review.userName,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              DateFormat('MMM d, yyyy').format(review.createdAt),
                              style: const TextStyle(color: Colors.grey, fontSize: 11),
                            ),
                          ],
                        ),
                        Row(
                          children: List.generate(
                            5,
                            (i) => Icon(
                              Icons.star,
                              size: 14,
                              color: i < review.rating ? Colors.amber : Colors.grey[300],
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          review.comment,
                          style: TextStyle(color: Colors.grey[800], height: 1.4),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      if (provider.hasMoreReviews)
        Center(
          child: TextButton(
            onPressed: () => provider.fetchReviews(productId),
            child: provider.isLoadingReviews
                ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text("Load More Reviews"),
          ),
        ),
    ],
  );
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
