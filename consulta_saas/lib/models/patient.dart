class Patient {
  final String id;
  final String name;
  final String email;
  final String phone;
  final List<String> appointmentHistory;

  Patient({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.appointmentHistory = const [],
  });

  factory Patient.fromMap(Map<String, dynamic> map) {
    return Patient(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
      appointmentHistory: List<String>.from(map['appointmentHistory'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'appointmentHistory': appointmentHistory,
    };
  }

  Patient copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    List<String>? appointmentHistory,
  }) {
    return Patient(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      appointmentHistory: appointmentHistory ?? this.appointmentHistory,
    );
  }

  @override
  String toString() {
    return 'Patient(id: $id, name: $name, email: $email, phone: $phone, appointmentHistory: $appointmentHistory)';
  }
}
