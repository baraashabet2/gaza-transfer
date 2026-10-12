import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/transaction_model.dart';
import '../models/contact_model.dart';
import 'auth_service.dart';

class StorageService {
  static late SharedPreferences _prefs;

  /// تهيئة مخزن البيانات المحلي وتحميل البيانات الأساسية
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    
    // تحميل رمز PIN المخزن إن وجد
    final savedPin = _prefs.getString('auth_pin');
    if (savedPin != null) {
      AuthService.activePin = savedPin;
    }
  }

  // --- رمز PIN ---
  static Future<void> savePin(String pin) async {
    await _prefs.setString('auth_pin', pin);
    AuthService.activePin = pin;
  }

  // --- تفعيل/إلغاء قفل PIN ---
  static bool isPinEnabled() {
    return _prefs.getBool('is_pin_enabled') ?? true; // الافتراضي مفعل
  }

  static Future<void> setPinEnabled(bool enabled) async {
    await _prefs.setBool('is_pin_enabled', enabled);
  }

  // --- مظهر التطبيق (داكن/فاتح) ---
  static bool isDarkMode() {
    return _prefs.getBool('is_dark_mode') ?? false; // الافتراضي فاتح
  }

  static Future<void> setDarkMode(bool isDark) async {
    await _prefs.setBool('is_dark_mode', isDark);
  }

  // --- الملف الشخصي ---
  static String getUserName(String defaultValue) {
    return _prefs.getString('user_name') ?? defaultValue;
  }

  static Future<void> saveUserName(String name) async {
    await _prefs.setString('user_name', name);
  }

  static String getUserPhone(String defaultValue) {
    return _prefs.getString('user_phone') ?? defaultValue;
  }

  static Future<void> saveUserPhone(String phone) async {
    await _prefs.setString('user_phone', phone);
  }

  // --- مسار صورة الملف الشخصي ---
  static String? getProfileImagePath() {
    return _prefs.getString('profile_image_path');
  }

  static Future<void> saveProfileImagePath(String path) async {
    await _prefs.setString('profile_image_path', path);
  }

  static Future<void> clearProfileImagePath() async {
    await _prefs.remove('profile_image_path');
  }

  // --- العمليات (Transactions) ---
  static List<TransactionModel> getTransactions() {
    final List<String>? txList = _prefs.getStringList('transactions');
    if (txList == null) return [];
    
    return txList.map((txStr) {
      return TransactionModel.fromJson(jsonDecode(txStr));
    }).toList();
  }

  static Future<void> saveTransactions(List<TransactionModel> list) async {
    final List<String> txList = list.map((tx) {
      return jsonEncode(tx.toJson());
    }).toList();
    
    await _prefs.setStringList('transactions', txList);
  }

  // --- جهات الاتصال (Contacts) ---
  static List<ContactModel> getContacts() {
    final List<String>? contactList = _prefs.getStringList('contacts');
    if (contactList == null) {
      return [];
    }
    
    return contactList.map((cStr) {
      return ContactModel.fromJson(jsonDecode(cStr));
    }).toList();
  }

  static Future<void> saveContacts(List<ContactModel> list) async {
    final List<String> contactList = list.map((c) {
      return jsonEncode(c.toJson());
    }).toList();
    
    await _prefs.setStringList('contacts', contactList);
  }
}
