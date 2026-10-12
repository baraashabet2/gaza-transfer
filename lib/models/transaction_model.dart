import '../enums/wallet_type.dart';

enum TransactionStatus {
  success,
  pending,
  failed,
}

class TransactionModel {
  final String id;
  final String title;
  final String subtitle; // Phone number or wallet details
  final double amount;
  final WalletType walletType;
  final TransactionStatus status;
  final DateTime date;
  final bool isIncoming;

  TransactionModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.walletType,
    required this.status,
    required this.date,
    required this.isIncoming,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'amount': amount,
      'walletType': walletType.index,
      'status': status.index,
      'date': date.toIso8601String(),
      'isIncoming': isIncoming,
    };
  }

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      title: json['title'],
      subtitle: json['subtitle'],
      amount: (json['amount'] as num).toDouble(),
      walletType: WalletType.values[json['walletType']],
      status: TransactionStatus.values[json['status']],
      date: DateTime.parse(json['date']),
      isIncoming: json['isIncoming'] ?? false,
    );
  }
}
