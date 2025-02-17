part of 'menu_utama_bloc.dart';

sealed class MenuUtamaState extends Equatable {
  const MenuUtamaState();
  
  @override
  List<Object> get props => [];
}

final class MenuUtamaInitial extends MenuUtamaState {}
