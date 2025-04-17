import 'package:flutter/material.dart';
import 'models/client.dart';
import 'package:intl/intl.dart';
import 'pages/add_client_page.dart';
import 'pages/edit_client_page.dart';
import 'consts.dart';

void main() {
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Salon Client Manager',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  List<Client> clients = [
    Client(
      name: 'Alice',
      treatment: [availableTreatments[0], availableTreatments[1]],
      lastVisit: DateTime(2025, 4, 1),
      nextAppointment: DateTime(2025, 5, 1),
    ),
    Client(
      name: 'Bob',
      treatment: [availableTreatments.last],
      lastVisit: DateTime(2025, 3, 20),
    ),
    Client(
      name: 'Charlie',
      treatment: availableTreatments,
      lastVisit: DateTime(2025, 4, 10),
      nextAppointment: DateTime(2025, 4, 25),
    ),
  ];

  String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Salon Client Manager'),
      ),
      body: ListView.builder(
        itemCount: clients.length,
        itemBuilder: (context, index) {
          final client = clients[index];
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
        'Last visit: ${formatDate(client.lastVisit)}',
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
              formatDate(client.nextAppointment!),
              style: const TextStyle(fontSize: 12),
            ),
          ],
        )
      : const Text('No next appt.'),
  onTap: () async {
    final result = await Navigator.push<ClientAction>(
      context,
      MaterialPageRoute(
        builder: (_) => EditClientPage(client: client),
      ),
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
  },
)
,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(onPressed: () async {
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
      child: const Icon(Icons.add),
      ),
    );
  }
}