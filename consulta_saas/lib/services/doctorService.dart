import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a new doctor
  Future<void> addDoctor(String uid, String name, String specialty) async {
    try {
      print('Adding doctor with uid: $uid'); // Debug print
      print('Name: $name, Specialty: $specialty'); // Debug print
      
      await _firestore.collection('doctors').doc(uid).set({
        'name': name,
        'specialty': specialty,
        'availability': [],
        'createdAt': FieldValue.serverTimestamp(),
      });
      print('Doctor added successfully with specialty: $specialty'); // Debug print
    } catch (e) {
      print('Error adding doctor: $e'); // Debug print
      throw Exception('Erro ao adicionar médico: $e');
    }
  }

  // Get doctor by ID
  Future<Map<String, dynamic>?> getDoctorById(String doctorId) async {
    try {
      print('Getting doctor with id: $doctorId'); // Debug print
      final doc = await _firestore.collection('doctors').doc(doctorId).get();
      if (!doc.exists) {
        print('Doctor not found'); // Debug print
        return null;
      }
      final data = doc.data()!;
      print('Doctor data: $data'); // Debug print
      return {
        'id': doc.id,
        ...data,
      };
    } catch (e) {
      print('Error getting doctor: $e'); // Debug print
      throw Exception('Erro ao buscar médico: $e');
    }
  }

  // Get all doctors
  Future<List<Map<String, dynamic>>> getAllDoctors() async {
    try {
      print('Getting all doctors'); // Debug print
      final snapshot = await _firestore.collection('doctors').get();
      print('Found ${snapshot.docs.length} doctors'); // Debug print
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          ...data,
        };
      }).toList();
    } catch (e) {
      print('Error getting all doctors: $e'); // Debug print
      throw Exception('Erro ao buscar médicos: $e');
    }
  }

  // Check if a user is a doctor
  Future<bool> isDoctor(String uid) async {
    try {
      print('Checking if user $uid is a doctor'); // Debug print
      final doc = await _firestore.collection('doctors').doc(uid).get();
      final result = doc.exists;
      print('Is doctor result: $result'); // Debug print
      return result;
    } catch (e) {
      print('Error checking if user is doctor: $e'); // Debug print
      throw Exception('Erro ao verificar médico: $e');
    }
  }

  // Get doctor's availability
  Future<List<String>> getDoctorAvailability(String doctorId) async {
    try {
      final doc = await _firestore.collection('doctors').doc(doctorId).get();
      if (!doc.exists) {
        return [];
      }
      final data = doc.data()!;
      return List<String>.from(data['availability'] ?? []);
    } catch (e) {
      throw Exception('Erro ao buscar disponibilidade: $e');
    }
  }

  // Update doctor's availability
  Future<void> updateDoctorAvailability(
    String doctorId,
    List<String> availability,
  ) async {
    try {
      await _firestore
          .collection('doctors')
          .doc(doctorId)
          .update({'availability': availability});
    } catch (e) {
      throw Exception('Erro ao atualizar disponibilidade: $e');
    }
  }

  // Update doctor's specialty
  Future<void> updateDoctorSpecialty(
    String doctorId,
    String specialty,
  ) async {
    try {
      print('Updating specialty for doctor $doctorId to: $specialty'); // Debug print
      await _firestore
          .collection('doctors')
          .doc(doctorId)
          .update({'specialty': specialty});
      print('Specialty updated successfully'); // Debug print
    } catch (e) {
      print('Error updating specialty: $e'); // Debug print
      throw Exception('Erro ao atualizar especialidade: $e');
    }
  }
}
