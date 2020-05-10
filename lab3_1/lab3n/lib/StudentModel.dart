import 'dart:convert';

Student studentFromJson(String str) => Student.fromMap(json.decode(str));

String studentToJson(Student data) => json.encode(data.toMap());

class Student {
    int id;
    String fio;
    String time;

    Student({
        this.id,
        this.fio,
        this.time,
    });

    factory Student.fromMap(Map<String, dynamic> json) => Student(
        id: json["id"],
        fio: json["FIO"],
        time: json["time"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "FIO": fio,
        "time": time,
    };
}
