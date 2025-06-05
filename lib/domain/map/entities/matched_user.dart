class MatchedUserEntity {
  final int userId;
  final String userName;
  final String avatar;
  final double longitude;
  final double latitude;
  final String status;
  MatchedUserEntity({
    required this.userId,
    required this.userName,
    required this.avatar,
    required this.longitude,
    required this.latitude,
    this.status = 'matched', //Leave, Finish
  });
}
