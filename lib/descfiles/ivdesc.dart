import 'package:flutter/material.dart';
import 'package:faculty_app/utility.dart';


Utility utility = Utility();

class IVDesc extends StatelessWidget {
  final Map<String, dynamic> details;

  const IVDesc({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Industrial Visit Details"),
        backgroundColor: const Color(0xff2F4F6F),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            utility.buildDetailRow(
                "Visit Title", details["visittitle"]!, context),
            utility.buildDetailRow(
                "Date of Visit", details["visitdate"]!, context),
            utility.buildDetailRow(
                "Name of the company", details["companyname"]!, context),
            utility.buildDetailRow(
                "Total Days", details["numdays"].toString(), context),
            utility.buildDetailRow(
                "Organizers", details["organizers"]!, context),
            utility.buildDetailRow(
                "Participants List", details["participantslist"]!, context,
                isDocumentType: true),
            utility.buildDetailRow(
                "Industry Type", details["industrytype"]!, context),
            utility.buildDetailRow("Conveners", details["conveners"]!, context),
            utility.buildDetailRow(
                "GPS Photos/Videos", details["gpsmedia"]!, context,
                isDocumentType: true),
            utility.buildDetailRow(
                "Budget", details["budget"].toString(), context),
            utility.buildDetailRow("Report", details["report"]!, context,
                isDocumentType: true),
            utility.buildDetailRow(
                "Feedback from Participants", details["feedback"]!, context,
                isDocumentType: true),
            utility.buildDetailRow(
                "Certificates", details["certificates"]!, context,
                isDocumentType: true),
            utility.buildDetailRow(
                "Speakers", details["speakersdetails"]!, context),
          ],
        ),
      ),
    );
  }
}
