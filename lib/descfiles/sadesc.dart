import 'package:flutter/material.dart';
import 'package:faculty_app/utility.dart';


Utility utility = Utility();

class SADesc extends StatefulWidget {
  final Map<String, dynamic> details;

  const SADesc({super.key, required this.details});

  @override
  State<SADesc> createState() => _SADescState();
}

class _SADescState extends State<SADesc> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Achievement Details"),
        backgroundColor: const Color(0xff2F4F6F),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            utility.buildDetailRow(
                "Names of Students", widget.details["studentnames"]!, context),
            utility.buildDetailRow("USNs", widget.details["usns"]!, context),
            utility.buildDetailRow(
                "Year of Study", widget.details["yearofstudy"]!, context),
            utility.buildDetailRow(
                "Event Type", widget.details["eventtype"]!, context),
            utility.buildDetailRow(
                "Event Title", widget.details["eventtitle"]!, context),
            utility.buildDetailRow("Date of Achievement",
                widget.details["achievementdate"]!, context),
            utility.buildDetailRow("Company/Organization",
                widget.details["companyorganization"]!, context),
            utility.buildDetailRow(
                "Recognition", widget.details["recognition"]!, context),
            utility.buildDetailRow("Certificate Proof",
                widget.details["certificateproof"]!, context,
                isDocumentType: true),
            utility.buildDetailRow(
                "GPS Photo", widget.details["gpsphoto"]!, context,
                isDocumentType: true),
            utility.buildDetailRow("Report", widget.details["report"]!, context,
                isDocumentType: true),
          ],
        ),
      ),
    );
  }
}
