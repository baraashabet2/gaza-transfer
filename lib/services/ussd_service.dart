import 'package:url_launcher/url_launcher.dart';
import '../enums/wallet_type.dart';

class UssdService {
  /// تركيب كود USSD بناءً على نوع المحفظة، المستلم، والمبلغ
  static String buildUssdCode({
    required WalletType walletType,
    required String target,
    required double amount,
  }) {
    // تنسيق المبلغ لحذف الكسور الصفرية (مثال: 50 بدلاً من 50.0)
    final String amountStr = amount % 1 == 0 ? amount.toInt().toString() : amount.toString();

    switch (walletType) {
      case WalletType.jawwalPay:
        return '*110#';
      case WalletType.palPay:
        // صيغة بال بي: *370*1*1*رقم_الهاتف*المبلغ#
        return '*370*1*1*$target*$amountStr#';
    }
  }

  /// إرسال كود الـ USSD إلى تطبيق الاتصال الافتراضي (Dialer)
  /// مع ترميز الـ # إلى %23 لضمان التوافق مع نظام أندرويد
  static Future<bool> launchInDialer({
    required WalletType walletType,
    required String target,
    required double amount,
  }) async {
    final String rawCode = buildUssdCode(
      walletType: walletType,
      target: target,
      amount: amount,
    );

    // استبدال الهاشتاج بـ %23
    final String encodedCode = rawCode.replaceAll('#', '%23');
    final Uri telUri = Uri.parse('tel:$encodedCode');

    try {
      if (await canLaunchUrl(telUri)) {
        return await launchUrl(telUri);
      } else {
        print('تعذر تشغيل الرابط: $telUri');
        return false;
      }
    } catch (e) {
      print('خطأ أثناء تشغيل واجهة الاتصال: $e');
      return false;
    }
  }

  /*
  /// ملاحظة للمطور: لتنفيذ الـ USSD المباشر دون فتح واجهة الاتصال (أندرويد فقط):
  /// 1. قم بإضافة حزمة ussd_advanced: ^1.2.1 إلى pubspec.yaml
  /// 2. قم بإضافة حزمة permission_handler لطلب صلاحية CALL_PHONE
  /// 3. استخدم الكود التالي:
  
  static Future<String?> sendDirectUssd({
    required WalletType walletType,
    required String target,
    required double amount,
  }) async {
    import 'package:permission_handler/permission_handler.dart';
    import 'package:ussd_advanced/ussd_advanced.dart';

    // طلب الصلاحية أولاً
    var status = await Permission.phone.request();
    if (status.isGranted) {
      final String rawCode = buildUssdCode(
        walletType: walletType,
        target: target,
        amount: amount,
      );
      
      // تنفيذ الكود مباشرة (تنبيه: لا تقم بترميز الـ # هنا، أرسله كـ # عادي)
      try {
        return await UssdAdvanced.sendUssd(code: rawCode);
      } catch (e) {
        print("خطأ في التنفيذ المباشر للـ USSD: $e");
        // Fallback: في حال الفشل، افتح واجهة الاتصال كحل احتياطي
        await launchInDialer(walletType: walletType, target: target, amount: amount);
        return null;
      }
    } else {
      throw 'صلاحية إجراء المكالمات مرفوضة من قبل المستخدم.';
    }
  }
  */
}
