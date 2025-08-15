import 'package:flutter/material.dart';

class AddRowButton extends StatelessWidget {
  final bool enabled;
  final VoidCallback onPressed;
  const AddRowButton({super.key, required this.enabled, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: FilledButton.icon(
        onPressed: enabled ? onPressed : null,
        icon: const Icon(Icons.add),
        label: const Text('Add Row'),
      ),
    );
  }
}
