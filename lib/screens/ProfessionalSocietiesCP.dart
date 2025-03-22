import 'package:faculty_app/repository.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class ProfessionalSocietiesCP extends StatefulWidget {
  const ProfessionalSocietiesCP({super.key});

  @override
  _ProfessionalSocietiesCPState createState() =>
      _ProfessionalSocietiesCPState();
}

class _ProfessionalSocietiesCPState extends State<ProfessionalSocietiesCP> {
  int _currentStep = 0;

  final List<String> _stepsQuestions = [
    "Enter Professional Society Name (ACM/CSI/IEEE CS)",
    "Select Event Type (Offline/Online)",
    "Select Activity Type (Workshop/Boot Camp/Seminar/Quiz/Hackathon)",
    "Enter Date of Activity",
    "Enter Number of Days",
    "Attach GPS Photos/Videos",
    "Enter Budget Sanctioned",
    "Attach Event Report",
    "Enter Organizers",
    "Enter Conveners",
    "Attach Feedback from Participants",
    "Attach Participants List (with Signature)",
    "Attach Certificates (Soft Copy)",
    "Enter Speaker Details"
  ];

  final Map<String, dynamic> _currentSocietyDetails = {
    "societyName": "",
    "eventType": "",
    "activityType": "",
    "activityDate": "",
    "numberOfDays": "",
    "gpsPhotosVideos": null,
    "budgetSanctioned": "",
    "eventReport": null,
    "organizers": "",
    "conveners": "",
    "feedback": null,
    "participantsList": null,
    "certificates": null,
    "speakerDetails": ""
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
        _currentSocietyDetails[key] = picked;
      });
    }
  }

  Future<void> _pickDocument(String key) async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _currentSocietyDetails[key] = result.files.first.path;
      });
    }
  }

  Repository repository = Repository();

  Future<void> _submitSocietyDetails() async {
    try {
      final professionalSocietyData =
          await repository.createProfessionalSocietyData(
        societyName: _currentSocietyDetails["societyName"],
        eventType: _currentSocietyDetails["eventType"],
        activityType: _currentSocietyDetails["activityType"],
        activityDate: _currentSocietyDetails["activityDate"],
        numberOfDays: _currentSocietyDetails["numberOfDays"],
        gpsPhotosVideosPath: _currentSocietyDetails["gpsPhotosVideos"],
        budgetSanctioned: _currentSocietyDetails["budgetSanctioned"],
        eventReportPath: _currentSocietyDetails["eventReport"],
        organizers: _currentSocietyDetails["organizers"],
        conveners: _currentSocietyDetails["conveners"],
        feedback: _currentSocietyDetails["feedback"],
        participantsListPath: _currentSocietyDetails["participantsList"],
        certificatesPath: _currentSocietyDetails["certificates"],
        speakerDetails: _currentSocietyDetails["speakerDetails"],
        identifier:" 0",
      );

      await repository.sendEvent(
        eventType: "professional_societies",
        eventName: _currentSocietyDetails["societyName"],
        additionalData: professionalSocietyData,
      );

      // Simulate submission
      await Future.delayed(const Duration(seconds: 2));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Society activity details submitted successfully!")),
      );

      setState(() {
        _currentStep = 0;
        _currentSocietyDetails.clear();
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
            TextEditingController(text: _currentSocietyDetails[key] ?? ''),
        onChanged: (value) {
          _currentSocietyDetails[key] = value;
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
        value: _currentSocietyDetails[key] == ""
            ? null
            : _currentSocietyDetails[key], // Ensure a non-null value
        items: options.map((option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Text(option),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _currentSocietyDetails[key] = value ?? "";
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
        return _buildInputField(
            "societyName", "Enter Professional Society Name (ACM/CSI/IEEE CS)");
      case 1:
        return _buildDropdownField("eventType", ['Offline', 'Online']);
      case 2:
        return _buildDropdownField("activityType",
            ['Workshop', 'Boot Camp', 'Seminar', 'Quiz', 'Hackathon']);
      case 3:
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () => _pickDate(context, 'activityDate'),
            child: const Text("Pick Date of Activity"),
          ),
        );
      case 4:
        return _buildInputField("numberOfDays", "Enter Number of Days");
      case 5:
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () => _pickDocument('gpsPhotosVideos'),
            child: const Text("Attach GPS Photos/Videos"),
          ),
        );
      case 6:
        return _buildInputField("budgetSanctioned", "Enter Budget Sanctioned");
      case 7:
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () => _pickDocument('eventReport'),
            child: const Text("Attach Event Report"),
          ),
        );
      case 8:
        return _buildInputField("organizers", "Enter Organizers");
      case 9:
        return _buildInputField("conveners", "Enter Conveners");
      case 10:
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () => _pickDocument('feedback'),
            child: const Text("Attach Feedback from Participants"),
          ),
        );
      case 11:
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () => _pickDocument('participantsList'),
            child: const Text("Attach Participants List (with Signature)"),
          ),
        );
      case 12:
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () => _pickDocument('certificates'),
            child: const Text("Attach Certificates (Soft Copy)"),
          ),
        );
      case 13:
        return _buildInputField("speakerDetails", "Enter Speaker Details");
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Professional Society Activity Submission'),
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
                      _submitSocietyDetails();
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
        children: List.generate(14, (index) {
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
