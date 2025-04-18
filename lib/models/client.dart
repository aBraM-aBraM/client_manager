class Client {
  final String name;
  final List<String> treatment;
  final DateTime lastAppointment;
  final DateTime? nextAppointment;

  Client({
    required this.name,
    required this.treatment,
    required this.lastAppointment,
    this.nextAppointment,
  });
}
