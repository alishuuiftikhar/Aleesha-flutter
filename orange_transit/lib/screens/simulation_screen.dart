import 'package:flutter/material.dart';

class SimulationScreen extends StatefulWidget {
  const SimulationScreen({super.key});

  @override
  State<SimulationScreen> createState() => _SimulationScreenState();
}

class _SimulationScreenState extends State<SimulationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffCFEFFF),
      appBar: AppBar(
        title: const Text("Metro Simulation"),
        backgroundColor: Colors.orange,
      ),
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              "assets/images/track.png",
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 80,
            left: 180,
            child: Image.asset(
              "assets/images/station.png",
              width: 220,
            ),
          ),
          Positioned(
            bottom: 75,
            left: 20,
            child: Image.asset(
              "assets/images/train.png",
              width: 250,
            ),
          ),
        ],
      ),
    );
  }
}