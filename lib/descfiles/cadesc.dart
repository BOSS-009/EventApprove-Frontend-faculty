import 'package:flutter/material.dart';
import 'package:faculty_app/utility.dart';

Utility utility = Utility();

class CADesc extends StatelessWidget {
  final Map<String, dynamic> details;

  const CADesc({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Club Activity Details"),
        backgroundColor: const Color(0xff2F4F6F),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            utility.buildDetailRow(
                "Club Name", details["clubname"] ?? "N/A", context),
            utility.buildDetailRow(
                "Activity Type", details["activitytype"] ?? "N/A", context),
            utility.buildDetailRow("Title", details["title"] ?? "N/A", context),
            utility.buildDetailRow(
                "Date", details["activitydate"] ?? "N/A", context),
            utility.buildDetailRow("Number of Days",
                details["numdays"]?.toString() ?? "0", context),
            utility.buildDetailRow(
                "GPS Photos/Videos", details["gpsmedia"] ?? "N/A", context,
                isDocumentType: true),
            utility.buildDetailRow("Budget Sanctioned",
                details["budget"]?.toString() ?? "0", context),
            utility.buildDetailRow(
                "Report", details["report"] ?? "N/A", context,
                isDocumentType: true),
            utility.buildDetailRow(
                "Organizers", details["organizers"] ?? "N/A", context),
            utility.buildDetailRow(
                "Conveners", details["conveners"] ?? "N/A", context),
            utility.buildDetailRow(
                "Feedback", details["feedback"] ?? "N/A", context,
                isDocumentType: true),
            utility.buildDetailRow("Participants List",
                details["participantslist"] ?? "N/A", context,
                isDocumentType: true),
            utility.buildDetailRow(
                "Certificates", details["certificates"] ?? "N/A", context,
                isDocumentType: true),
            utility.buildDetailRow("Speakers Details",
                details["speakersdetails"] ?? "N/A", context),
          ],
        ),
      ),
    );
  }
}
