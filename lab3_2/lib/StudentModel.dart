import 'dart:convert';

Student studentFromJson(String str) => Student.fromMap(json.decode(str));

String studentToJson(Student data) => json.encode(data.toMap());

class Student {
    int id;
    String firstName;
    String lastName;
    String middleName;
    String time;

    Student({
        this.id,
        this.firstName,
        this.lastName,
        this.middleName,
        this.time,
    });

    factory Student.fromMap(Map<String, dynamic> json) => Student(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        middleName: json["middleName"],
        time: json["time"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "middleName": middleName,
        "time": time,
    };
}
