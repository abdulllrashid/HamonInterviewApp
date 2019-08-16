class subjectsResponse {
  List<Subjects> subjects;

  subjectsResponse({this.subjects});

  subjectsResponse.fromJson(Map<String, dynamic> json) {
    if (json['subjects'] != null) {
      subjects = new List<Subjects>();
      json['subjects'].forEach((v) {
        subjects.add(new Subjects.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.subjects != null) {
      data['subjects'] = this.subjects.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Subjects {
  int credits;
  int id;
  String name;
  String teacher;

  Subjects({this.credits, this.id, this.name, this.teacher});

  Subjects.fromJson(Map<String, dynamic> json) {
    credits = json['credits'];
    id = json['id'];
    name = json['name'];
    teacher = json['teacher'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['credits'] = this.credits;
    data['id'] = this.id;
    data['name'] = this.name;
    data['teacher'] = this.teacher;
    return data;
  }
}
