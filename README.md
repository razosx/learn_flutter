# Store — Flutter Tutorial App

Aplicación Flutter de aprendizaje que implementa la **misma funcionalidad con dos patrones de estado distintos**: Riverpod y BLoC. Consume la API pública [RandomUser.me](https://randomuser.me) para mostrar, dar like y gestionar una lista de usuarios aleatorios.

> El objetivo es comparar ambos enfoques lado a lado en el mismo proyecto: el botón "Riverpod" y el botón "BLoC" en la Home muestran exactamente la misma UI con arquitecturas internas diferentes.

---

## Idea Principal

El proyecto simula una pantalla de "amigos" tipo Tinder donde el usuario puede:

- Ver una grilla de personas aleatorias con su avatar, nombre, email y país
- Dar **like** o **dislike** a cada persona
- Consultar la lista de usuarios a los que dio like
- Ver animaciones de feedback visual al interactuar

---

## Stack Tecnológico

| Capa | Tecnología |
|---|---|
| Framework | Flutter (Dart SDK `^3.11.1`) |
| Estado (A) | `flutter_riverpod` + `riverpod_annotation` |
| Estado (B) | `flutter_bloc ^9.1.0` + `equatable ^2.0.7` |
| HTTP Client | `dio` |
| Generación de código | `riverpod_generator` + `build_runner` |
| Testing | `flutter_test` + `bloc_test ^10.0.0` |
| Linting | `flutter_lints ^6.0.0` |
| API externa | [RandomUser.me](https://randomuser.me/api) |

---

## Arquitectura

```
lib/
├── main.dart                        # Entry point: ProviderScope + routing a Riverpod/BLoC
├── models/
│   └── random_user.dart             # Modelo de datos compartido (fromJson / toJson)
├── networking/
│   └── dio_util.dart                # Cliente HTTP (Dio) con timeouts, compartido
├── riverpod/                        # Implementación A — Riverpod
│   ├── providers/
│   │   ├── user_provider.dart       # FutureProvider: fetch de usuarios
│   │   ├── liked_users_provider.dart# StateNotifier: likes + animaciones
│   │   └── *.g.dart                 # [generados por riverpod_generator]
│   ├── screens/
│   │   ├── friends_list_screen.dart
│   │   ├── liked_users_screen.dart
│   │   └── widgets/
│   └── utils/
│       └── enums.dart               # LikeState enum (compartido con BLoC)
└── bloc/                            # Implementación B — BLoC
    ├── repositories/
    │   └── user_repository.dart     # Contrato + RandomUserRepository
    ├── blocs/
    │   ├── user/
    │   │   ├── user_event.dart      # FetchUsersEvent
    │   │   ├── user_state.dart      # Initial / Loading / Loaded / Error
    │   │   └── user_bloc.dart
    │   └── liked_users/
    │       ├── liked_users_event.dart  # Add / Remove / ResetAnimation
    │       ├── liked_users_state.dart  # likedUsers + likeStates + animaciones
    │       └── liked_users_bloc.dart
    └── screens/
        ├── friends_list_screen.dart
        ├── liked_users_screen.dart
        └── widgets/
```

---

## Comparativa de implementaciones

| Aspecto | Riverpod | BLoC |
|---|---|---|
| Unidad de estado | Múltiples providers independientes | Un `State` por BLoC |
| Like por índice | `randomUserStateProvider(index)` (family) | `Map<int, LikeState>` en `LikedUsersState` |
| Colección de likes | `likedUsersProvider` (`Set<RandomUser>`) | Campo `likedUsers` en `LikedUsersState` |
| Animaciones | `animateP1Provider` / `animateMinusProvider` | Campos `animateP1` / `animateMinus` en `LikedUsersState` |
| Reset animación | `Future.delayed` dentro del notifier | Widget dispara `ResetAnimationEvent` tras 500ms |
| Inyección de dependencias | `ref.read` / `ref.watch` | Constructor del BLoC (`UserBloc(repository: ...)`) |
| Testeo | `ProviderContainer` con overrides | `bloc_test` con `FakeRepository` |
| Código generado | Sí (`*.g.dart`) | No |

---

## Flujo de datos — Riverpod

```
RandomUser API
     │
     ▼
dio_util.dart (GET /?results=10)
     │
     ▼
randomUserListProvider (FutureProvider)
     │
     ├──▶ FriendsListScreen
     │         ├──▶ randomUserStateProvider(index) ─▶ LikeState por card
     │         └──▶ likedUsersProvider ─────────────▶ Set<RandomUser>
     │
     └──▶ LikedUsersScreen
               └──▶ likedUsersProvider
```

## Flujo de datos — BLoC

```
RandomUser API
     │
     ▼
RandomUserRepository.fetchUsers()
     │
     ▼
UserBloc (FetchUsersEvent → UserLoaded)
     │
     ├──▶ FriendsListBlocScreen
     │         └──▶ LikedUsersBloc
     │                  ├── AddLikedUserEvent    ─▶ likedUsers + likeStates + animateP1
     │                  ├── RemoveLikedUserEvent ─▶ likedUsers + likeStates + animateMinus
     │                  └── ResetAnimationEvent  ─▶ animateP1/animateMinus = false
     │
     └──▶ LikedUsersBlocScreen
               └──▶ LikedUsersBloc (estado compartido vía BlocProvider.value)
```

---

## Screens

### Home
Pantalla de bienvenida con dos botones: **Riverpod** y **BLoC**, cada uno navega a su implementación independiente.

### Friends List
- Grilla de 2 columnas con cards de usuario
- Carga asíncrona con estados `loading`, `error` y `data`
- Botones de like/dislike por card
- Contador de likes en el AppBar con animaciones "+1" / "−"

### Liked Users
- ListView de usuarios a los que se dio like
- Avatar, nombre y email
- Estado vacío cuando no hay likes

---

## Instalación y ejecución

```bash
# Instalar dependencias
flutter pub get

# Generar código de Riverpod
dart run build_runner build --delete-conflicting-outputs

# Ejecutar la app
flutter run
```

---

## Tests

```bash
# Todos los tests
flutter test

# Solo BLoC
flutter test test/bloc/

# Solo Riverpod
flutter test test/riverpod/
```

### Cobertura por implementación

**Riverpod** (`test/riverpod/providers/`)
- `user_provider_test.dart` — Estado de like por índice, override con datos mock
- `liked_users_provider_test.dart` — Agregar/eliminar usuarios, estados de animación

**BLoC** (`test/bloc/blocs/`)
- `user_bloc_test.dart` — Fetch exitoso, fetch con error, igualdad de estados
- `liked_users_bloc_test.dart` — Add/Remove/Reset, deduplicación por uuid, independencia de índices

---

## Modelo de datos

```dart
RandomUser                          // compartido por Riverpod y BLoC
├── Login (uuid, username)
├── Name (title, first, last)
├── Location (street, city, state, country, postcode)
└── Picture (large, medium, thumbnail)
```

Fuente: `GET https://randomuser.me/api/?results=10`
