// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Hair Salon';

  @override
  String get addClient => 'Add Client';

  @override
  String get treatmentsTitle => 'Treatments';

  @override
  String get treatmentHaircut => 'Haircut';

  @override
  String get treatmentColoring => 'Hair Coloring';

  @override
  String get treatmentProduct => 'Hair Product';

  @override
  String get lastVisit => 'Last visit';

  @override
  String get nextVisit => 'Next visit';

  @override
  String get noNextAppointment => 'No next appointment';

  @override
  String get pickLastAppointment => 'Pick Last Appointment';

  @override
  String get pickNextAppointment => 'Pick Next Appointment';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get nameTitle => 'Name';

  @override
  String get nameValidator => 'Enter Name';
}
