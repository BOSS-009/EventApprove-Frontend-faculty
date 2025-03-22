import 'package:faculty_app/repository.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class BookChapterCP extends StatefulWidget {
  const BookChapterCP({super.key});

  @override
  _BookChapterCPState createState() => _BookChapterCPState();
}

class _BookChapterCPState extends State<BookChapterCP> {
  int _currentStep = 0;

  final List<String> _stepsQuestions = [
    "Enter Authors with Affiliations:",
    "Enter Paper Title:",
    "Enter Abstract:",
    "Enter Journal Name:",
    "Select Publication Level:",
    "Enter Publication Month and Year:",
    "Enter Publisher Name:",
    "Enter DOI:",
    "Attach Document:",
    "Enter Link for Proof (Scopus/WoS/Sci/PubMed):",
    "Enter Scopus ID / WoS ID / ORCID ID:"
  ];

  final Map<String, dynamic> _currentBookChapterDetails = {
    "authors": "",
    "paperTitle": "",
    "abstract": "",
    "journalName": "",
    "publicationLevel": "",
    "publicationDate": "",
    "publisher": "",
    "doi": "",
    "document": null,
    "proofLink": "",
    "identifier": ""
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
        _currentBookChapterDetails['document'] = result.files.first.path;
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
        _currentBookChapterDetails['publicationDate'] = picked;
      });
    }
  }

  Repository repository = Repository();

  Future<void> _submitBookChapterDetails() async {
    try {
      // Simulate submission
      final bookChapterData = await repository.createBookChapterData(
        authors: _currentBookChapterDetails["authors"],
        paperTitle: _currentBookChapterDetails["paperTitle"],
        abstract: _currentBookChapterDetails["abstract"],
        journalName: _currentBookChapterDetails["journalName"],
        publicationLevel: _currentBookChapterDetails["publicationLevel"],
        publicationDate: _currentBookChapterDetails["publicationDate"],
        publisher: _currentBookChapterDetails["publisher"],
        doi: _currentBookChapterDetails["doi"],
        documentPath:
            _currentBookChapterDetails["document"], // Optional, can be null
        proofLink: _currentBookChapterDetails["proofLink"],
        identifier: _currentBookChapterDetails["identifier"] ?? "",
      );

      await repository.sendEvent(
        eventType: "bookchapter",
        eventName: _currentBookChapterDetails["paperTitle"],
        additionalData: bookChapterData,
      );

      await Future.delayed(const Duration(seconds: 2));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Book Chapter details submitted successfully!")),
      );

      setState(() {
        _currentStep = 0;
        _currentBookChapterDetails.clear();
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
            TextEditingController(text: _currentBookChapterDetails[key] ?? ''),
        onChanged: (value) {
          _currentBookChapterDetails[key] = value;
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
            groupValue: _currentBookChapterDetails[key],
            onChanged: (value) {
              setState(() {
                _currentBookChapterDetails[key] = value;
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
        return _buildInputField("doi", "Enter DOI");
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
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Chapter/Published Submission'),
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
                      _submitBookChapterDetails();
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
        children: List.generate(11, (index) {
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
