# Arquitectura BLoC — Store App

Diagramas de la implementación BLoC del proyecto. Cada diagrama cubre un nivel de abstracción distinto.

---

## 1. Visión general de capas

```mermaid
graph TD
    subgraph UI["Capa UI (Widgets)"]
        HOME[MyHomePage]
        BSP[BlocStorePage]
        FLS[FriendsListBlocScreen]
        FLW[FriendsListWidgetBloc]
        RUCW[RandomUserCardWidgetBloc]
        LUW[LikedUsersWidgetBloc]
        LUS[LikedUsersBlocScreen]
    end

    subgraph STATE["Capa Estado (BLoCs)"]
        UB[UserBloc]
        LUB[LikedUsersBloc]
    end

    subgraph DATA["Capa Datos"]
        UR[UserRepository\n«abstract»]
        RUR[RandomUserRepository]
        DIO[dio_util\nfetchRandomUsers]
        API[RandomUser API\nhttps://randomuser.me]
    end

    subgraph SHARED["Compartido con Riverpod"]
        MODEL[RandomUser\nmodel]
        ENUM[LikeState\nenum]
    end

    HOME --> BSP
    BSP -->|MultiBlocProvider| FLS
    FLS --> FLW
    FLS --> LUW
    FLW --> RUCW
    LUW -->|BlocProvider.value| LUS

    FLW -->|BlocBuilder| UB
    RUCW -->|BlocBuilder\nbuildWhen: índice propio| LUB
    LUW -->|BlocConsumer| LUB

    UB --> UR
    UR <-- RUR
    RUR --> DIO
    DIO --> API

    UB --> MODEL
    LUB --> MODEL
    LUB --> ENUM
```

---

## 2. Ciclo de vida de UserBloc

```mermaid
sequenceDiagram
    participant App as BlocStorePage
    participant UB as UserBloc
    participant Repo as RandomUserRepository
    participant API as RandomUser API
    participant UI as FriendsListWidgetBloc

    App->>UB: create + add(FetchUsersEvent)
    UB->>UI: emit UserLoading
    UB->>Repo: fetchUsers(10)
    Repo->>API: GET /?results=10
    API-->>Repo: JSON [{...}, ...]
    Repo-->>UB: List<RandomUser>
    UB->>UI: emit UserLoaded(users)

    Note over UB,UI: Si la llamada falla:
    API--xRepo: Exception
    Repo--xUB: Exception
    UB->>UI: emit UserError(message)
```

---

## 3. Estados de UserBloc

```mermaid
stateDiagram-v2
    [*] --> UserInitial
    UserInitial --> UserLoading : FetchUsersEvent
    UserLoading --> UserLoaded : fetchUsers() OK
    UserLoading --> UserError : fetchUsers() lanza Exception
    UserError --> UserLoading : FetchUsersEvent (reintento)
    UserLoaded --> UserLoading : FetchUsersEvent (refresh)
```

---

## 4. Ciclo de vida de LikedUsersBloc

```mermaid
sequenceDiagram
    participant Card as RandomUserCardWidgetBloc
    participant LUB as LikedUsersBloc
    participant Widget as LikedUsersWidgetBloc
    participant Timer as Future.delayed(500ms)

    Card->>LUB: add(AddLikedUserEvent(user, index))
    LUB->>LUB: isLiked(uuid)? → no
    LUB->>Widget: emit LikedUsersState\n(likedUsers+user, likeStates[index]=liked, animateP1=true)
    Widget->>Timer: arrancar timer 500ms
    Timer-->>LUB: add(ResetAnimationEvent)
    LUB->>Widget: emit LikedUsersState\n(animateP1=false)

    Card->>LUB: add(RemoveLikedUserEvent(user, index))
    LUB->>LUB: isLiked(uuid)? → sí
    LUB->>Widget: emit LikedUsersState\n(likedUsers-user, likeStates[index]=disliked, animateMinus=true)
    Widget->>Timer: arrancar timer 500ms
    Timer-->>LUB: add(ResetAnimationEvent)
    LUB->>Widget: emit LikedUsersState\n(animateMinus=false)
```

---

## 5. Estructura de LikedUsersState

```mermaid
classDiagram
    class LikedUsersState {
        +List~RandomUser~ likedUsers
        +Map~int LikeState~ likeStates
        +bool animateP1
        +bool animateMinus
        +likeStateForIndex(int index) LikeState
        +isLiked(String uuid) bool
        +copyWith(...) LikedUsersState
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

    LikedUsersState --> LikeState : likeStates values
    LikedUsersState --> RandomUser : likedUsers items
    RandomUser --> Login : login.uuid (clave de deduplicación)
```

---

## 6. Árbol de widgets BLoC

```mermaid
graph TD
    BSP["BlocStorePage\nMultiBlocProvider"]
    BSP -->|"BlocProvider&lt;UserBloc&gt;\n..add(FetchUsersEvent)"| UB_NODE["UserBloc"]
    BSP -->|"BlocProvider&lt;LikedUsersBloc&gt;"| LUB_NODE["LikedUsersBloc"]
    BSP --> FLS2["FriendsListBlocScreen\nScaffold"]

    FLS2 -->|AppBar actions| LUW2["LikedUsersWidgetBloc\nBlocConsumer&lt;LikedUsersBloc&gt;\n• listenWhen → timer 500ms\n• builder → Stack con animaciones"]
    FLS2 -->|body| FLW2["FriendsListWidgetBloc\nBlocBuilder&lt;UserBloc&gt;\n• loading → CircularProgressIndicator\n• error → Text\n• loaded → GridView"]

    FLW2 --> RUCW2["RandomUserCardWidgetBloc ×N\nBlocBuilder&lt;LikedUsersBloc&gt;\nbuildWhen: índice propio\n• dispatcha Add/RemoveLikedUserEvent"]

    LUW2 -->|"Navigator.push\nBlocProvider.value"| LUS2["LikedUsersBlocScreen\nBlocBuilder&lt;LikedUsersBloc&gt;\n• ListView o empty state"]

    UB_NODE -.->|watch| FLW2
    LUB_NODE -.->|watch| RUCW2
    LUB_NODE -.->|listen + watch| LUW2
    LUB_NODE -.->|watch| LUS2
```

---

## 7. Eventos y sus efectos sobre el estado

```mermaid
flowchart LR
    subgraph Eventos
        E1[FetchUsersEvent]
        E2["AddLikedUserEvent\n(user, index)"]
        E3["RemoveLikedUserEvent\n(user, index)"]
        E4[ResetAnimationEvent]
    end

    subgraph Guards["Guardas"]
        G1{uuid ya liked?}
        G2{uuid estaba liked?}
    end

    subgraph Efectos["Cambios en estado"]
        S1["UserLoading →\nUserLoaded / UserError"]
        S2["likedUsers ← +user\nlikeStates[index] ← liked\nanimateP1 ← true"]
        S3["likedUsers ← -user\nlikeStates[index] ← disliked\nanimateMinus ← true"]
        S4["animateP1 ← false\nanimateMinus ← false"]
        NOOP[no-op]
    end

    E1 --> S1
    E2 --> G1
    G1 -->|sí| NOOP
    G1 -->|no| S2
    E3 --> G2
    G2 -->|no| NOOP
    G2 -->|sí| S3
    E4 --> S4
```
