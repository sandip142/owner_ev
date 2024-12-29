import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OwnerBookingScreen extends StatelessWidget {
  final String userUuid;

  const OwnerBookingScreen({Key? key, required this.userUuid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('booking')
              .where('stationId', isEqualTo: userUuid) // Filter by userUuid
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text('No bookings available for your stations.'),
              );
            }

            final bookings = snapshot.data!.docs;

            return ListView.builder(
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                final bookingData = booking.data() as Map<String, dynamic>;

                return Card(
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Booking ID: ${booking.id}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildRow('Name:', bookingData['name']),
                        _buildRow('Mobile Number:', bookingData['mobileNumber']),
                        _buildRow('Station Name:', bookingData['stationName']),
                        _buildRow('Stand Number:', bookingData['standNumber']),
                        _buildRow('Vehicle Type:', bookingData['vehicleType']),
                        _buildRow('Vehicle Model:', bookingData['vehicleModel']),
                        _buildRow('Vehicle Plate Number:', bookingData['vehiclePlateNumber']),
                        _buildRow('Start Time:', bookingData['startTime']),
                        _buildRow('End Time:', bookingData['endTime']),
                        _buildRow('Booking Date:', bookingData['bookingDate']),
                        _buildRow('Amount:', '\$${bookingData['amount']}'),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                // Handle the action for verifying or managing the booking
                                // For example, navigate to another screen to modify the booking
                              },
                              child: const Text('Manage Booking'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '$label ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value.toString(),
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
