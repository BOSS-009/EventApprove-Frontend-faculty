import 'dart:developer';

import 'package:faculty_app/repository.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class FDPCP extends StatefulWidget {
  const FDPCP({super.key});

  @override
  _FDPCPState createState() => _FDPCPState();
}

class _FDPCPState extends State<FDPCP> {
  int _currentStep = 0;

  final List<String> _stepsQuestions = [
    "Enter FDP Title:",
    "Select Mode of FDP:",
    "Attach Brochure:",
    "Select Dates (From - To):",
    "Enter Number of Days:",
    "Attach GPS Photos/Videos with Captions:",
    "Attach Report:",
    "Enter Organizers' Details:",
    "Enter Conveners' Details:",
    "Attach Feedback from Participants:",
    "Attach Participants List with Signatures:",
    "Attach Certificates (Soft Copy):",
    "Enter Amount Sanctioned:",
    "Enter Faculty Receiving Sanctioned Amount:",
    "Attach Expenditure Report with Receipts:",
    "Enter Details of Speakers/Resource Persons:",
    "Enter Sponsorship Details:",
  ];

  final Map<String, dynamic> _currentFDPDetails = {
    "fdpTitle": "",
    "mode": "",
    "brochure": null,
    "dates": {"from": "", "to": ""},
    "days": "",
    "gpsMedia": null,
    "report": null,
    "organizers": "",
    "conveners": "",
    "feedback": null,
    "participantsList": null,
    "certificates": null,
    "sanctionedAmount": "",
    "facultyReceivingAmount": "",
    "expenditureReport": null,
    "speakersDetails": "",
    "sponsorship": "",
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
        _currentFDPDetails[key] =
            "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Future<void> _pickDocument(String key) async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _currentFDPDetails[key] = result.files.first.path;
      });
    }
  }

  Repository repository = Repository();

  Future<void> _submitFDPDetails() async {
    String from = _currentFDPDetails["dates.from"];
    String to = _currentFDPDetails["dates.to"];
    String datesString =
        from.isEmpty && to.isEmpty ? "No dates available" : "$from - $to";
    try {
      final fdpData = await repository.createFDPData(
        fdpTitle: _currentFDPDetails["fdpTitle"],
        mode: _currentFDPDetails["mode"],
        brochurePath: _currentFDPDetails["brochure"],
        dates: datesString,
        days: _currentFDPDetails["days"],
        gpsMediaPath: _currentFDPDetails["gpsMedia"],
        reportPath: _currentFDPDetails["report"],
        organizers: _currentFDPDetails["organizers"],
        conveners: _currentFDPDetails["conveners"],
        feedbackPath: _currentFDPDetails["feedback"],
        participantsListPath: _currentFDPDetails["participantsList"],
        certificatesPath: _currentFDPDetails["certificates"],
        sanctionedAmount: (_currentFDPDetails["sanctionedAmount"]),
        facultyReceivingAmount: (_currentFDPDetails["facultyReceivingAmount"]),
        expenditureReportPath: _currentFDPDetails["expenditureReport"],
        speakersDetails: _currentFDPDetails["speakersDetails"],
        sponsorship: _currentFDPDetails["sponsorship"],
        identifier: '0',
      );

      log('$fdpData');

      await repository.sendEvent(
        eventType: "fdp",
        eventName: _currentFDPDetails["fdpTitle"],
        additionalData: fdpData,
      );

      // Simulate submission
      await Future.delayed(const Duration(seconds: 2));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("FDP details submitted successfully!")),
      );

      setState(() {
        _currentStep = 0;
        _currentFDPDetails.clear();
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
        controller: TextEditingController(text: _currentFDPDetails[key] ?? ''),
        onChanged: (value) {
          _currentFDPDetails[key] = value;
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
            groupValue: _currentFDPDetails[key],
            onChanged: (value) {
              setState(() {
                _currentFDPDetails[key] = value;
              });
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCurrentStepContent() {
    _resetTextController();

    switch (_currentStep) {
      case 0:
        return _buildInputField("fdpTitle", "Enter FDP Title");
      case 1:
        return _buildRadioButtonField("mode", ["Online", "Offline"]);
      case 2:
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () => _pickDocument("brochure"),
            child: const Text("Attach Brochure"),
          ),
        );
      case 3:
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () => _pickDate(context, "dates.from"),
                child: const Text("Pick Start Date"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () => _pickDate(context, "dates.to"),
                child: const Text("Pick End Date"),
              ),
            ),
          ],
        );
      case 4:
        return _buildInputField("days", "Enter Number of Days");
      case 5:
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () => _pickDocument("gpsMedia"),
            child: const Text("Attach GPS Photos/Videos"),
          ),
        );
      case 6:
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () => _pickDocument("report"),
            child: const Text("Attach Report"),
          ),
        );
      case 7:
        return _buildInputField("organizers", "Enter Organizers' Details");
      case 8:
        return _buildInputField("conveners", "Enter Conveners' Details");
      case 9:
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () => _pickDocument("feedback"),
            child: const Text("Attach Feedback from Participants"),
          ),
        );
      case 10:
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () => _pickDocument("participantsList"),
            child: const Text("Attach Participants List with Signatures"),
          ),
        );
      case 11:
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () => _pickDocument("certificates"),
            child: const Text("Attach Certificates (Soft Copy)"),
          ),
        );
      case 12:
        return _buildInputField("sanctionedAmount", "Enter Amount Sanctioned");
      case 13:
        return _buildInputField("facultyReceivingAmount",
            "Enter Faculty Receiving Sanctioned Amount");
      case 14:
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () => _pickDocument("expenditureReport"),
            child: const Text("Attach Expenditure Report with Receipts"),
          ),
        );
      case 15:
        return _buildInputField(
            "speakersDetails", "Enter Details of Speakers/Resource Persons");
      case 16:
        return _buildInputField("sponsorship", "Enter Sponsorship Details");
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FDP Submission'),
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
                      _submitFDPDetails();
                    }
                  },
                  child: Text(_currentStep < _stepsQuestions.length - 1
                      ? 'Next Step'
                      : 'Submit'),
                ),
              ),
            ],
          ),
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
        children: List.generate(17, (index) {
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
