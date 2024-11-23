import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String userId;
  Map<String, dynamic>? profileData;

  @override
  void initState() {
    super.initState();
    // Get the current user ID
    userId = FirebaseAuth.instance.currentUser!.uid;
    _fetchProfileData();
  }

  // Fetch profile data from Firestore
  Future<void> _fetchProfileData() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('OwnerProfile')
          .doc(userId)
          .get();

      if (snapshot.exists) {
        setState(() {
          profileData = snapshot.data() as Map<String, dynamic>?;
        });
      }
    } catch (e) {
      print("Error fetching profile: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Navigate to Profile Edit screen (you can create this if needed)
              // Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileEditScreen()));
            },
          ),
        ],
      ),
      body: profileData == null
          ? const Center(child: CircularProgressIndicator()) // Show loader while fetching data
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Name: ${profileData?['name'] ?? 'N/A'}', style: Theme.of(context).textTheme.titleLarge),
                  SizedBox(height: 16),
                  Text('Mobile: ${profileData?['mobile'] ?? 'N/A'}', style: Theme.of(context).textTheme.titleLarge),
                  SizedBox(height: 16),
                  Text('Description: ${profileData?['description'] ?? 'N/A'}', style: Theme.of(context).textTheme.bodyLarge),
                ],
              ),
            ),
    );
  }
}
