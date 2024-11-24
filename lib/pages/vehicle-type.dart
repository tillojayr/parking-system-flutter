import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:parking_system/pages/parking-area.dart';
import 'package:parking_system/global.dart';

class VehicleType extends StatefulWidget {
  const VehicleType({super.key});

  @override
  State<VehicleType> createState() => _VehicleType();
}

class _VehicleType extends State<VehicleType> {
  Map<String, dynamic> data = {};
  bool isLoading = true;

  bool pwd = true;

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse('http://$ipAddress/parking-system/index.php'));

      if (response.statusCode == 200) {
        setState(() {
          data = json.decode(response.body);
          if(data['slot1'] == 0 && data['slot2'] == 0){
            pwd = false;
          }
          else{
            pwd = true;
          }
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        debugPrint('Error: ${response.statusCode}');
      }
    } on SocketException catch (e) {
      // Handle incorrect IP or network issues
      setState(() {
        isLoading = false;
      });
      debugPrint('SocketException: Could not connect to the server. Error: $e');
      _showErrorMessage(
          'Could not connect to the server. Please check the IP address and your network connection. $e $ipAddress');
    } on FormatException catch (e) {
      // Handle URL parsing issues
      setState(() {
        isLoading = false;
      });
      debugPrint('FormatException: Invalid URL format. Error: $e');
      _showErrorMessage(
          'Invalid URL format. Please check the IP address. $e $ipAddress');
    } catch (e) {
      // Handle other exceptions
      setState(() {
        isLoading = false;
      });
      debugPrint('Unexpected error: $e');
      _showErrorMessage(
          'An unexpected error occurred. Please try again later and make sure the ip address is correct. $e $ipAddress');
    }
  }

    void _showErrorMessage(String message) {
      // Replace this with your desired error display mechanism (e.g., Snackbar, Dialog, etc.)
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }

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
                  'Choose Vehicle Type',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 25),
                Text.rich(
                  TextSpan(
                    text: 'PWD Parking: ', // Default text
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(
                        text: !isLoading ? (pwd ? 'Available' : 'Not available') : 'Loading...', // The word to style differently
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: !isLoading ? (pwd ? Colors.green[900] : Colors.red) : Colors.black
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _buildButton(context, 'Car'),
                const SizedBox(height: 10),
                _buildButton(context, 'Motorcycle'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchData();
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
            MaterialPageRoute(builder: (context) => const ParkingArea()),
          );
          title == 'Car' ? isCar = true : isCar = false;
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
