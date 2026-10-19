import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aravind/main.dart';
import 'package:aravind/services/system_state.dart';
import 'package:provider/provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('Aravind smoke test', (WidgetTester tester) async {
    final systemState = SystemState();
    await systemState.initialize();

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: systemState,
        child: const AravindApp(),
      ),
    );

    // Initial render
    await tester.pumpAndSettle();

    // Verify key brand and navigation elements
    expect(find.text('aravind'), findsWidgets);
    expect(find.text('ASCENSION PROFILE'), findsOneWidget);
    expect(find.text('Ready to Begin'), findsOneWidget);
  });
}
