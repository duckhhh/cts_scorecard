import 'package:flutter/material.dart';

class RemarksInput extends StatelessWidget {
  final void Function(String) onChanged;
  final String? initialValue;
  const RemarksInput({super.key, required this.onChanged, this.initialValue});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      maxLines: 3,
      decoration: const InputDecoration(
        labelText: 'Remarks',
        border: OutlineInputBorder(),
      ),
      onChanged: onChanged,
    );
  }
}
