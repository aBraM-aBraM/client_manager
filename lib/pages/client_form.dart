import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/client.dart';

class ClientForm extends StatefulWidget {
  final Client? initialClient;
  final void Function(Client client) onSubmit;
  final bool showDelete;
  final VoidCallback? onDelete;

  const ClientForm({
    super.key,
    this.initialClient,
    required this.onSubmit,
    this.showDelete = false,
    this.onDelete,
  });

  @override
  State<ClientForm> createState() => _ClientFormState();
}

class _ClientFormState extends State<ClientForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController treatmentController;
  DateTime? lastVisit;
  DateTime? nextAppointment;

  @override
  void initState() {
    super.initState();
    final client = widget.initialClient;
    nameController = TextEditingController(text: client?.name ?? '');
    treatmentController = TextEditingController(text: client?.treatment ?? '');
    lastVisit = client?.lastVisit;
    nextAppointment = client?.nextAppointment;
  }

  Future<void> _pickDate(bool isLastVisit) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
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

  void _submit() {
    if (_formKey.currentState!.validate() && lastVisit != null) {
      final newClient = Client(
        name: nameController.text,
        treatment: treatmentController.text,
        lastVisit: lastVisit!,
        nextAppointment: nextAppointment,
      );
      widget.onSubmit(newClient);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
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
            onPressed: _submit,
            child: const Text('Save'),
          ),
          if (widget.showDelete && widget.onDelete != null) ...[
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: widget.onDelete,
              icon: const Icon(Icons.delete, color: Colors.red),
              label: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ]
        ],
      ),
    );
  }
}
