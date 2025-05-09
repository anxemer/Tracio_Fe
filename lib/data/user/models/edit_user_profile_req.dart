class EditUserProfileReq {
  EditUserProfileReq({
    this.userName,
    this.bio,
    this.gender,
    this.city,
    this.district,
    this.isPublic,
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
