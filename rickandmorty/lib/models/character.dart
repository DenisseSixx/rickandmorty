import 'dart:convert';

class Character {
    int id;
    String name;
    Status status;
    Species species;
    String type;
    Gender gender;
    Location origin;
    Location location;
    String image;
    List<String> episode;
    String url;
    DateTime created;

    Character({
        required this.id,
        required this.name,
        required this.status,
        required this.species,
        required this.type,
        required this.gender,
        required this.origin,
        required this.location,
        required this.image,
        required this.episode,
        required this.url,
        required this.created,
    });
    
  get fullPosterImg {
    if (this.image != null) {
      return 'https://image.tmdb.org/t/p/w500${this.image}';
    }
    return 'https://i.stack.imgur.com/GNhxO.png';
  }

    factory Character.fromRawJson(String str) => Character.fromJson(json.decode(str));

   // String toRawJson() => json.encode(toJson());

    factory Character.fromJson(Map<String, dynamic> json) =>Character(
        id: json["id"],
        name: json["name"],
        status: statusValues.map[json["status"]]!,
        species: speciesValues.map[json["species"]]!,
        type: json["type"],
        gender: genderValues.map[json["gender"]]!,
        origin: Location.fromJson(json["origin"]),
        location: Location.fromJson(json["location"]),
        image: json["image"],
        episode: List<String>.from(json["episode"].map((x) => x)),
        url: json["url"],
        created: DateTime.parse(json["created"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "status": statusValues.reverse[status],
        "species": speciesValues.reverse[species],
        "type": type,
        "gender": genderValues.reverse[gender],
        "origin": origin.toJson(),
        "location": location.toJson(),
        "image": image,
        "episode": List<dynamic>.from(episode.map((x) => x)),
        "url": url,
        "created": created.toIso8601String(),
    };
}

enum Gender {
    FEMALE,
    MALE,
    UNKNOWN
}

final genderValues = EnumValues({
    "Female": Gender.FEMALE,
    "Male": Gender.MALE,
    "unknown": Gender.UNKNOWN
});

class Location {
    String name;
    String url;

    Location({
        required this.name,
        required this.url,
    });

    factory Location.fromRawJson(String str) => Location.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Location.fromJson(Map<String, dynamic> json) => Location(
        name: json["name"],
        url: json["url"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "url": url,
    };
}

enum Species {
    ALIEN,
    HUMAN
}

final speciesValues = EnumValues({
    "Alien": Species.ALIEN,
    "Human": Species.HUMAN
});

enum Status {
    ALIVE,
    DEAD,
    UNKNOWN
}

final statusValues = EnumValues({
    "Alive": Status.ALIVE,
    "Dead": Status.DEAD,
    "unknown": Status.UNKNOWN
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        reverseMap = map.map((k, v) => MapEntry(v, k));
        return reverseMap;
    }
}
