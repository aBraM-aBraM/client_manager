import 'package:flutter/material.dart';
import 'models/client.dart';
import 'package:intl/intl.dart';
import 'pages/add_client_page.dart';
import 'pages/edit_client_page.dart';

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
      treatment: 'Hair Coloring',
      lastVisit: DateTime(2025, 4, 1),
      nextAppointment: DateTime(2025, 5, 1),
    ),
    Client(
      name: 'Bob',
      treatment: 'Haircut',
      lastVisit: DateTime(2025, 3, 20),
    ),
    Client(
      name: 'Charlie',
      treatment: 'Beard Trim',
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
              subtitle: Text(
                '${client.treatment} • Last visit: ${formatDate(client.lastVisit)}',
              ),
              trailing: client.nextAppointment != null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.calendar_today, size: 18),
                        Text(formatDate(client.nextAppointment!)),
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
            ),
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