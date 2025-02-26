import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:consulta_saas/services/authServices.dart';
import 'package:consulta_saas/services/doctorService.dart';
import 'package:consulta_saas/views/doctorHomePage.dart';
import 'package:consulta_saas/views/patientHomePage.dart';

class HomePage extends StatelessWidget {
  final DoctorService _doctorService = DoctorService();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Authservices>(context);
    
    if (auth.user == null) {
      return Center(
        child: Text('Usuário não autenticado'),
      );
    }

    return FutureBuilder<bool>(
      future: _doctorService.isDoctor(auth.user!.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Erro ao carregar: ${snapshot.error}'),
          );
        }

        final isDoctor = snapshot.data ?? false;
        print('User ID: ${auth.user!.uid}'); // Debug print
        print('Is Doctor: $isDoctor'); // Debug print

        if (isDoctor) {
          print('Routing to DoctorHomePage'); // Debug print
          return DoctorHomePage(doctorId: auth.user!.uid);
        } else {
          print('Routing to PatientHomePage'); // Debug print
          return PatientHomePage(patientId: auth.user!.uid);
        }
      },
    );
  }
}
