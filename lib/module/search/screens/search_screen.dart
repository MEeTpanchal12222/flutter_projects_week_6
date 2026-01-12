import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_projects_week_6/core/providers/search_provider.dart';
import 'package:flutter_projects_week_6/core/router/app_router.dart';
import 'package:flutter_projects_week_6/core/services/di.dart';
import 'package:flutter_projects_week_6/utils/Extension/responsive_ui_extension.dart';
import 'package:flutter_projects_week_6/utils/theme/app_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../widgets/empty_widget.dart';
import '../widgets/search_row_widget.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<SearchProvider>(),
      child: const _SearchContent(),
    );
  }
}

class _SearchContent extends StatelessWidget {
  const _SearchContent();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SearchProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(context.widthPercentage(5)),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => context.pop(),
                  ),
                  Expanded(
                    child: TextField(
                      controller: provider.searchCtrl,
                      autofocus: true,
                      onChanged: provider.onSearchChanged,
                      decoration: InputDecoration(
                        hintText: "Search plants, pots...",
                        filled: true,
                        fillColor: Colors.grey[100],
                        prefixIcon: const Icon(Icons.search, color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                        suffixIcon: provider.searchCtrl.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, color: Colors.grey),
                                onPressed: () {
                                  provider.searchCtrl.clear();
                                  provider.onSearchChanged('');
                                },
                              )
                            : null,
                      ),
                    ),
                  ),
                  SizedBox(width: context.widthPercentage(2)),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.tune, color: Colors.black),
                  ),
                ],
              ),
            ),

            Expanded(
              child: provider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : provider.searchResults.isEmpty && provider.searchCtrl.text.isNotEmpty
                  ? buildEmptyState()
                  : provider.searchResults.isEmpty
                  ? buildInitialState()
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: context.widthPercentage(5)),
                      itemCount: provider.searchResults.length,
                      itemBuilder: (context, index) {
                        final product = provider.searchResults[index];
                        return GestureDetector(
                          onTap: () {
                            PlantRoute(plantId: product.id).push(context);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(20),
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
                                    errorWidget: (context, url, error) =>
                                        Container(color: Colors.grey[300]),
                                  ),
                                ),
                                SizedBox(width: context.widthPercentage(4)),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.name,
                                        style: GoogleFonts.cabin(
                                          fontSize: context.responsiveTextSize(18),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "\$${product.price}",
                                        style: GoogleFonts.cabin(
                                          fontSize: context.responsiveTextSize(16),
                                          color: AppTheme.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
