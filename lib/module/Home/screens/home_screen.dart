import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_projects_week_6/core/constant.dart';
import 'package:flutter_projects_week_6/core/providers/home_provider.dart';
import 'package:flutter_projects_week_6/core/router/app_router.dart';
import 'package:flutter_projects_week_6/core/services/di.dart';
import 'package:flutter_projects_week_6/module/Home/widgets/product_card.dart';
import 'package:flutter_projects_week_6/utils/Extension/responsive_ui_extension.dart';
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
                  height: 41,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CommonTabButton(provider: provider, label: 'All', isActive: true),
                        ...provider.categories.map(
                          (cat) => CommonTabButton(provider: provider, label: cat['name'] ?? ''),
                        ),
                        if (provider.categories.isEmpty) ...[
                          CommonTabButton(provider: provider, label: 'Indoor'),
                          CommonTabButton(provider: provider, label: 'Outdoor'),
                          CommonTabButton(provider: provider, label: 'Popular'),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                SizedBox(
                  width: 370,
                  height: 400,
                  child: ListView.builder(
                    itemCount: 3,
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
                          child: ProductCard(
                            name: product.name,
                            price: product.price.toString(),
                            imgUrl: product.imageUrl,
                          ),
                        );
                      } else {
                        return const ProductCard(
                          name: "Monstera",
                          price: "200",
                          imgUrl: AppConstants.placeholderImage,
                        );
                      }
                    },
                  ),
                ),
                SizedBox(height: context.heightPercentage(3)),

                _buildSectionTitle(context, "New Arrivals"),
                SizedBox(height: context.heightPercentage(1.5)),

                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    return _NewArrivalCard(
                      name: index == 0 ? "Fiddle Leaf Fig" : "Snake Plant",
                      price: index == 0 ? "55" : "25",
                      imgUrl: index == 0
                          ? "https://images.unsplash.com/photo-1646665747444-9c595085e729?q=80&w=2574&auto=format&fit=crop"
                          : "https://images.unsplash.com/photo-1599598425947-32095f9d1e2a?q=80&w=2573&auto=format&fit=crop",
                    );
                  },
                ),

                SizedBox(height: context.heightPercentage(3)),

                _buildSectionTitle(context, "Plant Care Tips"),
                SizedBox(height: context.heightPercentage(1.5)),

                SizedBox(
                  height: context.heightPercentage(18),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: const [
                      _TipCard(
                        title: "Watering Guide",
                        subtitle: "How often should you water?",
                        color: Color(0xFFE3F2FD),
                        icon: Icons.water_drop,
                      ),
                      _TipCard(
                        title: "Sunlight Needs",
                        subtitle: "Find the perfect spot.",
                        color: Color(0xFFFFF3E0),
                        icon: Icons.wb_sunny,
                      ),
                      _TipCard(
                        title: "Repotting 101",
                        subtitle: "When and how to repot.",
                        color: Color(0xFFE8F5E9),
                        icon: Icons.grass,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: context.heightPercentage(5)), // Bottom padding
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
  final String name;
  final String price;
  final String imgUrl;

  const _NewArrivalCard({required this.name, required this.price, required this.imgUrl});

  @override
  Widget build(BuildContext context) {
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
            child: CachedNetworkImage(imageUrl: imgUrl, height: 80, width: 80, fit: BoxFit.cover),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: GoogleFonts.cabin(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 4),
                Text("Indoor • Easy Care", style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                const SizedBox(height: 8),
                Text(
                  "\$$price",
                  style: GoogleFonts.cabin(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.add, color: Colors.white, size: 20),
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
            style: TextStyle(color: Colors.black.withValues(alpha: 0.6), fontSize: 12),
          ),
        ],
      ),
    );
  }
}
