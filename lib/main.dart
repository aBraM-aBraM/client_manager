import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'gen_l10n/app_localizations.dart';
import 'models/client.dart';
import 'pages/add_client_page.dart';
import 'pages/edit_client_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en');

  void _changeLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: _locale,
      supportedLocales: const [Locale('en'), Locale('he')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(primarySwatch: Colors.pink),
      home: MyHomePage(key: ValueKey(_locale), onLocaleChange: _changeLocale),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final void Function(Locale) onLocaleChange;

  const MyHomePage({super.key, required this.onLocaleChange});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<Client> clients = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeClients();
  }

  void _initializeClients() {
    final l10n = AppLocalizations.of(context)!;
    final treatments = [
      l10n.treatmentColoring,
      l10n.treatmentHaircut,
      l10n.treatmentProduct,
    ];

    clients = [
      Client(
        name: 'Alice',
        treatment: [treatments[0], treatments[1]],
        lastVisit: DateTime(2025, 4, 1),
        nextAppointment: DateTime(2025, 5, 1),
      ),
      Client(
        name: 'Bob',
        treatment: [treatments.last],
        lastVisit: DateTime(2025, 3, 20),
      ),
      Client(
        name: 'Charlie',
        treatment: treatments,
        lastVisit: DateTime(2025, 4, 10),
        nextAppointment: DateTime(2025, 4, 25),
      ),
    ];
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  void _toggleLanguage() {
    final currentLocale = Localizations.localeOf(context).languageCode;
    final newLocale = currentLocale == 'en' ? const Locale('he') : const Locale('en');
    widget.onLocaleChange(newLocale);
  }

  Future<void> _navigateToEditPage(Client client, int index) async {
    final result = await Navigator.push<ClientAction>(
      context,
      MaterialPageRoute(builder: (_) => EditClientPage(client: client)),
    );

    if (result is ClientEdited) {
      setState(() {
        clients[index] = result.updatedClient;
      });
    } else if (result is ClientDeleted) {
      setState(() {
        clients.removeAt(index);
      });
    }
  }

  Future<void> _navigateToAddPage() async {
    final newClient = await Navigator.push<Client>(
      context,
      MaterialPageRoute(builder: (_) => const AddClientPage()),
    );

    if (newClient != null) {
      setState(() {
        clients.add(newClient);
      });
    }
  }

  PreferredSizeWidget _buildAppBar(AppLocalizations l10n) {
    return AppBar(
      title: Text(l10n.appTitle),
      actions: [
        IconButton(
          icon: const Icon(Icons.language),
          onPressed: _toggleLanguage,
        ),
      ],
    );
  }

  Widget _buildClientCard(Client client, int index, AppLocalizations l10n) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: ListTile(
        title: Text(client.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 6,
              runSpacing: -8,
              children: client.treatment.map((t) {
                return Chip(
                  label: Text(t),
                  backgroundColor: Colors.purple.shade50,
                  labelStyle: const TextStyle(fontSize: 12),
                  visualDensity: VisualDensity.compact,
                );
              }).toList(),
            ),
            const SizedBox(height: 4),
            Text(
              '${l10n.lastVisit}: ${_formatDate(client.lastVisit)}',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
          ],
        ),
        trailing: client.nextAppointment != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.calendar_today, size: 18),
                  Text(
                    _formatDate(client.nextAppointment!),
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              )
            : Text(l10n.noNextAppointment),
        onTap: () => _navigateToEditPage(client, index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: _buildAppBar(l10n),
      body: clients.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: clients.length,
              itemBuilder: (context, index) => _buildClientCard(clients[index], index, l10n),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddPage,
        child: const Icon(Icons.add),
      ),
    );
  }
}
