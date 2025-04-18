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
  Locale _locale = const Locale('he');

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
      theme: ThemeData(
        primarySwatch: Colors.pink,
        fontFamily: "OpenSans"),
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
    if (clients.isNotEmpty) return; // Don't overwrite existing clients
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
        lastAppointment: DateTime(2025, 4, 1),
        nextAppointment: DateTime(2025, 5, 1),
      ),
      Client(
        name: 'Bob',
        treatment: [treatments.last],
        lastAppointment: DateTime(2025, 3, 20),
      ),
      Client(
        name: 'Charlie',
        treatment: treatments,
        lastAppointment: DateTime(2025, 4, 10),
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


 Widget _buildClientCard(Client client, int index, AppLocalizations l10n) {
  return InkWell(
    onTap: () => _navigateToEditPage(client, index),
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Client info column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      client.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 6,
                      runSpacing: -8,
                      children: client.treatment.map((t) {
                        return Chip(
                          label: Text(t),
                          backgroundColor: Colors.purple.shade50,
                          labelStyle: const TextStyle(fontSize: 12),
                          visualDensity: VisualDensity.compact,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          padding: EdgeInsets.zero,
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              // Next appointment
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Icon(Icons.calendar_today, size: 18, color: Colors.black87),
                  const SizedBox(height: 4),
                  Text(
                    client.nextAppointment != null
                        ? _formatDate(client.nextAppointment!)
                        : l10n.noNextAppointment,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(
          height: 1,
          thickness: 1,
          indent: 16,
          endIndent: 16,
          color: Color(0xFFE0E0E0),
        ),
      ],
    ),
  );
}



  void _showAddClientOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.person_add),
                title: Text(l10n.createNewClient),
                onTap: () async {
                  Navigator.pop(context);
                  final newClient = await Navigator.push<Client>(
                    context,
                    MaterialPageRoute(builder: (_) => const AddClientPage()),
                  );
                  if (newClient != null) {
                    setState(() {
                      clients.add(newClient);
                    });
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.contacts),
                title: Text(l10n.chooseFromContacts),
                onTap: () {
                  Navigator.pop(context);
                  _handlePickFromContacts(); // placeholder
                },
              ),
            ],
          ),
        );
      },
    );
  }
  void _handlePickFromContacts() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Contact picker coming soon...')),
    );
  }

 @override
Widget build(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;

  return Scaffold(
    body: Stack(
      children: [
        // Top half with centered title + subtitle
        Container(
          height: MediaQuery.of(context).size.height / 2,
          color: const Color.fromRGBO(10, 51, 44, 1),
          padding: const EdgeInsets.all(32),
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(height: 25),
              Text(
                l10n.expectedIncomeTitle,
                style: const TextStyle(
                  color: Colors.white,
                   fontSize: 32,
                   fontWeight: FontWeight.w300),
              ),
              const SizedBox(height: 2),
              Text(
                "17,342₪",
                style: const TextStyle(
                  color: Colors.white,
                   fontSize: 48,
                   fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),

        // Persistent draggable bottom sheet
        DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.6,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: ListView.builder(
                controller: scrollController,
                itemCount: clients.length,
                itemBuilder: (context, index) =>
                    _buildClientCard(clients[index], index, l10n),
              ),
            );
          },
        ),
      ],
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: _showAddClientOptions,
      child: const Icon(Icons.add),
    ),
  );
}

}
