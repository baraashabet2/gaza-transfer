enum WalletType {
  jawwalPay,
  palPay,
}

extension WalletTypeExtension on WalletType {
  String get displayName {
    switch (this) {
      case WalletType.jawwalPay:
        return 'Jawwal Pay';
      case WalletType.palPay:
        return 'PalPay';
    }
  }

  String get baseUssdCode {
    switch (this) {
      case WalletType.jawwalPay:
        return '*110#';
      case WalletType.palPay:
        return '*370#';
    }
  }
}
