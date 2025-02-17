import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'menu_utama_event.dart';
part 'menu_utama_state.dart';

class MenuUtamaBloc extends Bloc<MenuUtamaEvent, MenuUtamaState> {
  MenuUtamaBloc() : super(MenuUtamaInitial()) {
    on<MenuUtamaEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
