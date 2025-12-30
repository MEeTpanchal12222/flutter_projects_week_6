import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_projects_week_6/core/constant.dart';
import 'package:flutter_projects_week_6/core/providers/home_provider.dart';
import 'package:flutter_projects_week_6/core/services/di.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../utils/theme/app_theme.dart';

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
                    Container(
                      height: screenWidth * 0.13,
                      width: screenWidth * 0.13,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(Icons.search, size: 30),
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
                        _buildTabButton('All', isActive: true),
                        ...provider.categories.map((cat) => _buildTabButton(cat['name'] ?? '')),
                        if (provider.categories.isEmpty) ...[
                          _buildTabButton('Indoor'),
                          _buildTabButton('Outdoor'),
                          _buildTabButton('Popular'),
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
                          onTap: () => context.push(
                            '/product/${product.id}',
                            extra: {
                              'name': product.name,
                              'price': product.price,
                              'image': product.imageUrl,
                              'rating': product.rating,
                              'desc': product.description,
                            },
                          ),
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
          if (idx == 1) context.push('/map');
        },
      ),
    );
  }
}

Widget _buildTabButton(String label, {bool isActive = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 35.84,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: isActive ? const Color(0xFF2E2D2D) : const Color(0xFFAEAEAE),
          ),
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? const Color(0xFF2E2D2D) : const Color(0xFFAEAEAE),
            fontSize: 18,
            fontFamily: 'Cabin',
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    ),
  );
}

class ProductCard extends StatelessWidget {
  final String name;
  final String price;
  final String imgUrl;

  const ProductCard({super.key, required this.name, required this.price, required this.imgUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          name,
                          style: GoogleFonts.cabin(
                            textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          '\$$price',
                          style: GoogleFonts.cabin(
                            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: CachedNetworkImage(
                        imageUrl: imgUrl,
                        fit: BoxFit.contain,
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.local_florist, size: 50, color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          height: 50,
                          width: 130,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 5,
                                color: Colors.grey.withValues(alpha: 0.2),
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: const Text(
                            'Add to Cart',
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                        ),
                        Container(
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
                          child: const Icon(Icons.favorite_border_rounded, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
