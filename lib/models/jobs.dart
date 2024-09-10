import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Import intl package for date formatting

class Job {
  final Timestamp date;
  final String title;
  final String description;
  final String parish;
  final String jobCategory;
  final String lowerBudget;
  final String upperBudget;
  final String userName;

  Job(
    this.title,
    this.description,
    this.parish,
    this.jobCategory,
    this.date,
    this.lowerBudget,
    this.upperBudget,
    this.userName,
  );

  // Factory constructor to create a Job from Firestore document
  factory Job.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Job(
      data['title'] ?? '',
      data['description'] ?? '',
      data['parish'] ?? '',
      data['jobCategory'] ?? '',
      data['date'] is Timestamp
          ? data['date']
          : Timestamp.now(), // Ensure a valid Timestamp is set
      data['lowerBudget'] ?? '',
      data['upperBudget'] ?? '',
      data['userName'] ?? '',
    );
  }

  // Format the timestamp to a human-readable string
  String get formattedDate {
    DateTime dateTime = date.toDate();
    return DateFormat('MMMM d, y')
        .format(dateTime); // Format as "September 3, 2024"
  }
}
