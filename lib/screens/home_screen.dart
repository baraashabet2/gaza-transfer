import 'package:flutter/material.dart';
import '../enums/wallet_type.dart';
import '../models/transaction_model.dart';
import '../theme/app_theme.dart';
import '../widgets/wallet_selector.dart';
import '../widgets/transaction_card.dart';
import 'confirmation_screen.dart';
import 'manage_contacts_screen.dart';
import '../models/contact_model.dart';

class HomeScreen extends StatefulWidget {
  final String userName;
  final List<TransactionModel> transactions;
  final Function(TransactionModel) onAddTransaction;
  final Function(int) onNavigateToTab;

  const HomeScreen({
    super.key,
    required this.userName,
    required this.transactions,
    required this.onAddTransaction,
    required this.onNavigateToTab,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  WalletType _selectedWallet = WalletType.palPay;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _handleTransfer() {
    if (_formKey.currentState!.validate()) {
      final String name = _nameController.text.trim();
      final String target = _phoneController.text.trim();
      final double amount = double.parse(_amountController.text.trim());

      // الانتقال لشاشة التأكيد وتمرير كولباك الإضافة
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConfirmationScreen(
            walletType: _selectedWallet,
            target: target,
            amount: amount,
            receiverName: name.isNotEmpty ? name : target,
            onTransactionConfirmed: widget.onAddTransaction,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // تسجيل اعتماد الشاشة على الثيم لتحديث الألوان فوراً عند التغيير
    Theme.of(context);
    
    // عرض آخر 3 حوالات فقط في الشاشة الرئيسية
    final recentList = widget.transactions.take(3).toList();

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
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(24),
              ),
            ),
            title: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'مرحباً،',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white.withOpacity(0.8),
                      fontFamily: 'Cairo',
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.userName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ],
              ),
            ),
            centerTitle: false,
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
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                // 1. اختيار نوع المحفظة
                WalletSelector(
                  selectedWallet: _selectedWallet,
                  onWalletChanged: (wallet) {
                    setState(() {
                      _selectedWallet = wallet;
                    });
                  },
                ),
                const SizedBox(height: 16),



                // 3. كارت نموذج التحويل
                Container(
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // اسم المستلم (اختياري)
                      Text(
                        'اسم المستلم (اختياري)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          hintText: 'مثال: أحمد محمود',
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          prefixIcon: Icon(Icons.person_outline, color: AppColors.primary),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // رقم هاتف المستلم
                      Text(
                        'رقم هاتف المستلم',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
                        decoration: InputDecoration(
                          hintText: '059XXXXXXXX',
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          prefixIcon: Icon(Icons.phone_android, color: AppColors.primary),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.contact_phone_rounded, color: AppColors.primary),
                            tooltip: 'اختيار من جهات الاتصال',
                            onPressed: () async {
                              final ContactModel? contact = await Navigator.push<ContactModel>(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ManageContactsScreen(isSelectionMode: true),
                                ),
                              );
                              if (contact != null) {
                                setState(() {
                                  _phoneController.text = contact.phone;
                                  _nameController.text = contact.name;
                                  if (contact.walletType.toLowerCase().contains('jawwal')) {
                                    _selectedWallet = WalletType.jawwalPay;
                                  } else if (contact.walletType.toLowerCase().contains('pal')) {
                                    _selectedWallet = WalletType.palPay;
                                  }
                                });
                              }
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'يرجى إدخال رقم الهاتف';
                          }
                          if (value.length < 9) {
                            return 'يرجى إدخال رقم هاتف صحيح';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // حقل المبلغ
                      Text(
                        'المبلغ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _amountController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          hintText: '0.00',
                          prefixIcon: Icon(Icons.monetization_on_outlined, color: AppColors.primary),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              '₪',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'يرجى إدخال المبلغ';
                          }
                          final amount = double.tryParse(value);
                          if (amount == null || amount <= 0) {
                            return 'يرجى إدخال مبلغ صحيح أكبر من 0';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      // زر تحويل الآن
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _handleTransfer,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('تحويل الآن'),
                              SizedBox(width: 8),
                              Icon(Icons.send_rounded, size: 18),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // 7. دليل التحويل السريع
                _buildQuickGuide(),
                const SizedBox(height: 28),

                // 8. النشاط الأخير (ديناميكي)
                if (recentList.isNotEmpty) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'النشاط الأخير',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      TextButton(
                        onPressed: () => widget.onNavigateToTab(1), // الانتقال لتبويب السجل
                        child: Text(
                          'عرض الكل',
                          style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: recentList.length,
                    itemBuilder: (context, index) {
                      return TransactionCard(transaction: recentList[index]);
                    },
                  ),
                ],
                const SizedBox(height: 140), // مساحة إضافية مريحة لتسهيل التمرير فوق الشريط العائم (للشاشات الصغيرة)
              ],
            ),
          ),
        ),
      ),
    ),
  );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.dividerColor),
      ),
      child: Column(
        children: [
          Icon(
            Icons.swap_horizontal_circle_outlined,
            color: AppColors.isDark ? Colors.grey.shade700 : Colors.grey.shade300,
            size: 48,
          ),
          const SizedBox(height: 12),
          Text(
            'لا توجد عمليات تحويل أخيرة',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'الحوالات التي تقوم بها ستظهر هنا تلقائياً.',
            style: TextStyle(
              color: AppColors.textLight,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickGuide() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: AppColors.isDark ? Colors.blue.shade300 : Colors.blue.shade700, size: 20),
              const SizedBox(width: 8),
              Text(
                'دليل التحويل السريع',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: AppColors.isDark ? Colors.blue.shade100 : Colors.blue.shade900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildGuideStep('1', 'تأكد من رقم المستلم وتطابقه مع مزود الخدمة.'),
          const SizedBox(height: 8),
          _buildGuideStep('2', 'أدخل المبلغ المراد تحويله بالشيكل (ILS).'),
          const SizedBox(height: 8),
          _buildGuideStep('3', 'اضغط تحويل وسيتم فتح شاشة الاتصال بالكود تلقائياً.'),
        ],
      ),
    );
  }

  Widget _buildGuideStep(String stepNumber, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 22,
          height: 22,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            shape: BoxShape.circle,
          ),
          child: Text(
            stepNumber,
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
