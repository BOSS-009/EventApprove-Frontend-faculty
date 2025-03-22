import 'package:flutter/material.dart';
import 'profile.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: const Color(0xff405375),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSettingItem(
            context,
            icon: Icons.person,
            label: 'Profile',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
          const Divider(),
          _buildSettingItem(
            context,
            icon: Icons.color_lens,
            label: 'Theme',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Theme settings coming soon!')),
              );
            },
          ),
          const Divider(),
          _buildSettingItem(
            context,
            icon: Icons.security,
            label: 'Privacy',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Privacy settings coming soon!')),
              );
            },
          ),
          const Divider(),
          // Notifications Option
          _buildSettingItem(
            context,
            icon: Icons.notifications,
            label: 'Notifications',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Notification settings coming soon!')),
              );
            },
          ),
          const Divider(),
          // Contact Info Section
          const SizedBox(height: 24),
          const Text(
            'If you have any doubts or complaints, please contact:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            '1. notbilalahmed.gmail.com\n2. mamadapurdevesh.gmail.com',
            style: TextStyle(
              fontSize: 15,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'If you have any complaints, please refer to these emails.',
            style: TextStyle(
              fontSize: 15,
              fontStyle: FontStyle.italic,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          const Divider(),
          const Align(
            alignment: Alignment.center,
            child: Text(
              'Created by Bilal A, Devesh M, Naindeep S, Punith K',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper Function to Create List Items
  Widget _buildSettingItem(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(
        icon,
        size: 30,
        color: const Color(0xff405375),
      ),
      title: Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 18,
        color: Colors.black54,
      ),
      onTap: onTap,
    );
  }
}
