import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:faculty_app/accepted_or_rejected.dart';
import 'package:faculty_app/login.dart';
import 'package:faculty_app/repository.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/IAmarksCP.dart';
import 'screens/BookChapterCP.dart';
import 'screens/ClubActivitiesCP.dart';
import 'screens/ConferencesCP.dart';
import 'screens/EventsCP.dart';
import 'screens/FDCP.dart';
import 'screens/FacultyAchievementsCP.dart';
import 'screens/IndustrialVisitsCP.dart';
import 'screens/JournalsCP.dart';
import 'screens/PatentsCP.dart';
import 'screens/ProfessionalSocietiesCP.dart';
import 'screens/SeminarsCP.dart';
import 'screens/StudentAchievementsCP.dart';
import 'screens/UnknownEventPage.dart';
import 'screens/WorkshopCP.dart';
import 'screens/settings.dart';

Repository repository = Repository();

void main() {
  runApp(const DashboardApp());
}

class DashboardApp extends StatelessWidget {
  const DashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DSU-EventApprove',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xfff8f9fd),
      ),
      home: const SplashScreen(),
    );
  }
}

// Splash Screen with animation
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: AnimatedOpacity(
          opacity: 1.0,
          duration: Duration(seconds: 2),
          child: Text(
            'Welcome to DSU-EventApprove!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.username});
  final String? username;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  Widget _buildDashboardGrid() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Faculty Dashboard',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xff2F4F6F),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.count(
              crossAxisCount: 5,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              children: [
                buildCategoryCard("IA Marks", Icons.school),
                buildCategoryCard("Conferences", Icons.business),
                buildCategoryCard("Journals", Icons.book),
                buildCategoryCard("Book- chapter/Published", Icons.menu_book),
                buildCategoryCard("Patents", Icons.lightbulb),
                buildCategoryCard("Workshops", Icons.work),
                buildCategoryCard("FDP", Icons.people),
                buildCategoryCard("Seminars/Webinars", Icons.web),
                buildCategoryCard("Club Activities", Icons.group),
                buildCategoryCard("Industrial Visits", Icons.factory),
                buildCategoryCard("Faculty Major Achievements", Icons.star),
                buildCategoryCard(
                    "Student Major Achievements", Icons.emoji_events),
                buildCategoryCard(
                    "Professional Societies activities", Icons.account_balance),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    switch (_currentIndex) {
      case 0:
        return _buildDashboardGrid();
      case 1:
        return const AcceptedAndRejectedView();
      case 2:
        return const SettingsPage();
      default:
        return _buildDashboardGrid();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Sidebar(
            username: widget.username,
            selectedIndex: _currentIndex,
            onItemSelected: (index) {
              setState(() => _currentIndex = index);
            },
            onLogout: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('user');
              await prefs.setBool('isLoggedIn', false);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
          Expanded(child: _buildMainContent()),
        ],
      ),
    );
  }

  Widget buildCategoryCard(String label, IconData icon) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: const Color(0xff405375),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => getPageForEvent(label)),
          );
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 40),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getPageForEvent(String eventType) {
    switch (eventType) {
      case "IA Marks":
        return const IAmarksCP();
      case "Conferences":
        return const ConferencesCP();
      case "Journals":
        return const JournalsCP();
      case "Book- chapter/Published":
        return const BookChapterCP();
      case "Patents":
        return const PatentsCP();
      case "Events":
        return const EventsCP();
      case "Workshops":
        return const WorkshopsCP();
      case "FDP":
        return const FDPCP();
      case "Seminars/Webinars":
        return const SeminarsCP();
      case "Club Activities":
        return const ClubActivitiesCP();
      case "Industrial Visits":
        return const IndustrialVisitsCP();
      case "Faculty Major Achievements":
        return const FacultyAchievementsCP();
      case "Student Major Achievements":
        return const StudentsAchievementsCP();
      case "Professional Societies activities":
        return const ProfessionalSocietiesCP();
      default:
        return const UnknownEventPage();
    }
  }
}

class Sidebar extends StatelessWidget {
  final String? username;
  final int selectedIndex;
  final Function(int) onItemSelected;
  final VoidCallback onLogout;

  const Sidebar({
    super.key,
    required this.username,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: const Color(0xff2F4F6F),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: 40,
          ),
          Column(
            children: [
              const Text(
                'DSU-EventApprove',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              if (username != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Welcome, $username',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _SidebarItem(
                  icon: Icons.dashboard,
                  label: "Dashboard",
                  isSelected: selectedIndex == 0,
                  onTap: () => onItemSelected(0),
                ),
                _SidebarItem(
                  icon: Icons.list_alt,
                  label: "View Submissions",
                  isSelected: selectedIndex == 1,
                  onTap: () => onItemSelected(1),
                ),
                _SidebarItem(
                  icon: Icons.settings,
                  label: "Settings",
                  isSelected: selectedIndex == 2,
                  onTap: () => onItemSelected(2),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
            ),
            child: _SidebarItem(
              icon: Icons.logout_outlined,
              label: "Logout",
              isSelected: false,
              onTap: onLogout,
              textColor: Colors.red[300],
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.textColor,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color:
                isSelected ? Colors.white.withOpacity(0.1) : Colors.transparent,
            border: Border(
              left: BorderSide(
                color: isSelected ? Colors.white : Colors.transparent,
                width: 4,
              ),
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: textColor ?? Colors.white.withOpacity(0.9),
                size: 20,
              ),
              const SizedBox(width: 16),
              Text(
                label,
                style: TextStyle(
                  color: textColor ?? Colors.white.withOpacity(0.9),
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SidebarButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const SidebarButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 20.0),
      child: ElevatedButton.icon(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff405375),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
        icon: Icon(icon, color: Colors.white),
        label: Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
    );
  }
}

class ViewSubmissionsPage extends StatefulWidget {
  const ViewSubmissionsPage({super.key});

  @override
  _ViewSubmissionsPageState createState() => _ViewSubmissionsPageState();
}

class _ViewSubmissionsPageState extends State<ViewSubmissionsPage> {
  late Future<List<Map<String, dynamic>>> proposalsFuture;

  @override
  void initState() {
    super.initState();
    proposalsFuture = repository.fetchData(); // Initial data load
  }

  Future<void> _viewDocument(String base64PDF, String fileName) async {
    try {
      // Decode the Base64 string to bytes
      Uint8List bytes = base64Decode(base64PDF);

      // Get the Downloads directory
      final downloadsDir = await getDownloadsDirectory();
      if (downloadsDir == null) {
        throw 'Downloads directory not found';
      }

      // Create a file path in the Downloads directory
      final filePath = '${downloadsDir.path}/$fileName.pdf';

      // Write the bytes to a file
      final file = File(filePath);
      await file.writeAsBytes(bytes);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('File saved to Downloads: $fileName.pdf')),
      );
    } catch (e) {
      debugPrint('Error viewing document: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving document: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Submissions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                proposalsFuture =
                    repository.fetchProposals(); // Reload the data
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: proposalsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No submissions found.'));
          }

          final proposals = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: proposals.length,
            itemBuilder: (context, index) {
              final proposal = proposals[index];

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Render all fields except eventPDF and document
                      ...proposal.entries
                          .where((entry) =>
                              entry.key != 'eventPDF' &&
                              entry.key != 'document')
                          .map((entry) {
                        final key = entry.key;
                        final value = entry.value ?? 'N/A';

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text("$key: $value"),
                        );
                      }),

                      const SizedBox(height: 8),

                      // Render eventPDF or document if available
                      if (proposal['eventPDF'] != null)
                        TextButton(
                          onPressed: () {
                            final base64PDF = proposal['eventPDF'];
                            _viewDocument(base64PDF,
                                proposal['eventTitle'] ?? 'document');
                          },
                          child: const Text('Save Event PDF to Downloads'),
                        )
                      else if (proposal['document'] != null)
                        TextButton(
                          onPressed: () {
                            final base64Document = proposal['document'];
                            _viewDocument(base64Document,
                                proposal['documentTitle'] ?? 'document');
                          },
                          child: const Text('Save Document to Downloads'),
                        )
                      else
                        const Text('Document not available'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<Directory?> getDownloadsDirectory() async {
    if (Platform.isWindows) {
      return Directory('${Platform.environment['USERPROFILE']}\\Downloads');
    } else if (Platform.isLinux || Platform.isMacOS) {
      return Directory('${Platform.environment['HOME']}/Downloads');
    }
    return null;
  }
}
