import 'package:flutter/material.dart';

class JobProfile {
  final String id;
  final String title;
  final IconData icon;
  final String subject;
  final String body;
  final String resumeName;
  final String resumeAssetPath;
  final String? defaultEmail;
  final List<String> keywords;

  const JobProfile({
    required this.id,
    required this.title,
    required this.icon,
    required this.subject,
    required this.body,
    required this.resumeName,
    required this.resumeAssetPath,
    this.defaultEmail,
    required this.keywords,
  });

  static List<JobProfile> get defaultProfiles => [
    const JobProfile(
      id: 'QA',
      title: 'QA Engineer',
      icon: Icons.assignment_outlined,
      subject: 'Application for Software Test Engineer/ QA Engineer',
      body: '''Dear Sir/Madam,

I have recently completed my Master of Computer Applications (MCA) and completed an internship in Software Testing at Camerin Innovative Solutions. I also gained practical experience in software testing and web development through the NextGen Employability Program conducted by Edunet Foundation in collaboration with EY.

During my training and internship, I gained hands-on experience in Manual Testing, Functional Testing, API Testing, Automation Testing, Performance Testing, and Playwright Automation Testing. I performed functional testing on web applications by validating user workflows, form validations, navigation, login functionality, and overall system behavior. I also executed test cases, identified defects, and prepared defect reports to ensure software quality.

I have experience in API testing using Postman, automation testing using Selenium and Playwright, and basic test script development for web applications. Additionally, I performed performance testing using Apache JMeter by simulating multiple user loads and analyzing response time, throughput, and system stability for e-commerce workflows.

I also have knowledge in SQL, Java, Python, JavaScript, Selenium, Playwright, Selenium IDE, JMeter, and TestNG, with experience in both automation and manual testing.

I am familiar with HTML, CSS, React.js, Node.js, Express.js, and MongoDB, which helps me better understand application workflows and backend functionality during testing.

I recently completed Playwright automation testing practice projects and shared my work on LinkedIn: https://www.linkedin.com/in/sanju-antony/

Portfolio: https://sanju-antony.vercel.app/

Thank you.

Best Regards,
Sanju Antony
MCA
8921399907''',
      resumeName: 'Sanju Antony QA1.pdf',
      resumeAssetPath: 'assets/resumes/Sanju Antony QA1.pdf',
      keywords: [
        'test', 'tester', 'qa', 'sdet', 'uat', 'quality assurance', 'quality analyst',
        'quality control', 'testing'
      ],
    ),

    const JobProfile(
      id: 'FullStack',
      title: 'Full Stack Dev',
      icon: Icons.code,
      subject: 'Application for Full stack Developer / Web Developer',
      body: '''Dear Sir/Madam,

I am writing to express my interest in the position at your organization. As a recent graduate of the NextGen Employability Program conducted by Edunet Foundation in collaboration with EY, I have gained strong practical knowledge in full stack development with a focus on the MERN stack.

Through this program, I acquired hands-on experience in the following technologies:

Frontend: React.js, HTML, CSS
Backend: Node.js, Express.js
Database: MongoDB
Tools & Libraries: Postman, Axios, CORS, Mongoose
Authentication: JWT for secure user login and registration

As part of the program, I developed a Personal Finance Manager web application, which was successfully presented to EY officials. This project highlights my ability to integrate modular code, manage user authentication, and connect with MongoDB Atlas.

📌 Portfolio Website : https://sanju-antony.vercel.app/

Along with my technical skills, I bring strong communication and analytical abilities, and I am eager to learn and grow as part of your team. I believe this internship will be a valuable opportunity for me to apply my skills while contributing meaningfully to your projects.

I have attached my updated resume for your kind consideration. I would be grateful for the opportunity to discuss how I can contribute as a React Developer Intern at your organization.

--
Best Regards,

Sanju Antony
MCA
8921399907''',
      resumeName: 'Sanju Antony.pdf',
      resumeAssetPath: 'assets/resumes/Sanju Antony.pdf',
      keywords: [
        'full stack', 'fullstack', 'software developer', 'web developer', 'mern', 'mean',
        'react developer', 'node', 'frontend', 'backend', 'software engineer trainee',
        'application developer', 'junior software engineer', 'software engineer'
      ],
    ),

    const JobProfile(
      id: 'AssociateSE',
      title: 'Associate SE',
      icon: Icons.terminal,
      subject: 'Application for Associate Software Engineer',
      body: '''Dear Sir/Madam,

I am writing to express my interest in the position at your organization. As a recent graduate of the NextGen Employability Program conducted by Edunet Foundation in collaboration with EY, I have gained strong practical knowledge in full stack development with a focus on the MERN stack.

Through this program, I acquired hands-on experience in the following technologies:

Frontend: React.js, HTML, CSS
Backend: Node.js, Express.js
Database: MongoDB
Tools & Libraries: Postman, Axios, CORS, Mongoose
Authentication: JWT for secure user login and registration

As part of the program, I developed a Personal Finance Manager web application, which was successfully presented to EY officials. This project highlights my ability to integrate modular code, manage user authentication, and connect with MongoDB Atlas.

📌 Portfolio Website : https://sanju-antony.vercel.app/

Along with my technical skills, I bring strong communication and analytical abilities, and I am eager to learn and grow as part of your team. I believe this internship will be a valuable opportunity for me to apply my skills while contributing meaningfully to your projects.

I have attached my updated resume for your kind consideration. I would be grateful for the opportunity to discuss how I can contribute as a React Developer Intern at your organization.

--
Best Regards,

Sanju Antony
MCA
8921399907''',
      resumeName: 'Sanju Antony.pdf',
      resumeAssetPath: 'assets/resumes/Sanju Antony.pdf',
      keywords: [
        'associate software engineer', 'associate software developer'
      ],
    ),

    const JobProfile(
      id: 'OlaComplaint',
      title: 'Ola Complaint',
      icon: Icons.warning_amber_rounded,
      subject: 'Urgent Complaint Regarding Delay in Repair of Ola Scooter #12647329',
      body: '''Ola Electric Team,

I am writing to raise a serious complaint regarding my Ola scooter (#12647329), which has been in your showroom/service centre for the last 7 months.

Initially, the service representative informed me that the scooter had an MCU issue. Later, I was told that it was a motor issue, and the motor was replaced. However, after replacing the motor, your team again informed me that the problem is related to the MCU, and the required MCU is currently not available in the service centre and is awaiting delivery from Ola.

This continuous delay and repeated change in diagnosis have caused me significant inconvenience, stress, and loss of time. Despite waiting for several months, the issue has still not been resolved.

I request you to urgently deliver the required MCU to the service centre and complete the repair process as soon as possible. Kindly provide a permanent solution without any further delay.

If this issue is not resolved immediately, I will be forced to proceed with legal action and file a complaint before the appropriate consumer authorities for deficiency in service and the prolonged delay.

Please treat this matter as urgent and provide an immediate update regarding the repair status.

Regards,

Sanju Antony
8921399907''',
      resumeName: 'Ola Ticket Details.pdf',
      resumeAssetPath: 'assets/resumes/Ola Ticket Details.pdf',
      defaultEmail: 'service@olaelectric.com, support@olaelectric.com',
      keywords: [],
    ),
  ];
}
