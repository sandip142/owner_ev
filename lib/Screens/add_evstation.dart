import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:owner_ev/Screens/station_map_page';

class StationForm extends StatefulWidget {
  final String userUuid; // Add this to pass the user's UUID

  const StationForm({super.key,required this.userUuid});

  @override
  _StationFormState createState() => _StationFormState();
}

class _StationFormState extends State<StationForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _stationNameController = TextEditingController();
  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _contactNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _powerOutputController = TextEditingController();
  final TextEditingController _numChargersController = TextEditingController();

  // Fields for location
  double? _latitude;
  double? _longitude;

  // Initial values
  String _selectedCategory = 'Two Wheeler';
  String _selectedChargerType = 'AC Charger';
  bool _isBook = false;
  bool _isLoading = false;
  bool _isVerified=false;

  // Save the station data to Firebase and create a 'ports' subcollection
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() && _latitude != null && _longitude != null) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Prepare station data
        final stationData = {
          'stationName': _stationNameController.text,
          'stationAddress': _addressController.text,
          'latitude': _latitude,
          'longitude': _longitude,
          'ownerName': _ownerNameController.text,
          'contactNumber': _contactNumberController.text,
          'chargerType': _selectedChargerType,
          'numberOfChargers': int.parse(_numChargersController.text),
          'powerOutput': double.parse(_powerOutputController.text),
          'isBook': _isBook,
          'category': _selectedCategory,
          'userUuid': widget.userUuid,
          'isVerified':_isVerified // Include the user's UUID
        };

        // Add station data to Firebase
        DocumentReference stationRef = await FirebaseFirestore.instance.collection('stations').add(stationData);

        // Fetch number of chargers
        int numberOfChargers = int.parse(_numChargersController.text);

        // Create subcollection 'ports' for chargers
        for (int i = 1; i <= numberOfChargers; i++) {
          String standId = 'stand$i';
          await stationRef.collection('ports').doc(standId).set({
            'standNumber': i,
            'busy': false, // Initial status is not busy
          });
        }

        // Success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Station and chargers added successfully!')),
        );

        // Reset form after submission
        _formKey.currentState?.reset();
        _latitude = null;
        _longitude = null;
        _addressController.clear();
      } catch (e) {
        print('Error adding station: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add station. Please try again!')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields and select a location on the map!')),
      );
    }
  }

  Future<void> _pickLocationOnMap() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StationMapPage(),
      ),
    );

    if (result != null) {
      setState(() {
        _latitude = result['latitude'];
        _longitude = result['longitude'];
        _addressController.text = result['address'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                _buildTextField('Station Name', _stationNameController),
                _buildTextField('Owner Name', _ownerNameController),
                _buildTextField(
                  'Contact Number',
                  _contactNumberController,
                  isNumber: true,
                  validator: (value) {
                    if (value == null || value.length != 10) {
                      return 'Enter a valid 10-digit phone number';
                    }
                    return null;
                  },
                ),
                GestureDetector(
                  onTap: _pickLocationOnMap,
                  child: AbsorbPointer(
                    child: _buildTextField('Station Address', _addressController),
                  ),
                ),
                _buildTextField(
                  'Number of Chargers',
                  _numChargersController,
                  isNumber: true,
                  validator: (value) {
                    if (value == null || int.tryParse(value) == null) {
                      return 'Enter a valid number';
                    }
                    return null;
                  },
                ),
                _buildTextField(
                  'Power Output (kW)',
                  _powerOutputController,
                  isNumber: true,
                  validator: (value) {
                    if (value == null || double.tryParse(value) == null) {
                      return 'Enter a valid power output';
                    }
                    return null;
                  },
                ),
                _buildDropdown(
                  'Category',
                  ['Two Wheeler', 'Four Wheeler', 'Both'],
                  (value) {
                    setState(() {
                      _selectedCategory = value!;
                    });
                  },
                  _selectedCategory,
                ),
                _buildDropdown(
                  'Charger Type',
                  ['AC Charger', 'DC Charger'],
                  (value) {
                    setState(() {
                      _selectedChargerType = value!;
                    });
                  },
                  _selectedChargerType,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Add EV Station'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_isLoading)
          Center(
            child: SpinKitFadingFour(
              color: Colors.green,
              size: 50.0,
            ),
          ),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool isNumber = false, String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        validator: validator ??
            (value) {
              if (value == null || value.isEmpty) {
                return '$label is required';
              }
              return null;
            },
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, ValueChanged<String?> onChanged, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        items: items.map((item) {
          return DropdownMenuItem(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
