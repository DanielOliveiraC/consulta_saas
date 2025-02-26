import 'package:flutter/material.dart';
import 'package:consulta_saas/widgets/auth_check.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'cONsultas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: AuthCheck()
    );
  }
  
}