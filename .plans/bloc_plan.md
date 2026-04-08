# Plan: Implementar BLoC equivalente al flujo Riverpod

## Context

El proyecto ya tiene una implementación funcional con Riverpod. El objetivo es replicar exactamente la misma funcionalidad en `lib/bloc/` usando el patrón BLoC con buenas prácticas, sin modificar nada del código Riverpod existente. El botón "Bloc" en `main.dart` apunta a un stub vacío (`BlocStorePage`) que se reemplazará.

---

## Archivos que NO se tocan
- `lib/models/random_user.dart`
- `lib/networking/dio_util.dart`
- `lib/riverpod/utils/enums.dart` — el `LikeState` enum se reutiliza tal cual desde BLoC

---

## Paso 1 — pubspec.yaml

Agregar a `dependencies`:
```yaml
flutter_bloc: ^9.1.0
equatable: ^2.0.7
```
Agregar a `dev_dependencies`:
```yaml
bloc_test: ^9.1.0
```

---

## Paso 2 — Repository

**`lib/bloc/repositories/user_repository.dart`**

```dart
abstract class UserRepository {
  Future<List<RandomUser>> fetchUsers(int count);
}

class RandomUserRepository implements UserRepository {
  const RandomUserRepository();
  @override
  Future<List<RandomUser>> fetchUsers(int count) => fetchRandomUsers(count);
}
```

---

## Paso 3 — UserBloc

### `lib/bloc/blocs/user/user_event.dart`
- `UserEvent extends Equatable` (abstract)
- `FetchUsersEvent extends UserEvent`

### `lib/bloc/blocs/user/user_state.dart`
- `UserState extends Equatable` (abstract)
- `UserInitial`, `UserLoading`, `UserLoaded(List<RandomUser> users)`, `UserError(String message)`

### `lib/bloc/blocs/user/user_bloc.dart`
- `UserBloc(UserRepository repository)`
- Handler `_onFetchUsers`: emite `UserLoading` → `UserLoaded` o `UserError`

---

## Paso 4 — LikedUsersBloc

Este BLoC unifica lo que en Riverpod son tres providers: `likedUsersProvider`, `randomUserStateProvider(index)` y los dos animation providers.

### `lib/bloc/blocs/liked_users/liked_users_event.dart`
- `LikedUsersEvent extends Equatable` (abstract)
- `AddLikedUserEvent({RandomUser user, int index})`
- `RemoveLikedUserEvent({RandomUser user, int index})`
- `ResetAnimationEvent()` — disparado por el widget tras 500ms para limpiar flags

### `lib/bloc/blocs/liked_users/liked_users_state.dart`
```dart
class LikedUsersState extends Equatable {
  final Set<RandomUser> likedUsers;       // colección global
  final Map<int, LikeState> likeStates;  // equivalente a randomUserStateProvider(index)
  final bool animateP1;                   // equivalente a animateP1Provider
  final bool animateMinus;               // equivalente a animateMinusProvider

  LikeState likeStateForIndex(int index) => likeStates[index] ?? LikeState.neutral;
  LikedUsersState copyWith({...});
}
```

**Nota:** `RandomUser` no implementa `==`/`hashCode`. La deduplicación en el BLoC se hace comparando por `login.uuid` explícitamente (sin necesidad de modificar el modelo).

### `lib/bloc/blocs/liked_users/liked_users_bloc.dart`
- `_onAddLikedUser`: guarda si ya existe por uuid, emite `animateP1: true`
- `_onRemoveLikedUser`: elimina por uuid, emite `animateMinus: true` solo si estaba liked
- `_onResetAnimation`: emite `animateP1: false, animateMinus: false`

**Diseño clave:** El BLoC no maneja timers. Los flags `animateP1`/`animateMinus` se fijan en `true` y el widget es responsable de disparar `ResetAnimationEvent` tras 500ms.

---

## Paso 5 — Screens y Widgets

### `lib/bloc/screens/friends_list_screen.dart`
`FriendsListBlocScreen extends StatelessWidget` — Scaffold con AppBar + `LikedUsersWidgetBloc` + `FriendsListWidgetBloc`. No provee BLoCs (se proveen en main.dart).

### `lib/bloc/screens/liked_users_screen.dart`
`LikedUsersBlocScreen extends StatelessWidget` — `BlocBuilder<LikedUsersBloc>` con ListView o texto vacío.

### `lib/bloc/screens/widgets/friends_list_widget.dart`
`FriendsListWidgetBloc extends StatelessWidget` — `BlocBuilder<UserBloc>` con GridView 2 columnas.

### `lib/bloc/screens/widgets/random_user_card_widget.dart`
`RandomUserCardWidgetBloc extends StatelessWidget` — `BlocBuilder<LikedUsersBloc>` con `buildWhen` que filtra solo cambios relevantes al índice propio. Despacha `AddLikedUserEvent` / `RemoveLikedUserEvent`.

### `lib/bloc/screens/widgets/liked_users_widget.dart`
`LikedUsersWidgetBloc extends StatefulWidget` — Usa `BlocListener` con `listenWhen` para arrancar el timer de 500ms y despachar `ResetAnimationEvent`. Usa `BlocBuilder` para los `AnimatedPositioned`/`AnimatedOpacity`.

---

## Paso 6 — main.dart

Reemplazar la clase `BlocStorePage` (stub actual) con:

```dart
class BlocStorePage extends StatelessWidget {
  const BlocStorePage({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserBloc>(
          create: (_) => UserBloc(repository: const RandomUserRepository())
            ..add(const FetchUsersEvent()),
        ),
        BlocProvider<LikedUsersBloc>(
          create: (_) => LikedUsersBloc(),
        ),
      ],
      child: const FriendsListBlocScreen(),
    );
  }
}
```

Agregar imports de `flutter_bloc`, los dos BLoCs, el repositorio y `FriendsListBlocScreen`.

---

## Paso 7 — Tests

### `test/bloc/blocs/user_bloc_test.dart`
- `FakeUserRepository` inyectable (retorna lista mock o lanza Exception)
- Estado inicial: `UserInitial`
- `FetchUsersEvent` éxito: `[UserLoading, UserLoaded(mockUsers)]`
- `FetchUsersEvent` error: `[UserLoading, UserError]`
- Equatable: dos `UserLoaded` con misma lista son iguales

### `test/bloc/blocs/liked_users_bloc_test.dart`
- Estado inicial: likedUsers vacío, likeStates vacío, animaciones false
- `AddLikedUserEvent`: usuario en set, `likeStateForIndex(0) == liked`, `animateP1 == true`
- `AddLikedUserEvent` duplicado: no-op
- `RemoveLikedUserEvent` (usuario liked): usuario fuera del set, `likeStateForIndex == disliked`, `animateMinus == true`
- `RemoveLikedUserEvent` (usuario no liked): `animateMinus == false`
- `ResetAnimationEvent`: resetea ambos flags a false
- Independencia de índices: índice 0 liked, índice 1 disliked, índice 2 neutral

---

## Estructura final de archivos

```
lib/bloc/
├── blocs/
│   ├── user/
│   │   ├── user_bloc.dart
│   │   ├── user_event.dart
│   │   └── user_state.dart
│   └── liked_users/
│       ├── liked_users_bloc.dart
│       ├── liked_users_event.dart
│       └── liked_users_state.dart
├── repositories/
│   └── user_repository.dart
└── screens/
    ├── friends_list_screen.dart
    ├── liked_users_screen.dart
    └── widgets/
        ├── friends_list_widget.dart
        ├── liked_users_widget.dart
        └── random_user_card_widget.dart

test/bloc/blocs/
├── user_bloc_test.dart
└── liked_users_bloc_test.dart
```

---

## Orden de implementación

1. `pubspec.yaml` → `flutter pub get`
2. `lib/bloc/repositories/user_repository.dart`
3. `lib/bloc/blocs/user/user_event.dart`
4. `lib/bloc/blocs/user/user_state.dart`
5. `lib/bloc/blocs/user/user_bloc.dart`
6. `lib/bloc/blocs/liked_users/liked_users_event.dart`
7. `lib/bloc/blocs/liked_users/liked_users_state.dart`
8. `lib/bloc/blocs/liked_users/liked_users_bloc.dart`
9. `lib/bloc/screens/liked_users_screen.dart`
10. `lib/bloc/screens/widgets/random_user_card_widget.dart`
11. `lib/bloc/screens/widgets/liked_users_widget.dart`
12. `lib/bloc/screens/widgets/friends_list_widget.dart`
13. `lib/bloc/screens/friends_list_screen.dart`
14. `lib/main.dart` — reemplazar `BlocStorePage`
15. `test/bloc/blocs/user_bloc_test.dart`
16. `test/bloc/blocs/liked_users_bloc_test.dart`

---

## Verificación

```bash
flutter pub get
flutter analyze          # sin errores
flutter test             # todos los tests pasan (Riverpod + BLoC)
flutter run              # botón "Bloc" muestra la misma UI que "Riverpod"
```
