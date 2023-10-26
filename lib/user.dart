class User {
  String? name;
  String? city;
  List<String>? body;

  User(this.name, this.city, this.body);

  static User empty() {
    return User('', '', []);
  }

  // User를 Map으로 변환
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'city': city,
      'body': body,
    };
  }

  // Map에서 User로 변환
  static User fromMap(Map<String, dynamic> map) {
    return User(map['name'], map['city'], List<String>.from(map['body']));
  }
}