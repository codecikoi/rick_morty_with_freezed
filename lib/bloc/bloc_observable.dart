import 'package:flutter_bloc/flutter_bloc.dart';

class CharacterBlocObservable extends BlocObserver {

  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc,   event);
    print('onEvent -- bloc: ${bloc.runtimeType}, event: $event');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    print('onEvent -- bloc: ${bloc.runtimeType}, event: $error');
  }
}