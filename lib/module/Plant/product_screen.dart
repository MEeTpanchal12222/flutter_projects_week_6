import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_projects_week_6/utils/Extension/responsive_ui_extension.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductScreen extends StatelessWidget {
  final String productId;
  final Map<String, dynamic>? productData;

  const ProductScreen({super.key, required this.productId, this.productData});

  @override
  Widget build(BuildContext context) {
    final name = productData?['name'] ?? "Monstera";
    final price = productData?['price'] ?? 200;
    final image =
        productData?['image'] ??
        "https://images.unsplash.com/photo-1614594975525-e45852b82481?q=80&w=2574&auto=format&fit=crop";
    final description =
        productData?['desc'] ??
        "Monstera is a genus of 40 to 60 tropical and warm temperate flowering annuals...";
    final rating = productData?['rating'] ?? 5.0;

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
            horizontal: context.widthPercentage(8), // Responsive Padding
            vertical: context.heightPercentage(2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: context.heightPercentage(35), // Responsive Image Height
                width: context.widthPercentage(90),
                child: CachedNetworkImage(
                  imageUrl: image,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.error, size: 50, color: Colors.grey),
                ),
              ),
              SizedBox(height: context.heightPercentage(3)),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      name,
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
                        '$rating',
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
                style: TextStyle(
                  fontSize: context.responsiveTextSize(20),
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: context.heightPercentage(1.5)),

              Text(
                description,
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

              const Spacer(),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Price',
                        style: GoogleFonts.cabin(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: context.responsiveTextSize(18),
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      Text(
                        '\$ $price',
                        style: GoogleFonts.cabin(
                          textStyle: TextStyle(
                            fontSize: context.responsiveTextSize(30),
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      // Add to Cart Logic via Provider would go here
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      height: context.hightForButton(60), // Responsive Button
                      width: context.widthPercentage(50),
                      decoration: BoxDecoration(
                        color: const Color(0xff50AD98),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Add to Cart',
                        style: GoogleFonts.cabin(
                          textStyle: TextStyle(
                            fontSize: context.responsiveTextSize(18),
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
