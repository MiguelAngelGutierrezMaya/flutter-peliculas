class Cast {
  List<Actor> actors = new List();

  Cast.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;
    jsonList.forEach((item) {
      final actor = Actor.fromJsonMap(item);
      actors.add(actor);
    });
  }
}

class Actor {
  bool adult;
  int gender;
  int id;
  String knownForDepartment;
  String name;
  String originalName;
  double popularity;
  String profilePath;
  int castId;
  String character;
  String creditId;
  int order;
  String department;
  String job;

  Actor({
    this.adult,
    this.gender,
    this.id,
    this.knownForDepartment,
    this.name,
    this.originalName,
    this.popularity,
    this.profilePath,
    this.castId,
    this.character,
    this.creditId,
    this.order,
    this.department,
    this.job,
  });

  Actor.fromJsonMap(Map<String, dynamic> json) {
    adult = json['adult'];
    gender = json['gender'];
    id = json['id'];
    knownForDepartment = json['known_for_department'];
    name = json['name'];
    originalName = json['original_name'];
    popularity = json['popularity'];
    profilePath = json['profile_path'];
    castId = json['cast_id'];
    character = json['character'];
    creditId = json['credit_id'];
    order = json['order'];
    department = json['department'];
    job = json['job'];
  }

  getImage() {
    //print(profilePath);
    //https://image.tmdb.org/t/p/w500/uFEQ7JW5GFvRinOMPaVBn4epcar.jpg
    if (profilePath == null)
      return 'https://img1.freepng.es/20180320/hww/kisspng-computer-icons-directory-computer-file-png-transparent-no-5ab134adbd3e51.0821639815215627977751.jpg';
    return 'https://image.tmdb.org/t/p/w500$profilePath';
  }
}
