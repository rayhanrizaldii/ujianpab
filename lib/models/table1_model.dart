class table1 {
  final String name;
  final String birth;
  final String address;
  final String gender;
  final int age;
  final String framework;

  table1(
      {required this.name,
      required this.birth,
      required this.address,
      required this.gender,
      required this.age,
      required this.framework});

  factory table1.fromJson(Map<String, dynamic> json) {
    return table1(
      name: json['name'],
      birth: json['birth'],
      age: json['age'],
      address: json['address'],
      gender: json['gender'],
      framework: json['framework'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'birth': birth,
      'age': age,
      'address': address,
      'gender': gender,
      'framework': framework,
    };
  }
}
