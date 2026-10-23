import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:url_launcher/url_launcher.dart';

class EmailService {
  String backendUrl;
  String? gmailUser;
  String? gmailAppPassword;

  EmailService({
    this.backendUrl = 'http://10.0.2.2:3000',
    this.gmailUser,
    this.gmailAppPassword,
  });

  /// Send an email via the Express backend server
  Future<Map<String, dynamic>> sendViaBackend({
    required String to,
    required String subject,
    required String body,
    required String resumeName,
  }) async {
    try {
      final url = Uri.parse('$backendUrl/api/send-email');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'to': to,
          'subject': subject,
          'text': body,
          'resumeName': resumeName,
        }),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {'success': true, 'message': data['message'] ?? 'Email sent!'};
      } else {
        return {'success': false, 'error': data['error'] ?? 'Failed to send'};
      }
    } catch (e) {
      return {'success': false, 'error': 'Cannot connect to backend: $e'};
    }
  }

  /// Send an email directly from mobile device using SMTP & Gmail App Password
  Future<Map<String, dynamic>> sendViaSmtp({
    required String to,
    required String subject,
    required String body,
    required String resumeAssetPath,
  }) async {
    final user = gmailUser?.trim() ?? '';
    final pass = gmailAppPassword?.trim() ?? '';

    if (user.isEmpty || pass.isEmpty) {
      return {
        'success': false,
        'error': 'Gmail credentials not configured in Settings.',
      };
    }

    try {
      final smtpServer = gmail(user, pass);
      final message = Message()
        ..from = Address(user, 'Sanju Antony')
        ..recipients.addAll(to.split(RegExp(r'[\s,]+')).where((e) => e.isNotEmpty))
        ..subject = subject
        ..text = body;

      // Attach PDF from Flutter assets if present
      try {
        final byteData = await rootBundle.load(resumeAssetPath);
        final bytes = byteData.buffer.asUint8List();
        final filename = resumeAssetPath.split('/').last;
        message.attachments.add(
          StreamAttachment(
            Stream.value(bytes),
            'application/pdf',
            fileName: filename,
          ),
        );
      } catch (e) {
        print('Attachment load note: $e');
      }

      await send(message, smtpServer);
      return {'success': true, 'message': 'Email dispatched via SMTP!'};
    } catch (e) {
      return {'success': false, 'error': 'SMTP dispatch error: $e'};
    }
  }

  /// Launch default device email app with pre-filled content
  Future<bool> launchEmailApp({
    required String to,
    required String subject,
    required String body,
  }) async {
    final uri = Uri(
      scheme: 'mailto',
      path: to,
      query: 'subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}',
    );

    if (await canLaunchUrl(uri)) {
      return await launchUrl(uri);
    }
    return false;
  }
}
