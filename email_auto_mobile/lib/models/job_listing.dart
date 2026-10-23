class JobListing {
  final String source;
  final String title;
  final String company;
  final String email;
  String status;

  JobListing({
    required this.source,
    required this.title,
    required this.company,
    required this.email,
    this.status = 'Pending',
  });

  factory JobListing.fromJson(Map<String, dynamic> json) {
    return JobListing(
      source: json['source'] ?? '',
      title: json['title'] ?? '',
      company: json['company'] ?? '',
      email: json['email'] ?? '',
      status: json['status'] ?? 'Pending',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'source': source,
      'title': title,
      'company': company,
      'email': email,
      'status': status,
    };
  }
}
