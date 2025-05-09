class MediaFile {
  MediaFile({
    required this.mediaId,
    required this.mediaUrl,
  });

  final int? mediaId;
  final String? mediaUrl;

  factory MediaFile.fromJson(Map<String, dynamic> json) {
    return MediaFile(
      mediaId: json["mediaId"],
      mediaUrl: json["mediaUrl"],
    );
  }

  Map<String, dynamic> toJson() => {
        "mediaId": mediaId,
        "mediaUrl": mediaUrl,
      };
}
