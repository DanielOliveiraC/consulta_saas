import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consulta_saas/models/appointment.dart';

class AppointmentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Schedule a new appointment
  Future<void> scheduleAppointment(
    String patientId,
    String doctorId,
    DateTime dateTime,
  ) async {
    try {
      final appointmentData = {
        'patientId': patientId,
        'doctorId': doctorId,
        'dateTime': dateTime.toIso8601String(),
        'status': 'scheduled',
        'createdAt': FieldValue.serverTimestamp(),
      };

      await _firestore.collection('appointments').add(appointmentData);
    } catch (e) {
      throw Exception('Erro ao agendar consulta: $e');
    }
  }

  // Cancel an appointment
  Future<void> cancelAppointment(String appointmentId) async {
    try {
      await _firestore
          .collection('appointments')
          .doc(appointmentId)
          .update({'status': 'cancelled'});
    } catch (e) {
      throw Exception('Erro ao cancelar consulta: $e');
    }
  }

  // Complete an appointment
  Future<void> completeAppointment(String appointmentId) async {
    try {
      await _firestore
          .collection('appointments')
          .doc(appointmentId)
          .update({'status': 'completed'});
    } catch (e) {
      throw Exception('Erro ao concluir consulta: $e');
    }
  }

  // Get appointments for a patient
  Stream<List<Appointment>> getPatientAppointments(String patientId) {
    return _firestore
        .collection('appointments')
        .where('patientId', isEqualTo: patientId)
        .snapshots()
        .map((snapshot) {
      final appointments = snapshot.docs.map((doc) {
        return Appointment.fromMap(doc.id, doc.data());
      }).toList();

      // Sort appointments by date locally
      appointments.sort((a, b) => b.dateTime.compareTo(a.dateTime));
      return appointments;
    });
  }

  // Get appointments for a doctor
  Stream<List<Appointment>> getDoctorAppointments(String doctorId) {
    print('Fetching appointments for doctor: $doctorId'); // Debug print
    return _firestore
        .collection('appointments')
        .where('doctorId', isEqualTo: doctorId)
        .snapshots()
        .map((snapshot) {
      print('Received ${snapshot.docs.length} appointments'); // Debug print
      final appointments = snapshot.docs.map((doc) {
        final data = doc.data();
        print('Appointment data: $data'); // Debug print
        return Appointment.fromMap(doc.id, data);
      }).toList();

      // Sort appointments by date locally
      appointments.sort((a, b) => b.dateTime.compareTo(a.dateTime));
      return appointments;
    });
  }

  // Get a specific appointment
  Future<Appointment?> getAppointment(String appointmentId) async {
    try {
      final doc = await _firestore
          .collection('appointments')
          .doc(appointmentId)
          .get();

      if (!doc.exists) {
        return null;
      }

      return Appointment.fromMap(doc.id, doc.data()!);
    } catch (e) {
      throw Exception('Erro ao buscar consulta: $e');
    }
  }
}
