class classRoomRegistredStudentsResponse {
  List<Registrations> registrations;

  classRoomRegistredStudentsResponse({this.registrations});

  classRoomRegistredStudentsResponse.fromJson(Map<String, dynamic> json) {
    if (json['registrations'] != null) {
      registrations = new List<Registrations>();
      json['registrations'].forEach((v) {
        registrations.add(new Registrations.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.registrations != null) {
      data['registrations'] =
          this.registrations.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Registrations {
  int id;
  int student;
  int subject;

  Registrations({this.id, this.student, this.subject});

  Registrations.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    student = json['student'];
    subject = json['subject'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['student'] = this.student;
    data['subject'] = this.subject;
    return data;
  }
}
