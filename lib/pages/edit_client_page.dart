import 'package:flutter/material.dart';
import '../models/client.dart';
import './client_form.dart';

abstract class ClientAction {}

class ClientEdited extends ClientAction {
  final Client updatedClient;
  ClientEdited(this.updatedClient);
}

class ClientDeleted extends ClientAction {}

class EditClientPage extends StatelessWidget {
  final Client client;

  const EditClientPage({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Client')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ClientForm(
          initialClient: client,
          onSubmit: (updatedClient) {
            Navigator.pop(context, ClientEdited(updatedClient));
          },
          showDelete: true,
          onDelete: () {
            Navigator.pop(context, ClientDeleted());
          },
        ),
      ),
    );
  }
}
