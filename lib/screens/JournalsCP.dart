import 'package:faculty_app/repository.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class JournalsCP extends StatefulWidget {
  const JournalsCP({super.key});

  @override
  _JournalsCPState createState() => _JournalsCPState();
}

class _JournalsCPState extends State<JournalsCP> {
  int _currentStep = 0;

  final List<String> _stepsQuestions = [
    "Enter Authors with Affiliations:",
    "Enter Paper Title:",
    "Enter Abstract:",
    "Enter Journal Name:",
    "Select Publication Level:",
    "Enter Publication Month and Year:",
    "Enter Publisher Name:",
    "Enter DOI/ISBN:",
    "Attach Document:",
    "Enter Link for Proof (Scopus/WoS):",
    "Enter Scopus ID / WoS ID / ORCID ID:",
    "Enter Impact Factor:",
    "Select Quartile (Q1/Q2/Q3/Q4):"
  ];

  final Map<String, dynamic> _currentJournalDetails = {
    "authors": "",
    "paperTitle": "",
    "abstract": "",
    "journalName": "",
    "publicationLevel": "",
    "publicationDate": "",
    "publisher": "",
    "doiIsbn": "",
    "document": null,
    "proofLink": "",
    "identifier": "",
    "impactFactor": "",
    "quartile": "",
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
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _currentJournalDetails['document'] = result.files.first.path;
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
        _currentJournalDetails['publicationDate'] = picked;
      });
    }
  }

  Repository repository = Repository();

  Future<void> _submitJournalDetails() async {
    try {
      final journalData = await repository.createJournalData(
        authors: _currentJournalDetails["authors"],
        paperTitle: _currentJournalDetails["paperTitle"],
        abstract: _currentJournalDetails["abstract"],
        journalName: _currentJournalDetails["journalName"],
        publicationLevel: _currentJournalDetails["publicationLevel"],
        publicationDate: _currentJournalDetails["publicationDate"],
        publisher: _currentJournalDetails["publisher"],
        doiIsbn: _currentJournalDetails["doiIsbn"],
        documentPath: _currentJournalDetails["document"],
        proofLink: _currentJournalDetails["proofLink"],
        impactFactor: _currentJournalDetails["impactFactor"],
        quartile: _currentJournalDetails["quartile"],
        identifier: _currentJournalDetails["identifier"] ?? "",
      );

      await repository.sendEvent(
        eventType: "journals",
        eventName: _currentJournalDetails["paperTitle"],
        additionalData: journalData,
      );

      // Simulate submission
      await Future.delayed(const Duration(seconds: 2));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Journal details submitted successfully!")),
      );

      setState(() {
        _currentStep = 0;
        _currentJournalDetails.clear();
        _resetTextController();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  Widget _buildInputField(String key, String hintText) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller:
            TextEditingController(text: _currentJournalDetails[key] ?? ''),
        onChanged: (value) {
          _currentJournalDetails[key] = value;
        },
        decoration: InputDecoration(
          hintText: hintText,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildRadioButtonField(String key, List<String> options) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: options.map((option) {
          return RadioListTile<String>(
            title: Text(option),
            value: option,
            groupValue: _currentJournalDetails[key],
            onChanged: (value) {
              setState(() {
                _currentJournalDetails[key] = value;
              });
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCurrentStepContent() {
    // Clear text controller when switching to a new step
    _resetTextController();

    switch (_currentStep) {
      case 0:
        return _buildInputField("authors", "Enter Authors with Affiliations");
      case 1:
        return _buildInputField("paperTitle", "Enter Paper Title");
      case 2:
        return _buildInputField("abstract", "Enter Abstract");
      case 3:
        return _buildInputField("journalName", "Enter Journal Name");
      case 4:
        return _buildRadioButtonField(
            "publicationLevel", ["National", "International"]);
      case 5:
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () => _pickDate(context),
            child: const Text("Pick Publication Date"),
          ),
        );
      case 6:
        return _buildInputField("publisher", "Enter Publisher Name");
      case 7:
        return _buildInputField("doiIsbn", "Enter DOI/ISBN");
      case 8:
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: _pickDocument,
            child: const Text("Attach Document"),
          ),
        );
      case 9:
        return _buildInputField("proofLink", "Enter Link for Proof");
      case 10:
        return _buildInputField(
            "identifier", "Enter Scopus ID / WoS ID / ORCID ID");
      case 11:
        return _buildInputField("impactFactor", "Enter Impact Factor");
      case 12:
        return _buildRadioButtonField("quartile", ["Q1", "Q2", "Q3", "Q4"]);
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Journal Submission'),
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
                    )
                  : SizedBox(width: 80), // Empty space to preserve layout

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    print(';sdaodk');
                    if (_currentStep < _stepsQuestions.length - 1) {
                      setState(() {
                        _currentStep++;
                      });
                    } else {
                      _submitJournalDetails();
                    }
                  },
                  child: Text(_currentStep < _stepsQuestions.length - 1
                      ? 'Next Step'
                      : 'Submit'),
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
        children: List.generate(13, (index) {
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
