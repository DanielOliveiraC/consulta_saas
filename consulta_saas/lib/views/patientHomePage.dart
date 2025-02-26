import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:consulta_saas/services/authServices.dart';
import 'package:consulta_saas/services/appointmentService.dart';
import 'package:consulta_saas/services/doctorService.dart';
import 'package:consulta_saas/models/appointment.dart';

class PatientHomePage extends StatefulWidget {
  final String patientId;

  PatientHomePage({required this.patientId});

  @override
  _PatientHomePageState createState() => _PatientHomePageState();
}

class _PatientHomePageState extends State<PatientHomePage> {
  final TextEditingController observationController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final AppointmentService _appointmentService = AppointmentService();
  final DoctorService _doctorService = DoctorService();
  
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  Map<String, dynamic>? selectedDoctor;

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        dateController.text = _formatDate(picked);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
        timeController.text = _formatTime(picked);
      });
    }
  }

  Future<void> _scheduleAppointment() async {
    if (selectedDate == null || selectedTime == null || selectedDoctor == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, preencha todos os campos obrigatórios')),
      );
      return;
    }

    try {
      final DateTime appointmentDateTime = DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        selectedTime!.hour,
        selectedTime!.minute,
      );

      await _appointmentService.scheduleAppointment(
        widget.patientId,
        selectedDoctor!['id'],
        appointmentDateTime,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Consulta agendada com sucesso!')),
      );
      Navigator.pop(context);
      setState(() {
        selectedDoctor = null;
        observationController.clear();
        dateController.clear();
        timeController.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  Future<void> _cancelAppointment(String appointmentId) async {
    try {
      await _appointmentService.cancelAppointment(appointmentId);
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Consulta cancelada com sucesso')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minhas Consultas'),
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
            child: Text(
              'Minhas Consultas',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Appointment>>(
              stream: _appointmentService.getPatientAppointments(widget.patientId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Erro ao carregar consultas: ${snapshot.error}'),
                  );
                }

                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final appointments = snapshot.data!;

                if (appointments.isEmpty) {
                  return Center(
                    child: Text('Nenhuma consulta agendada'),
                  );
                }

                return ListView.builder(
                  itemCount: appointments.length,
                  itemBuilder: (context, index) {
                    final appointment = appointments[index];
                    String formattedDateTime = _formatDate(appointment.dateTime) + 
                        ' ' + _formatTime(TimeOfDay.fromDateTime(appointment.dateTime));

                    return FutureBuilder<Map<String, dynamic>?>(
                      future: _doctorService.getDoctorById(appointment.doctorId),
                      builder: (context, doctorSnapshot) {
                        final doctorInfo = doctorSnapshot.data;
                        final doctorName = doctorInfo?['name'] ?? 'Médico não encontrado';
                        final doctorSpecialty = doctorInfo?['specialty'] ?? '';

                        return Card(
                          margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: ListTile(
                            title: Text('Consulta $formattedDateTime'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Médico: $doctorName - $doctorSpecialty'),
                                Text('Status: ${appointment.status}'),
                                if (appointment.status == "scheduled")
                                  Text('Aguardando consulta', 
                                    style: TextStyle(color: Colors.orange)
                                  ),
                                if (appointment.status == "completed")
                                  Text('Consulta realizada', 
                                    style: TextStyle(color: Colors.green)
                                  ),
                                if (appointment.status == "cancelled")
                                  Text('Consulta cancelada', 
                                    style: TextStyle(color: Colors.red)
                                  ),
                              ],
                            ),
                            trailing: appointment.status == "scheduled"
                                ? IconButton(
                                    icon: Icon(Icons.cancel),
                                    onPressed: () => _cancelAppointment(appointment.id),
                                    tooltip: 'Cancelar consulta',
                                  )
                                : null,
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  left: 16,
                  right: 16,
                  top: 16,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FutureBuilder<List<Map<String, dynamic>>>(
                        future: _doctorService.getAllDoctors(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return CircularProgressIndicator();
                          }

                          final doctors = snapshot.data!;

                          return DropdownButtonFormField<Map<String, dynamic>>(
                            value: selectedDoctor,
                            decoration: InputDecoration(
                              labelText: 'Médico',
                              border: OutlineInputBorder(),
                            ),
                            items: doctors.map((doctor) {
                              return DropdownMenuItem<Map<String, dynamic>>(
                                value: doctor,
                                child: Text('${doctor['name']} - ${doctor['specialty']}'),
                              );
                            }).toList(),
                            onChanged: (Map<String, dynamic>? newValue) {
                              setState(() {
                                selectedDoctor = newValue;
                              });
                            },
                          );
                        },
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: dateController,
                        readOnly: true,
                        onTap: () => _selectDate(context),
                        decoration: InputDecoration(
                          labelText: 'Data da Consulta',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: timeController,
                        readOnly: true,
                        onTap: () => _selectTime(context),
                        decoration: InputDecoration(
                          labelText: 'Hora da Consulta',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.access_time),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: observationController,
                        decoration: InputDecoration(
                          labelText: 'Observações',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _scheduleAppointment,
                        child: Text('Agendar Consulta'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
