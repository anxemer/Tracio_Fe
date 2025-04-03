import 'package:flutter/material.dart';

class MyGroupItem extends StatelessWidget {
  final String groupImageUrl;
  final String groupName;
  final int memberCount;
  final String address;
  final int postCount;

  const MyGroupItem({
    super.key,
    required this.groupImageUrl,
    required this.groupName,
    required this.memberCount,
    required this.address,
    required this.postCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            // Left side: Group Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                groupImageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            // Right side: Group Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    groupName,
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '$memberCount members',
                    style: TextStyle(
                        fontSize: 14.0, color: Colors.grey.withOpacity(0.7)),
                  ),
                  SizedBox(height: 4),
                  Text(
                    address,
                    style: TextStyle(
                        fontSize: 12.0, color: Colors.grey.withOpacity(0.6)),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '$postCount posts',
                    style: TextStyle(
                        fontSize: 12.0, color: Colors.grey.withOpacity(0.6)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
