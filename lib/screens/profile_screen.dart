import 'dart:io';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/storage_service.dart';
import 'edit_profile_screen.dart';
import 'security_settings_screen.dart';
import 'manage_contacts_screen.dart';
import 'help_support_screen.dart';
import 'about_screen.dart';
import 'pin_lock_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String userName;
  final String userPhone;
  final Function(String, String) onUpdateProfile;
  final VoidCallback onBackToHome;

  const ProfileScreen({
    super.key,
    required this.userName,
    required this.userPhone,
    required this.onUpdateProfile,
    required this.onBackToHome,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    // تسجيل اعتماد الشاشة على الثيم لتحديث الألوان فوراً عند التغيير
    Theme.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(72.0),
          child: AppBar(
            backgroundColor: AppColors.primary,
            elevation: 0,
            scrolledUnderElevation: 0,
            leadingWidth: 72,
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
                  onPressed: widget.onBackToHome,
                ),
              ),
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(24),
              ),
            ),
            title: const Text(
              'حسابي',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFamily: 'Cairo',
              ),
            ),
            centerTitle: true,
            actions: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        return RotationTransition(
                          turns: animation,
                          child: FadeTransition(
                            opacity: animation,
                            child: child,
                          ),
                        );
                      },
                      child: Icon(
                        Theme.of(context).brightness == Brightness.dark
                            ? Icons.light_mode_rounded
                            : Icons.dark_mode_rounded,
                        key: ValueKey<bool>(Theme.of(context).brightness == Brightness.dark),
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () => AppTheme.toggleTheme(context),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 140.0), // مساحة مريحة جداً للجوالات الصغيرة
          child: Column(
            children: [
              // 1. كرت الملف الشخصي (عند الضغط عليه أو على القلم يفتح التعديل)
              _buildUserProfileCard(context),
              const SizedBox(height: 16),

              // 2. قائمة الإعدادات
              _buildSettingsList(context),
              const SizedBox(height: 24),

              // 3. كارت المطور الاحترافي
              _buildDeveloperCard(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserProfileCard(BuildContext context) {
    final imagePath = StorageService.getProfileImagePath();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
      child: Column(
        children: [
          // الصورة الشخصية مع زر التعديل الأزرق التفاعلي
          GestureDetector(
            onTap: () => _navigateToEditProfile(context),
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: AppColors.isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(16),
                    image: imagePath != null && imagePath.isNotEmpty
                        ? DecorationImage(
                            image: FileImage(File(imagePath)),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: imagePath == null || imagePath.isEmpty
                      ? Icon(
                          Icons.person,
                          size: 40,
                          color: AppColors.primary,
                        )
                      : null,
                ),
                // زر تعديل الصورة الأزرق
                Transform.translate(
                  offset: const Offset(-8, 8),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // الاسم ورقم الهاتف الديناميكيين
          Text(
            widget.userName,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.userPhone,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  letterSpacing: 0.5,
                ),
                textDirection: TextDirection.ltr,
              ),
              const SizedBox(width: 6),
              Icon(
                Icons.phone_android_rounded,
                color: AppColors.textSecondary,
                size: 16,
              ),
            ],
          ),
          const SizedBox(height: 12),
          // زر نصي إضافي لتسهيل الوصول للتعديل
          TextButton.icon(
            onPressed: () => _navigateToEditProfile(context),
            icon: Icon(Icons.edit_note_rounded, size: 18, color: AppColors.accent),
            label: Text(
              'تعديل بيانات الحساب',
              style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToEditProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(
          currentName: widget.userName,
          currentPhone: widget.userPhone,
          onSave: widget.onUpdateProfile,
        ),
      ),
    );
  }

  Widget _buildDeveloperCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1), // لون الهيدر شفاف (أزرق مائي فخم)
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.25), // بوردر خفيف ملفت ومتناسق
          width: 1.2,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.code_rounded,
            color: AppColors.primary,
            size: 22,
          ),
          const SizedBox(width: 10),
          Text(
            'تم التطوير بواسطة م. براء رياض شابط',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.primary, // نفس لون الهيدر
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsList(BuildContext context) {
    return Container(
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
      child: Column(
        children: [
          _buildSettingItem(
            icon: Icons.security_rounded,
            title: 'إعدادات الأمان (تغيير PIN)',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SecuritySettingsScreen()),
              );
            },
          ),
          _buildDivider(),
          _buildSettingItem(
            icon: Icons.people_alt_rounded,
            title: 'إدارة جهات الاتصال',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ManageContactsScreen()),
              );
            },
          ),
           _buildDivider(),
          _buildSettingItem(
            icon: Icons.support_agent_rounded,
            title: 'المساعدة والدعم الفني',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpSupportScreen()),
              );
            },
          ),
          _buildDivider(),
          _buildSettingItem(
            icon: Icons.info_rounded,
            title: 'عن التطبيق',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutScreen()),
              );
            },
          ),
          _buildDivider(),
          _buildSettingItem(
            icon: Icons.logout_rounded,
            title: 'تسجيل الخروج',
            textColor: AppColors.failed,
            iconColor: AppColors.failed,
            onTap: () {
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            backgroundColor: AppColors.cardBackground,
            surfaceTintColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              'تسجيل الخروج',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                fontFamily: 'Cairo',
              ),
            ),
            content: Text(
              'هل أنت متأكد من رغبتك في تسجيل الخروج من التطبيق؟',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                fontFamily: 'Cairo',
              ),
            ),
            actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            actions: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        // تسجيل الخروج الحقيقي: التوجيه لصفحة القفل وإزالة كافة الصفحات السابقة
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const PinLockScreen()),
                          (route) => false,
                        );
                      },
                      icon: const Icon(Icons.logout_rounded, size: 16),
                      label: const Text(
                        'تسجيل خروج',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.failed,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        'إلغاء',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    Color? textColor,
    Color? iconColor,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    final Color actualTextColor = textColor ?? AppColors.textPrimary;
    final Color actualIconColor = iconColor ?? AppColors.primary;
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: actualIconColor, size: 22),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: actualTextColor,
        ),
      ),
      trailing: trailing ?? Icon(
        Icons.chevron_right_rounded,
        color: AppColors.textLight,
        size: 20,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 0.5,
      color: AppColors.dividerColor,
      indent: 16,
      endIndent: 16,
    );
  }
}
