import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:consulta_saas/services/authServices.dart';
import 'package:consulta_saas/services/doctorService.dart';
import 'package:consulta_saas/views/doctorHomePage.dart';
import 'package:consulta_saas/views/loginPage.dart';
import 'package:consulta_saas/views/patientHomePage.dart';

class AuthCheck extends StatelessWidget {
  final DoctorService _doctorService = DoctorService();

  @override
  Widget build(BuildContext context) {
    print('AuthCheck build called'); // Debug print

    return Consumer<Authservices>(
      builder: (context, auth, _) {
        print('Auth state changed - isLoading: ${auth.isLoading}, user: ${auth.user?.uid}'); // Debug print

        if (auth.isLoading) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (auth.user == null) {
          print('No user logged in, showing LoginPage'); // Debug print
          return LoginPage();
        }

        // User is logged in, check if they're a doctor
        return FutureBuilder<bool>(
          future: _doctorService.isDoctor(auth.user!.uid),
          builder: (context, snapshot) {
            print('Checking if user is doctor - state: ${snapshot.connectionState}'); // Debug print

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (snapshot.hasError) {
              print('Error checking doctor status: ${snapshot.error}'); // Debug print
              return Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Erro ao verificar tipo de usuário'),
                      ElevatedButton(
                        onPressed: () => auth.logout(),
                        child: Text('Voltar ao Login'),
                      ),
                    ],
                  ),
                ),
              );
            }

            final isDoctor = snapshot.data ?? false;
            print('User ${auth.user!.uid} isDoctor: $isDoctor'); // Debug print

            if (isDoctor) {
              print('Routing to DoctorHomePage with ID: ${auth.user!.uid}'); // Debug print
              return DoctorHomePage(doctorId: auth.user!.uid);
            } else {
              print('Routing to PatientHomePage with ID: ${auth.user!.uid}'); // Debug print
              return PatientHomePage(patientId: auth.user!.uid);
            }
          },
        );
      },
    );
  }
}
