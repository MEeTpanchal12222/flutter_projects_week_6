import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/product_details_provider.dart';
import '../../../core/router/app_router.dart';
import '../../../utils/Extension/responsive_ui_extension.dart';

class buildSimilarPlants extends StatelessWidget {
  const buildSimilarPlants({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PlantDetailProvider>();
    if (provider.isLoadingSimilar && provider.similarPlants.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (provider.similarPlants.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: context.widthPercentage(8)),
          child: const Text(
            "Similar Plants",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: ListView.builder(
            padding: EdgeInsets.only(left: context.widthPercentage(8)),
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
                          placeholder: (context, url) => Container(color: Colors.grey[100]),
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
