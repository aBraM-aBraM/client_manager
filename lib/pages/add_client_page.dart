import 'package:flutter/material.dart';
import './client_form.dart';

class AddClientPage extends StatelessWidget {
  const AddClientPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Client')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ClientForm(
          onSubmit: (client) {
            Navigator.pop(context, client);
          },
        ),
      ),
    );
  }
}
