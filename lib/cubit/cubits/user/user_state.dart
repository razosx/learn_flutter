import 'package:equatable/equatable.dart';
import 'package:store/models/random_user.dart';

/// Estado base del [UserCubit]. Todos los estados concretos extienden de aquí.
/// Usa [Equatable] para que BlocBuilder detecte cambios correctamente.
abstract class UserCubitState extends Equatable {
  const UserCubitState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial antes de que se haya solicitado cualquier dato.
class UserCubitInitial extends UserCubitState {
  const UserCubitInitial();
}

/// Estado emitido mientras se espera la respuesta de la API.
class UserCubitLoading extends UserCubitState {
  const UserCubitLoading();
}

/// Estado emitido cuando la API retornó la lista de usuarios correctamente.
class UserCubitLoaded extends UserCubitState {
  final List<RandomUser> users;

  const UserCubitLoaded(this.users);

  @override
  List<Object?> get props => [users];
}

/// Estado emitido cuando la llamada a la API falló.
class UserCubitError extends UserCubitState {
  final String message;

  const UserCubitError(this.message);

  @override
  List<Object?> get props => [message];
}
