class EditUserProfileReq {
  EditUserProfileReq({
    required this.userName,
    required this.bio,
    required this.gender,
    required this.city,
    required this.district,
    required this.isPublic,
  });

  final String? userName;
  final String? bio;
  final String? gender;
  final String? city;
  final String? district;
  final bool? isPublic;

  Map<String, dynamic> toJson() => {
        "userName": userName,
        "bio": bio,
        "gender": gender,
        "city": city,
        "district": district,
        "isPublic": isPublic,
      };
}
