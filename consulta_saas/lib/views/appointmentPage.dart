import 'package:flutter/material.dart';

class AppointmentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agendar Consulta'),
      ),
      body: Center(
        child: Text('Aqui você pode agendar uma consulta.'),
      ),
    );
  }
}
