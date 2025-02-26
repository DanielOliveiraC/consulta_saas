class Appointment {
  final String id;
  final String patientId;
  final String doctorId;
  final DateTime dateTime;
  final String status; // 'scheduled', 'completed', 'cancelled'

  Appointment({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.dateTime,
    required this.status,
  });

  factory Appointment.fromMap(String id, Map<String, dynamic> map) {
    return Appointment(
      id: id,
      patientId: map['patientId'] ?? '',
      doctorId: map['doctorId'] ?? '',
      dateTime: DateTime.parse(map['dateTime'] ?? DateTime.now().toIso8601String()),
      status: map['status'] ?? 'scheduled',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'patientId': patientId,
      'doctorId': doctorId,
      'dateTime': dateTime.toIso8601String(),
      'status': status,
    };
  }

  Appointment copyWith({
    String? id,
    String? patientId,
    String? doctorId,
    DateTime? dateTime,
    String? status,
  }) {
    return Appointment(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      doctorId: doctorId ?? this.doctorId,
      dateTime: dateTime ?? this.dateTime,
      status: status ?? this.status,
    );
  }
}
