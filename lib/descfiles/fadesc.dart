import 'package:flutter/material.dart';
import 'package:faculty_app/utility.dart';


Utility utility = Utility();

class FADesc extends StatelessWidget {
  final Map<String, dynamic> details;

  const FADesc({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Achievement Details"),
        backgroundColor: const Color(0xff2F4F6F),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            utility.buildDetailRow(
                "Faculty Name", details["facultyname"]!, context),
            utility.buildDetailRow(
                "Designation", details["designation"]!, context),
            utility.buildDetailRow(
                "Date of Achievement", details["achievementdate"]!, context),
            utility.buildDetailRow(
                "Recognition", details["recognition"]!, context),
            utility.buildDetailRow(
                "Event Name", details["eventname"]!, context),
            utility.buildDetailRow(
                "Award Name", details["awardname"]!, context),
            utility.buildDetailRow("Awarding Organization",
                details["awardingorganization"]!, context),
            utility.buildDetailRow("GPS Photo", details["gpsphoto"]!, context,
                isDocumentType: true),
            utility.buildDetailRow("Report", details["report"]!, context,
                isDocumentType: true),
            utility.buildDetailRow("Proof", details["proof"]!, context,
                isDocumentType: true),
            utility.buildDetailRow(
                "Certificates", details["certificateproof"]!, context,
                isDocumentType: true),
          ],
        ),
      ),
    );
  }
}
