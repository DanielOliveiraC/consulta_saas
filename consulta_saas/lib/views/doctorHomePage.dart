import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:consulta_saas/services/authServices.dart';
import 'package:consulta_saas/services/appointmentService.dart';
import 'package:consulta_saas/models/appointment.dart';

class DoctorHomePage extends StatefulWidget {
  final String doctorId;

  DoctorHomePage({required this.doctorId}) {
    print('DoctorHomePage constructed with ID: $doctorId'); // Debug print
  }

  @override
  _DoctorHomePageState createState() => _DoctorHomePageState();
}

class _DoctorHomePageState extends State<DoctorHomePage> {
  final AppointmentService _appointmentService = AppointmentService();

  @override
  void initState() {
    super.initState();
    print('DoctorHomePage initialized for doctor: ${widget.doctorId}'); // Debug print
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _completeAppointment(String appointmentId) async {
    try {
      print('Completing appointment: $appointmentId'); // Debug print
      await _appointmentService.completeAppointment(appointmentId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Consulta concluída com sucesso')),
      );
    } catch (e) {
      print('Error completing appointment: $e'); // Debug print
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Building DoctorHomePage for doctor: ${widget.doctorId}'); // Debug print

    return Scaffold(
      appBar: AppBar(
        title: Text('Agenda Médica'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              Provider.of<Authservices>(context, listen: false).logout();
            },
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(Icons.calendar_today, size: 24),
                SizedBox(width: 8),
                Text(
                  'Minhas Consultas',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Appointment>>(
              stream: _appointmentService.getDoctorAppointments(widget.doctorId),
              builder: (context, snapshot) {
                print('StreamBuilder update - connectionState: ${snapshot.connectionState}'); // Debug print
                if (snapshot.hasError) {
                  print('StreamBuilder error: ${snapshot.error}'); // Debug print
                  return Center(
                    child: Text('Erro ao carregar consultas: ${snapshot.error}'),
                  );
                }

                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final appointments = snapshot.data!;
                print('Received ${appointments.length} appointments'); // Debug print

                if (appointments.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.event_busy, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'Nenhuma consulta agendada',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: appointments.length,
                  itemBuilder: (context, index) {
                    final appointment = appointments[index];
                    print('Building appointment card for: ${appointment.id}'); // Debug print
                    String formattedDateTime = _formatDate(appointment.dateTime) +
                        ' ' +
                        _formatTime(TimeOfDay.fromDateTime(appointment.dateTime));

                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: ListTile(
                        leading: Icon(
                          Icons.medical_services,
                          color: Theme.of(context).primaryColor,
                        ),
                        title: Text(
                          'Consulta $formattedDateTime',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ID do Paciente: ${appointment.patientId}'),
                            Text('Status: ${appointment.status}'),
                            if (appointment.status == "scheduled")
                              Text('Aguardando consulta',
                                  style: TextStyle(color: Colors.orange)),
                            if (appointment.status == "completed")
                              Text('Consulta realizada',
                                  style: TextStyle(color: Colors.green)),
                            if (appointment.status == "cancelled")
                              Text('Consulta cancelada',
                                  style: TextStyle(color: Colors.red)),
                          ],
                        ),
                        trailing: appointment.status == "scheduled"
                            ? IconButton(
                                icon: Icon(Icons.check_circle),
                                onPressed: () =>
                                    _completeAppointment(appointment.id),
                                tooltip: 'Marcar como concluída',
                                color: Colors.green,
                              )
                            : null,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
