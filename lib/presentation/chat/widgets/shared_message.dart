import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tracio_fe/core/configs/theme/app_colors.dart';
import 'package:tracio_fe/domain/chat/entities/shared_content.dart';

class SharedMessageWidget extends StatelessWidget {
  final SharedContentEntity content;

  const SharedMessageWidget({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 240,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: content.thumbnail,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  height: 120,
                  color: Colors.grey.shade200,
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (_, __, ___) => Container(
                  height: 120,
                  color: Colors.grey.shade300,
                  child: const Center(child: Icon(Icons.broken_image)),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              content.type.toUpperCase(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              content.summary,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14),
            ),
            if (content.creatorName != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundImage: NetworkImage(content.creatorAvatar ?? ''),
                    backgroundColor: Colors.grey.shade300,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      content.creatorName!,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              )
            ],
          ],
        ),
      ),
    );
  }
}
