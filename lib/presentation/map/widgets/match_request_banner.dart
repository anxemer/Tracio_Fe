import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MatchRequestBanner extends StatefulWidget {
  final String userName;
  final String avatar;
  final VoidCallback onAccept;
  final VoidCallback onCancel;

  const MatchRequestBanner({
    super.key,
    required this.userName,
    required this.avatar,
    required this.onAccept,
    required this.onCancel,
  });

  @override
  State<MatchRequestBanner> createState() => _MatchRequestBannerState();
}

class _MatchRequestBannerState extends State<MatchRequestBanner> {
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 6,
      color: Colors.orangeAccent,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: widget.avatar,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(strokeWidth: 2),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.person),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '${widget.userName} is on the same route with you. Match?',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
              onPressed: widget.onCancel,
              child:
                  const Text("Cancel", style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              onPressed: widget.onAccept,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
              child: const Text("Match",
                  style: TextStyle(color: Colors.orangeAccent)),
            )
          ],
        ),
      ),
    );
  }
}
