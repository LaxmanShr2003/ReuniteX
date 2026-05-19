import 'package:flutter/material.dart';

class Sightings extends StatelessWidget {
  const Sightings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sightings")),
      body: ListView(
        children: const [
          ListTile(
            leading: Icon(Icons.visibility),
            title: Text("Possible sighting in Thamel"),
          ),
          ListTile(
            leading: Icon(Icons.visibility),
            title: Text("Reported in Pokhara"),
          ),
        ],
      ),
    );
  }
}