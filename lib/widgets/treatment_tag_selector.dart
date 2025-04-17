import 'package:flutter/material.dart';
import '../consts.dart';

class TreatmentTagSelector extends StatelessWidget {
  final List<String> selectedTreatments;
  final void Function(List<String>) onChanged;

  const TreatmentTagSelector({
    super.key,
    required this.selectedTreatments,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final allTreatments = Set<String>.from(availableTreatments);
    final selectedSet = Set<String>.from(selectedTreatments);

    final unselected = allTreatments.difference(selectedSet).toList();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        // Selected treatments
        for (var treatment in selectedTreatments)
          Chip(
            label: Text(treatment),
            backgroundColor: Colors.pink.shade100,
            deleteIcon: const Icon(Icons.close),
            onDeleted: () {
              final updated = List<String>.from(selectedTreatments)
                ..remove(treatment);
              onChanged(updated);
            },
          ),

        // Unselected treatments
        for (var treatment in unselected)
          ActionChip(
            label: Text(treatment),
            backgroundColor: Colors.grey.shade200,
            onPressed: () {
              final updated = List<String>.from(selectedTreatments)
                ..add(treatment);
              onChanged(updated);
            },
          ),
      ],
    );
  }
}
