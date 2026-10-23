import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../services/preferences_service.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  final PreferencesService preferences;

  const SettingsScreen({super.key, required this.preferences});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _backendController;
  late TextEditingController _gmailUserController;
  late TextEditingController _gmailPassController;
  late String _sendMode;

  bool _isTestingBackend = false;
  String? _backendStatus;

  @override
  void initState() {
    super.initState();
    _backendController = TextEditingController(text: widget.preferences.backendUrl);
    _gmailUserController = TextEditingController(text: widget.preferences.gmailUser);
    _gmailPassController = TextEditingController(text: widget.preferences.gmailPassword);
    _sendMode = widget.preferences.sendMode;
  }

  void _saveSettings() {
    widget.preferences.backendUrl = _backendController.text.trim();
    widget.preferences.gmailUser = _gmailUserController.text.trim();
    widget.preferences.gmailPassword = _gmailPassController.text.trim();
    widget.preferences.sendMode = _sendMode;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Settings saved successfully!'),
        backgroundColor: AppTheme.success,
      ),
    );
    Navigator.pop(context);
  }

  Future<void> _testBackend() async {
    setState(() {
      _isTestingBackend = true;
      _backendStatus = null;
    });

    try {
      final res = await http.get(Uri.parse(_backendController.text.trim())).timeout(
            const Duration(seconds: 4),
          );
      setState(() {
        _backendStatus = 'Connected! HTTP ${res.statusCode}';
      });
    } catch (e) {
      setState(() {
        _backendStatus = 'Connection failed: $e';
      });
    } finally {
      setState(() {
        _isTestingBackend = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuration & Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: AppTheme.success),
            onPressed: _saveSettings,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.dns_outlined, color: AppTheme.primaryLight),
                      SizedBox(width: 8),
                      Text('Backend API Integration', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _backendController,
                    decoration: const InputDecoration(
                      labelText: 'Backend Server URL',
                      hintText: 'e.g. http://10.0.2.2:3000 or Vercel URL',
                      helperText: 'Use 10.0.2.2 for Android emulator host loopback',
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: _isTestingBackend ? null : _testBackend,
                    icon: _isTestingBackend
                        ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.speed, size: 16),
                    label: const Text('Test Connection', style: TextStyle(fontSize: 12)),
                  ),
                  if (_backendStatus != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      _backendStatus!,
                      style: TextStyle(
                        fontSize: 12,
                        color: _backendStatus!.contains('Connected') ? AppTheme.success : AppTheme.error,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.mark_email_read_outlined, color: AppTheme.primaryLight),
                      SizedBox(width: 8),
                      Text('Direct Device SMTP (Gmail)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _gmailUserController,
                    decoration: const InputDecoration(
                      labelText: 'Gmail Address',
                      hintText: 'your-email@gmail.com',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _gmailPassController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Gmail 16-Char App Password',
                      hintText: 'xxxx xxxx xxxx xxxx',
                      helperText: 'Generate in Google Account > Security > App Passwords',
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.send_and_archive_outlined, color: AppTheme.cyan),
                      SizedBox(width: 8),
                      Text('Dispatch Preference', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  RadioListTile<String>(
                    title: const Text('Via Express Backend / Vercel API'),
                    subtitle: const Text('Recommended for local dev server (port 3000)'),
                    value: 'backend',
                    groupValue: _sendMode,
                    activeColor: AppTheme.primary,
                    onChanged: (val) => setState(() => _sendMode = val!),
                  ),
                  RadioListTile<String>(
                    title: const Text('Direct Mobile SMTP'),
                    subtitle: const Text('Sends natively from phone using Gmail App Password'),
                    value: 'smtp',
                    groupValue: _sendMode,
                    activeColor: AppTheme.primary,
                    onChanged: (val) => setState(() => _sendMode = val!),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          ElevatedButton(
            onPressed: _saveSettings,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Save & Apply Settings', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
