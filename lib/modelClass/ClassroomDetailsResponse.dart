class classroomDetailsResponse {
  int id;
  String layout;
  String name;
  int size;
  int subject;

  classroomDetailsResponse(
      {this.id, this.layout, this.name, this.size, this.subject});

  classroomDetailsResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    layout = json['layout'];
    name = json['name'];
    size = json['size'];
    subject = json['subject'] == "" ? -1 : json['subject'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['layout'] = this.layout;
    data['name'] = this.name;
    data['size'] = this.size;
    data['subject'] = this.subject;
    return data;
  }
}
