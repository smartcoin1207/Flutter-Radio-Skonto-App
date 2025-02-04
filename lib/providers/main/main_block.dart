import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

abstract class MainEvent {}

class CheckErrorStatusEvent extends MainEvent {
  CheckErrorStatusEvent();
}

class MainState {
  final bool errorConnect;

  MainState({this.errorConnect = false});
}

class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc() : super(MainState()) {
    on<CheckErrorStatusEvent>(_checkErrorStatus);
  }

  _checkErrorStatus(
      CheckErrorStatusEvent event, Emitter<MainState> emit) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if ((connectivityResult == ConnectivityResult.none) != state.errorConnect) {
      final errorConnect = connectivityResult == ConnectivityResult.none;
      emit(MainState(errorConnect: errorConnect));
    }
  }

  void startCheckConnection() {
    const Duration interval = Duration(seconds: 2);
    Timer.periodic(interval, (Timer timer) {
      add(CheckErrorStatusEvent());
    });
  }
}
