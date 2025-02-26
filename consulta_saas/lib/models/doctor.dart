class Doctor {
  final String id;
  final String name;
  final String specialty;
  final List<String> availability;

  Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    this.availability = const [],
  });

  factory Doctor.fromMap(Map<String, dynamic> map) {
    return Doctor(
      id: map['id'] as String,
      name: map['name'] as String,
      specialty: map['specialty'] as String,
      availability: List<String>.from(map['availability'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'specialty': specialty,
      'availability': availability,
    };
  }

  Doctor copyWith({
    String? id,
    String? name,
    String? specialty,
    List<String>? availability,
  }) {
    return Doctor(
      id: id ?? this.id,
      name: name ?? this.name,
      specialty: specialty ?? this.specialty,
      availability: availability ?? this.availability,
    );
  }

  @override
  String toString() {
    return 'Doctor(id: $id, name: $name, specialty: $specialty, availability: $availability)';
  }
}
