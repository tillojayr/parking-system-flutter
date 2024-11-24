import 'package:flutter/material.dart';
import 'package:parking_system/pages/vehicle-type.dart';
import 'package:parking_system/global.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  String userInput = ''; // Variable to store user input

  // Function to display the input dialog
  Future<void> _showInputDialog(BuildContext context) async {
    TextEditingController textController = TextEditingController(text: ipAddress); // Initialize with the current value
    String? errorText; // Error message for validation

    await showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissal by clicking outside
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text(
                'Enter Your IP Address',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: textController, // Bind the controller to the TextField
                    onChanged: (value) {
                      setState(() {
                        errorText = null; // Clear error message on input
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Enter IP address',
                      border: const OutlineInputBorder(),
                      errorText: errorText, // Show error message if any
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(textController.text.trim());
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      },
    ).then((value) {
      if (value != null && value.toString().isNotEmpty) {
        // Update the parent widget's state with the new IP
        setState(() {
          userInput = value;
          ipAddress = userInput;
        });
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green, // Light green background
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
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
                    Text(
                      'Vehicle Parking System',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[900], // Dark green text
                      ),
                    ),
                    Text(
                      '🚗',
                      style: TextStyle(
                        fontSize: 70,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[900], // Dark green text
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildButton(context, 'Start'),
                  ],
                ),
              ),
            ),
          ),
          // const SizedBox(height: 20), // Add spacing between card and text
          // GestureDetector(
          //   onTap: () {
          //     _showInputDialog(context);
          //   },
          //   child: Container(
          //     width: 300,
          //     padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(8),
          //       color: Colors.white,
          //       border: Border.all(color: Colors.green[700]!),
          //     ),
          //     child: Text(
          //       ipAddress.isNotEmpty
          //           ? 'Current IP: $ipAddress'
          //           : 'Tap to enter IP address',
          //       style: TextStyle(
          //         fontSize: 16,
          //         color: Colors.green[900],
          //       ),
          //       textAlign: TextAlign.center,
          //     ),
          //   ),
          // ),
        ],
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
            MaterialPageRoute(builder: (context) => const VehicleType()),
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
