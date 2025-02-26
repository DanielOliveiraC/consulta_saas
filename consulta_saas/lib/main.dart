import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:consulta_saas/services/authServices.dart';
import 'package:consulta_saas/services/doctorService.dart';
import 'package:consulta_saas/services/appointmentService.dart';
import 'package:consulta_saas/widgets/auth_check.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    print('Initializing Firebase...'); // Debug print
    await Firebase.initializeApp();
    print('Firebase initialized successfully'); // Debug print
  } catch (e) {
    print('Error initializing Firebase: $e'); // Debug print
  }
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Authservices()),
        Provider(create: (context) => DoctorService()),
        Provider(create: (context) => AppointmentService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SaaS Consultas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: AuthCheck(),
    );
  }
}
