import 'package:flutter/material.dart';
import 'package:flutter_projects_week_6/core/constant.dart';
import 'package:flutter_projects_week_6/core/providers/home_provider.dart';
import 'package:flutter_projects_week_6/core/router/app_router.dart';
import 'package:flutter_projects_week_6/core/services/di.dart';
import 'package:flutter_projects_week_6/module/Home/widgets/product_card.dart';
import 'package:flutter_projects_week_6/utils/widgets/common_tab_button.dart';
import 'package:go_router/go_router.dart';
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
                            $extra: product.toJson(),
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
          if (idx == 1) context.push('/favorites');
          if (idx == 3) context.push('/tracking');
          if (idx == 2) context.push('/cart');
        },
      ),
    );
  }
}
