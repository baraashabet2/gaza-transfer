import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../theme/app_theme.dart';

class TransactionCard extends StatelessWidget {
  final TransactionModel transaction;
  final VoidCallback? onTap;

  const TransactionCard({
    super.key,
    required this.transaction,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // تنسيق حالة المعاملة باللغة العربية
    String statusText = '';
    Color statusColor = Colors.grey;
    Color statusBgColor = Colors.grey.shade100;

    switch (transaction.status) {
      case TransactionStatus.success:
        statusText = 'ناجح';
        statusColor = AppColors.success;
        statusBgColor = AppColors.success.withOpacity(0.1);
        break;
      case TransactionStatus.pending:
        statusText = 'قيد المعالجة';
        statusColor = AppColors.pending;
        statusBgColor = AppColors.pending.withOpacity(0.1);
        break;
      case TransactionStatus.failed:
        statusText = 'مرفوض';
        statusColor = AppColors.failed;
        statusBgColor = AppColors.failed.withOpacity(0.1);
        break;
    }

    final String amountPrefix = transaction.isIncoming ? '+' : '-';
    final Color amountColor = transaction.isIncoming ? AppColors.success : AppColors.primary;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
        border: Border.all(color: AppColors.dividerColor),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        // الأيقونة (تظهر على اليمين تلقائياً في الـ RTL)
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: transaction.isIncoming
                ? AppColors.success.withOpacity(0.08)
                : AppColors.primary.withOpacity(0.08),
            shape: BoxShape.circle,
          ),
          child: Icon(
            transaction.isIncoming ? Icons.arrow_downward : Icons.arrow_upward,
            color: transaction.isIncoming ? AppColors.success : AppColors.primary,
            size: 20,
          ),
        ),
        // الاسم (يظهر محاذى لليمين بجانب الأيقونة)
        title: Text(
          transaction.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: AppColors.textPrimary,
            fontFamily: 'Cairo',
          ),
        ),
        // التفاصيل والوقت (تحت الاسم محاذى لليمين)
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            transaction.subtitle,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontFamily: 'Cairo',
            ),
          ),
        ),
        // المبلغ (يظهر في أقصى اليسار)
        trailing: Text(
          '$amountPrefix ${transaction.amount.toStringAsFixed(2)} ILS',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: amountColor,
          ),
          textDirection: TextDirection.ltr,
        ),
      ),
    );
  }
}
