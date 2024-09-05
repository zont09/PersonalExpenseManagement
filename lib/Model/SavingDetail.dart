import 'package:personal_expense_management/Model/Wallet.dart';

class SavingDetail {
  int? id;
  int id_saving;
  double amount;
  Wallet wallet;
  String note;

  SavingDetail({this.id, required this.id_saving, required this.amount, required this.wallet, required this.note});

  factory SavingDetail.fromMap(Map<String, dynamic> json, Wallet Wat) {
    return SavingDetail(
      id: json['id'],
      id_saving: json['id_saving'],
      amount: json['amount'],
      wallet: Wat,
      note: json['note']
    );
  }

  Map<String, dynamic> toMap() {
    final data = <String, dynamic>{
      'id_saving': id_saving,
      'amount': amount,
      'wallet': wallet,
      'note': note
    };
    if (id != null) {
      data['id'] = id;
    }
    return data;
  }
}