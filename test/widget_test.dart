import 'package:flutter_test/flutter_test.dart';
import 'package:workout_timer/main.dart';

void main() {
  testWidgets(
    'Workout timer initial state renders default 2m work and 15s rest',
    (WidgetTester tester) async {
      await tester.pumpWidget(const WorkoutTimerApp());
      await tester.pump();

      // Verify main timer display starts at 02:00
      expect(find.text('02:00'), findsWidgets);

      // Verify Exercise and Rest labels
      expect(find.text('EXERCISE'), findsOneWidget);
      expect(find.text('REST'), findsOneWidget);

      // Verify default rest duration is 00:15
      expect(find.text('00:15'), findsOneWidget);

      // Verify Start Workout button is present
      expect(find.text('START WORKOUT'), findsOneWidget);
    },
  );
}
