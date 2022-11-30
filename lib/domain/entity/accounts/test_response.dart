part 'account_entity.dart';

class TestResponse {
  int id = 0;
  List<AccountEntity> accounts = [];

  TestResponse({required this.accounts});

  TestResponse.fromJson(Map<String, dynamic> json) {
    if (json['accounts'] != null) {
      json['accounts'].forEach((v) {
        accounts.add(AccountEntity.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    // if (accounts != null) {
    data['accounts'] = accounts.toList().map((v) => v.toJson()).toList();
    // }
    return data;
  }
}
