import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../gen_l10n/app_localizations.dart';
import '../models/client.dart';
import '../widgets/treatment_tag_selector.dart';

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
  late List<String> _selectedTreatments;
  DateTime? lastAppointment;
  DateTime? nextAppointment;

  final Duration appointmentDelta = const Duration(days: 30);

  @override
  void initState() {
    super.initState();
    final client = widget.initialClient;
    nameController = TextEditingController(text: client?.name ?? '');
    _selectedTreatments = client?.treatment ?? [];
    lastAppointment = client?.lastAppointment ?? DateTime.now();
    nextAppointment = client?.nextAppointment ?? DateTime.now().add(appointmentDelta) ;
  }

  Future<void> _pickLastAppointment() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null) {
      setState(() {
        lastAppointment = picked;
      });
    }
  }
  Future<void> _pickNextAppointment() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(appointmentDelta),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null) {
      setState(() {
        nextAppointment = picked;
      });
    }
  }

  String formatDate(DateTime? date) {
    return date == null ? '' : DateFormat('dd/MM/yyyy').format(date);
  }

  void _submit() {
    if (_formKey.currentState!.validate() && lastAppointment != null) {
      final newClient = Client(
        name: nameController.text,
        treatment: _selectedTreatments,
        lastAppointment: lastAppointment!,
        nextAppointment: nextAppointment,
      );
      widget.onSubmit(newClient);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          TextFormField(
            controller: nameController,
            decoration: InputDecoration(labelText: l10n.nameTitle),
            validator: (val) => val!.isEmpty ? l10n.nameValidator : null,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.treatmentsTitle,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TreatmentTagSelector(
            selectedTreatments: _selectedTreatments,
            onChanged: (updatedList) {
              setState(() {
                _selectedTreatments = updatedList;
              });
            },
          ),
          const SizedBox(height: 20),
          ListTile(
            title: Text(
              lastAppointment == null
                  ? l10n.pickLastAppointment 
                  : '${l10n.lastAppointment}: ${formatDate(lastAppointment)}',
            ),
            trailing: const Icon(Icons.date_range),
            onTap: () => _pickLastAppointment(),
          ),
          ListTile(
            title: Text(
              nextAppointment == null
                  ? l10n.pickNextAppointment 
                  : '${l10n.nextAppointment}: ${formatDate(nextAppointment)}',
            ),
            trailing: const Icon(Icons.event),
            onTap: () => _pickNextAppointment(),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _submit,
            child: Text(l10n.save)
          ),
          if (widget.showDelete && widget.onDelete != null) ...[
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: widget.onDelete,
              icon: const Icon(Icons.delete, color: Colors.red),
              label: Text(l10n.delete, style: TextStyle(color: Colors.red)),
            ),
          ]
        ],
      ),
    );
  }
}
