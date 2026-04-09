# Plan: Implementar Cubit equivalente al flujo Riverpod y BLoC

## Context

El proyecto ya tiene dos implementaciones funcionales de la misma UI: Riverpod y BLoC. El objetivo es agregar una tercera con **Cubit**, que es una simplificación de BLoC: elimina los Events y expone métodos públicos directos en lugar de handlers. Esto permite comparar los tres patrones lado a lado.

El botón "Cubit" se agrega en `main.dart` apuntando a `CubitStorePage`, siguiendo exactamente el mismo patrón que `BlocStorePage`.

**Diferencia clave Cubit vs BLoC:**
- BLoC: `bloc.add(FetchUsersEvent())` → handler `_onFetchUsers(event, emit)`
- Cubit: `cubit.fetchUsers()` → método que llama `emit()` directamente

---

## Archivos que NO se tocan

- `lib/models/random_user.dart`
- `lib/networking/dio_util.dart`
- `lib/riverpod/` — toda la carpeta
- `lib/bloc/` — toda la carpeta
- `lib/riverpod/utils/enums.dart` — `LikeState` se reutiliza desde Cubit

---

## Archivos que SÍ se modifican

- `lib/main.dart` — agregar tercer botón y `CubitStorePage`
- `pubspec.yaml` — sin cambios (flutter_bloc ya incluye Cubit)
- `README.md` — actualizar stack, arquitectura y comparativa
- `docs/bloc_architecture.md` — NO se modifica (es específico de BLoC)

---

## Paso 1 — UserCubit

### `lib/cubit/cubits/user/user_state.dart`
Estados idénticos a los de BLoC pero en su propio namespace para que sea auto-contenido:
- `UserCubitState` (abstract, Equatable)
- `UserCubitInitial`
- `UserCubitLoading`
- `UserCubitLoaded(List<RandomUser> users)`
- `UserCubitError(String message)`

> Nota: Se crean estados propios (en lugar de reutilizar los del BLoC) para que cada implementación sea didácticamente independiente.

### `lib/cubit/cubits/user/user_cubit.dart`
```dart
class UserCubit extends Cubit<UserCubitState> {
  final UserRepository repository; // reutiliza el mismo de BLoC

  UserCubit({required this.repository}) : super(const UserCubitInitial());

  // Método público que reemplaza al FetchUsersEvent + _onFetchUsers
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
```

---

## Paso 2 — LikedUsersCubit

### `lib/cubit/cubits/liked_users/liked_users_state.dart`
Idéntico a `LikedUsersState` del BLoC (mismos campos, `copyWith`, `likeStateForIndex`, `isLiked`), pero llamado `LikedUsersCubitState`.

### `lib/cubit/cubits/liked_users/liked_users_cubit.dart`
```dart
class LikedUsersCubit extends Cubit<LikedUsersCubitState> {
  LikedUsersCubit() : super(const LikedUsersCubitState());

  // Reemplaza AddLikedUserEvent
  void addLikedUser(RandomUser user, int index) { ... }

  // Reemplaza RemoveLikedUserEvent
  void removeLikedUser(RandomUser user, int index) { ... }

  // Reemplaza ResetAnimationEvent
  void resetAnimation() {
    emit(state.copyWith(animateP1: false, animateMinus: false));
  }
}
```

---

## Paso 3 — Repository

Reutilizar `lib/bloc/repositories/user_repository.dart` directamente.
No se crea un nuevo repositorio. El import apunta a `package:store/bloc/repositories/user_repository.dart`.

---

## Paso 4 — Screens y Widgets

### `lib/cubit/screens/friends_list_screen.dart`
`FriendsListCubitScreen` — mismo patrón que `FriendsListBlocScreen`. Scaffold con AppBar + `LikedUsersWidgetCubit` + `FriendsListWidgetCubit`.

### `lib/cubit/screens/liked_users_screen.dart`
`LikedUsersCubitScreen` — `BlocBuilder<LikedUsersCubit, LikedUsersCubitState>` con ListView o estado vacío.

### `lib/cubit/screens/widgets/friends_list_widget.dart`
`FriendsListWidgetCubit` — `BlocBuilder<UserCubit, UserCubitState>` con GridView de 2 columnas.

### `lib/cubit/screens/widgets/random_user_card_widget.dart`
`RandomUserCardWidgetCubit` — `BlocBuilder<LikedUsersCubit, LikedUsersCubitState>` con `buildWhen` por índice.
Diferencia clave: llama `context.read<LikedUsersCubit>().addLikedUser(user, index)` en lugar de `.add(Event)`.

### `lib/cubit/screens/widgets/liked_users_widget.dart`
`LikedUsersWidgetCubit` — `BlocConsumer<LikedUsersCubit, LikedUsersCubitState>`.
`listener` dispara `cubit.resetAnimation()` tras 500ms (en lugar de `add(ResetAnimationEvent())`).

---

## Paso 5 — main.dart

Agregar tercer botón y reemplazar `BlocStorePage` como referencia para crear `CubitStorePage`:

```dart
class CubitStorePage extends StatelessWidget {
  const CubitStorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserCubit>(
          create: (_) => UserCubit(repository: const RandomUserRepository())
            ..fetchUsers(), // llama método, no add(Event)
        ),
        BlocProvider<LikedUsersCubit>(
          create: (_) => LikedUsersCubit(),
        ),
      ],
      child: const FriendsListCubitScreen(),
    );
  }
}
```

---

## Paso 6 — Tests

### `test/cubit/cubits/user_cubit_test.dart`
Mismo patrón que `user_bloc_test.dart` con `blocTest` (funciona igual para Cubits):
- Estado inicial: `UserCubitInitial`
- `fetchUsers()` éxito: `[UserCubitLoading, UserCubitLoaded(mockUsers)]`
- `fetchUsers()` error: `[UserCubitLoading, UserCubitError]`
- Igualdad de `UserCubitLoaded` con misma lista

### `test/cubit/cubits/liked_users_cubit_test.dart`
Mismo patrón que `liked_users_bloc_test.dart`:
- Estado inicial vacío
- `addLikedUser()`: usuario en lista, `likeStateForIndex == liked`, `animateP1 == true`
- `addLikedUser()` duplicado: no-op
- `removeLikedUser()` (usuario liked): fuera de lista, `disliked`, `animateMinus == true`
- `removeLikedUser()` (no liked): no-op, `expect: () => []`
- `resetAnimation()`: ambos flags a false
- Independencia de índices

---

## Paso 7 — Documentación

### `docs/cubit_architecture.md`
7 diagramas Mermaid con el mismo formato que `docs/bloc_architecture.md`:
1. Visión general de capas (Cubit)
2. Ciclo de vida de UserCubit (secuencia sin eventos)
3. Estados de UserCubit (máquina de estados)
4. Ciclo de vida de LikedUsersCubit
5. Estructura de LikedUsersCubitState (class diagram)
6. Árbol de widgets Cubit
7. Métodos y sus efectos sobre el estado (equivalente al diagrama de eventos BLoC)

### `README.md`
- Agregar `cubit` al stack
- Ampliar la tabla de comparativa con columna Cubit
- Agregar flujo de datos Cubit
- Actualizar sección de tests

---

## Estructura final de archivos nuevos

```
lib/cubit/
├── cubits/
│   ├── user/
│   │   ├── user_state.dart           # UserCubitInitial/Loading/Loaded/Error
│   │   └── user_cubit.dart           # fetchUsers()
│   └── liked_users/
│       ├── liked_users_state.dart    # LikedUsersCubitState con copyWith
│       └── liked_users_cubit.dart    # addLikedUser / removeLikedUser / resetAnimation
└── screens/
    ├── friends_list_screen.dart
    ├── liked_users_screen.dart
    └── widgets/
        ├── friends_list_widget.dart
        ├── liked_users_widget.dart
        └── random_user_card_widget.dart

test/cubit/cubits/
├── user_cubit_test.dart
└── liked_users_cubit_test.dart

docs/
└── cubit_architecture.md
```

---

## Orden de implementación

1. `lib/cubit/cubits/user/user_state.dart`
2. `lib/cubit/cubits/user/user_cubit.dart`
3. `lib/cubit/cubits/liked_users/liked_users_state.dart`
4. `lib/cubit/cubits/liked_users/liked_users_cubit.dart`
5. `lib/cubit/screens/liked_users_screen.dart`
6. `lib/cubit/screens/widgets/random_user_card_widget.dart`
7. `lib/cubit/screens/widgets/liked_users_widget.dart`
8. `lib/cubit/screens/widgets/friends_list_widget.dart`
9. `lib/cubit/screens/friends_list_screen.dart`
10. `lib/main.dart` — agregar botón Cubit y `CubitStorePage`
11. `test/cubit/cubits/user_cubit_test.dart`
12. `test/cubit/cubits/liked_users_cubit_test.dart`
13. `docs/cubit_architecture.md`
14. `README.md`

---

## Verificación

```bash
flutter analyze          # sin errores nuevos
flutter test             # todos los tests pasan (Riverpod + BLoC + Cubit)
flutter run              # botón "Cubit" muestra la misma UI que "Riverpod" y "BLoC"
```
