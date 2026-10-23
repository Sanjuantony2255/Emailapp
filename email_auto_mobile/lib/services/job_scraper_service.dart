import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/job_listing.dart';

class JobScraperService {
  final Map<String, String> _headers = {
    'User-Agent':
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
    'Accept': 'application/json, text/html, */*',
  };

  bool _matchesKeywords(String title, List<String> keywords) {
    final lowerTitle = title.toLowerCase();

    // Avoid Senior, Lead, or Sr. roles
    if (lowerTitle.contains('senior') ||
        lowerTitle.contains('lead') ||
        RegExp(r'\bsr\.?\b', caseSensitive: false).hasMatch(title)) {
      return false;
    }

    return keywords.any((k) => lowerTitle.contains(k.toLowerCase()));
  }

  Future<List<JobListing>> crawlJobs({
    required List<String> keywords,
    required void Function(String log) onLog,
  }) async {
    final List<JobListing> results = [];

    onLog('Initiating scraper...');
    onLog('Filtering keywords: ${keywords.join(', ')}');

    // 1. Scrape Infopark
    try {
      onLog('Searching Infopark listings...');
      final infoResponse = await http.get(
        Uri.parse('https://infopark.in/companies/job-search'),
        headers: _headers,
      );

      if (infoResponse.statusCode == 200) {
        final html = infoResponse.body;
        final tableMatch = RegExp(
          r'<div[^>]*id="job-list"[\s\S]*?<tbody>([\s\S]*?)<\/tbody>',
        ).firstMatch(html);

        if (tableMatch != null) {
          final rows = tableMatch.group(1)?.split(RegExp(r'<tr>')) ?? [];
          for (final row in rows) {
            if (row.trim().isEmpty) continue;

            final tdMatches = RegExp(r'<td[^>]*>([\s\S]*?)<\/td>')
                .allMatches(row)
                .map((m) => m.group(1) ?? '')
                .toList();

            if (tdMatches.length >= 4) {
              final title = tdMatches[1].replaceAll(RegExp(r'<[^>]*>'), '').trim();
              final company = tdMatches[2].replaceAll(RegExp(r'<[^>]*>'), '').trim();

              if (_matchesKeywords(title, keywords)) {
                final linkMatch = RegExp(r'href="([^"]+)"').firstMatch(row);
                final link = linkMatch?.group(1) ?? '';

                String email = '';
                if (link.isNotEmpty) {
                  onLog('Matched Infopark: $title at $company. Extracting contact...');
                  try {
                    final detailRes = await http.get(Uri.parse(link), headers: _headers);
                    if (detailRes.statusCode == 200) {
                      final detailHtml = detailRes.body;
                      final mailtoMatch = RegExp(r'href="mailto:([^"]+)"', caseSensitive: false)
                          .firstMatch(detailHtml);
                      if (mailtoMatch != null) {
                        email = mailtoMatch.group(1)?.trim() ?? '';
                      } else {
                        final emailMatches = RegExp(r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}')
                            .allMatches(detailHtml)
                            .map((m) => m.group(0) ?? '')
                            .where((e) => !e.contains('infopark.in'))
                            .toList();
                        if (emailMatches.isNotEmpty) {
                          email = emailMatches.first;
                        }
                      }
                    }
                  } catch (e) {
                    onLog('Warning: Could not fetch detail for $title');
                  }
                }

                results.add(JobListing(
                  source: 'Infopark',
                  title: title,
                  company: company,
                  email: email,
                  status: email.isNotEmpty ? 'Pending' : 'No Email Found',
                ));
              }
            }
          }
        }
      }
    } catch (e) {
      onLog('Infopark crawl failed: $e');
    }

    // 2. Scrape Technopark
    try {
      onLog('Searching Technopark listings...');
      final techResponse = await http.get(
        Uri.parse('https://technopark.in/api/paginated-jobs?page=1&search=&type='),
        headers: _headers,
      );

      if (techResponse.statusCode == 200) {
        final Map<String, dynamic> techData = jsonDecode(techResponse.body);
        final List jobList = techData['data'] ?? [];

        for (final job in jobList) {
          final title = job['job_title']?.toString() ?? '';
          if (_matchesKeywords(title, keywords)) {
            final company = job['company']?['company']?.toString() ?? 'Unknown';
            final jobId = job['id']?.toString() ?? '';
            final detailUrl = 'https://technopark.in/job-details/$jobId?job=${Uri.encodeComponent(title)}';

            onLog('Matched Technopark: $title at $company. Extracting contact...');
            String email = '';

            try {
              final detailRes = await http.get(Uri.parse(detailUrl), headers: _headers);
              if (detailRes.statusCode == 200) {
                final detailHtml = detailRes.body;
                final dataPageMatch = RegExp(r'data-page="([^"]+)"').firstMatch(detailHtml);
                if (dataPageMatch != null) {
                  final rawJson = (dataPageMatch.group(1) ?? '')
                      .replaceAll('&quot;', '"')
                      .replaceAll('&amp;', '&');
                  final parsed = jsonDecode(rawJson);
                  email = parsed['props']?['jobListing']?['contact_email']?.toString() ?? '';
                }
              }
            } catch (e) {
              onLog('Warning: Could not fetch Technopark detail for $title');
            }

            results.add(JobListing(
              source: 'Technopark',
              title: title,
              company: company,
              email: email,
              status: email.isNotEmpty ? 'Pending' : 'No Email Found',
            ));
          }
        }
      }
    } catch (e) {
      onLog('Technopark crawl failed: $e');
    }

    onLog('Completed! Found ${results.length} matching jobs.');
    return results;
  }
}
