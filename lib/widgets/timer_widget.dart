import 'dart:async';

class GameTimer {
  late Timer _timer;
  final StreamController<int> _timerController = StreamController<int>();
  int _secondsElapsed = 0;
  bool _isRunning = false;

  Stream<int> get timerStream => _timerController.stream;

  void startTimer() {
    if (!_isRunning) {
      _isRunning = true;
      _timer = Timer.periodic(Duration(seconds: 1), _onTimerTick);
    }
  }

  void _onTimerTick(Timer timer) {
    _secondsElapsed++;
    _timerController.add(_secondsElapsed);
  }

  void stopTimer() {
    if (_isRunning) {
      _isRunning = false;
      _timer.cancel();
    }
  }

  void resetTimer() {
    _secondsElapsed = 0;
    _timerController.add(_secondsElapsed);
  }

  void dispose() {
    _timer.cancel();
    _timerController.close();
  }
}
