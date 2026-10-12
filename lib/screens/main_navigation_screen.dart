import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';
import 'history_screen.dart';
import 'profile_screen.dart';
import '../services/storage_service.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  // القائمة الديناميكية للحوالات
  late final List<TransactionModel> _transactions;

  // بيانات الحساب الشخصي القابلة للتعديل
  late String _userName;
  late String _userPhone;

  @override
  void initState() {
    super.initState();
    _transactions = StorageService.getTransactions();
    _userName = StorageService.getUserName('المستخدم');
    _userPhone = StorageService.getUserPhone('0590000000');
  }

  void _addTransaction(TransactionModel tx) {
    setState(() {
      _transactions.insert(0, tx);
    });
    StorageService.saveTransactions(_transactions);
  }

  void _updateProfile(String name, String phone) {
    setState(() {
      _userName = name;
      _userPhone = phone;
    });
    StorageService.saveUserName(name);
    StorageService.saveUserPhone(phone);
  }

  void _changeTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // تسجيل اعتماد الشاشة على الثيم لتحديث الألوان فوراً عند التغيير
    Theme.of(context);
    
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        extendBody: true, // يتيح للمحتوى الممتد بالمرور خلف شريط التنقل السفلي لجعله عائماً بحق
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            HomeScreen(
              userName: _userName,
              transactions: _transactions,
              onAddTransaction: _addTransaction,
              onNavigateToTab: _changeTab,
            ),
            HistoryScreen(
              transactions: _transactions,
              onBackToHome: () => _changeTab(0),
            ),
            ProfileScreen(
              userName: _userName,
              userPhone: _userPhone,
              onUpdateProfile: _updateProfile,
              onBackToHome: () => _changeTab(0),
            ),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: 220, // تقليل العرض لمظهر أكثر دقة وتقارباً
              height: 64, // تقليص الارتفاع
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32), // زيادة الانحناء ليصبح كبسولة مثالية تماماً
                boxShadow: [
                  BoxShadow(
                    color: AppColors.isDark 
                        ? Colors.black.withOpacity(0.3) 
                        : Colors.black.withOpacity(0.06), // ظل ناعم وخفيف
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32), // انحناء متناسق مع الحاوية
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // تأثير الضباب الزجاجي خلف الكبسولة
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8), // إلغاء البادينج الرأسي لتوسيط الكبسولة عمودياً بشكل مثالي
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground.withOpacity(0.9), // نفس لون خلفية الكروت بشفافية فخمة
                      borderRadius: BorderRadius.circular(32), // انحناء متناسق مع الحاوية
                      border: Border.all(color: AppColors.dividerColor), // بوردر متناسق مع التقسيمات
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: _buildNavItem(0, Icons.home_rounded, 'الرئيسية'),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: _buildNavItem(1, Icons.receipt_long_rounded, 'العمليات'),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: _buildNavItem(2, Icons.person_rounded, 'حسابي'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedIndex == index;
    final isDark = AppColors.isDark;
    
    // تحديد الألوان ديناميكياً لتفادي مشاكل التباين في الوضعين الفاتح والداكن
    final Color capsuleColor = isSelected
        ? (isDark ? AppColors.primary.withOpacity(0.3) : AppColors.primary.withOpacity(0.12))
        : Colors.transparent;
        
    final Color itemColor = isSelected
        ? (isDark ? Colors.white : AppColors.primary)
        : (isDark ? Colors.white.withOpacity(0.55) : AppColors.primary.withOpacity(0.55));

    return GestureDetector(
      onTap: () => _changeTab(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        constraints: const BoxConstraints(minWidth: 74), // زيادة العرض الأدنى للايتيم قليلاً
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7), // زيادة الطول (البادينج الرأسي) قليلاً
        decoration: BoxDecoration(
          color: capsuleColor,
          borderRadius: BorderRadius.circular(32), // زيادة الانحناء الداخلي ليتناسق مع الحاوية الخارجية
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: itemColor,
              size: 18, // تقليص حجم الأيقونة لتلائم الارتفاع الجديد
            ),
            const SizedBox(height: 2), // مسافة صغيرة
            Text(
              label,
              style: TextStyle(
                color: itemColor,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 9.5, // خط أنعم للارتفاع الصغير
                fontFamily: 'Cairo',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
