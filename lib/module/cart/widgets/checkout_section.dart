import 'package:flutter/material.dart';
import 'package:flutter_projects_week_6/core/providers/cart_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/widgets/common_top_notification.dart';

class CheckoutSection extends StatelessWidget {
  final CartProvider provider;

  const CheckoutSection({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total:", style: GoogleFonts.cabin(fontSize: 18, color: Colors.grey)),
              Text(
                "\$${provider.totalAmount.toStringAsFixed(2)}",
                style: GoogleFonts.cabin(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () async {
                await provider.checkout();
                if (context.mounted) {
                  showTopNotification(context, "Order Placed!", isError: false);
                  context.go('/home');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff50AD98),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
              ),
              child: Text(
                "Checkout",
                style: GoogleFonts.cabin(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
