class RandomUser {
  final String gender;
  final Name name;
  final Location location;
  final String email;
  final Login login;
  final DateTime dob;
  final int age;
  final DateTime registered;
  final String phone;
  final String cell;
  final Picture picture;
  final String nat;

  RandomUser({
    required this.gender,
    required this.name,
    required this.location,
    required this.email,
    required this.login,
    required this.dob,
    required this.age,
    required this.registered,
    required this.phone,
    required this.cell,
    required this.picture,
    required this.nat,
  });

  factory RandomUser.fromJson(Map<String, dynamic> json) {
    final dobData = json['dob'] as Map<String, dynamic>?;
    final registeredData = json['registered'] as Map<String, dynamic>?;

    return RandomUser(
      gender: json['gender'] as String? ?? '',
      name: Name.fromJson(json['name'] as Map<String, dynamic>? ?? {}),
      location: Location.fromJson(json['location'] as Map<String, dynamic>? ?? {}),
      email: json['email'] as String? ?? '',
      login: Login.fromJson(json['login'] as Map<String, dynamic>? ?? {}),
      dob: DateTime.tryParse(dobData?['date'] as String? ?? '') ?? DateTime(1900),
      age: dobData?['age'] as int? ?? 0,
      registered: DateTime.tryParse(registeredData?['date'] as String? ?? '') ?? DateTime(1900),
      phone: json['phone'] as String? ?? '',
      cell: json['cell'] as String? ?? '',
      picture: Picture.fromJson(json['picture'] as Map<String, dynamic>? ?? {}),
      nat: json['nat'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gender': gender,
      'name': name.toJson(),
      'location': location.toJson(),
      'email': email,
      'login': login.toJson(),
      'dob': {
        'date': dob.toIso8601String(),
        'age': age,
      },
      'registered': {
        'date': registered.toIso8601String(),
      },
      'phone': phone,
      'cell': cell,
      'picture': picture.toJson(),
      'nat': nat,
    };
  }

  @override
  String toString() {
    return 'RandomUser(gender: $gender, name: $name, email: $email, dob: ${dob.toIso8601String()}, age: $age, registered: ${registered.toIso8601String()}, phone: $phone, cell: $cell, nat: $nat)';
  }
}

class Name {
  final String title;
  final String first;
  final String last;

  Name({required this.title, required this.first, required this.last});

  factory Name.fromJson(Map<String, dynamic> json) => Name(
        title: json['title'] as String? ?? '',
        first: json['first'] as String? ?? '',
        last: json['last'] as String? ?? '',
      );

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'first': first,
      'last': last,
    };
  }

  @override
  String toString() => 'Name(title: $title, first: $first, last: $last)';
}

class Location {
  final Street street;
  final String city;
  final String state;
  final String country;
  final String postcode;

  Location({
    required this.street,
    required this.city,
    required this.state,
    required this.country,
    required this.postcode,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    final postcodeValue = json['postcode'];
    String postcodeStr;
    if (postcodeValue is String) {
      postcodeStr = postcodeValue;
    } else if (postcodeValue is int) {
      postcodeStr = postcodeValue.toString();
    } else {
      postcodeStr = '';
    }

    return Location(
      street: Street.fromJson(json['street'] as Map<String, dynamic>? ?? {}),
      city: json['city'] as String? ?? '',
      state: json['state'] as String? ?? '',
      country: json['country'] as String? ?? '',
      postcode: postcodeStr,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'street': street.toJson(),
      'city': city,
      'state': state,
      'country': country,
      'postcode': postcode,
    };
  }

  @override
  String toString() {
    return 'Location(street: $street, city: $city, state: $state, country: $country, postcode: $postcode)';
  }
}

class Street {
  final int number;
  final String name;

  Street({required this.number, required this.name});

  factory Street.fromJson(Map<String, dynamic> json) => Street(
        number: json['number'] as int? ?? 0,
        name: json['name'] as String? ?? '',
      );

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'name': name,
    };
  }

  @override
  String toString() => 'Street(number: $number, name: $name)';
}

class Login {
  final String uuid;
  final String username;
  final String password;
  final String salt;
  final String md5;
  final String sha1;
  final String sha256;

  Login({
    required this.uuid,
    required this.username,
    required this.password,
    required this.salt,
    required this.md5,
    required this.sha1,
    required this.sha256,
  });

  factory Login.fromJson(Map<String, dynamic> json) => Login(
        uuid: json['uuid'] as String? ?? '',
        username: json['username'] as String? ?? '',
        password: json['password'] as String? ?? '',
        salt: json['salt'] as String? ?? '',
        md5: json['md5'] as String? ?? '',
        sha1: json['sha1'] as String? ?? '',
        sha256: json['sha256'] as String? ?? '',
      );

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'username': username,
      'password': password,
      'salt': salt,
      'md5': md5,
      'sha1': sha1,
      'sha256': sha256,
    };
  }

  @override
  String toString() {
    return 'Login(uuid: $uuid, username: $username, password: $password, salt: $salt, md5: $md5, sha1: $sha1, sha256: $sha256)';
  }
}

class Picture {
  final String large;
  final String medium;
  final String thumbnail;

  Picture({required this.large, required this.medium, required this.thumbnail});

  factory Picture.fromJson(Map<String, dynamic> json) => Picture(
        large: json['large'] as String? ?? '',
        medium: json['medium'] as String? ?? '',
        thumbnail: json['thumbnail'] as String? ?? '',
      );

  Map<String, dynamic> toJson() {
    return {
      'large': large,
      'medium': medium,
      'thumbnail': thumbnail,
    };
  }

  @override
  String toString() => 'Picture(large: $large, medium: $medium, thumbnail: $thumbnail)';
}
