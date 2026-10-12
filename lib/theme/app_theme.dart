import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class AppColors {
  static bool get isDark => AppTheme.themeModeNotifier.value == ThemeMode.dark;

  // الألوان الأساسية الموحدة بالوضع الداكن والفاتح (الأزرق الفخم للوضع الفاتح)
  static Color get primary => const Color(0xFF0288D1);
  static Color get primaryLight => isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE1F5FE); // أزرق فاتح جداً للخلفيات الصغيرة
  static Color get accent => const Color(0xFFF25C22); // البرتقالي الدافئ النشط من اللوجو
  
  // ألوان الخلفيات - متناسقة مع تطبيق med_path
  static Color get background => isDark ? const Color(0xFF161618) : const Color(0xFFF6F9FC); // رمادي داكن فخم جداً
  static Color get cardBackground => isDark ? const Color(0xFF242426) : Colors.white; // كروت رمادية داكنة

  // ألوان الحالات
  static Color get success => isDark ? const Color(0xFF2E7D32) : const Color(0xFF2E7D32); // أخضر ناجح
  static Color get pending => isDark ? const Color(0xFFFFB74D) : const Color(0xFFEF6C00); // برتقالي قيد المعالجة
  static Color get failed => isDark ? const Color(0xFFD64747) : const Color(0xFFC62828); // أحمر فاشل

  // ألوان النصوص - متناسقة مع med_path
  static Color get textPrimary => isDark ? const Color(0xFFF2F2F7) : const Color(0xFF1A1A1A); // أسود داكن / أبيض ناصع
  static Color get textSecondary => isDark ? const Color(0xFF8E8E93) : const Color(0xFF757575); // رمادي متوسط
  static Color get textLight => isDark ? const Color(0xFF8E8E93) : const Color(0xFFBDBDBD); // رمادي فاتح

  // عناصر إضافية للوضع الداكن متوافقة مع med_path
  static Color get dividerColor => isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE2E8F0);
  static Color get shadowColor => Colors.transparent; // إلغاء الظلال في الوضع الداكن لمحاكاة تصميم مسار المسطح والأنيق
}

class AppTheme {
  static final ValueNotifier<ThemeMode> themeModeNotifier = ValueNotifier(ThemeMode.light);

  static void toggleTheme(BuildContext context) {
    final isCurrentlyDark = Theme.of(context).brightness == Brightness.dark;
    final newMode = isCurrentlyDark ? ThemeMode.light : ThemeMode.dark;
    themeModeNotifier.value = newMode;
    StorageService.setDarkMode(newMode == ThemeMode.dark);
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: const Color(0xFF0288D1),
      scaffoldBackgroundColor: const Color(0xFFF6F9FC),
      cardColor: Colors.white,
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF0288D1),
        secondary: Color(0xFFF25C22),
        surface: Color(0xFFF6F9FC),
      ),
      fontFamily: 'Cairo',
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1A1A1A),
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1A1A1A),
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1A1A1A),
        ),
        bodyLarge: TextStyle(
          fontSize: 15,
          color: Color(0xFF1A1A1A),
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: Color(0xFF757575),
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          color: Color(0xFFBDBDBD),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0288D1),
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF0288D1), width: 1.5),
        ),
        labelStyle: const TextStyle(color: Color(0xFF757575)),
        hintStyle: const TextStyle(color: Color(0xFFBDBDBD)),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: const Color(0xFF0288D1), // تم التوحيد للأزرق الفخم
      scaffoldBackgroundColor: const Color(0xFF161618), // رمادي داكن فخم جداً (med_path)
      cardColor: const Color(0xFF242426), // كروت رمادية داكنة (med_path)
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF0288D1), // تم التوحيد للأزرق الفخم
        secondary: Color(0xFFF25C22), // تم التوحيد للأزرق النشط الفاتح
        surface: Color(0xFF242426),
        background: Color(0xFF161618),
      ),
      fontFamily: 'Cairo',
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFFF2F2F7),
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFFF2F2F7),
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFFF2F2F7),
        ),
        bodyLarge: TextStyle(
          fontSize: 15,
          color: Color(0xFFF2F2F7),
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: Color(0xFF8E8E93),
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          color: Color(0xFF8E8E93),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0288D1), // تم التوحيد للأزرق الفخم
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF242426),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2C2C2E)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2C2C2E)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF0288D1), width: 1.5), // تم التوحيد للأزرق الفخم
        ),
        labelStyle: const TextStyle(color: Color(0xFF8E8E93)),
        hintStyle: const TextStyle(color: Color(0xFF8E8E93)),
      ),
    );
  }
}

