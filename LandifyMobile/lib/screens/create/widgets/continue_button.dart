import 'package:flutter/material.dart';

class ContinueButton extends StatelessWidget {
  final bool isFormValid;
  final VoidCallback onPressed;

  const ContinueButton({super.key, required this.isFormValid, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isFormValid ? onPressed : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade800,
              disabledBackgroundColor: Colors.grey.shade400,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Tiếp tục', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }
}