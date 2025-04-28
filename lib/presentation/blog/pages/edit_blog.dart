import 'package:flutter/material.dart';
import 'package:tracio_fe/common/helper/media_file.dart';
import 'package:tracio_fe/core/constants/app_size.dart';

import '../../../common/widget/blog/picture_card.dart';

// class EditBlogResult {
//   final String content;
//   final bool isPublic;

//   EditBlogResult({required this.content, required this.isPublic});
// }

class EditBlogPostScreen extends StatefulWidget {
  final List<MediaFile> imageUrl;
  final int blogId;
  final String initialContent;
  final bool initialIsPublic;

  const EditBlogPostScreen({
    super.key,
    required this.initialContent,
    required this.initialIsPublic,
    required this.blogId,
    required this.imageUrl,
  });

  @override
  State<EditBlogPostScreen> createState() => _EditBlogPostScreenState();
}

class _EditBlogPostScreenState extends State<EditBlogPostScreen> {
  late TextEditingController _contentController;
  late bool _isPublic;

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(text: widget.initialContent);
    _isPublic = widget.initialIsPublic;
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    final updatedContent = _contentController.text;
    final updatedIsPublic = _isPublic;

    // final result = EditBlogResult(
    //   content: updatedContent,
    //   isPublic: updatedIsPublic,
    // );

    // if (mounted) {
    //   Navigator.pop(context, result);
    // }
  }

  @override
  Widget build(BuildContext context) {
    List<String> mediaUrls =
        widget.imageUrl.map((file) => file.mediaUrl ?? "").toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Blog'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _saveChanges,
            child: Text(
              'Save',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            widget.imageUrl.isNotEmpty
                ? PictureCard(listImageUrl: mediaUrls)
                : Container(),
            Expanded( 
              child: TextField(
                controller: _contentController,
                maxLines: null,
                expands: true,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  hintText: 'What Do You Think',
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
                style: const TextStyle(fontSize: 18),
                autofocus: true,
                textAlignVertical: TextAlignVertical.top,
              ),
            ),
            const Divider(),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      _isPublic ? Icons.public : Icons.lock,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _isPublic ? 'Public' : 'Privete',
                      style: TextStyle(
                          fontSize: AppSize.textLarge,
                          color: Colors.grey.shade700),
                    ),
                  ],
                ),
                Switch(
                  value: _isPublic,
                  onChanged: (newValue) {
                    setState(() {
                      _isPublic = newValue;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
