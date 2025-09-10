import 'package:flutter/material.dart';
import 'package:jessy_cabs/Utils/AllImports.dart'; // Assuming your theme and constants are in this file

class TermsAndPoliciesPage extends StatelessWidget {
  const TermsAndPoliciesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final headingStyle = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    );

    final bodyStyle = TextStyle(
      fontSize: 15,
      color: Colors.grey[800],
      height: 1.6,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms & Policies'),
        backgroundColor: AppTheme.Navblue1,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0.5,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        color: Colors.grey[100],
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    section("1. Introduction", """
Welcome to the Jessy Cabs Driver App. By accessing or using this application, you agree to be bound by the terms and policies outlined herein. These terms are applicable to all registered drivers operating under Jessy Cabs.""", headingStyle, bodyStyle),

                    section("2. Driver Obligations", """
• Maintain a valid driver’s license, insurance, and vehicle documentation.
• Operate your vehicle safely and professionally at all times.
• Arrive punctually for all assigned trips.
• Report issues or incidents immediately to support.""", headingStyle, bodyStyle),

                    section("3. Trip Execution", """
• Accept and complete only trips assigned via the Jessy Cabs app.
• Mark accurate trip statuses: Start, In Progress, and Completed.
• Follow the optimal or suggested routes unless instructed otherwise.
• Never solicit or accept cash or tips unless authorized.""", headingStyle, bodyStyle),

                    section("4. Professional Conduct", """
• Treat passengers with courtesy and respect.
• Avoid inappropriate conversations or personal questions.
• Refrain from smoking, consuming alcohol, or playing loud music during trips.
• Comply with all local traffic laws and Jessy Cabs policies.""", headingStyle, bodyStyle),

                    section("5. App Usage", """
• Keep the app updated and functional at all times.
• Ensure location access and notifications are enabled.
• Never share login credentials or allow unauthorized access.
• Use the app only for official Jessy Cabs activities.""", headingStyle, bodyStyle),

                    section("6. Data & Privacy", """
Jessy Cabs collects usage, trip, and location data to ensure operational excellence and safety. All data is handled in compliance with applicable privacy laws and is only shared when legally required.""", headingStyle, bodyStyle),

                    section("7. Payments & Penalties", """
• Payments are issued based on completed trips and company payroll schedules.
• Misconduct or policy violations may result in deductions or suspensions.
• Incentive programs may change without prior notice.""", headingStyle, bodyStyle),

                    section("8. Disciplinary Measures", """
Non-compliance with any of the above terms may lead to:
• Temporary or permanent suspension.
• Financial penalties or non-payment.
• Legal actions in case of fraud, abuse, or endangerment.""", headingStyle, bodyStyle),

                    section("9. Amendments", """
Jessy Cabs reserves the right to update or modify these terms at any time. Continued use of the app constitutes your acceptance of the latest version.""", headingStyle, bodyStyle),

                    section("10. Support & Contact", """
For any assistance, contact Jessy Cabs Support:
📞 +91-XXXXXXXXXX
📧 support@jessycabs.com
Or use the in-app support option from the Help section.""", headingStyle, bodyStyle),

                    const SizedBox(height: 30),
                    Center(
                      child: Text(
                        "By using the Jessy Cabs Driver App, you agree to comply with all the above terms and policies.",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                        "Last Updated: June 27, 2025",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Or handle save/agree logic
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.Navblue1,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "I Agree & Continue",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget section(String title, String content, TextStyle headingStyle, TextStyle bodyStyle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: headingStyle),
          const SizedBox(height: 8),
          Text(content.trim(), style: bodyStyle),
        ],
      ),
    );
  }
}
