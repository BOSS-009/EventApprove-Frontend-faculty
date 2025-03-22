import 'package:faculty_app/repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:faculty_app/descfiles/PSdesc.dart';
import 'package:faculty_app/descfiles/bcdesc.dart';
import 'package:faculty_app/descfiles/cadesc.dart';
import 'package:faculty_app/descfiles/confdesc.dart';
import 'package:faculty_app/descfiles/fadesc.dart';
import 'package:faculty_app/descfiles/fddesc.dart';
import 'package:faculty_app/descfiles/ivdesc.dart';
import 'package:faculty_app/descfiles/journaldesc.dart';
import 'package:faculty_app/descfiles/patentdesc.dart';
import 'package:faculty_app/descfiles/sadesc.dart';
import 'package:faculty_app/descfiles/seminardesc.dart';
import 'package:faculty_app/descfiles/wsdesc.dart';

Repository repository = Repository();

class AcceptedAndRejectedView extends StatefulWidget {
  const AcceptedAndRejectedView({super.key});

  @override
  _AcceptedAndRejectedView createState() => _AcceptedAndRejectedView();
}

class _AcceptedAndRejectedView extends State<AcceptedAndRejectedView> {
  late Future<List<Map<String, dynamic>>> _futureData =
      Future.value([]); // Initialize with an empty list

  @override
  void initState() {
    super.initState();
    fetchData(); // Call fetchData to fetch the events.
  }

  Future<void> fetchData() async {
    try {
      // Fetch the data (this could be from an API or local repository)
      var data = await repository.getAllMasterEvents();

      // Explicitly cast the data to List<Map<String, dynamic>>
      var typedData = (data).cast<Map<String, dynamic>>();

      // Set the filtered data in the state
      setState(() {
        _futureData = Future.value(typedData);
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching data: $e");
      }
      setState(() {
        _futureData = Future.error("Failed to load data");
      });
    }
  }

  String getStatus(value) {
    if (value == false) {
      return 'Rejected';
    } else if (value == true) {
      return 'Approved';
    }
    return 'Pending';
  }

  // Function to generate cards based on submission type
  Widget generateCard(BuildContext context, Map<String, dynamic> event) {
    Widget navigateToPage(
        String eventType,
        Future<Map<String, dynamic>> eventDetailsFuture,
        Widget Function(Map<String, dynamic>) pageBuilder) {
      return ListTile(
        title: Text(
          event["event_name"] ?? "No Title",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(event["event_type"] ?? "No Event Type"),
            Text(
              'Submission status: ${getStatus(event["approval"])}',
              style: const TextStyle(
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: () async {
            try {
              // Perform API call to get event details
              var eventDetails = await eventDetailsFuture;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => pageBuilder(eventDetails),
                ),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: $e')),
              );
            }
          },
        ),
      );
    }

    switch (event['event_type']) {
      case 'conference':
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: navigateToPage(
            event['event_type'],
            repository.getEventByMasterId(event['master_id']),
            (details) => EventDesc(details: details),
          ),
        );
      case 'journals':
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: navigateToPage(
            event['event_type'],
            repository.getEventByMasterId(event['master_id']),
            (details) => JournalDesc(details: details),
          ),
        );
      case 'workshop':
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: navigateToPage(
            event['event_type'],
            repository.getEventByMasterId(event['master_id']),
            (details) => WSDesc(details: details),
          ),
        );
      case 'bookchapter':
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: navigateToPage(
            event['event_type'],
            repository.getEventByMasterId(event['master_id']),
            (details) => BCDesc(details: details),
          ),
        );
      case 'patents':
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: navigateToPage(
            event['event_type'],
            repository.getEventByMasterId(event['master_id']),
            (details) => PatentDesc(details: details),
          ),
        );
      case 'fdp':
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: navigateToPage(
            event['event_type'],
            repository.getEventByMasterId(event['master_id']),
            (details) => FDDesc(details: details),
          ),
        );
      case 'seminar':
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: navigateToPage(
            event['event_type'],
            repository.getEventByMasterId(event['master_id']),
            (details) => SeminarDesc(details: details),
          ),
        );
      case 'clubactivity':
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: navigateToPage(
            event['event_type'],
            repository.getEventByMasterId(event['master_id']),
            (details) => CADesc(details: details),
          ),
        );
      case 'industrial_visit':
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: navigateToPage(
            event['event_type'],
            repository.getEventByMasterId(event['master_id']),
            (details) => IVDesc(details: details),
          ),
        );
      case 'faculty_achievements':
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: navigateToPage(
            event['event_type'],
            repository.getEventByMasterId(event['master_id']),
            (details) => FADesc(details: details),
          ),
        );
      case 'student_achievements':
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: navigateToPage(
            event['event_type'],
            repository.getEventByMasterId(event['master_id']),
            (details) => SADesc(details: details),
          ),
        );
      case 'professional_societies':
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: navigateToPage(
            event['event_type'],
            repository.getEventByMasterId(event['master_id']),
            (details) => PSDesc(details: details),
          ),
        );
      default:
        return const SizedBox
            .shrink(); // If no valid submission type, return an empty widget.
    }
  }

  @override
  Widget build(BuildContext context) {
    String title = 'Submissions';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No Submissions'),
            );
          }

          final events = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return generateCard(context,
                  event); // Use the function to generate the correct card
            },
          );
        },
      ),
    );
  }
}
