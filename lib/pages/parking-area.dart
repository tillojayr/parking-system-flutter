import 'package:flutter/material.dart';
import 'package:parking_system/pages/sc-grounds.dart';

class ParkingArea extends StatelessWidget {
  const ParkingArea({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green, // Light green background
      body: Center(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Choose Parking Area',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                _buildButton(context, 'SC Grounds'),
                const SizedBox(height: 10),
                _buildButton(context, 'SB Grounds'),
                const SizedBox(height: 10),
                _buildButton(context, 'LSU-IS'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String title) {
    return SizedBox(
      width: 250, // Fixed width
      height: 50, // Fixed height
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green[700], // Dark green button color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ScGrounds()),
          );
        },
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white, // Button text color
          ),
        ),
      ),
    );
  }
}
