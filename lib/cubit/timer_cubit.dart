import 'package:bloc/bloc.dart';

part 'timer_state.dart';

class TimerCubit extends Cubit<TimerState> {
  TimerCubit() : super(TimerState(timerValue: 0, rateValue: 0));

  void increment() {
    emit(TimerState(
      timerValue: state.timerValue + 1,
      rateValue: state.rateValue,
    ));
  }

  void decrement() {
    emit(TimerState(
      timerValue: state.timerValue - 1,
      rateValue: state.rateValue,
    ));
  }

  void incremRate() {
    emit(TimerState(
      rateValue: state.rateValue! + 1,
      timerValue: state.timerValue,
    ));
  }

  void decremRate() {
    emit(TimerState(
      rateValue: state.rateValue! - 1,
      timerValue: state.timerValue,
    ));
  }
}
