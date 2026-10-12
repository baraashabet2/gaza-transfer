import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../theme/app_theme.dart';
import '../widgets/transaction_card.dart';

class HistoryScreen extends StatefulWidget {
  final List<TransactionModel> transactions;
  final VoidCallback onBackToHome;

  const HistoryScreen({
    super.key,
    required this.transactions,
    required this.onBackToHome,
  });

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _searchQuery = '';
  bool _sortByNewest = true; // فرز افتراضي: الأحدث أولاً

  List<TransactionModel> get _filteredTransactions {
    final list = widget.transactions.where((tx) {
      final query = _searchQuery.trim();
      if (query.isEmpty) return true;
      return tx.title.contains(query) ||
          tx.subtitle.contains(query) ||
          tx.amount.toString().contains(query);
    }).toList();

    // الفرز حسب التاريخ (أحدث/أقدم)
    list.sort((a, b) {
      if (_sortByNewest) {
        return b.date.compareTo(a.date); // الأحدث أولاً
      } else {
        return a.date.compareTo(b.date); // الأقدم أولاً
      }
    });

    return list;
  }

  @override
  Widget build(BuildContext context) {
    // تسجيل اعتماد الشاشة على الثيم لتحديث الألوان فوراً عند التغيير
    Theme.of(context);

    final filtered = _filteredTransactions;

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
              'سجل العمليات',
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
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // 2. شريط البحث مع أيقونة الفرز المنبثقة الأنيقة على اليسار
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'بحث برقم الجوال أو المبلغ...',
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
                        fillColor: AppColors.cardBackground,
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.dividerColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.dividerColor),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // زر الفرز المنبثق
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.dividerColor),
                    ),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        cardColor: AppColors.cardBackground, // توافق لون القائمة مع المظهر الداكن/الفاتح
                      ),
                      child: PopupMenuButton<bool>(
                        initialValue: _sortByNewest,
                        tooltip: 'فرز العمليات',
                        onSelected: (value) {
                          setState(() {
                            _sortByNewest = value;
                          });
                        },
                        icon: Icon(Icons.filter_list_rounded, color: AppColors.primary, size: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: AppColors.dividerColor),
                        ),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: true,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.history_rounded,
                                  color: _sortByNewest ? AppColors.primary : AppColors.textSecondary,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'الأحدث (الجديد)',
                                  style: TextStyle(
                                    fontWeight: _sortByNewest ? FontWeight.bold : FontWeight.normal,
                                    color: _sortByNewest ? AppColors.primary : AppColors.textPrimary,
                                    fontSize: 13,
                                    fontFamily: 'Cairo',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: false,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.schedule_rounded,
                                  color: !_sortByNewest ? AppColors.primary : AppColors.textSecondary,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'الأقدم (القديم)',
                                  style: TextStyle(
                                    fontWeight: !_sortByNewest ? FontWeight.bold : FontWeight.normal,
                                    color: !_sortByNewest ? AppColors.primary : AppColors.textPrimary,
                                    fontSize: 13,
                                    fontFamily: 'Cairo',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // 4. قائمة المعاملات المقسمة ديناميكياً حسب اليوم والتاريخ
              Expanded(
                child: filtered.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.history_toggle_off, color: AppColors.isDark ? Colors.grey.shade700 : Colors.grey.shade300, size: 64),
                            const SizedBox(height: 12),
                            Text(
                              'لا توجد معاملات في السجل حالياً',
                              style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )
                    : ListView(
                        children: _buildTransactionList(filtered),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildTransactionList(List<TransactionModel> txList) {
    final List<Widget> list = [];
    String lastGroupDate = '';

    for (final tx in txList) {
      final String groupDate = _getGroupDateHeader(tx.date);
      if (groupDate != lastGroupDate) {
        lastGroupDate = groupDate;
        list.add(
          Padding(
            padding: const EdgeInsets.only(top: 20.0, bottom: 8.0),
            child: Text(
              groupDate,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary,
                fontSize: 14,
                fontFamily: 'Cairo',
              ),
            ),
          ),
        );
      }
      list.add(TransactionCard(transaction: tx));
    }

    list.add(const SizedBox(height: 140)); // مساحة إضافية مريحة للتمرير فوق الشريط العائم (للشاشات الصغيرة)
    return list;
  }

  String _getGroupDateHeader(DateTime date) {
    if (_isToday(date)) return 'اليوم';
    if (_isYesterday(date)) return 'الأمس';
    // تنسيق التاريخ الفعلي للعمليات القديمة
    return '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  bool _isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year && date.month == yesterday.month && date.day == yesterday.day;
  }
}
