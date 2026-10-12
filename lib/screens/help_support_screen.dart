import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  Future<void> _launchUrl(BuildContext context, String urlString) async {
    final Uri url = Uri.parse(urlString);
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw 'Could not launch $urlString';
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('تعذر فتح الرابط المطلوب'),
            backgroundColor: AppColors.failed,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
              'المساعدة والدعم الفني',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. قسم التواصل المباشر
              Text(
                'تواصل معنا مباشرة',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildContactCard(
                      context: context,
                      title: 'الدعم عبر واتساب',
                      subtitle: 'متاح على مدار الساعة',
                      icon: Icons.chat_bubble_outline_rounded,
                      color: const Color(0xFF2E7D32),
                      onTap: () => _launchUrl(context, 'https://wa.me/972595075569'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildContactCard(
                      context: context,
                      title: 'اتصال هاتفي مباشر',
                      subtitle: 'من 8 ص حتى 8 م',
                      icon: Icons.phone_in_talk_rounded,
                      color: AppColors.primary,
                      onTap: () => _launchUrl(context, 'tel:0595075569'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // 2. الأسئلة الشائعة
              Text(
                'الأسئلة الشائعة',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              _buildFaqTile(
                question: 'كيف يعمل تطبيق حوِّلي؟',
                answer: 'يقوم التطبيق بتحويل مدخلاتك (رقم الهاتف والمبلغ) إلى كود USSD المعتمد من قبل شركات الاتصالات الفلسطينية، ويقوم بتشغيل هذا الكود مباشرة عبر واجهة الاتصال في هاتفك لإجراء عملية تحويل الرصيد دون الحاجة لوجود إنترنت.',
              ),
              _buildFaqTile(
                question: 'هل يحتاج التطبيق إلى الاتصال بالإنترنت؟',
                answer: 'لا، التطبيق مصمم خصيصاً ليعمل بالكامل بدون اتصال بالإنترنت، حيث يعتمد على أكواد الـ USSD وشبكة الهاتف الخلوي العادية لإرسال واستلام الحوالات.',
              ),
              _buildFaqTile(
                question: 'هل تطبيق حوِّلي آمن؟',
                answer: 'نعم، التطبيق آمن تماماً. لا يقوم التطبيق بتخزين أو مشاركة أي بيانات حساسة، ورمز الـ PIN الخاص بمحفظتك تقوم بإدخاله بنفسك بشكل يدوي على شاشة الاتصال الرسمية التابعة للشركة المزودة للخدمة ولا يمر عبر التطبيق.',
              ),
              _buildFaqTile(
                question: 'ما هي الرسوم المترتبة على استخدام التطبيق؟',
                answer: 'تطبيق حوِّلي مجاني بالكامل ولا يتقاضى أي رسوم على الحوالات. الرسوم المقتطعة هي فقط الرسوم الرسمية المقررة من قِبل مزودي الخدمة (جوال باي أو بال بي) إن وجدت.',
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.dividerColor),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqTile({required String question, required String answer}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.dividerColor),
      ),
      child: Theme(
        data: ThemeData(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          title: Text(
            question,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: AppColors.textPrimary,
            ),
          ),
          iconColor: AppColors.primary,
          collapsedIconColor: AppColors.textSecondary,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
              child: Text(
                answer,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
