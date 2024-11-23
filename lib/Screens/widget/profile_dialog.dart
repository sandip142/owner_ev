import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:owner_ev/Screens/add_evstation.dart';
import 'package:owner_ev/Screens/btm_bar_screen.dart';


class ProfileCompletionScreen extends StatefulWidget {
  final String uid;

  const ProfileCompletionScreen({Key? key, required this.uid}) : super(key: key);

  @override
  _ProfileCompletionScreenState createState() => _ProfileCompletionScreenState();
}

class _ProfileCompletionScreenState extends State<ProfileCompletionScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool _isSaving = false;

  Future<void> _saveProfile() async {
    setState(() {
      _isSaving = true;
    });

    try {
      await FirebaseFirestore.instance.collection('OwnerProfile').doc(widget.uid).set({
        'name': _nameController.text.trim(),
        'mobile': _mobileController.text.trim(),
        'description': _descriptionController.text.trim(),
        'uid': widget.uid,
      });

      // Navigate to StationForm after saving
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) =>  BottomBarScreen(uuid: widget.uid,),),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving profile: $e')),
      );
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Complete Your Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _mobileController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Mobile Number',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            _isSaving
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _saveProfile,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Save Profile', style: TextStyle(fontSize: 18)),
                  ),
          ],
        ),
      ),
    );
  }
}
