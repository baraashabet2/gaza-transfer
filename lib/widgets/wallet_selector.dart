import 'package:flutter/material.dart';
import '../enums/wallet_type.dart';
import '../theme/app_theme.dart';

class WalletSelector extends StatelessWidget {
  final WalletType selectedWallet;
  final ValueChanged<WalletType> onWalletChanged;

  const WalletSelector({
    super.key,
    required this.selectedWallet,
    required this.onWalletChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 240),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: AppColors.dividerColor),
        ),
        padding: const EdgeInsets.all(4),
        child: Row(
          children: [
            // زر بال بي
            Expanded(
              child: _buildTabButton(
                context: context,
                type: WalletType.palPay,
                label: 'PalPay',
                isSelected: selectedWallet == WalletType.palPay,
              ),
            ),
            const SizedBox(width: 4),
            // زر جوال باي
            Expanded(
              child: _buildTabButton(
                context: context,
                type: WalletType.jawwalPay,
                label: 'Jawwal Pay',
                isSelected: selectedWallet == WalletType.jawwalPay,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton({
    required BuildContext context,
    required WalletType type,
    required String label,
    required bool isSelected,
  }) {
    final isDark = AppColors.isDark;

    // نفس منطق ألوان كبسولة الـ Bottom Bar
    final Color capsuleColor = isSelected
        ? (isDark ? AppColors.primary.withOpacity(0.3) : AppColors.primary.withOpacity(0.12))
        : Colors.transparent;

    final Color textColor = isSelected
        ? (isDark ? Colors.white : AppColors.primary)
        : (isDark ? Colors.white.withOpacity(0.55) : AppColors.primary.withOpacity(0.55));

    return GestureDetector(
      onTap: () => onWalletChanged(type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: capsuleColor,
          borderRadius: BorderRadius.circular(26),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: textColor,
            fontFamily: 'Cairo',
          ),
        ),
      ),
    );
  }
}
