import 'package:wakelock_plus/wakelock_plus.dart';

abstract class WakelockService {
  Future<void> enable();
  Future<void> disable();
}

class DefaultWakelockService implements WakelockService {
  @override
  Future<void> enable() async {
    try {
      await WakelockPlus.enable();
    } catch (_) {
      // Ignored if platform channels are unavailable
    }
  }

  @override
  Future<void> disable() async {
    try {
      await WakelockPlus.disable();
    } catch (_) {
      // Ignored if platform channels are unavailable
    }
  }
}

class NoopWakelockService implements WakelockService {
  @override
  Future<void> enable() async {}

  @override
  Future<void> disable() async {}
}
