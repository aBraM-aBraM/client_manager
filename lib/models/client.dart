class Client {
  final String name;
  final List<String> treatment;
  final DateTime lastVisit;
  final DateTime? nextAppointment;

  Client({
    required this.name,
    required this.treatment,
    required this.lastVisit,
    this.nextAppointment,
  });
}
