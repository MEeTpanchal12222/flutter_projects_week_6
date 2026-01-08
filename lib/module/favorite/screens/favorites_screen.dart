import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_projects_week_6/core/base_model/product.dart';
import 'package:flutter_projects_week_6/core/router/app_router.dart';
import 'package:flutter_projects_week_6/utils/theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/favorites_provider.dart';
import '../../../core/services/di.dart';
import '../../../utils/Extension/responsive_ui_extension.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<FavoriteProvider>()..loadFavorites(),
      child: const _FavoriteContent(),
    );
  }
}

class _FavoriteContent extends StatelessWidget {
  const _FavoriteContent();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FavoriteProvider>();

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: Text(
          "Favorites",
          style: GoogleFonts.cabin(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: AppTheme.primary.withValues(alpha: 0.4),
        elevation: 0,
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.favorites.isNotEmpty
          ? GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.6,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
              ),
              itemCount: provider.favorites.length,
              itemBuilder: (context, index) {
                final Product product = provider.favorites[index];
                return GestureDetector(
                  onTap: () => PlantRoute(plantId: product.id).push(context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: CachedNetworkImage(
                            imageUrl: product.imageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 120,
                                child: Text(
                                  product.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              Text("\$${product.price}"),
                            ],
                          ),
                          GestureDetector(
                            onTap: () => provider.toggleFavorite(product.id),
                            child: Container(
                              height: 35,
                              width: 40,
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
                                size: context.responsiveTextSize(22),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    "No favorites yet",
                    style: GoogleFonts.cabin(fontSize: 18, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Explore plants and tap the heart to save them here!",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cabin(color: Colors.grey[500]),
                  ),
                ],
              ),
            ),
    );
  }
}
