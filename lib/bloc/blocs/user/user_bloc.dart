import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/bloc/repositories/user_repository.dart';
import 'package:store/bloc/blocs/user/user_event.dart';
import 'package:store/bloc/blocs/user/user_state.dart';

/// BLoC responsable de cargar la lista de usuarios aleatorios.
/// Recibe un [UserRepository] por inyección para facilitar el testing.
class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository repository;

  UserBloc({required this.repository}) : super(const UserInitial()) {
    on<FetchUsersEvent>(_onFetchUsers);
  }

  /// Maneja [FetchUsersEvent]: emite [UserLoading] mientras espera la respuesta
  /// y luego [UserLoaded] con la lista, o [UserError] si la llamada falla.
  Future<void> _onFetchUsers(
    FetchUsersEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(const UserLoading());
    try {
      final users = await repository.fetchUsers(10);
      emit(UserLoaded(users));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
}
