import 'package:flutter/material.dart';

import '../../../utils/Extension/responsive_ui_extension.dart';

class buildInitialState extends StatelessWidget {
  const buildInitialState({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.widthPercentage(5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Popular Searches",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: ["Monstera", "Aloe", "Cactus", "Indoor"]
                .map(
                  (term) => Chip(
                    label: Text(term),
                    backgroundColor: Colors.grey[100],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide.none,
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
