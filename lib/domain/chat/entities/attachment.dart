import 'dart:io';

class AttachmentEntity {
  final String? fileUrl;
  final File? file;
  final DateTime updatedAt;
  AttachmentEntity({required this.fileUrl, required this.updatedAt, this.file});
}
