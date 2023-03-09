class UserModel {
  final String id;
  late final String email;

  UserModel(this.id, Map<String, dynamic> map) {
    email = map['email'] ?? (throw 'NO EMAIL IN USER $id');
  }
}