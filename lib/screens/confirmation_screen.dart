import 'package:flutter/material.dart';
import '../enums/wallet_type.dart';
import '../models/transaction_model.dart';
import '../services/ussd_service.dart';
import '../theme/app_theme.dart';

class ConfirmationScreen extends StatelessWidget {
  final WalletType walletType;
  final String target;
  final double amount;
  final String receiverName;
  final Function(TransactionModel) onTransactionConfirmed;

  const ConfirmationScreen({
    super.key,
    required this.walletType,
    required this.target,
    required this.amount,
    required this.receiverName,
    required this.onTransactionConfirmed,
  });

  @override
  Widget build(BuildContext context) {
    // تركيب كود USSD النهائي للعرض
    final String ussdCode = UssdService.buildUssdCode(
      walletType: walletType,
      target: target,
      amount: amount,
    );

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(72.0),
          child: AppBar(
            backgroundColor: AppColors.primary,
            elevation: 0,
            leadingWidth: 72,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(24),
              ),
            ),
            leading: Padding(
              padding: const EdgeInsets.only(right: 16.0, top: 8.0, bottom: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 18),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            title: const Text(
              'تأكيد عملية التحويل',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    // 1. أيقونة التأكيد الدائرية
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_circle,
                        color: AppColors.primary,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 2. العناوين
                    Text(
                      'تأكيد التحويل',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'يرجى مراجعة تفاصيل العملية قبل التأكيد',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // 3. كرت التفاصيل المالي
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.dividerColor),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadowColor,
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'تفاصيل العملية',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const Divider(height: 24, thickness: 0.5),
                          
                          _buildDetailRow('اسم المستلم', receiverName),
                          const SizedBox(height: 16),
                          _buildDetailRow('نوع الخدمة', walletType.displayName),
                          const SizedBox(height: 16),
                          _buildDetailRow('رقم المستلم', target),
                          const SizedBox(height: 16),
                          _buildDetailRow('المبلغ', '${amount.toStringAsFixed(0)} ILS'),
                          const SizedBox(height: 16),
                          _buildDetailRow('رسوم التحويل', '0 ILS'),
                          const Divider(height: 32, thickness: 0.5),
                          
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'المجموع الكلي',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                '${amount.toStringAsFixed(0)} ILS',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 4. صندوق كود USSD النهائي
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                          child: Text(
                            'رمز USSD النهائي',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                          decoration: BoxDecoration(
                            color: AppColors.cardBackground,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.dividerColor, width: 1),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            ussdCode,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                              letterSpacing: 1.5,
                            ),
                            textDirection: TextDirection.ltr,
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
              ),
            ),
            // 6. الأزرار الثابتة بالأسفل
            Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        // 1. تشغيل كود الـ USSD عبر الـ Dialer
                        final success = await UssdService.launchInDialer(
                          walletType: walletType,
                          target: target,
                          amount: amount,
                        );

                        if (success) {
                          // 2. تسجيل الحوالة برمجياً لتصبح ديناميكية وتظهر في السجل والنشاط الأخير
                          final newTx = TransactionModel(
                            id: DateTime.now().millisecondsSinceEpoch.toString(),
                            title: receiverName,
                            subtitle: '${walletType.displayName} • $target',
                            amount: amount,
                            walletType: walletType,
                            status: TransactionStatus.success, // نعتبرها ناجحة بمجرد إرسال الكود للاتصال
                            date: DateTime.now(),
                            isIncoming: false,
                          );

                          onTransactionConfirmed(newTx);

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('تم فتح شاشة الاتصال وإدراج الكود وتوثيق الحوالة بنجاح'),
                                backgroundColor: AppColors.success,
                              ),
                            );
                            // العودة للشاشة الرئيسية
                            Navigator.popUntil(context, (route) => route.isFirst);
                          }
                        } else if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('فشل فتح واجهة الاتصال، يرجى المحاولة يدوياً'),
                              backgroundColor: AppColors.failed,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('تأكيد وإرسال'),
                          SizedBox(width: 8),
                          Icon(Icons.check, size: 18),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: AppColors.primary, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.edit_outlined, color: AppColors.primary, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'العودة للتعديل',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
