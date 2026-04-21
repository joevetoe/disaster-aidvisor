import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../widgets/copyright_footer.dart';

class TermsConditions extends StatelessWidget {
  const TermsConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Terms and Conditions"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Expanded(
                child: Markdown(
                data: """Disaster AIDvisor – Terms and Conditions of Use
Effective Date: [Insert Date]
Last Updated: [Insert Date]
1. Informational Use Only
Disaster AIDvisor is intended to provide general, non-specific information and guidance to users who are preparing for, experiencing, or recovering from natural disasters. The Service may also provide generalized explanations of insurance policies and claims processes, or assist users in navigating post-disaster challenges. It draws from publicly available resources, the BuildSOS knowledge base, and large language models (LLMs) via OpenAI's ChatGPT API. It is intended solely for informational and educational purposes and does not constitute legal, financial, insurance, safety, emergency, or professional advice.
2. No Emergency or Real-Time Services
Disaster AIDvisor is not a substitute for 911, emergency alerts, or official disaster response systems. It does not provide real-time weather, evacuation, or safety information and must not be relied on during emergencies. If you are experiencing a life-threatening situation, please immediately call 911 or follow local emergency instructions.
3. Pass-Through to External Resources
The Service may reference or guide users to third-party materials such as FEMA programs, emergency shelter locators, disaster relief resources, insurance guides, and best practice checklists. These references are provided as a convenience only. BuildSOS does not create, control, verify, or guarantee the accuracy, completeness, or timeliness of any third-party resources or content. We are not responsible for any harm, loss, or confusion resulting from reliance on third-party material.
4. No Client, Fiduciary, or Advisory Relationship
Use of the Service does not create any professional relationship between you and BuildSOS or any of its agents. The Service does not constitute legal advice, insurance interpretation, contractor guidance, or emergency preparedness certification. Any decisions you make are your sole responsibility.
5. User Assumes All Risk
You agree that your use of Disaster AIDvisor is entirely at your own risk. BuildSOS and its affiliates, partners, officers, employees, or contractors disclaim any and all liability for damages, including but not limited to: Property damage or delayed recovery, Denied insurance claims, Physical injury or emotional distress, Missed deadlines or filings, Incomplete or outdated advice. You must independently verify all recommendations or resources provided by the Service.
6. No Document Uploads or Data Retention
Disaster AIDvisor does not accept, process, or store uploaded documents. You should not attempt to share sensitive personal or financial information through the Service. Any user input may be processed by the underlying AI system for functionality and improvement purposes, in accordance with our Privacy Policy.
7. Third-Party Technology Disclaimer
The Service is powered in part by OpenAI’s language models and may interface with other third-party APIs and publicly available data. BuildSOS is not responsible for errors, hallucinations, delays, or outages caused by these providers.
8. Acceptable Use
You agree not to misuse the Service or attempt to rely on it in ways not intended, including but not limited to: Submitting false, harmful, or malicious content, Using the Service as a substitute for licensed professionals, Attempting to obtain real-time emergency updates from the chatbot, Making legal, medical, or financial decisions based solely on its responses. We reserve the right to suspend access for any user who misuses the Service.
9. Intellectual Property
All branding, interfaces, original content, and underlying systems developed by BuildSOS are the exclusive property of BuildSOS, LLC, and protected under applicable IP laws. You may not reproduce, copy, distribute, or repurpose content from the Service without written permission.
10. Modifications to Terms
We reserve the right to update or modify these Terms at any time without prior notice. Your continued use of the Service constitutes acceptance of any updated Terms.
11. Governing Law
These Terms shall be governed by and construed in accordance with the laws of the State of Louisiana, without regard to conflict of laws principles. Any disputes not subject to arbitration shall be brought exclusively in the state or federal courts located in Orleans Parish, Louisiana, and you hereby consent to their jurisdiction.
12. Contact Us
For questions regarding these Terms or your use of the Service, please contact:  BuildSOS, LLC [Your Company Address] Email: [Your Contact Email] Phone: [Your Contact Number]
13. Dispute Resolution and Binding Arbitration
PLEASE READ THIS SECTION CAREFULLY. IT AFFECTS YOUR LEGAL RIGHTS.  You agree that any dispute, controversy, or claim arising out of or relating to your use of Disaster AIDvisor or these Terms — including but not limited to the interpretation, breach, enforcement, or validity of these Terms — shall be exclusively resolved through final and binding arbitration, rather than in court.  This arbitration agreement applies to all legal claims, whether arising under contract, tort, statute, regulation, or otherwise, and whether brought individually or as part of a class or other representative proceeding.  Arbitration shall be conducted in accordance with the Commercial Arbitration Rules of the American Arbitration Association (AAA). The arbitration will be held in New Orleans, Louisiana, unless the parties agree otherwise. The arbitration shall be conducted by a single neutral arbitrator mutually agreed upon by the parties or appointed under AAA rules. Each party shall bear its own attorneys’ fees and costs, unless otherwise awarded by the arbitrator under applicable law. The arbitrator's decision shall be final and binding, and judgment may be entered thereon in any court of competent jurisdiction.  By agreeing to these Terms, you and BuildSOS knowingly and voluntarily waive the right to a jury trial and agree that all claims must be brought individually and not as part of a class, collective, or representative action.  Notwithstanding the above, either party may seek equitable relief (such as a temporary restraining order or injunction) in a court of competent jurisdiction in Orleans Parish, Louisiana, for matters relating to intellectual property or misuse of confidential information.
""")),
            const CopyrightFooter(),
          ],
        ),
      ),
    );
  }
}
