import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gaza_transfer/services/storage_service.dart';
import 'package:gaza_transfer/main.dart';

void main() {
  testWidgets('GazaTransfer App smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await StorageService.init();

    // Build our app and trigger a frame.
    await tester.pumpWidget(const GazaTransferApp());

    // Verify that the title "إنشاء رمز دخول جديد" is present.
    expect(find.text('إنشاء رمز دخول جديد'), findsOneWidget);
  });
}
