import 'package:flutter/material.dart';
import '../gen_l10n/app_localizations.dart';
import './client_form.dart';

class AddClientPage extends StatelessWidget {
  const AddClientPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.addClient)),
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
