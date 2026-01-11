import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_projects_week_6/core/providers/cart_provider.dart';
import 'package:flutter_projects_week_6/core/router/app_router.dart';
import 'package:flutter_projects_week_6/core/services/di.dart';
import 'package:flutter_projects_week_6/module/cart/widgets/checkout_section.dart';
import 'package:flutter_projects_week_6/module/cart/widgets/quantity_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../utils/theme/app_theme.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: getIt<CartProvider>()..loadCart(),
      child: const _CartContent(),
    );
  }
}

class _CartContent extends StatelessWidget {
  const _CartContent();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "My Cart",
          style: GoogleFonts.cabin(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppTheme.primary.withValues(alpha: 0.4),
        elevation: 0,
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.items.isEmpty
          ? Center(
              child: Text(
                "Your cart is empty",
                style: GoogleFonts.cabin(fontSize: 18, color: Colors.grey),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(20),
                    itemCount: provider.items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final item = provider.items[index];
                      return GestureDetector(
                        onTap: () =>
                            PlantRoute(plantId: item.product.id).push(context),

                        child: Container(
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
                                  imageUrl: item.product.imageUrl,
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
                                      item.product.name,
                                      style: GoogleFonts.cabin(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "\$${item.product.price}",
                                      style: GoogleFonts.cabin(
                                        fontSize: 16,
                                        color: AppTheme.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  QuantityButton(
                                    icon: Icons.remove,
                                    onTap: () => provider.updateQuantity(
                                      item.id,
                                      item.quantity - 1,
                                      context,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    child: Text(
                                      "${item.quantity}",
                                      style: GoogleFonts.cabin(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  QuantityButton(
                                    icon: Icons.add,
                                    onTap: () => provider.updateQuantity(
                                      item.id,
                                      item.quantity + 1,
                                      context,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                CheckoutSection(provider: provider),
              ],
            ),
    );
  }
}
