import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_projects_week_6/core/base_model/review.dart';
import 'package:flutter_projects_week_6/core/providers/cart_provider.dart';
import 'package:flutter_projects_week_6/core/router/app_router.dart';
import 'package:flutter_projects_week_6/core/services/di.dart';
import 'package:flutter_projects_week_6/utils/Extension/responsive_ui_extension.dart';
import 'package:flutter_projects_week_6/utils/theme/app_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/home_provider.dart';
import '../../../core/providers/product_details_provider.dart';
import '../../../utils/widgets/common_top_notification.dart';

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

    if (detailProvider.isLoadingProduct && product == null) {
      return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: AppTheme.backgroundLight,
        child: Center(child: CircularProgressIndicator(color: AppTheme.primary)),
      );
    }

    if (product == null) {
      return Scaffold(
        backgroundColor: AppTheme.backgroundLight,
        appBar: AppBar(leading: const BackButton()),
        body: const Center(child: Text("Product not found")),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundLight,
        elevation: 0,
        surfaceTintColor: AppTheme.backgroundLight,
        title: Text(
          product.name,
          style: GoogleFonts.cabin(
            fontWeight: FontWeight.bold,
            fontSize: context.responsiveTextSize(18),
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: IconButton(
              icon: Icon(
                product.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border_rounded,
                color: product.isFavorite ? AppTheme.primary : Colors.black,
              ),
              onPressed: () => context.read<HomeProvider>().toggleFavorite(
                product.id,
                context,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: context.widthPercentage(8),
              ),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Hero(
                        tag: 'plant_${product.id}',
                        child: CachedNetworkImage(
                          imageUrl: product.imageUrl,
                          height: context.heightPercentage(35),
                          fit: BoxFit.contain,
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => const Icon(
                            Icons.error,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                      ),
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
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.teal),
                            const SizedBox(width: 4),
                            Text(
                              '${product.rating}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              '/5',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: context.heightPercentage(2)),
                    Text(
                      'Description',
                      style: GoogleFonts.cabin(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product.description,
                      style: TextStyle(
                        color: Colors.grey[600],
                        height: 1.5,
                        fontSize: context.responsiveTextSize(14),
                      ),
                    ),
                    SizedBox(height: context.heightPercentage(4)),
                  ],
                ),
              ),
            ),

            SliverPersistentHeader(
              pinned: true,
              delegate: _StickyBottomDelegate(
                child: Container(
                  height: 90.0,
                  padding: EdgeInsets.symmetric(
                    horizontal: context.widthPercentage(8),
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(color: Colors.black12, width: 0.5),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Price',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '\$${product.price}',
                            style: GoogleFonts.cabin(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: context.widthPercentage(50),
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () async {
                            await getIt<CartProvider>().addToCart(
                              product.id,
                              context,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff50AD98),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          child: const Text(
                            "Add to Cart",
                            style: TextStyle(
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

            SliverPadding(
              padding: EdgeInsets.all(context.widthPercentage(8)),
              sliver: SliverToBoxAdapter(child: _buildSimilarPlants(context)),
            ),

            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: context.widthPercentage(8),
              ),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Reviews",
                      style: GoogleFonts.cabin(
                        fontSize: context.responsiveTextSize(18),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () =>
                          _showWriteReviewBottomSheet(context, product.id),
                      child: Text(
                        "Write a Review",
                        style: GoogleFonts.cabin(
                          fontSize: context.responsiveTextSize(12),
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: context.widthPercentage(8),
                vertical: 16,
              ),
              sliver: detailProvider.reviews.isEmpty
                  ? const SliverToBoxAdapter(
                      child: Center(child: Text("No reviews yet.")),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final review = detailProvider.reviews[index];
                        return _buildReviewItem(review);
                      }, childCount: detailProvider.reviews.length),
                    ),
            ),

            if (detailProvider.hasMoreReviews)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Center(
                    child: TextButton(
                      onPressed: () => detailProvider.fetchReviews(productId),
                      child: detailProvider.isLoadingReviews
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text("Load More Reviews"),
                    ),
                  ),
                ),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  void _showWriteReviewBottomSheet(BuildContext context, String productId) {
    final provider = context.read<PlantDetailProvider>();
    final commentCtrl = TextEditingController();
    int selectedRating = 5;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            top: 24,
            left: 24,
            right: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "Write a Review",
                style: GoogleFonts.cabin(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "How was your experience?",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    onPressed: () =>
                        setModalState(() => selectedRating = index + 1),
                    icon: Icon(
                      index < selectedRating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 40,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),
              const Text(
                "Your Feedback",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: commentCtrl,
                maxLines: 4,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: "Tell others what you love about this plant...",
                  filled: true,
                  fillColor: Colors.grey[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppTheme.primary),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: provider.isSubmittingReview
                      ? null
                      : () async {
                          if (commentCtrl.text.trim().isEmpty) {
                            showTopNotification(
                              context,
                              "Please enter your comments",
                            );

                            return;
                          }

                          try {
                            await provider.submitReview(
                              productId: productId,
                              rating: selectedRating,
                              comment: commentCtrl.text.trim(),
                              context: context,
                            );
                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                          } catch (e) {
                            // Error handled in provider/repo
                          }
                        },
                  child: provider.isSubmittingReview
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Submit Review",
                          style: TextStyle(
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
    );
  }

  Widget _buildReviewItem(Review review) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(
              review.userAvatar ??
                  "https://ui-avatars.com/api/?name=${review.userName}",
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
                      color: i < review.rating
                          ? Colors.amber
                          : Colors.grey[300],
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  review.comment,
                  style: TextStyle(
                    color: Colors.grey[800],
                    height: 1.4,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
        const Text(
          "Similar Plants",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: provider.similarPlants.length,
            itemBuilder: (context, index) {
              final plant = provider.similarPlants[index];
              return GestureDetector(
                onTap: () => PlantRoute(plantId: plant.id).push(context),
                child: Container(
                  width: 140,
                  margin: const EdgeInsets.only(right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: CachedNetworkImage(
                          imageUrl: plant.imageUrl,
                          height: 130,
                          width: 140,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              Container(color: Colors.grey[100]),
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
                        style: const TextStyle(
                          color: Color(0xff50AD98),
                          fontWeight: FontWeight.bold,
                        ),
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
}

class _StickyBottomDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  _StickyBottomDelegate({required this.child});

  @override
  double get minExtent => 90.0;
  @override
  double get maxExtent => 90.0;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(covariant _StickyBottomDelegate oldDelegate) {
    return oldDelegate.child != child;
  }
}
