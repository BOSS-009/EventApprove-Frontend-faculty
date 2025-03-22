import 'package:flutter/material.dart';
import 'package:faculty_app/utility.dart';


Utility utility = Utility();

class EventDesc extends StatefulWidget {
  final Map<String, dynamic> details;

  const EventDesc({super.key, required this.details});

  @override
  State<EventDesc> createState() => _EventDescState();
}

class _EventDescState extends State<EventDesc> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Conference Details"),
        backgroundColor: const Color(0xff2F4F6F),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow("Paper Title", widget.details["papertitle"]!),
            _buildDetailRow("Abstract", widget.details["abstract"]!),
            _buildDetailRow(
                "Conference Name", widget.details["conferencename"]!),
            _buildDetailRow(
                "Publication Level", widget.details["publicationlevel"]!),
            _buildDetailRow(
                "Publication Date", widget.details["publicationdate"]!),
            _buildDetailRow("Publisher", widget.details["publisher"]!),
            _buildDetailRow("DOI, ISBN", widget.details["doiisbn"]!),
            _buildDetailRow("Proof Link", widget.details["prooflink"]!),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final base64Document = widget.details["document"]!;
                utility.viewDocument(
                  base64Document,
                  widget.details["papertitle"] ?? 'Document',
                  context,
                ); // Handle document viewing or downloading
              },
              child: const Text("Download Document"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              "$label:",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
