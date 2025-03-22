import 'package:faculty_app/repository.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class FacultyAchievementsCP extends StatefulWidget {
  const FacultyAchievementsCP({super.key});

  @override
  _FacultyAchievementsCPState createState() => _FacultyAchievementsCPState();
}

class _FacultyAchievementsCPState extends State<FacultyAchievementsCP> {
  int _currentStep = 0;

  final List<String> _stepsQuestions = [
    "Enter Faculty Name",
    "Enter Designation",
    "Pick Date of Achievement",
    "Select Recognition (Best paper presentation, Key note speaker, Patent published, Patent Granted, Book published, Book chapter/Paper published in Scopus/WoS, Chair, Reviewer, Best Thesis award, Resource person, Mentor, SPOC, Quality Publication in Q1 or Q2)",
    "Enter Event Name",
    "Enter Award Name",
    "Enter Awarding Organization",
    "Attach GPS Photo",
    "Attach Report",
    "Attach Proof (Invitation, Email Doc)",
    "Attach Certificate Proof"
  ];

  final Map<String, dynamic> _currentAchievementDetails = {
    "facultyName": "",
    "designation": "",
    "achievementDate": "",
    "recognition": "",
    "eventName": "",
    "awardName": "",
    "awardingOrganization": "",
    "gpsPhoto": null,
    "report": null,
    "proof": null,
    "certificateProof": null,
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

  Future<void> _pickDate(BuildContext context, String key) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _currentAchievementDetails[key] = picked;
      });
    }
  }

  Future<void> _pickDocument(String key) async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _currentAchievementDetails[key] = result.files.first.path;
      });
    }
  }

  Repository repository = Repository();

  Future<void> _submitAchievementDetails() async {
    try {
      final facultyAchievementData =
          await repository.createFacultyAchievementData(
        facultyName: _currentAchievementDetails["facultyName"],
        designation: _currentAchievementDetails["designation"],
        achievementDate: _currentAchievementDetails["achievementDate"],
        recognition: _currentAchievementDetails["recognition"],
        eventName: _currentAchievementDetails["eventName"],
        awardName: _currentAchievementDetails["awardName"],
        awardingOrganization:
            _currentAchievementDetails["awardingOrganization"],
        gpsPhotoPath: _currentAchievementDetails["gpsPhoto"],
        reportPath: _currentAchievementDetails["report"],
        proofPath: _currentAchievementDetails["proof"],
        certificateProofPath: _currentAchievementDetails["certificateProof"],
        identifier: "0",
      );

      await repository.sendEvent(
        eventType: "faculty_achievements",
        eventName: _currentAchievementDetails["eventName"],
        additionalData: facultyAchievementData,
      );

      // Simulate submission
      await Future.delayed(const Duration(seconds: 2));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Achievement details submitted successfully!")),
      );

      setState(() {
        _currentStep = 0;
        _currentAchievementDetails.clear();
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
            TextEditingController(text: _currentAchievementDetails[key] ?? ''),
        onChanged: (value) {
          _currentAchievementDetails[key] = value;
        },
        decoration: InputDecoration(
          hintText: hintText,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildDropdownField(String key, List<String> options) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: DropdownButtonFormField<String>(
        value: _currentAchievementDetails[key] == ""
            ? null
            : _currentAchievementDetails[key], // Ensure a non-null value
        items: options.map((option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Text(option),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _currentAchievementDetails[key] = value ?? "";
          });
        },
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: 'Select $key',
        ),
      ),
    );
  }

  Widget _buildCurrentStepContent() {
    _resetTextController();

    switch (_currentStep) {
      case 0:
        return _buildInputField("facultyName", "Enter Faculty Name");
      case 1:
        return _buildInputField("designation", "Enter Designation");
      case 2:
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () => _pickDate(context, 'achievementDate'),
            child: const Text("Pick Date of Achievement"),
          ),
        );
      case 3:
        return _buildDropdownField("recognition", [
          'Best Paper Presentation',
          'Key Note Speaker',
          'Patent Published',
          'Patent Granted',
          'Book Published',
          'Book Chapter/Paper Published in Scopus/WoS',
          'Chair',
          'Reviewer',
          'Best Thesis Award',
          'Resource Person',
          'Mentor',
          'SPOC',
          'Quality Publication in Q1 or Q2'
        ]);
      case 4:
        return _buildInputField("eventName", "Enter Event Name");
      case 5:
        return _buildInputField("awardName", "Enter Award Name");
      case 6:
        return _buildInputField(
            "awardingOrganization", "Enter Awarding Organization");
      case 7:
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () => _pickDocument('gpsPhoto'),
            child: const Text("Attach GPS Photo"),
          ),
        );
      case 8:
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () => _pickDocument('report'),
            child: const Text("Attach Report"),
          ),
        );
      case 9:
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () => _pickDocument('proof'),
            child: const Text("Attach Proof (Invitation, Email Doc)"),
          ),
        );
      case 10:
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () => _pickDocument('certificateProof'),
            child: const Text("Attach Certificate Proof"),
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Faculty Achievement Submission'),
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
                      _submitAchievementDetails();
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
