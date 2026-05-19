
import 'package:flutter/material.dart';

class Reporting extends StatelessWidget {
  const Reporting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Report Missing Case")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(Icons.report, size: 80, color: Colors.red),
            const SizedBox(height: 20),
            const Text(
              "Report a Missing Person",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: const Text("Create Report"),
            )
          ],
        ),
      ),
    );
  }
}