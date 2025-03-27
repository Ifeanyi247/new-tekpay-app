import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  Future<void> _launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'support@tekskillz.com',
      queryParameters: {
        'subject': 'Support Request',
      },
    );

    if (!await launchUrl(emailLaunchUri)) {
      throw Exception('Could not launch email');
    }
  }

  Future<void> _launchWhatsApp() async {
    final phoneNumber = '2348104652226';
    final whatsappUrl = Uri.parse('https://wa.me/$phoneNumber');

    if (!await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch WhatsApp');
    }
  }

  Future<void> _launchPhoneCall() async {
    try {
      final phoneNumber = '08104652226';
      final uri = 'tel:$phoneNumber';

      if (await canLaunchUrl(Uri.parse(uri))) {
        await launchUrl(Uri.parse(uri));
      } else {
        Get.snackbar(
          'Error',
          'Could not launch phone app',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error launching phone call: $e');
      Get.snackbar(
        'Error',
        'Could not launch phone app',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Help & Support'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select your preferred option to contact our customer service',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),
            _buildContactOption(
              context,
              icon: Icons.email_outlined,
              title: 'Email',
              subtitle: 'support@tekskillz.com',
              onTap: _launchEmail,
            ),
            const Divider(),
            _buildContactOption(
              context,
              icon: Icons.phone_outlined,
              title: 'Whatsapp',
              subtitle: '+2348104652226',
              onTap: _launchWhatsApp,
            ),
            const Divider(),
            _buildContactOption(
              context,
              icon: Icons.phone_outlined,
              title: 'Phone Call',
              subtitle: '+2348104652226',
              onTap: _launchPhoneCall,
            ),
            // const Divider(),
            // _buildContactOption(
            //   context,
            //   icon: Icons.chat_bubble_outline,
            //   title: 'Live Chat',
            //   subtitle: '',
            //   onTap: () {
            //     // Handle live chat
            //   },
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.purple.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: Colors.purple,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: subtitle.isNotEmpty
          ? Text(
              subtitle,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            )
          : null,
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey,
      ),
      onTap: onTap,
    );
  }
}
