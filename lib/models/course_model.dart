class CourseModel {
  final String id;
  final String title;
  final String description;
  final String instructor;
  final String imageUrl;
  final int credits;
  final String department;
  final String schedule;
  final int capacity;
  final int enrolled;
  final List<String> prerequisites;
  final double rating;

  CourseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.instructor,
    this.imageUrl = '',
    required this.credits,
    required this.department,
    required this.schedule,
    required this.capacity,
    this.enrolled = 0,
    this.prerequisites = const [],
    this.rating = 0.0,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      instructor: json['instructor'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      credits: json['credits'] ?? 0,
      department: json['department'] ?? '',
      schedule: json['schedule'] ?? '',
      capacity: json['capacity'] ?? 0,
      enrolled: json['enrolled'] ?? 0,
      prerequisites: List<String>.from(json['prerequisites'] ?? []),
      rating: (json['rating'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'instructor': instructor,
      'imageUrl': imageUrl,
      'credits': credits,
      'department': department,
      'schedule': schedule,
      'capacity': capacity,
      'enrolled': enrolled,
      'prerequisites': prerequisites,
      'rating': rating,
    };
  }

  bool get isAvailable => enrolled < capacity;

  CourseModel copyWith({
    String? id,
    String? title,
    String? description,
    String? instructor,
    String? imageUrl,
    int? credits,
    String? department,
    String? schedule,
    int? capacity,
    int? enrolled,
    List<String>? prerequisites,
    double? rating,
  }) {
    return CourseModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      instructor: instructor ?? this.instructor,
      imageUrl: imageUrl ?? this.imageUrl,
      credits: credits ?? this.credits,
      department: department ?? this.department,
      schedule: schedule ?? this.schedule,
      capacity: capacity ?? this.capacity,
      enrolled: enrolled ?? this.enrolled,
      prerequisites: prerequisites ?? this.prerequisites,
      rating: rating ?? this.rating,
    );
  }
}

