import 'dart:async';

/// Simple Ticker class for animation frame callbacks (like AnimationController/Ticker in Flutter)
class Ticker {
  final void Function(Duration) onTick;
  Timer? _timer;
  DateTime? _start;
  bool _running = false;

  Ticker(this.onTick);

  void start() {
    if (_running) return;
    _running = true;
    _start = DateTime.now();
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      final elapsed = DateTime.now().difference(_start!);
      onTick(elapsed);
    });
  }

  void dispose() {
    _timer?.cancel();
    _running = false;
  }
}