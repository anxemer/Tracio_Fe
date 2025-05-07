// ignore_for_file: public_member_api_docs, sort_constructors_first
class ChangeRoleReq {
  final String refreshToken;
  final String? role;
  ChangeRoleReq({
    required this.refreshToken,
    this.role,
  });
}
