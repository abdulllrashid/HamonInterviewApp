class studentsResponse {
  List<Students> students;

  studentsResponse({this.students});

  studentsResponse.fromJson(Map<String, dynamic> json) {
    if (json['students'] != null) {
      students = new List<Students>();
      json['students'].forEach((v) {
        students.add(new Students.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.students != null) {
      data['students'] = this.students.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Students {
  int age;
  String email;
  int id;
  String name;

  Students({this.age, this.email, this.id, this.name});

  Students.fromJson(Map<String, dynamic> json) {
    age = json['age'];
    email = json['email'];
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['age'] = this.age;
    data['email'] = this.email;
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
