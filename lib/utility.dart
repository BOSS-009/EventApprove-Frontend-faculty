import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';

class Utility {
  Future<void> viewDocument(
      String base64PDF, String fileName, BuildContext context) async {
    try {
      // Decode the Base64 string to bytes
      Uint8List bytes = base64Decode(base64PDF);
      String fileExtension;

      // Detect the MIME type from the bytes
      String? mimeType = lookupMimeType('', headerBytes: bytes);
      fileExtension = mimeType.split('/').last;
    
      // Get the Downloads directory
      final downloadsDir = await getDownloadsDirectory();
      if (downloadsDir == null) {
        throw 'Downloads directory not found';
      }

      // Create a file path in the Downloads directory
      final filePath = '${downloadsDir.path}/$fileName.$fileExtension';

      // Write the bytes to a file
      final file = File(filePath);
      await file.writeAsBytes(bytes);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('File saved to Downloads: $fileName.$fileExtension')),
      );
    } catch (e) {
      debugPrint('Error viewing document: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving document: $e')),
      );
    }
  }

  Future<Directory?> getDownloadsDirectory() async {
    if (Platform.isWindows) {
      return Directory('${Platform.environment['USERPROFILE']}\\Downloads');
    } else if (Platform.isLinux || Platform.isMacOS) {
      return Directory('${Platform.environment['HOME']}/Downloads');
    }
    return null;
  }

  Widget buildDetailRow(String label, String value, BuildContext context,
      {bool isDocumentType = false}) {
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
            child: Visibility(
              visible: !isDocumentType,
              replacement: Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton(
                  onPressed: () {
                    viewDocument(
                      value,
                      label,
                      context,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Document downloaded successfully!"),
                      ),
                    );
                  },
                  child: const Text("Download Attachment"),
                ),
              ),
              child: Text(
                value,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
