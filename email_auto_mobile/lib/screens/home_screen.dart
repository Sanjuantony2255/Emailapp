import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/job_profile.dart';
import '../models/job_listing.dart';
import '../services/email_service.dart';
import '../services/job_scraper_service.dart';
import '../services/preferences_service.dart';
import '../theme/app_theme.dart';
import 'settings_screen.dart';
import 'hybrid_web_screen.dart';

class HomeScreen extends StatefulWidget {
  final PreferencesService preferences;

  const HomeScreen({super.key, required this.preferences});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<JobProfile> _profiles = JobProfile.defaultProfiles;
  late JobProfile _activeProfile;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  final ScrollController _logScrollController = ScrollController();

  late EmailService _emailService;
  final JobScraperService _scraperService = JobScraperService();

  bool _isSending = false;
  String? _statusMessage;
  bool _isSuccessStatus = false;

  bool _isAutomating = false;
  final List<String> _automationLogs = [];
  final List<JobListing> _automationResults = [];

  @override
  void initState() {
    super.initState();
    _activeProfile = _profiles.first;
    _emailService = EmailService(
      backendUrl: widget.preferences.backendUrl,
      gmailUser: widget.preferences.gmailUser,
      gmailAppPassword: widget.preferences.gmailPassword,
    );
    _loadProfileData(_activeProfile);
  }

  void _loadProfileData(JobProfile profile) {
    _activeProfile = profile;
    _subjectController.text = profile.subject;
    _bodyController.text = profile.body;
    _emailController.text = profile.defaultEmail ?? '';
    _statusMessage = null;
    setState(() {});
  }

  void _addLog(String log) {
    setState(() {
      _automationLogs.add(log);
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_logScrollController.hasClients) {
        _logScrollController.animateTo(
          _logScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _handleSendEmail() async {
    final to = _emailController.text.trim();
    if (to.isEmpty) {
      setState(() {
        _statusMessage = 'Please enter a recruiter email to send.';
        _isSuccessStatus = false;
      });
      return;
    }

    setState(() {
      _isSending = true;
      _statusMessage = null;
    });

    Map<String, dynamic> result;
    if (widget.preferences.sendMode == 'smtp' &&
        widget.preferences.gmailPassword.isNotEmpty) {
      result = await _emailService.sendViaSmtp(
        to: to,
        subject: _subjectController.text,
        body: _bodyController.text,
        resumeAssetPath: _activeProfile.resumeAssetPath,
      );
    } else {
      result = await _emailService.sendViaBackend(
        to: to,
        subject: _subjectController.text,
        body: _bodyController.text,
        resumeName: _activeProfile.resumeName,
      );
    }

    setState(() {
      _isSending = false;
      if (result['success'] == true) {
        _statusMessage = 'Email sent successfully! 🚀';
        _isSuccessStatus = true;
      } else {
        _statusMessage = result['error'] ?? 'Failed to send email.';
        _isSuccessStatus = false;
      }
    });
  }

  Future<void> _handleAutomate() async {
    if (_activeProfile.keywords.isEmpty) return;

    setState(() {
      _isAutomating = true;
      _automationLogs.clear();
      _automationResults.clear();
    });

    _addLog('Initiating crawler for ${_activeProfile.title}...');
    _addLog('Keywords: ${_activeProfile.keywords.join(', ')}');

    final listings = await _scraperService.crawlJobs(
      keywords: _activeProfile.keywords,
      onLog: _addLog,
    );

    setState(() {
      _automationResults.addAll(listings);
    });

    // Auto dispatch emails if enabled
    _addLog('Starting dispatch sequence for ${listings.length} contacts...');

    for (final job in listings) {
      if (job.email.isNotEmpty && job.status == 'Pending') {
        _addLog('Sending application to ${job.email} for "${job.title}"...');

        Map<String, dynamic> res;
        if (widget.preferences.sendMode == 'smtp' &&
            widget.preferences.gmailPassword.isNotEmpty) {
          res = await _emailService.sendViaSmtp(
            to: job.email,
            subject: 'Job Application for ${job.title}',
            body: _bodyController.text,
            resumeAssetPath: _activeProfile.resumeAssetPath,
          );
        } else {
          res = await _emailService.sendViaBackend(
            to: job.email,
            subject: 'Job Application for ${job.title}',
            body: _bodyController.text,
            resumeName: _activeProfile.resumeName,
          );
        }

        setState(() {
          if (res['success'] == true) {
            job.status = 'Sent 🚀';
            _addLog('Dispatched successfully to ${job.email}');
          } else {
            job.status = 'Failed';
            _addLog('Dispatch error (${job.email}): ${res['error']}');
          }
        });
      }
    }

    _addLog('Automation workflow finished!');
    setState(() {
      _isAutomating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'RecruitMail',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  'Automator Suite',
                  style: TextStyle(fontSize: 11, color: AppTheme.primaryLight),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Web Preview',
            icon: const Icon(Icons.language_rounded, color: AppTheme.cyan),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HybridWebScreen()),
              );
            },
          ),
          IconButton(
            tooltip: 'Settings',
            icon: const Icon(Icons.settings_outlined, color: AppTheme.textSecondary),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SettingsScreen(preferences: widget.preferences),
                ),
              );
              // Update service instance with new preferences
              _emailService = EmailService(
                backendUrl: widget.preferences.backendUrl,
                gmailUser: widget.preferences.gmailUser,
                gmailAppPassword: widget.preferences.gmailPassword,
              );
              setState(() {});
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Intro Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: AppTheme.cardGradient,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Supercharge Your Job Outreach',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Craft customized emails, attach tailored resumes, and crawl Kerala tech parks with one tap.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Profile selection chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _profiles.map((profile) {
                        final isSelected = _activeProfile.id == profile.id;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(30),
                            onTap: () => _loadProfileData(profile),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                gradient: isSelected ? AppTheme.primaryGradient : null,
                                color: isSelected ? null : AppTheme.surfaceCard,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.transparent
                                      : Colors.white.withValues(alpha: 0.1),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    profile.icon,
                                    size: 16,
                                    color: isSelected ? Colors.white : AppTheme.textSecondary,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    profile.title,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                      color: isSelected ? Colors.white : AppTheme.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Recipient Details Card
            _buildRecipientCard(),

            const SizedBox(height: 16),

            // Email Content & Composer Card
            _buildComposerCard(),

            const SizedBox(height: 16),

            // Automation Hub Card
            if (_activeProfile.keywords.isNotEmpty) _buildAutomationCard(),

            const SizedBox(height: 24),

            // Footer
            Center(
              child: Column(
                children: [
                  RichText(
                    text: const TextSpan(
                      text: 'Designed and Created by ',
                      style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                      children: [
                        TextSpan(
                          text: 'Web7TechSolutions',
                          style: TextStyle(
                            color: AppTheme.primaryLight,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(text: ' of '),
                        TextSpan(
                          text: 'Sanju Antony',
                          style: TextStyle(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () => launchUrl(
                          Uri.parse('https://www.linkedin.com/in/sanju-antony/'),
                        ),
                        child: const Text(
                          'LinkedIn',
                          style: TextStyle(fontSize: 12, color: AppTheme.cyan),
                        ),
                      ),
                      const Text('  •  ', style: TextStyle(color: AppTheme.textMuted)),
                      InkWell(
                        onTap: () => launchUrl(
                          Uri.parse('https://sanju-antony.vercel.app/'),
                        ),
                        child: const Text(
                          'Portfolio',
                          style: TextStyle(fontSize: 12, color: AppTheme.cyan),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipientCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.person_outline, color: AppTheme.primaryLight, size: 20),
                SizedBox(width: 8),
                Text(
                  'Recipient Details',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'To (Recruiter Email)',
                hintText: 'e.g. hr@company.com',
                prefixIcon: const Icon(Icons.mail_outline, size: 18),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_emailController.text.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () => setState(() => _emailController.clear()),
                      ),
                    IconButton(
                      icon: const Icon(Icons.paste_rounded, size: 18),
                      tooltip: 'Paste from clipboard',
                      onPressed: () async {
                        final data = await Clipboard.getData(Clipboard.kTextPlain);
                        if (data?.text != null) {
                          setState(() => _emailController.text = data!.text!);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Your email template for ${_activeProfile.title} is pre-loaded below. Review the subject and body, enter the destination email, and send!',
              style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComposerCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.edit_note_rounded, color: AppTheme.primaryLight, size: 22),
                SizedBox(width: 8),
                Text(
                  'Email Content & Attachment',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Subject field
            TextField(
              controller: _subjectController,
              decoration: const InputDecoration(
                labelText: 'Subject',
                prefixIcon: Icon(Icons.title, size: 18),
              ),
            ),

            const SizedBox(height: 12),

            // Body field
            TextField(
              controller: _bodyController,
              maxLines: 8,
              style: const TextStyle(fontSize: 13, height: 1.5),
              decoration: const InputDecoration(
                labelText: 'Message Body',
                alignLabelWithHint: true,
              ),
            ),

            const SizedBox(height: 14),

            // Resume Attachment Card
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.picture_as_pdf_rounded,
                      color: AppTheme.primaryLight,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _activeProfile.resumeName,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Resume Attachment (Pre-loaded)',
                          style: TextStyle(fontSize: 11, color: AppTheme.textMuted),
                        ),
                      ],
                    ),
                  ),
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.cyan,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                    ),
                    icon: const Icon(Icons.check_circle_outline, size: 16),
                    label: const Text('Ready', style: TextStyle(fontSize: 12)),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Send Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _isSending ? null : _handleSendEmail,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                child: _isSending
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text('Dispatching...', style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.send_rounded, size: 18),
                          SizedBox(width: 8),
                          Text(
                            'Send Email Now',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
              ),
            ),

            if (_statusMessage != null) ...[
              const SizedBox(height: 10),
              Center(
                child: Text(
                  _statusMessage!,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _isSuccessStatus ? AppTheme.success : AppTheme.error,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAutomationCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(Icons.terminal_rounded, color: AppTheme.cyan, size: 22),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Automate ${_activeProfile.title}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: _isAutomating ? null : _handleAutomate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: _isAutomating
                      ? const Text('Running...', style: TextStyle(fontSize: 12))
                      : const Text('Automate Now', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ],
            ),

            const SizedBox(height: 10),
            Text(
              'Scrapes active listings on Infopark & Technopark matching keywords: "${_activeProfile.keywords.take(4).join(', ')}...", extracts recruiter emails, and sends your resume.',
              style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary, height: 1.4),
            ),

            // Live Log Console
            if (_automationLogs.isNotEmpty) ...[
              const SizedBox(height: 14),
              Container(
                height: 120,
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                ),
                child: ListView.builder(
                  controller: _logScrollController,
                  itemCount: _automationLogs.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: Text(
                        '> ${_automationLogs[index]}',
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 11,
                          color: AppTheme.success,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],

            // Results List
            if (_automationResults.isNotEmpty) ...[
              const SizedBox(height: 14),
              const Text(
                'Extracted Job Opportunities',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _automationResults.length,
                separatorBuilder: (_, __) => const Divider(height: 16, color: Colors.white12),
                itemBuilder: (context, index) {
                  final job = _automationResults[index];
                  final isInfopark = job.source == 'Infopark';

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: isInfopark
                              ? Colors.blue.withValues(alpha: 0.2)
                              : Colors.green.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          job.source,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: isInfopark ? Colors.blueAccent : Colors.greenAccent,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              job.title,
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              job.company,
                              style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                            ),
                            if (job.email.isNotEmpty)
                              Text(
                                job.email,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontFamily: 'monospace',
                                  color: AppTheme.cyan,
                                ),
                              ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: job.status.contains('🚀')
                              ? AppTheme.success.withValues(alpha: 0.2)
                              : AppTheme.surfaceElevated,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          job.status,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: job.status.contains('🚀') ? AppTheme.success : AppTheme.textMuted,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
