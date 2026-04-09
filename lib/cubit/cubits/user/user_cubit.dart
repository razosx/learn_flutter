import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/bloc/repositories/user_repository.dart';
import 'package:store/cubit/cubits/user/user_state.dart';

/// Cubit responsable de cargar la lista de usuarios aleatorios.
///
/// A diferencia del [UserBloc], no define eventos: expone el método público
/// [fetchUsers] que los widgets llaman directamente.
/// Recibe un [UserRepository] por inyección para facilitar el testing.
class UserCubit extends Cubit<UserCubitState> {
  final UserRepository repository;

  UserCubit({required this.repository}) : super(const UserCubitInitial());

  /// Obtiene 10 usuarios aleatorios desde el repositorio.
  /// Emite [UserCubitLoading] mientras espera, luego [UserCubitLoaded] con la
  /// lista o [UserCubitError] si la llamada falla.
  Future<void> fetchUsers() async {
    emit(const UserCubitLoading());
    try {
      final users = await repository.fetchUsers(10);
      emit(UserCubitLoaded(users));
    } catch (e) {
      emit(UserCubitError(e.toString()));
    }
  }
}
