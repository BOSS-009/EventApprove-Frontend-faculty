import 'package:flutter/material.dart';
import 'package:faculty_app/utility.dart';


Utility utility = Utility();

class FDDesc extends StatelessWidget {
  final Map<String, dynamic> details;

  const FDDesc({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FDP Details"),
        backgroundColor: const Color(0xff2F4F6F),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            utility.buildDetailRow("FDP Title", details["fdptitle"]!, context),
            utility.buildDetailRow("Mode", details["mode"]!, context),
            utility.buildDetailRow("Brochure", details["brochure"]!, context,
                isDocumentType: true),
            utility.buildDetailRow("Date", details["dates"]!, context),
            utility.buildDetailRow("Number of Days", details["days"]!, context),
            utility.buildDetailRow("GPS Photos", details["gpsmedia"]!, context,
                isDocumentType: true),
            utility.buildDetailRow("Report", details["report"]!, context,
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
            utility.buildDetailRow("Amount Sanctioned",
                details["sanctionedamount"].toString(), context),
            utility.buildDetailRow("Faculty Receiving Sanctioned Amount",
                details["facultyreceivingamount"].toString(), context),
            utility.buildDetailRow("Expenditure Report with Receipts",
                details["expenditurereport"]!, context,
                isDocumentType: true),
            utility.buildDetailRow("Details of Speakers/Resource Persons",
                details["speakersdetails"]!, context),
            utility.buildDetailRow(
                "Sponsorship", details["sponsorship"]!, context),
          ],
        ),
      ),
    );
  }
}
