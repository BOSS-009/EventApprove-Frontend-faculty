import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:faculty_app/main.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';
import 'package:faculty_app/config.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Repository {
  Future<Map<String, dynamic>?> getUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user');
    if (userData != null) {
      return jsonDecode(userData);
    }
    return null;
  }

  Future<void> sendEvent({
    required String eventType,
    required String eventName,
    required Map<String, dynamic> additionalData,
  }) async {
    final dio = Dio();
    final url = '${config.baseURL}/centralized';

    Map<String, dynamic>? userDetails = await getUserDetails();

    // Check if there's a MultipartFile in the additionalData
    bool hasFile = additionalData.values.any((value) => value is MultipartFile);

    try {
      if (hasFile) {
        // If there's a file, use FormData
        final formData = FormData.fromMap({
          "event_type": eventType,
          "event_name": eventName,
          "user_id": userDetails!['user_id'],
          ...additionalData,
        });

        final response = await dio.post(
          url,
          data: formData,
        );
        print('Response: ${response.data}');
      } else {
        // If no file, use regular JSON
        final data = {
          "event_type": eventType,
          "event_name": eventName,
          ...additionalData,
        };

        final response = await dio.post(
          url,
          data: data,
          options: Options(headers: {'Content-Type': 'application/json'}),
        );
        print('Response: ${response.data}');
      }
    } catch (e) {
      print('Error: $e');
      rethrow; // Rethrow to allow handling in the calling function
    }
  }

  Future<Map<String, dynamic>> createConferenceData({
    required String paperTitle,
    required String abstract,
    required String conferenceName,
    required String publicationLevel,
    required String publicationDate,
    required String publisher,
    required String doiIsbn,
    required String identifier,
    String? documentPath,
    required String proofLink,
  }) async {
    final Map<String, dynamic> data = {
      "papertitle": paperTitle,
      "abstract": abstract,
      "conferencename": conferenceName,
      "publicationlevel": publicationLevel,
      "publicationdate": publicationDate,
      "publisher": publisher,
      "doiisbn": doiIsbn,
      "prooflink": proofLink,
      "identifier": identifier,
    };

    if (documentPath != null) {
      // Read the file as bytes
      final file = File(documentPath);
      final bytes = await file.readAsBytes();

      // Try to determine the MIME type
      String? mimeType = lookupMimeType(documentPath, headerBytes: bytes);

      // Parse MIME type into MediaType
      final contentType = MediaType.parse(mimeType);

      // Create MultipartFile from bytes
      data["document"] = MultipartFile.fromBytes(
        bytes,
        filename: documentPath.split('/').last,
        contentType: contentType,
      );

      data["documentname"] = documentPath.split('\\').last;
    }

    return data;
  }

  Future<Map<String, dynamic>> createJournalData({
    required String authors,
    required String paperTitle,
    String? abstract,
    String? journalName,
    String? publicationLevel,
    DateTime? publicationDate,
    String? publisher,
    String? doiIsbn,
    String? documentPath,
    String? proofLink,
    String? impactFactor,
    String? quartile,
    required String identifier,
  }) async {
    final Map<String, dynamic> data = {
      "authors": authors,
      "papertitle": paperTitle,
      "abstract": abstract,
      "journalname": journalName,
      "publicationlevel": publicationLevel,
      "publicationdate": publicationDate,
      "publisher": publisher,
      "doiisbn": doiIsbn,
      "prooflink": proofLink,
      "impactfactor": impactFactor,
      "quartile": quartile,
      "identifier": identifier,
    };

    if (documentPath != null) {
      // Read the file as bytes
      final file = File(documentPath);
      final bytes = await file.readAsBytes();

      // Create MultipartFile from bytes
      data["document"] = MultipartFile.fromBytes(
        bytes,
        filename: documentPath.split('/').last,
      );

      data["documentname"] = documentPath.split('\\').last;
    }

    return data;
  }

  Future<Map<String, dynamic>> createBookChapterData({
    required String authors,
    required String paperTitle,
    String? abstract,
    String? journalName,
    String? publicationLevel,
    DateTime? publicationDate,
    String? publisher,
    String? doi,
    String? documentPath,
    String? proofLink,
    required String identifier,
  }) async {
    final Map<String, dynamic> data = {
      "authors": authors,
      "papertitle": paperTitle,
      "abstract": abstract,
      "journalname": journalName,
      "publicationlevel": publicationLevel,
      "publicationdate": publicationDate,
      "publisher": publisher,
      "doi": doi,
      "prooflink": proofLink,
      "identifier": identifier,
    };

    if (documentPath != null) {
      // Read the file as bytes
      final file = File(documentPath);
      final bytes = await file.readAsBytes();

      // Create MultipartFile from bytes
      data["document"] = MultipartFile.fromBytes(
        bytes,
        filename: documentPath.split('/').last,
      );

      data["documentname"] = documentPath.split('\\').last;
    }

    return data;
  }

  Future<Map<String, dynamic>> createPatentData({
    required String applicationNumber,
    String? patentNumber,
    required String title,
    required String inventors,
    String? patenteeName,
    DateTime? filingDate,
    String? status,
    String? patentCountry,
    DateTime? publicationDate,
    String? abstract,
    String? url,
    String? documentPath,
    required String identifier,
  }) async {
    final Map<String, dynamic> data = {
      "applicationnumber": applicationNumber,
      "patentnumber": patentNumber,
      "title": title,
      "inventors": inventors,
      "patenteename": patenteeName ?? "Dayananda Sagar University",
      "filingdate": filingDate,
      "status": status,
      "patentcountry": patentCountry,
      "publicationdate": publicationDate,
      "abstract": abstract,
      "url": url,
      "identifier": identifier,
    };

    if (documentPath != null) {
      // Read the file as bytes
      final file = File(documentPath);
      final bytes = await file.readAsBytes();

      // Create MultipartFile from bytes
      data["document"] = MultipartFile.fromBytes(
        bytes,
        filename: documentPath.split('/').last,
      );

      data["documentname"] = documentPath.split('\\').last;
    }

    return data;
  }

  Future<Map<String, dynamic>> createWorkshopData({
    required String workshopTitle,
    String? mode,
    String? dates,
    String? days,
    String? organizers,
    String? conveners,
    String? speakersDetails,
    String? sanctionedAmount,
    String? facultyReceivingAmount,
    String? identifier,
    String? reportPath,
    String? feedbackPath,
    String? participantsListPath,
    String? certificatesPath,
    String? expenditureReportPath,
    String? gpsMediaPath,
    String? brochurePath,
  }) async {
    final Map<String, dynamic> data = {
      "workshoptitle": workshopTitle,
      "mode": mode,
      "dates": dates,
      "days": days,
      "organizers": organizers,
      "conveners": conveners,
      "speakersdetails": speakersDetails,
      "sanctionedamount": sanctionedAmount,
      "facultyreceivingamount": facultyReceivingAmount,
      "identifier": identifier,
    };

    if (brochurePath != null) {
      final file = File(brochurePath);
      final bytes = await file.readAsBytes();
      data["brochure"] = MultipartFile.fromBytes(bytes,
          filename: brochurePath.split('/').last);
      data["brochurename"] = brochurePath.split('\\').last;
    }

    if (gpsMediaPath != null) {
      final file = File(gpsMediaPath);
      final bytes = await file.readAsBytes();
      data["gpsmedia"] = MultipartFile.fromBytes(bytes,
          filename: gpsMediaPath.split('/').last);
      data["gpsmedianame"] = gpsMediaPath.split('\\').last;
    }

    if (reportPath != null) {
      final file = File(reportPath);
      final bytes = await file.readAsBytes();
      data["report"] =
          MultipartFile.fromBytes(bytes, filename: reportPath.split('/').last);
      data["reportname"] = reportPath.split('\\').last;
    }

    if (feedbackPath != null) {
      final file = File(feedbackPath);
      final bytes = await file.readAsBytes();
      data["feedback"] = MultipartFile.fromBytes(bytes,
          filename: feedbackPath.split('/').last);
      data["feedbackname"] = feedbackPath.split('\\').last;
    }

    if (participantsListPath != null) {
      final file = File(participantsListPath);
      final bytes = await file.readAsBytes();
      data["participantslist"] = MultipartFile.fromBytes(bytes,
          filename: participantsListPath.split('/').last);
      data["participantslistname"] = participantsListPath.split('\\').last;
    }

    if (certificatesPath != null) {
      final file = File(certificatesPath);
      final bytes = await file.readAsBytes();
      data["certificates"] = MultipartFile.fromBytes(bytes,
          filename: certificatesPath.split('/').last);
      data["certificatesname"] = certificatesPath.split('\\').last;
    }

    if (expenditureReportPath != null) {
      final file = File(expenditureReportPath);
      final bytes = await file.readAsBytes();
      data["expenditurereport"] = MultipartFile.fromBytes(bytes,
          filename: expenditureReportPath.split('/').last);
      data["expenditurereportname"] = expenditureReportPath.split('\\').last;
    }

    return data;
  }

  Future<Map<String, dynamic>> createFDPData({
    required String fdpTitle,
    String? mode,
    String? dates,
    String? days,
    String? organizers,
    String? conveners,
    String? speakersDetails,
    String? sanctionedAmount,
    String? facultyReceivingAmount,
    String? identifier,
    String? reportPath,
    String? feedbackPath,
    String? participantsListPath,
    String? certificatesPath,
    String? expenditureReportPath,
    String? gpsMediaPath,
    String? brochurePath,
    String? sponsorship,
  }) async {
    final Map<String, dynamic> data = {
      "fdptitle": fdpTitle,
      "mode": mode,
      "dates": dates,
      "days": days,
      "organizers": organizers,
      "conveners": conveners,
      "speakersdetails": speakersDetails,
      "sanctionedamount": sanctionedAmount,
      "facultyreceivingamount": facultyReceivingAmount,
      "sponsorship": sponsorship,
      "identifier": identifier,
    };

    if (brochurePath != null) {
      final file = File(brochurePath);
      final bytes = await file.readAsBytes();
      data["brochure"] = MultipartFile.fromBytes(bytes,
          filename: brochurePath.split('/').last);
      data["brochurename"] = brochurePath.split('\\').last;
    }

    if (gpsMediaPath != null) {
      final file = File(gpsMediaPath);
      final bytes = await file.readAsBytes();
      data["gpsmedia"] = MultipartFile.fromBytes(bytes,
          filename: gpsMediaPath.split('/').last);
      data["gpsmedianame"] = gpsMediaPath.split('\\').last;
    }

    if (reportPath != null) {
      final file = File(reportPath);
      final bytes = await file.readAsBytes();
      data["report"] =
          MultipartFile.fromBytes(bytes, filename: reportPath.split('/').last);
      data["reportname"] = reportPath.split('\\').last;
    }

    if (feedbackPath != null) {
      final file = File(feedbackPath);
      final bytes = await file.readAsBytes();
      data["feedback"] = MultipartFile.fromBytes(bytes,
          filename: feedbackPath.split('/').last);
      data["feedbackname"] = feedbackPath.split('\\').last;
    }

    if (participantsListPath != null) {
      final file = File(participantsListPath);
      final bytes = await file.readAsBytes();
      data["participantslist"] = MultipartFile.fromBytes(bytes,
          filename: participantsListPath.split('/').last);
      data["participantslistname"] = participantsListPath.split('\\').last;
    }

    if (certificatesPath != null) {
      final file = File(certificatesPath);
      final bytes = await file.readAsBytes();
      data["certificates"] = MultipartFile.fromBytes(bytes,
          filename: certificatesPath.split('/').last);
      data["certificatesname"] = certificatesPath.split('\\').last;
    }

    if (expenditureReportPath != null) {
      final file = File(expenditureReportPath);
      final bytes = await file.readAsBytes();
      data["expenditurereport"] = MultipartFile.fromBytes(bytes,
          filename: expenditureReportPath.split('/').last);
      data["expenditurereportname"] = expenditureReportPath.split('\\').last;
    }

    return data;
  }

  Future<Map<String, dynamic>> createSeminarData({
    required String seminarTitle,
    String? mode,
    String? dates,
    String? days,
    String? organizers,
    String? conveners,
    String? speakersDetails,
    String? sanctionedAmount,
    String? facultyReceivingAmount,
    String? identifier,
    String? reportPath,
    String? feedbackPath,
    String? participantsListPath,
    String? certificatesPath,
    String? expenditureReportPath,
    String? gpsMediaPath,
    String? brochurePath,
  }) async {
    final Map<String, dynamic> data = {
      "seminartitle": seminarTitle,
      "mode": mode,
      "dates": dates,
      "days": days,
      "organizers": organizers,
      "conveners": conveners,
      "speakersdetails": speakersDetails,
      "sanctionedamount": sanctionedAmount,
      "facultyreceivingamount": facultyReceivingAmount,
      "identifier": identifier,
    };

    if (brochurePath != null) {
      final file = File(brochurePath);
      final bytes = await file.readAsBytes();
      data["brochure"] = MultipartFile.fromBytes(bytes,
          filename: brochurePath.split('/').last);
      data["brochurename"] = brochurePath.split('\\').last;
    }

    if (gpsMediaPath != null) {
      final file = File(gpsMediaPath);
      final bytes = await file.readAsBytes();
      data["gpsmedia"] = MultipartFile.fromBytes(bytes,
          filename: gpsMediaPath.split('/').last);
      data["gpsmedianame"] = gpsMediaPath.split('\\').last;
    }

    if (reportPath != null) {
      final file = File(reportPath);
      final bytes = await file.readAsBytes();
      data["report"] =
          MultipartFile.fromBytes(bytes, filename: reportPath.split('/').last);
      data["reportname"] = reportPath.split('\\').last;
    }

    if (feedbackPath != null) {
      final file = File(feedbackPath);
      final bytes = await file.readAsBytes();
      data["feedback"] = MultipartFile.fromBytes(bytes,
          filename: feedbackPath.split('/').last);
      data["feedbackname"] = feedbackPath.split('\\').last;
    }

    if (participantsListPath != null) {
      final file = File(participantsListPath);
      final bytes = await file.readAsBytes();
      data["participantslist"] = MultipartFile.fromBytes(bytes,
          filename: participantsListPath.split('/').last);
      data["participantslistname"] = participantsListPath.split('\\').last;
    }

    if (certificatesPath != null) {
      final file = File(certificatesPath);
      final bytes = await file.readAsBytes();
      data["certificates"] = MultipartFile.fromBytes(bytes,
          filename: certificatesPath.split('/').last);
      data["certificatesname"] = certificatesPath.split('\\').last;
    }

    if (expenditureReportPath != null) {
      final file = File(expenditureReportPath);
      final bytes = await file.readAsBytes();
      data["expenditurereport"] = MultipartFile.fromBytes(bytes,
          filename: expenditureReportPath.split('/').last);
      data["expenditurereportname"] = expenditureReportPath.split('\\').last;
    }

    return data;
  }

  Future<Map<String, dynamic>> createClubActivityData({
    String? clubName,
    String? activityType,
    String? title,
    DateTime? activityDate,
    String? numDays,
    String? gpsMediaPath,
    String? budget,
    String? reportPath,
    String? organizers,
    String? conveners,
    String? feedback,
    String? participantsListPath,
    String? certificatesPath,
    String? speakersDetails,
    required String identifier,
  }) async {
    final Map<String, dynamic> data = {
      "clubname": clubName,
      "activitytype": activityType,
      "title": title,
      "activitydate": activityDate?.toIso8601String(),
      "numdays": numDays,
      "budget": budget,
      "organizers": organizers,
      "conveners": conveners,
      "feedback": feedback,
      "speakersdetails": speakersDetails,
      "identifier": identifier,
    };

    Future<void> addFileField(String key, String? filePath) async {
      if (filePath != null) {
        final file = File(filePath);
        final bytes = await file.readAsBytes();
        data[key] = MultipartFile.fromBytes(
          bytes,
          filename: filePath.split('/').last,
        );
        data['${key}name'] = filePath.split('\\').last;
      }
    }

    await addFileField("gpsmedia", gpsMediaPath);
    await addFileField("feedback", feedback);
    await addFileField("report", reportPath);
    await addFileField("participantslist", participantsListPath);
    await addFileField("certificates", certificatesPath);

    return data;
  }

  Future<Map<String, dynamic>> createIndustrialVisitData({
    String? companyName,
    String? industryType,
    String? visitTitle,
    DateTime? visitDate,
    String? numDays,
    String? gpsMediaPath,
    String? budget,
    String? reportPath,
    String? organizers,
    String? conveners,
    String? feedback,
    String? participantsListPath,
    String? certificatesPath,
    String? speakersDetails,
    required String identifier,
  }) async {
    final Map<String, dynamic> data = {
      "companyname": companyName,
      "industrytype": industryType,
      "visittitle": visitTitle,
      "visitdate": visitDate?.toIso8601String(),
      "numdays": numDays,
      "budget": budget,
      "organizers": organizers,
      "conveners": conveners,
      "feedback": feedback,
      "speakersdetails": speakersDetails,
      "identifier": identifier,
    };

    Future<void> addFileField(String key, String? filePath) async {
      if (filePath != null) {
        final file = File(filePath);
        final bytes = await file.readAsBytes();
        data[key] = MultipartFile.fromBytes(
          bytes,
          filename: filePath.split('/').last,
        );
        data['${key}name'] = filePath.split('\\').last;
      }
    }

    await addFileField("gpsmedia", gpsMediaPath);
    await addFileField("feedback", feedback);
    await addFileField("report", reportPath);
    await addFileField("participantslist", participantsListPath);
    await addFileField("certificates", certificatesPath);

    return data;
  }

  Future<Map<String, dynamic>> createFacultyAchievementData({
    String? facultyName,
    String? designation,
    DateTime? achievementDate,
    String? recognition,
    String? eventName,
    String? awardName,
    String? awardingOrganization,
    String? gpsPhotoPath,
    String? reportPath,
    String? proofPath,
    String? certificateProofPath,
    required String identifier,
  }) async {
    final Map<String, dynamic> data = {
      "facultyname": facultyName,
      "designation": designation,
      "achievementdate": achievementDate?.toIso8601String(),
      "recognition": recognition,
      "eventname": eventName,
      "awardname": awardName,
      "awardingorganization": awardingOrganization,
      "identifier": identifier,
    };

    Future<void> addFileField(String key, String? filePath) async {
      if (filePath != null) {
        final file = File(filePath);
        final bytes = await file.readAsBytes();
        data[key] = MultipartFile.fromBytes(
          bytes,
          filename: filePath.split('/').last,
        );
        data['${key}name'] = filePath.split('\\').last;
      }
    }

    await addFileField("gpsphoto", gpsPhotoPath);
    await addFileField("report", reportPath);
    await addFileField("proof", proofPath);
    await addFileField("certificateproof", certificateProofPath);

    return data;
  }

  Future<Map<String, dynamic>> createStudentAchievementData({
    String? studentNames,
    String? usns,
    String? yearOfStudy,
    String? eventType,
    String? eventTitle,
    DateTime? achievementDate,
    String? companyOrganization,
    String? recognition,
    String? certificateProofPath,
    String? gpsPhotoPath,
    String? reportPath,
    required String identifier,
  }) async {
    final Map<String, dynamic> data = {
      "studentnames": studentNames,
      "usns": usns,
      "yearofstudy": yearOfStudy,
      "eventtype": eventType,
      "eventtitle": eventTitle,
      "achievementdate": achievementDate?.toIso8601String(),
      "companyorganization": companyOrganization,
      "recognition": recognition,
      "identifier": identifier,
    };

    Future<void> addFileField(String key, String? filePath) async {
      if (filePath != null) {
        final file = File(filePath);
        final bytes = await file.readAsBytes();
        data[key] = MultipartFile.fromBytes(
          bytes,
          filename: filePath.split('/').last,
        );
        data['${key}name'] = filePath.split('\\').last;
      }
    }

    await addFileField("certificateproof", certificateProofPath);
    await addFileField("gpsphoto", gpsPhotoPath);
    await addFileField("report", reportPath);

    return data;
  }

  Future<Map<String, dynamic>> createProfessionalSocietyData({
    String? societyName,
    String? eventType,
    String? activityType,
    DateTime? activityDate,
    String? numberOfDays,
    String? gpsPhotosVideosPath,
    String? budgetSanctioned,
    String? eventReportPath,
    String? organizers,
    String? conveners,
    String? feedback,
    String? participantsListPath,
    String? certificatesPath,
    String? speakerDetails,
    required String identifier,
  }) async {
    final Map<String, dynamic> data = {
      "societyname": societyName,
      "eventtype": eventType,
      "activitytype": activityType,
      "activitydate": activityDate?.toIso8601String(),
      "numberofdays": numberOfDays,
      "budgetsanctioned": budgetSanctioned,
      "organizers": organizers,
      "conveners": conveners,
      "feedback": feedback,
      "speakerdetails": speakerDetails,
      "identifier": identifier,
    };

    Future<void> addFileField(String key, String? filePath) async {
      if (filePath != null) {
        final file = File(filePath);
        final bytes = await file.readAsBytes();
        data[key] = MultipartFile.fromBytes(
          bytes,
          filename: filePath.split('/').last,
        );
        data['${key}name'] = filePath.split('\\').last;
      }
    }

    await addFileField("feedback", feedback);
    await addFileField("gpsphotosvideos", gpsPhotosVideosPath);
    await addFileField("eventreport", eventReportPath);
    await addFileField("participantslist", participantsListPath);
    await addFileField("certificates", certificatesPath);

    return data;
  }

  Future<Map<String, dynamic>> getEventByMasterId(int masterId) async {
    try {
      final dio = Dio();
      // Replace with your base URL
      dio.options.baseUrl = '${config.baseURL}/centralized';

      final response = await dio.get('/$masterId');

      if (response.statusCode == 200) {
        // The API returns a JSON object, so we'll return it as Map<String, dynamic>
        return response.data as Map<String, dynamic>;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          message: 'Failed to fetch event data',
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw 'Event not found';
      }
      throw 'Error fetching event: ${e.message}';
    } catch (e) {
      throw 'Unexpected error: $e';
    }
  }

  Future<List<dynamic>> getAllMasterEvents() async {
    final Dio dio = Dio();

    try {
      Map<String, dynamic>? userDetails = await getUserDetails();
      // Configure Dio (e.g., base URL, headers)
      dio.options.baseUrl =
          '${config.baseURL}/centralized'; // Replace with your API base URL
      dio.options.headers = {
        'Content-Type': 'application/json',
      };

      // Make the GET request
      final response =
          await dio.get('/allFiltered?user_id=${userDetails!['user_id']}');

      // Handle response
      if (response.statusCode == 200) {
        List<dynamic> masterEvents = response.data;
        debugPrint('Master Events fetched successfully: $masterEvents');
        return masterEvents;
      } else {
        debugPrint('Failed to fetch events: ${response.statusMessage}');
      }
      return [];
    } catch (e) {
      debugPrint('Error fetching events: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchProposals() async {
    try {
      final String endpoint = "${config.baseURL}/event";
      final response = await Dio().get(endpoint);
      final List eventsJson = response.data['events'];

      return eventsJson.map((json) => json as Map<String, dynamic>).toList();
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching events: $e");
      }
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> fetchConference() async {
    try {
      final String endpoint = "${config.baseURL}/conference";
      final response = await Dio().get(endpoint);
      print('$response');
      final List conferenceJson = response.data['conferences'];

      return conferenceJson
          .map((json) => json as Map<String, dynamic>)
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching conferences: $e");
      }
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> fetchData() async {
    try {
      // Fetch proposals and conferences concurrently
      final proposals = await fetchProposals();
      final conferences = await fetchConference();

      // Merge both lists of maps into a single list
      List<Map<String, dynamic>> mergedData = [];
      mergedData.addAll(proposals);
      mergedData.addAll(conferences);

      return mergedData;
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching data: $e");
      }
      rethrow;
    }
  }

  Future<void> validateLogin(BuildContext context, username, password) async {
    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Username and Password cannot be empty")),
      );
      return;
    }

    try {
      // Make the API call
      final response = await http.post(
        Uri.parse(
            '${config.baseURL}/centralized/login'), // Replace with your API URL
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
          'role': 'Faculty', // Replace with the role you need
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Save user details locally
        final prefs = await SharedPreferences.getInstance();
        log('${data['user']}');
        log('$data');

        await prefs.setString('user', jsonEncode(data['user']));
        await prefs.setBool('isLoggedIn', true);

        // Navigate to Home Page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage(
                    username: data['user']['username'],
                  )),
        );
      } else {
        final error = jsonDecode(response.body)['error'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error ?? "Invalid credentials")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred: $e")),
      );
    }
  }

  Future<void> registerUser(
      BuildContext context, String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${config.baseURL}/centralized/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
          'role': 'Faculty',
        }),
      );

      if (response.statusCode == 201) {
        Navigator.pop(context); // Close the dialog
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration successful!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
   Future<bool> pingServer(String ip) async {
    try {
      final response = await http.get(
        Uri.parse('http://$ip:5001/centralized/ping'),
      );

      if (response.statusCode == 200) {
        return true; // Server is reachable
      }
    } catch (e) {
      print('Error pinging server: $e');
    }
    return false; // Server unreachable
  }
}
