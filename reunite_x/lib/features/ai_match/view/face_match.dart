import 'package:flutter/material.dart';

class AI_Match extends StatelessWidget {
  const AI_Match({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AI Match System")),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.face_retouching_natural, size: 80),
            SizedBox(height: 10),
            Text(
              "AI Matching Screen",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Text("Upload image to search missing persons"),
          ],
        ),
      ),
    );
  }
}