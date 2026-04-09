# Arquitectura Cubit — Store App

Diagramas de la implementación Cubit del proyecto. Cada diagrama cubre un nivel de abstracción distinto.

> **Cubit vs BLoC:** Cubit es una simplificación de BLoC. Elimina los eventos (clases `Event`) y expone métodos públicos que llaman `emit()` directamente. La API de widgets (`BlocBuilder`, `BlocConsumer`, `BlocProvider`) es idéntica porque `Cubit` extiende `BlocBase`.

---

## 1. Visión general de capas

```mermaid
graph TD
    subgraph UI["Capa UI (Widgets)"]
        HOME[MyHomePage]
        CSP[CubitStorePage]
        FLS[FriendsListCubitScreen]
        FLW[FriendsListWidgetCubit]
        RUCW[RandomUserCardWidgetCubit]
        LUW[LikedUsersWidgetCubit]
        LUS[LikedUsersCubitScreen]
    end

    subgraph STATE["Capa Estado (Cubits)"]
        UC[UserCubit]
        LUC[LikedUsersCubit]
    end

    subgraph DATA["Capa Datos (compartida con BLoC)"]
        UR[UserRepository\n«abstract»]
        RUR[RandomUserRepository]
        DIO[dio_util\nfetchRandomUsers]
        API[RandomUser API\nhttps://randomuser.me]
    end

    subgraph SHARED["Compartido con Riverpod y BLoC"]
        MODEL[RandomUser\nmodel]
        ENUM[LikeState\nenum]
    end

    HOME --> CSP
    CSP -->|MultiBlocProvider| FLS
    FLS --> FLW
    FLS --> LUW
    FLW --> RUCW
    LUW -->|BlocProvider.value| LUS

    FLW -->|BlocBuilder| UC
    RUCW -->|"BlocBuilder\nbuildWhen: índice propio"| LUC
    LUW -->|BlocConsumer| LUC

    UC --> UR
    UR <-- RUR
    RUR --> DIO
    DIO --> API

    UC --> MODEL
    LUC --> MODEL
    LUC --> ENUM
```

---

## 2. Ciclo de vida de UserCubit

```mermaid
sequenceDiagram
    participant App as CubitStorePage
    participant UC as UserCubit
    participant Repo as RandomUserRepository
    participant API as RandomUser API
    participant UI as FriendsListWidgetCubit

    App->>UC: create + fetchUsers()
    Note over App,UC: Sin eventos — método directo
    UC->>UI: emit UserCubitLoading
    UC->>Repo: fetchUsers(10)
    Repo->>API: GET /?results=10
    API-->>Repo: JSON [{...}, ...]
    Repo-->>UC: List<RandomUser>
    UC->>UI: emit UserCubitLoaded(users)

    Note over UC,UI: Si la llamada falla:
    API--xRepo: Exception
    Repo--xUC: Exception
    UC->>UI: emit UserCubitError(message)
```

---

## 3. Estados de UserCubit

```mermaid
stateDiagram-v2
    [*] --> UserCubitInitial
    UserCubitInitial --> UserCubitLoading : fetchUsers()
    UserCubitLoading --> UserCubitLoaded : fetchUsers() OK
    UserCubitLoading --> UserCubitError : fetchUsers() lanza Exception
    UserCubitError --> UserCubitLoading : fetchUsers() (reintento)
    UserCubitLoaded --> UserCubitLoading : fetchUsers() (refresh)
```

---

## 4. Ciclo de vida de LikedUsersCubit

```mermaid
sequenceDiagram
    participant Card as RandomUserCardWidgetCubit
    participant LUC as LikedUsersCubit
    participant Widget as LikedUsersWidgetCubit
    participant Timer as Future.delayed(500ms)

    Card->>LUC: addLikedUser(user, index)
    Note over Card,LUC: Sin evento — método directo
    LUC->>LUC: isLiked(uuid)? → no
    LUC->>Widget: emit LikedUsersCubitState\n(likedUsers+user, likeStates[index]=liked, animateP1=true)
    Widget->>Timer: arrancar timer 500ms
    Timer-->>LUC: resetAnimation()
    LUC->>Widget: emit LikedUsersCubitState\n(animateP1=false)

    Card->>LUC: removeLikedUser(user, index)
    LUC->>LUC: isLiked(uuid)? → sí
    LUC->>Widget: emit LikedUsersCubitState\n(likedUsers-user, likeStates[index]=disliked, animateMinus=true)
    Widget->>Timer: arrancar timer 500ms
    Timer-->>LUC: resetAnimation()
    LUC->>Widget: emit LikedUsersCubitState\n(animateMinus=false)
```

---

## 5. Estructura de LikedUsersCubitState

```mermaid
classDiagram
    class LikedUsersCubit {
        +LikedUsersCubitState state
        +addLikedUser(RandomUser user, int index) void
        +removeLikedUser(RandomUser user, int index) void
        +resetAnimation() void
    }

    class LikedUsersCubitState {
        +List~RandomUser~ likedUsers
        +Map~int LikeState~ likeStates
        +bool animateP1
        +bool animateMinus
        +likeStateForIndex(int index) LikeState
        +isLiked(String uuid) bool
        +copyWith(...) LikedUsersCubitState
        +props List
    }

    class LikeState {
        <<enumeration>>
        neutral
        liked
        disliked
    }

    class RandomUser {
        +String gender
        +Name name
        +Login login
        +Location location
        +String email
        +Picture picture
    }

    class Login {
        +String uuid
        +String username
    }

    LikedUsersCubit --> LikedUsersCubitState : emit
    LikedUsersCubitState --> LikeState : likeStates values
    LikedUsersCubitState --> RandomUser : likedUsers items
    RandomUser --> Login : login.uuid (clave de deduplicación)
```

---

## 6. Árbol de widgets Cubit

```mermaid
graph TD
    CSP["CubitStorePage\nMultiBlocProvider"]
    CSP -->|"BlocProvider&lt;UserCubit&gt;\n..fetchUsers()"| UC_NODE["UserCubit"]
    CSP -->|"BlocProvider&lt;LikedUsersCubit&gt;"| LUC_NODE["LikedUsersCubit"]
    CSP --> FLS2["FriendsListCubitScreen\nScaffold"]

    FLS2 -->|AppBar actions| LUW2["LikedUsersWidgetCubit\nBlocConsumer&lt;LikedUsersCubit&gt;\n• listenWhen → timer 500ms\n• builder → Stack con animaciones"]
    FLS2 -->|body| FLW2["FriendsListWidgetCubit\nBlocBuilder&lt;UserCubit&gt;\n• loading → CircularProgressIndicator\n• error → Text\n• loaded → GridView"]

    FLW2 --> RUCW2["RandomUserCardWidgetCubit ×N\nBlocBuilder&lt;LikedUsersCubit&gt;\nbuildWhen: índice propio\n• llama cubit.addLikedUser()\n• llama cubit.removeLikedUser()"]

    LUW2 -->|"Navigator.push\nBlocProvider.value"| LUS2["LikedUsersCubitScreen\nBlocBuilder&lt;LikedUsersCubit&gt;\n• ListView o empty state"]

    UC_NODE -.->|watch| FLW2
    LUC_NODE -.->|watch| RUCW2
    LUC_NODE -.->|listen + watch| LUW2
    LUC_NODE -.->|watch| LUS2
```

---

## 7. Métodos y sus efectos sobre el estado

```mermaid
flowchart LR
    subgraph Métodos["Métodos públicos del Cubit"]
        M1["fetchUsers()"]
        M2["addLikedUser\n(user, index)"]
        M3["removeLikedUser\n(user, index)"]
        M4["resetAnimation()"]
    end

    subgraph Guards["Guardas"]
        G1{uuid ya liked?}
        G2{uuid estaba liked?}
    end

    subgraph Efectos["Cambios en estado"]
        S1["UserCubitLoading →\nUserCubitLoaded / UserCubitError"]
        S2["likedUsers ← +user\nlikeStates[index] ← liked\nanimateP1 ← true"]
        S3["likedUsers ← -user\nlikeStates[index] ← disliked\nanimateMinus ← true"]
        S4["animateP1 ← false\nanimateMinus ← false"]
        NOOP[no-op / return]
    end

    M1 --> S1
    M2 --> G1
    G1 -->|sí| NOOP
    G1 -->|no| S2
    M3 --> G2
    G2 -->|no| NOOP
    G2 -->|sí| S3
    M4 --> S4
```

---

## Comparativa BLoC vs Cubit en este proyecto

| Aspecto | BLoC | Cubit |
|---|---|---|
| Disparar acción | `bloc.add(FetchUsersEvent())` | `cubit.fetchUsers()` |
| Agregar like | `bloc.add(AddLikedUserEvent(...))` | `cubit.addLikedUser(user, index)` |
| Reset animación | `bloc.add(ResetAnimationEvent())` | `cubit.resetAnimation()` |
| Archivos por feature | 3 (event + state + bloc) | 2 (state + cubit) |
| Boilerplate | Mayor (clases Event) | Menor (métodos directos) |
| Trazabilidad | Alta (eventos logeables) | Media (métodos directos) |
| API de widgets | Idéntica | Idéntica |
