import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/client.dart';

class AddClientPage extends StatefulWidget {
  const AddClientPage({super.key});

  @override
  State<AddClientPage> createState() => _AddClientPageState();
}

class _AddClientPageState extends State<AddClientPage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final treatmentController = TextEditingController();

  DateTime? lastVisit;
  DateTime? nextAppointment;

  Future<void> _pickDate(bool isLastVisit) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        if (isLastVisit) {
          lastVisit = picked;
        } else {
          nextAppointment = picked;
        }
      });
    }
  }

  String formatDate(DateTime? date) {
    return date == null ? '' : DateFormat('dd/MM/yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Client')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (val) => val!.isEmpty ? 'Enter name' : null,
              ),
              TextFormField(
                controller: treatmentController,
                decoration: const InputDecoration(labelText: 'Treatment'),
                validator: (val) => val!.isEmpty ? 'Enter treatment' : null,
              ),
              const SizedBox(height: 20),
              ListTile(
                title: Text(
                  lastVisit == null
                      ? 'Pick Last Visit Date'
                      : 'Last Visit: ${formatDate(lastVisit)}',
                ),
                trailing: const Icon(Icons.date_range),
                onTap: () => _pickDate(true),
              ),
              ListTile(
                title: Text(
                  nextAppointment == null
                      ? 'Pick Next Appointment (optional)'
                      : 'Next Appt: ${formatDate(nextAppointment)}',
                ),
                trailing: const Icon(Icons.event),
                onTap: () => _pickDate(false),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate() && lastVisit != null) {
                    final newClient = Client(
                      name: nameController.text,
                      treatment: treatmentController.text,
                      lastVisit: lastVisit!,
                      nextAppointment: nextAppointment,
                    );
                    Navigator.pop(context, newClient);
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}