// class UserModel {
//   final String id;
//   final String name;
//   final String email;
//   final String photoUrl;
//   final List<String> enrolledCourses;
//   final String department;
//   final String studentId;

//   UserModel({
//     required this.id,
//     required this.name,
//     required this.email,
//     this.photoUrl = '',
//     this.enrolledCourses = const [],
//     this.department = '',
//     this.studentId = '',
//   });

//   factory UserModel.fromJson(Map<String, dynamic> json) {
//     return UserModel(
//       id: json['id'] ?? '',
//       name: json['name'] ?? '',
//       email: json['email'] ?? '',
//       photoUrl: json['photoUrl'] ?? '',
//       enrolledCourses: List<String>.from(json['enrolledCourses'] ?? []),
//       department: json['department'] ?? '',
//       studentId: json['studentId'] ?? '',
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'email': email,
//       'photoUrl': photoUrl,
//       'enrolledCourses': enrolledCourses,
//       'department': department,
//       'studentId': studentId,
//     };
//   }

//   UserModel copyWith({
//     String? id,
//     String? name,
//     String? email,
//     String? photoUrl,
//     List<String>? enrolledCourses,
//     String? department,
//     String? studentId,
//   }) {
//     return UserModel(
//       id: id ?? this.id,
//       name: name ?? this.name,
//       email: email ?? this.email,
//       photoUrl: photoUrl ?? this.photoUrl,
//       enrolledCourses: enrolledCourses ?? this.enrolledCourses,
//       department: department ?? this.department,
//       studentId: studentId ?? this.studentId,
//     );
//   }
// }

class UserModel {
  final String id;
  final String name;
  final String email;
  final String photoUrl;
  final List<String> enrolledCourses;
  final String department;
  final String studentId;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl = '',
    this.enrolledCourses = const [],
    this.department = '',
    this.studentId = '',
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      photoUrl: json['photoUrl'] ?? '',
      enrolledCourses: List<String>.from(json['enrolledCourses'] ?? []),
      department: json['department'] ?? '',
      studentId: json['studentId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'enrolledCourses': enrolledCourses,
      'department': department,
      'studentId': studentId,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? photoUrl,
    List<String>? enrolledCourses,
    String? department,
    String? studentId,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      enrolledCourses: enrolledCourses ?? this.enrolledCourses,
      department: department ?? this.department,
      studentId: studentId ?? this.studentId,
    );
  }
}

