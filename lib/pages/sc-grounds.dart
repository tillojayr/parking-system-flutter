import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:parking_system/global.dart';

class ScGrounds extends StatefulWidget {
  const ScGrounds({super.key});

  @override
  State<ScGrounds> createState() => _ScGrounds();
}

class _ScGrounds extends State<ScGrounds> {
  Map<String, dynamic> data = {};
  bool isLoading = true;

  Map<String, dynamic> slotName = {
    "slot1": 'PWD1',
    "slot2": 'PWD2',
    "slot3": 'A1',
    "slot4": 'A2',
    "slot5": 'A3',
    "slot6": 'B1',
    "slot7": 'B2',
    "slot8": 'B3',
    "slot9": 'C1',
    "slot10": 'C2',
    "slot11": 'C3',
    "slot12": 'D1',
    "slot13": 'E1',
    "slot14": 'E2',
    "slot15": 'E3',
    "slot16": 'E4',
    "slot17": 'E5',
    "slot18": 'E6'
  };

  String nearest = 'none';

  late List<String> slots = [];

  final List<String> allSlots = [
    "slot1", "slot2", "slot3", "slot4", "slot5", "slot6",
    "slot7", "slot8", "slot9", "slot10", "slot11", "slot12",
    "slot13", "slot14", "slot15", "slot16", "slot17", "slot18"
  ];

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse('http://$ipAddress/parking-system/index.php'));

      if (response.statusCode == 200) {
        setState(() {
          data = json.decode(response.body);
          slots = isCar ? allSlots.sublist(0, 12) : allSlots.sublist(12, 18);

          for(int i = 0; i < slots.length; i++){
            if(slots[i] != 'slot1' && slots[i] != 'slot2'){
              if(data[slots[i]] == 1){
                nearest = slotName[slots[i]];
                break;
              }
            }
          }
        });
        isLoading = false;
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
      _showErrorMessage('Could not connect to the server. Please check the IP address and your network connection. $e $ipAddress');
    } on FormatException catch (e) {
      // Handle URL parsing issues
      setState(() {
        isLoading = false;
      });
      debugPrint('FormatException: Invalid URL format. Error: $e');
      _showErrorMessage('Invalid URL format. Please check the IP address. $e $ipAddress');
    } catch (e) {
      // Handle other exceptions
      setState(() {
        isLoading = false;
      });
      debugPrint('Unexpected error: $e');
      _showErrorMessage('An unexpected error occurred. Please try again later and make sure the ip address is correct. $e $ipAddress');
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
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green, // Light green background
      body: RefreshIndicator(
        onRefresh: fetchData, // Call the fetchData method to refresh the data
        child: Center(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16.0), // Add padding for better spacing
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isLoading)
                    const CircularProgressIndicator() // Show loader while fetching data
                  else
                    Card(
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
                              'Parking Area - Car - SC Grounds',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Guide:',
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text.rich(
                              TextSpan(
                                text: 'Available ', // Default text
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green, // Dark green for default text
                                ),
                                children: [
                                  TextSpan(
                                    text: '|', // The word to style differently
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black, // Dark green for default text
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' Occupied', // The word to style differently
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red, // Dark green for default text
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GridView.count(
                              shrinkWrap: true, // Allow GridView to size itself
                              physics: const NeverScrollableScrollPhysics(), // Disable scrolling inside GridView
                              crossAxisCount: 4, // 4 buttons per row
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              children: slots.map<Widget>((slot) {
                                return _buildSlotButton(slot);
                              }).toList(), // Convert to List<Widget>
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'Nearest available slot: $nearest',
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }




  Widget _buildSlotButton(String slot) {
    bool isOccupied = data[slot] == 1; // Check if the slot status is 1 (occupied)
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isOccupied ? Colors.green : Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: () {

      },
      child: Text(
        slotName[slot],
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: (slot == 'slot1' || slot == 'slot2') ? 13 : 17
        ),
      ),
    );
  }

}
