import 'package:flutter/material.dart';
import 'screens/pin_lock_screen.dart';
import 'screens/main_navigation_screen.dart';
import 'theme/app_theme.dart';
import 'services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  
  // تحميل وضع المظهر المحفوظ تلقائياً عند إقلاع التطبيق
  final isDark = StorageService.isDarkMode();
  AppTheme.themeModeNotifier.value = isDark ? ThemeMode.dark : ThemeMode.light;

  runApp(const GazaTransferApp());
}

class GazaTransferApp extends StatelessWidget {
  const GazaTransferApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppTheme.themeModeNotifier,
      builder: (context, themeMode, _) {
        return MaterialApp(
          title: 'حوِّلي',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          themeAnimationDuration: const Duration(milliseconds: 350),
          themeAnimationCurve: Curves.easeInOut,
          // تهيئة التطبيق ليدعم اللغة العربية والاتجاه من اليمين لليسار افتراضياً
          home: StorageService.isPinEnabled()
              ? const PinLockScreen()
              : const MainNavigationScreen(),
          builder: (context, child) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: child!,
            );
          },
        );
      },
    );
  }
}
