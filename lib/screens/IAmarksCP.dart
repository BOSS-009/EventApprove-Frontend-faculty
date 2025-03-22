import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart'; // Correct import for file_picker

class IAmarksCP extends StatelessWidget {
  const IAmarksCP({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "IA Marks",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xff2F4F6F),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Upload Your IA Marks",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xff2F4F6F),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Refer to the demo Excel file below and upload your own file.",
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 20),

            // Demo File Preview Section
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.file_download,
                    color: Color(0xff2F4F6F), size: 32),
                title: const Text(
                  "Demo IA Report.xlsx",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff2F4F6F),
                  ),
                ),
                onTap: () {
                  // Add functionality to download the demo file here
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Demo file clicked')),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // Upload Button
            ElevatedButton.icon(
              onPressed: () async {
                // File Picker
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['xls', 'xlsx'],
                );

                if (result != null) {
                  // Success message
                  final filePath = result.files.single.path;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('File uploaded: $filePath')),
                  );
                } else {
                  // Error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No file selected')),
                  );
                }
              },
              icon: const Icon(Icons.upload_file),
              label: const Text(
                "Upload IA Report",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff2F4F6F),
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Submit Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle submit action
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Document submitted successfully!')),
                  );
                },
                child: const Text(
                  "Submit Document",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
