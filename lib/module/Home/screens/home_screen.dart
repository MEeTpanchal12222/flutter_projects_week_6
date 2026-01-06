import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_projects_week_6/core/base_model/product.dart';
import 'package:flutter_projects_week_6/core/providers/cart_provider.dart';
import 'package:flutter_projects_week_6/core/providers/home_provider.dart';
import 'package:flutter_projects_week_6/core/router/app_router.dart';
import 'package:flutter_projects_week_6/core/services/di.dart';
import 'package:flutter_projects_week_6/utils/Extension/responsive_ui_extension.dart';
import 'package:flutter_projects_week_6/utils/widgets/common_product_card.dart';
import 'package:flutter_projects_week_6/utils/widgets/common_tab_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../utils/theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<HomeProvider>()..loadData(),
      child: const _HomeContent(),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    final provider = context.watch<HomeProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 13),
            child: Column(
              children: [
                SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      'Find your\n favorite plants',
                      style: GoogleFonts.cabin(
                        textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: screenWidth * 0.08,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => const SearchRoute().push(context),
                      child: Container(
                        height: screenWidth * 0.13,
                        width: screenWidth * 0.13,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(Icons.search, size: 30),
                      ),
                    ),
                  ],
                ),
                Image.asset("Assets/banner.png"),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  height: context.hightForButton(45),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CommonTabButton(
                          provider: provider,
                          label: 'All',
                          isActive: provider.selectedCategoryId == 0,
                          onTap: () => provider.selectCategory(0),
                        ),
                        ...provider.categories.map(
                          (cat) => CommonTabButton(
                            provider: provider,
                            label: cat['name'] ?? '',
                            isActive: provider.selectedCategoryId == cat['id'],
                            onTap: () => provider.selectCategory(cat['id']),
                          ),
                        ),
                        if (provider.categories.isEmpty) ...[
                          CommonTabButton(provider: provider, label: 'Indoor', onTap: () {}),
                          CommonTabButton(provider: provider, label: 'Outdoor', onTap: () {}),
                          CommonTabButton(provider: provider, label: 'Popular', onTap: () {}),
                        ],
                      ],
                    ),
                  ),
                ),
                SizedBox(height: context.heightPercentage(2.5)),

                _buildSectionTitle(context, "Popular"),
                SizedBox(height: context.heightPercentage(1.5)),

                if (provider.products.isNotEmpty)
                  SizedBox(
                    width: 370,
                    height: 400,
                    child: ListView.builder(
                      itemCount: provider.products.length,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        if (provider.products.isNotEmpty) {
                          final product = provider.products[index];
                          return GestureDetector(
                            onTap: () => PlantRoute(
                              plantId: product.id,
                              $extra: product.copyWith(),
                            ).push(context),
                            child: ProductCard(product: product),
                          );
                        } else {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 50,
                                alignment: Alignment.center,
                                child: const Text("No plants found"),
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ),
                if (provider.products.isEmpty)
                  Container(
                    height: 200,
                    alignment: Alignment.center,
                    child: const Text("No plants found"),
                  ),
                SizedBox(height: context.heightPercentage(3)),

                _buildSectionTitle(context, "New Arrivals"),
                SizedBox(height: context.heightPercentage(1.5)),

                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: provider.newArrivals.length,
                  itemBuilder: (context, index) {
                    final product = provider.newArrivals[index];
                    return GestureDetector(
                      onTap: () {
                        PlantRoute(plantId: product.id, $extra: product).push(context);
                      },
                      child: _NewArrivalCard(product: product),
                    );
                  },
                ),

                SizedBox(height: context.heightPercentage(3)),

                _buildSectionTitle(context, "Plant Care Tips"),
                SizedBox(height: context.heightPercentage(1.5)),

                SizedBox(
                  height: context.heightPercentage(18),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: provider.tips.length,
                    itemBuilder: (context, index) {
                      final tip = provider.tips[index];

                      IconData iconData = Icons.help_outline;
                      if (tip.iconName == 'water_drop') iconData = Icons.water_drop;
                      if (tip.iconName == 'wb_sunny') iconData = Icons.wb_sunny;
                      if (tip.iconName == 'grass') iconData = Icons.grass;

                      return _TipCard(
                        title: tip.title,
                        subtitle: tip.subtitle,
                        color: Color(tip.colorValue),
                        icon: iconData,
                      );
                    },
                  ),
                ),

                SizedBox(height: context.heightPercentage(5)),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        indicatorColor: AppTheme.secondary,
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
          side: BorderSide(color: AppTheme.primary, width: 1),
        ),
        selectedIndex: 0,
        backgroundColor: Colors.white,

        elevation: 0,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.favorite_border), label: 'Favorite'),
          NavigationDestination(icon: Icon(Icons.shopping_cart_outlined), label: 'Cart'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
        onDestinationSelected: (idx) {
          if (idx == 1) FavoritesRoute().push(context);
          if (idx == 3) ProfileRoute().push(context);
          if (idx == 2) CartRoute().push(context);
        },
      ),
    );
  }
}

Widget _buildSectionTitle(BuildContext context, String title) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: GoogleFonts.cabin(
          textStyle: TextStyle(
            fontSize: context.responsiveTextSize(20),
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      Text(
        "See all",
        style: TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.w600,
          fontSize: context.responsiveTextSize(14),
        ),
      ),
    ],
  );
}

class _NewArrivalCard extends StatelessWidget {
  Product product;

  _NewArrivalCard({required this.product});

  @override
  Widget build(context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: CachedNetworkImage(
              imageUrl: product.imageUrl,
              height: 80,
              width: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: GoogleFonts.cabin(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 4),
                Text("Indoor • Easy Care", style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                const SizedBox(height: 8),
                Text(
                  "\$${product.price}",
                  style: GoogleFonts.cabin(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
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
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}

class _TipCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;

  const _TipCard({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32, color: Colors.black87),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 4),
          Text(
            subtitle,
            maxLines: 3,
            style: GoogleFonts.cabin(
              color: Colors.black.withValues(alpha: 0.6),
              fontSize: 12,
              textStyle: TextStyle(overflow: TextOverflow.ellipsis),
            ),
          ),
        ],
      ),
    );
  }
}
