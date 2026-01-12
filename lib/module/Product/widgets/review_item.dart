import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/base_model/review.dart';

class buildReviewItem extends StatelessWidget {
  Review review;
  buildReviewItem({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(
              review.userAvatar ?? "https://ui-avatars.com/api/?name=${review.userName}",
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(review.userName, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                      DateFormat('MMM d, yyyy').format(review.createdAt),
                      style: const TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                  ],
                ),
                Row(
                  children: List.generate(
                    5,
                    (i) => Icon(
                      Icons.star,
                      size: 14,
                      color: i < review.rating ? Colors.amber : Colors.grey[300],
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  review.comment,
                  style: TextStyle(color: Colors.grey[800], height: 1.4, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
