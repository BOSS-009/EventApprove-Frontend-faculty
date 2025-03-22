import 'dart:developer';
import 'package:faculty_app/repository.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

Repository repository = Repository();

class ConferencesCP extends StatefulWidget {
  const ConferencesCP({super.key});

  @override
  _ConferencesCPState createState() => _ConferencesCPState();
}

class _ConferencesCPState extends State<ConferencesCP> {
  int _currentStep = 0;

  final List<String> _stepsQuestions = [
    "Enter Paper Title: *",
    "Enter Abstract: *",
    "Enter Conference Name: *",
    "Select Publication Level: *",
    "Enter Publication Month and Year: *",
    "Enter Publisher Name: *",
    "Enter DOI/ISBN: *",
    "Attach Document: *",
    "Enter Link for Proof (Scopus/WoS): *",
    "Enter Scopus ID / WoS ID / ORCID ID: *"
  ];

  final Map<String, dynamic> _currentConferenceDetails = {
    "paperTitle": "",
    "abstract": "",
    "conferenceName": "",
    "publicationLevel": "",
    "publicationDate": "",
    "publisher": "",
    "doiIsbn": "",
    "document": null,
    "proofLink": "",
    "identifier": "",
  };

  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _resetTextController() {
    _textController.clear();
  }

  Future<void> _pickDocument() async {
    final result = await FilePicker.platform.pickFiles(
        // type: FileType.custom,
        // allowedExtensions: ['pdf'], // Restrict to only PDF files
        );

    if (result != null) {
      setState(() {
        _currentConferenceDetails['document'] = result.files.first.path;
      });
    }
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _currentConferenceDetails['publicationDate'] =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _submitConferenceDetails() async {
    try {
      // Simulate submission
      final conferenceData = await repository.createConferenceData(
          paperTitle: _currentConferenceDetails["paperTitle"],
          abstract: _currentConferenceDetails["abstract"],
          conferenceName: _currentConferenceDetails["conferenceName"],
          publicationLevel: _currentConferenceDetails["publicationLevel"],
          publicationDate: _currentConferenceDetails["publicationDate"],
          publisher: _currentConferenceDetails["publisher"],
          doiIsbn: _currentConferenceDetails["doiIsbn"],
          documentPath: _currentConferenceDetails["document"],
          identifier: _currentConferenceDetails["identifier"] ?? "",
          proofLink: _currentConferenceDetails["proofLink"]);
      log('$conferenceData');
      await repository.sendEvent(
        eventType: "conference",
        eventName: _currentConferenceDetails["paperTitle"],
        additionalData: conferenceData,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Conference details submitted successfully!")),
      );
      print('$_currentConferenceDetails');
      print('skaodfpjrfiweoouytw4ire8otyhtgjdbs,gstujghrgujkbsdfgs');

      setState(() {
        _currentStep = 0;
        _currentConferenceDetails.clear();
        _resetTextController();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  bool _isCurrentStepValid() {
    switch (_currentStep) {
      case 0:
        return true;
      case 1:
        return _currentConferenceDetails["abstract"]?.trim().isNotEmpty ??
            false;
      case 2:
        return _currentConferenceDetails["conferenceName"]?.trim().isNotEmpty ??
            false;
      case 3:
        return _currentConferenceDetails["publicationLevel"]?.isNotEmpty ??
            false;
      case 4:
        return _currentConferenceDetails["publicationDate"]?.isNotEmpty ??
            false;
      case 5:
        return _currentConferenceDetails["publisher"]?.trim().isNotEmpty ??
            false;
      case 6:
        return _currentConferenceDetails["doiIsbn"]?.trim().isNotEmpty ?? false;
      case 7:
        return _currentConferenceDetails["document"] != null;
      case 8:
        return _currentConferenceDetails["proofLink"]?.trim().isNotEmpty ??
            false;
      case 9:
        return _currentConferenceDetails["identifier"]?.trim().isNotEmpty ??
            false;
      default:
        return false;
    }
  }

  Widget _buildInputField(String key, String hintText) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller:
            TextEditingController(text: _currentConferenceDetails[key] ?? ''),
        onChanged: (value) {
          setState(() {
            _currentConferenceDetails[key] = value;
          });
        },
        decoration: InputDecoration(
          hintText: hintText,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildCurrentStepContent() {
    // Clear text controller when switching to a new step
    _resetTextController();

    switch (_currentStep) {
      case 0:
        return _buildInputField("paperTitle", "Enter Paper Title");
      case 1:
        return _buildInputField("abstract", "Enter Abstract");
      case 2:
        return _buildInputField("conferenceName", "Enter Conference Name");
      case 3:
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Select an option:", style: TextStyle(fontSize: 16)),
              SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: ['National', 'International'].map((level) {
                  bool isSelected =
                      _currentConferenceDetails['publicationLevel'] == level;
                  return ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _currentConferenceDetails['publicationLevel'] = level;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSelected ? Colors.blue : null,
                      foregroundColor: isSelected ? Colors.white : null,
                      side: BorderSide(
                        color: isSelected ? Colors.blue : Colors.grey,
                        width: 2,
                      ),
                    ),
                    child: Text(level),
                  );
                }).toList(),
              ),
              if (_currentConferenceDetails['publicationLevel']?.isNotEmpty ??
                  false)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    "Selected: ${_currentConferenceDetails['publicationLevel']}",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        );
      case 4:
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 200,
                child: ElevatedButton(
                  onPressed: () => _pickDate(context),
                  child: const Text("Pick Publication Date"),
                ),
              ),
              SizedBox(height: 16),
              if (_currentConferenceDetails['publicationDate']?.isNotEmpty ??
                  false)
                Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.calendar_today, color: Colors.blue, size: 18),
                      SizedBox(width: 8),
                      Text(
                        "Selected date: ${_currentConferenceDetails['publicationDate']}",
                        style: TextStyle(
                          color: Colors.blue[800],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      case 5:
        return _buildInputField("publisher", "Enter Publisher Name");
      case 6:
        return _buildInputField("doiIsbn", "Enter DOI/ISBN");
      case 7:
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                width: 200, // Fixed width to avoid elongated button
                child: ElevatedButton(
                  onPressed: _pickDocument,
                  child: const Text("Attach Document"),
                ),
              ),
              const SizedBox(height: 10),
              if (_currentConferenceDetails['document'] != null)
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    "Selected file: ${_currentConferenceDetails['document'].toString().split('/').last}",
                    style: const TextStyle(color: Colors.black87),
                  ),
                ),
            ],
          ),
        );
      case 8:
        return _buildInputField("proofLink", "Enter Link for Proof");
      case 9:
        return _buildInputField(
            "identifier", "Enter Scopus ID / WoS ID / ORCID ID");
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conference Submission'),
      ),
      body: Column(
        children: [
          ProposalStepsWidget(currentStep: _currentStep),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              _stepsQuestions[_currentStep],
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xff2F4F6F),
              ),
            ),
          ),
          Expanded(child: _buildCurrentStepContent()),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Show either the Previous Step button or an empty SizedBox
              _currentStep > 0
                  ? Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        width: 140, // Fixed width to avoid elongated button
                        child: ElevatedButton(
                          onPressed: () {
                            if (_currentStep > 0) {
                              setState(() {
                                _currentStep--;
                              });
                            }
                          },
                          child: Text('Previous Step'),
                        ),
                      ),
                    )
                  : SizedBox(width: 80), // Empty space to preserve layout

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  width: 120, // Fixed width to avoid elongated button
                  child: ElevatedButton(
                    onPressed: () {
                      if (_currentStep < _stepsQuestions.length - 1) {
                        if (_isCurrentStepValid()) {
                          setState(() {
                            _currentStep++;
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text("Please fill in the required field"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      } else {
                        if (_isCurrentStepValid()) {
                          _submitConferenceDetails();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text("Please fill in the required field"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                    child: Text(_currentStep < _stepsQuestions.length - 1
                        ? 'Next Step'
                        : 'Submit'),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class ProposalStepsWidget extends StatelessWidget {
  final int currentStep;

  const ProposalStepsWidget({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: List.generate(10, (index) {
          return Expanded(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor:
                      currentStep == index ? Colors.blue : Colors.grey,
                  child: Text(
                    (index + 1).toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                Text(
                  'Step ${index + 1}',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
