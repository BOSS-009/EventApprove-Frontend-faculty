import 'package:flutter/material.dart';
import 'package:faculty_app/utility.dart';


Utility utility = Utility();

class PSDesc extends StatelessWidget {
  final Map<String, dynamic> details;

  const PSDesc({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Professional Society Activity Details"),
        backgroundColor: const Color(0xff2F4F6F),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            utility.buildDetailRow(
                "Society Name", details["societyname"]!, context),
            utility.buildDetailRow("Date", details["activitydate"]!, context),
            utility.buildDetailRow(
                "Activity Type", details["activitytype"]!, context),
            utility.buildDetailRow(
                "Event Type", details["eventtype"]!, context),
            utility.buildDetailRow(
                "Number of Days", details["numberofdays"].toString(), context),
            utility.buildDetailRow(
                "GPS Photos/Videos", details["gpsphotosvideos"]!, context,
                isDocumentType: true),
            utility.buildDetailRow("Budget Sanctioned",
                details["budgetsanctioned"].toString(), context),
            utility.buildDetailRow("Report", details["eventreport"]!, context,
                isDocumentType: true),
            utility.buildDetailRow(
                "Organizers", details["organizers"]!, context),
            utility.buildDetailRow("Conveners", details["conveners"]!, context),
            utility.buildDetailRow("Feedback", details["feedback"]!, context,
                isDocumentType: true),
            utility.buildDetailRow(
                "Participants List", details["participantslist"]!, context,
                isDocumentType: true),
            utility.buildDetailRow(
                "Certificates", details["certificates"]!, context,
                isDocumentType: true),
            utility.buildDetailRow(
                "Speakers Details", details["speakerdetails"]!, context),
          ],
        ),
      ),
    );
  }
}
