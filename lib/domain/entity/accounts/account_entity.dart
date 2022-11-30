part of 'test_response.dart';

class AccountEntity {
  int id = 0;
  String? name;
  String? city;
  String? state;

  AccountEntity({
    this.id = 0,
    this.name,
    this.city,
    this.state,
  });

  AccountEntity.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    city = json['city'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['city'] = city;
    data['state'] = state;
    return data;
  }
}
