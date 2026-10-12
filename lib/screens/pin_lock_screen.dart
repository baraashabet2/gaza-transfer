import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';
import 'main_navigation_screen.dart';

class PinLockScreen extends StatefulWidget {
  const PinLockScreen({super.key});

  @override
  State<PinLockScreen> createState() => _PinLockScreenState();
}

class _PinLockScreenState extends State<PinLockScreen> {
  String _enteredPin = '';
  bool _isError = false;
  
  bool _isFirstTime = false;
  String? _tempPin;
  bool _isConfirming = false;

  @override
  void initState() {
    super.initState();
    // إذا كان رمز الـ PIN النشط فارغاً، فهذا يعني أن المستخدم يفتح التطبيق لأول مرة ولم يقم بتعيين رمز دخول بعد
    _isFirstTime = AuthService.activePin.isEmpty;
  }

  void _onKeyPress(String val) {
    if (_enteredPin.length >= 4) return;

    setState(() {
      _isError = false;
      _enteredPin += val;
    });

    if (_enteredPin.length == 4) {
      _verifyPin();
    }
  }

  void _onDelete() {
    if (_enteredPin.isEmpty) return;
    setState(() {
      _isError = false;
      _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
    });
  }

  void _onClear() {
    setState(() {
      _isError = false;
      _enteredPin = '';
    });
  }

  void _verifyPin() {
    Future.delayed(const Duration(milliseconds: 150), () {
      if (_isFirstTime) {
        if (!_isConfirming) {
          // الخطوة الأولى لإنشاء الرمز: حفظ الرمز مؤقتاً وطلب التأكيد
          setState(() {
            _tempPin = _enteredPin;
            _enteredPin = '';
            _isConfirming = true;
          });
        } else {
          // الخطوة الثانية: التحقق من تطابق الرمزين للتأكيد
          if (_enteredPin == _tempPin) {
            // متطابقين! حفظ الرمز وتوجيه المستخدم للشاشة الرئيسية
            StorageService.savePin(_enteredPin);
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('تم تعيين رمز الدخول بنجاح!'),
                  backgroundColor: AppColors.success,
                  duration: const Duration(seconds: 2),
                ),
              );
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
              );
            }
          } else {
            // غير متطابقين! إعادة التصفير والمحاولة مجدداً
            setState(() {
              _isError = true;
              _enteredPin = '';
              _tempPin = null;
              _isConfirming = false;
            });
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('الرمزان غير متطابقين! يرجى إعادة المحاولة.'),
                  backgroundColor: AppColors.failed,
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          }
        }
      } else {
        // الحالة العادية: التحقق من رمز الدخول المخزن للدخول للتطبيق
        if (_enteredPin == AuthService.activePin) {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
            );
          }
        } else {
          if (mounted) {
            setState(() {
              _isError = true;
              _enteredPin = '';
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('رمز PIN غير صحيح. يرجى المحاولة مجدداً'),
                backgroundColor: AppColors.failed,
                duration: const Duration(seconds: 2),
              ),
            );
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String titleText = 'رمز الدخول السريع';
    String subtitleText = 'الرجاء إدخال رمز PIN المكون من 4 أرقام';
    
    if (_isFirstTime) {
      if (_isConfirming) {
        titleText = 'تأكيد رمز الدخول';
        subtitleText = 'يرجى إعادة إدخال الرمز لتأكيده';
      } else {
        titleText = 'إنشاء رمز دخول جديد';
        subtitleText = 'يرجى تعيين رمز PIN مكون من 4 أرقام لحماية التطبيق';
      }
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 2),
              // هيدر الشاشة (اللوجو وحالة القفل)
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: (_isError ? AppColors.failed : AppColors.primary).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _isError 
                      ? Icons.lock_open_outlined 
                      : _isFirstTime 
                          ? Icons.lock_reset_rounded 
                          : Icons.lock_outline_rounded,
                  color: _isError ? AppColors.failed : AppColors.primary,
                  size: 38,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                titleText,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitleText,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 36),

              // مؤشرات الـ PIN (الدوائر)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) {
                  bool isFilled = index < _enteredPin.length;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isError
                          ? AppColors.failed
                          : isFilled
                              ? AppColors.primary
                              : AppColors.isDark
                                  ? const Color(0xFF2C2C2E)
                                  : Colors.grey.shade300,
                      border: Border.all(
                        color: _isError
                            ? AppColors.failed
                            : isFilled
                                ? AppColors.primary
                                : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                  );
                }),
              ),

              const Spacer(flex: 2),

              // لوحة المفاتيح الرقمية
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: ['1', '2', '3'].map((n) => _buildKeypadButton(n)).toList(),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: ['4', '5', '6'].map((n) => _buildKeypadButton(n)).toList(),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: ['7', '8', '9'].map((n) => _buildKeypadButton(n)).toList(),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // زر المسح (C)
                        _buildActionKeypadButton('C', _onClear),
                        // زر الصفر
                        _buildKeypadButton('0'),
                        // زر الحذف (Back)
                        _buildActionKeypadButton('delete', _onDelete),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKeypadButton(String digit) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.dividerColor, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _onKeyPress(digit),
          customBorder: const CircleBorder(),
          child: Center(
            child: Text(
              digit,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                fontFamily: 'Cairo',
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionKeypadButton(String action, VoidCallback onTap) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: Colors.transparent,
        shape: BoxShape.circle,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Center(
            child: action == 'delete'
                ? Icon(
                    Icons.backspace_outlined,
                    color: AppColors.textPrimary,
                    size: 24,
                  )
                : Text(
                    action,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
