// import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disasterbuddy/views/terms_conditions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/release_notes.dart';
import '../widgets/whats_new_modal.dart';
import '../constants/colors.dart';
import '../models/chat_model.dart';
import '../l10n/generated/app_localizations.dart';
import '../services/briefing_service.dart';
import '../services/chat_service.dart';
import '../services/locale_controller.dart';
import '../widgets/chat_box.dart';
import '../widgets/copyright_footer.dart';
import '../widgets/custom_round_button.dart';
import '../widgets/send_recieve_bubble.dart';
import '../widgets/text_widget_custom.dart';
import 'package:intl/intl.dart';

import 'login.dart';
import 'reports.dart';

class ChattingScreen extends StatefulWidget {
  const ChattingScreen({super.key});

  @override
  State<ChattingScreen> createState() => _ChattingScreenState();
}

class _ChattingScreenState extends State<ChattingScreen>
    with SingleTickerProviderStateMixin {
  final ChatService _chatService = ChatService();
  final chatref = FirebaseDatabase.instance.ref('chats');
  List<String> userInput = [
    "What am I supposed to do now?",
    "I ,don't know where to start. Can you help?",
    "I'm overwhelmed. What should be my first step?",
    "How do I figure out if I need to evacuate?",
    "What should I do if I think my home might be in danger?",
    "How do I find out what kind of disaster is affecting my area?",
    "I need help planning for a disaster. Where do I begin?",
    "What?s the first thing I should do in an emergency?",
    "How do I check if my home is safe to stay in?",
    "What?s the best way to track emergency alerts and warnings?",
    "How do I prepare if I have no emergency plan yet?",
    "How do I find out if my area is under evacuation orders?",
    "Where can I find shelters or safe places to go?",
    "How do I know what supplies I need right now?",
    "I have kids and pets. What extra steps should I take?",
    "How do I check if my insurance covers disasters?",
    "What government resources are available for disaster help?",
    "I have a disability. What special preparations should I make?",
    "What?s the best way to communicate with family during a disaster?",
    "How do I stay calm and focused in an emergency?",
    "What do I do if I or someone with me is injured?",
    "How do I shut off gas, water, and electricity safely?",
    "How do I protect my home from further damage after a disaster (e.g., broken windows, leaks)?",
    "How do I know if it's safe to go outside or if I should stay indoors?",
    "What local emergency numbers should I have saved?",
    "How do I communicate if cell service or the internet is down?",
    "What should I do if my phone runs out of battery and I can?t access emergency alerts?",
    "How do I evacuate safely if I don?t have a car?",
    "What should I bring with me if I have to leave immediately?",
    "What if I get separated from my family during an evacuation?",
    "Where do I find emergency transportation services?",
    "What important documents should I take with me in an evacuation?",
    "How do I access emergency funds or financial assistance if I lose everything?",
    "Where do I apply for disaster relief funding?",
    "How do I check if my neighbors need help?",
    "How can I help people with disabilities, elderly neighbors, or others who need assistance?",
    "How do I find volunteer groups or organizations that provide disaster aid in my area?",
    "How do I file an insurance claim after a disaster?",
    "What should I do if my home is destroyed or unlivable?",
    "Who do I contact for home repairs and rebuilding assistance?",
    "How do I deal with scammers and fraud after a disaster?",
    "How do I check if my home is structurally safe after a disaster?",
    "How do I prevent mold growth after flooding?",
    "What are the first steps for cleaning up after a disaster?",
    "How do I safely dispose of hazardous materials after a disaster?",
    "Where can I find mental health support after a disaster?",
    "How do I get my children to feel safe again after a disaster?",
    "How do I rebuild my home to be more disaster-resistant?",
    "What should I do if I can?t afford repairs?",
    "Where do I find emergency food and water supplies?",
    "How do I apply for temporary housing assistance?",
    "What should I do with my pets during a disaster?",
    "How do I reconnect utilities after a disaster?",
    "How do I ensure my insurance policy covers future disasters?",
    "How do I track emergency aid distribution in my area?",
    "How can I prepare my business for disaster recovery?",
    "What steps should I take to rebuild my credit after a disaster?",
    "How do I find out if my home is at risk for flooding?",
    "Where can I check if my area is prone to wildfires?",
    "How do I know if my location is vulnerable to hurricanes or tropical storms?",
    "What is the best way to assess my risk for extreme heat events?",
    "How can I determine if my air quality is poor or hazardous?",
    "Where do I enter my address to check my disaster risk?",
    "Why is it important to know my risk for different disasters?",
    "What steps should I take after I check my risk factor?",
    "How does my risk factor affect my insurance rates?",
    "Where can I compare my community's disaster risk levels?",
    "How do I track changes in my disaster risk over time?",
    "What can I do if my home is in a high-risk flood zone?",
    "What does my wildfire risk number mean for my home?s safety?",
    "How do I interpret my wind risk factor results?",
    "Where can I learn more about community resilience ratings?",
    "How do I prepare for extreme heat events based on my risk factor?",
    "What should I do if I live in an area with poor air quality?",
    "Where can I find official preparedness guides for my disaster risks?",
    "How do I order free preparedness materials from FEMA?",
    "What resources exist to help me reduce my home?s disaster risk?",
    "What are the best emergency preparedness apps to download?",
    "Why should I have disaster preparedness apps on my phone?",
    "How do I find open shelters during an emergency?",
    "Where can I download the FEMA emergency app?",
    "How does the FEMA app help during disasters?",
    "What features does the Red Cross Emergency Weather App have?",
    "Where can I download the Red Cross Emergency Weather App?",
    "How can the Red Cross First Aid App help me in an emergency?",
    "Where can I download the Red Cross First Aid App?",
    "What is the Red Cross Pet First Aid App and why do I need it?",
    "Where can I download the Red Cross Pet First Aid App?",
    "How do disaster apps help with communication during emergencies?",
    "Can these apps help me create a disaster preparedness plan?",
    "Do these apps work without an internet connection?",
    "What types of alerts do emergency apps provide?",
    "How do I set up emergency notifications on my phone?",
    "How can I connect with family members using these apps?",
    "Are there any other recommended disaster preparedness apps?",
    "What should I do after downloading these emergency apps?",
    "Can these apps provide real-time disaster updates and evacuation routes?",
    "How do I assess the emergency needs of my household members?",
    "Why is it important to consider individual needs in emergency planning?",
    "How do I create an evacuation plan for an elderly family member?",
    "What should I do if someone in my household has mobility limitations?",
    "How do I ensure my emergency plan includes medical needs?",
    "What medical supplies should be included in an emergency kit?",
    "How do I prepare for communication challenges in an emergency?",
    "What alternative communication methods can I use for family members with hearing impairments?",
    "How do I plan for special accommodations for household members with disabilities?",
    "What steps should I take to ensure dietary needs are met during a disaster?",
    "How do I create an emergency plan that accounts for children?",
    "What should I pack in an emergency kit for infants and toddlers?",
    "How do I ensure my pets are included in my emergency evacuation plan?",
    "Where can I find pet-friendly shelters during a disaster?",
    "How do I prepare for the evacuation of multiple household members with different needs?",
    "What transportation options exist for individuals with disabilities during an evacuation?",
    "How do I practice and test my household?s evacuation plan?",
    "How can I make emergency drills less stressful for children?",
    "What are the most important considerations when planning an evacuation for a large family?",
    "How do I ensure my household?s emergency plan is up to date?",
    "Why is it important to document my house before a disaster?",
    "How can a 3D model of my home help with insurance claims?",
    "What are the best ways to document my home's pre-disaster condition?",
    "How do I take proper photos of my house for insurance purposes?",
    "How many pictures should I take of my home for documentation?",
    "What angles should I capture when photographing my home?",
    "Where should I store my home documentation for safekeeping?",
    "What is Hover.com, and how does it help with home documentation?",
    "How do I create a 3D model of my home using Hover?",
    "Can I use my 3D model for contractor estimates and renovations?",
    "How do I save my 3D model and photos in my BuildSOS profile?",
    "What should I include in my documentation besides photos?",
    "How often should I update my home documentation?",
    "What should I do if my insurance company asks for proof of my home's condition?",
    "How does documenting my home reduce disputes in insurance claims?",
    "Should I document the inside of my house as well?",
    "What are the benefits of purchasing a full 3D home report from Hover?",
    "How do I use my 3D home model to speed up the claims process?",
    "Can my 3D home model be used to estimate repair costs?",
    "What are the best practices for keeping my home documentation updated?",
    "Why is it important to document my belongings before a disaster?",
    "How does having an inventory help with insurance claims?",
    "What?s the best way to document the contents of my home?",
    "Should I take photos or videos of my home?s contents for documentation?",
    "How do I create an asset list for my belongings?",
    "What details should I include in my home inventory?",
    "How do I estimate the value of my belongings for insurance purposes?",
    "Where should I store my asset list and documentation?",
    "What tools or apps can help me create a digital inventory?",
    "How can a 3D model of my home help with asset documentation?",
    "What is Contents360, and how does it help with home inventory?",
    "How do I use my phone?s lidar function to scan the inside of my home?",
    "Should I include receipts or warranties in my home inventory?",
    "How often should I update my asset list?",
    "How do I upload my home inventory to my BuildSOS profile?",
    "What should I do if I don?t have records of older purchases?",
    "Can I use a spreadsheet instead of an app for my asset list?",
    "What?s the easiest way to categorize my belongings in an inventory?",
    "Where can I take an emergency preparedness training course?",
    "How do I prepare my insurance documents along with my home inventory?",
    "Why is it important to find a verified contractor before a disaster?",
    "How do I research and verify a contractor's credentials?",
    "What are the risks of hiring an unverified contractor after a storm?",
    "Where can I find a list of verified contractors in my area?",
    "What should I look for when choosing a contractor for storm repairs?",
    "How do I check if a contractor has the proper licenses and insurance?",
    "What questions should I ask a contractor before hiring them?",
    "How do I know if a contractor has a good reputation?",
    "What are common contractor scams to watch out for after a disaster?",
    "How can I avoid high-pressure sales tactics from contractors?",
    "Is it safe to pay a contractor upfront before work begins?",
    "What should I do if a contractor asks for full payment before starting work?",
    "How do I compare estimates from multiple contractors?",
    "Where can I find customer reviews and ratings for contractors?",
    "How do I report a contractor who scammed me or did poor work?",
    "What should be included in a contract with a contractor?",
    "How can I ensure a contractor will complete the work as promised?",
    "Where do I store my contractor?s contact details for easy access?",
    "Should I have more than one contractor on my list in case of a disaster?",
    "How can I use BuildZoom to find reliable contractors in my area?",
    "Why is it important to set up an emergency communication plan?",
    "How do I create a group chat for disaster communication?",
    "What app should I use to stay in touch with family during emergencies?",
    "Why is WhatsApp recommended for emergency communication?",
    "How do I add family members to my disaster communication group?",
    "What should I include in my emergency communication plan?",
    "How do I keep my emergency contacts updated?",
    "What should I do if phone lines and cell towers go down?",
    "How can I use text messaging to check in with family during a disaster?",
    "What backup communication methods should I have in case of an outage?",
    "How do I ensure elderly family members are included in the communication plan?",
    "How do I share my location with my family during an emergency?",
    "Where should my family?s designated meeting point be in case of evacuation?",
    "How can I practice and test my emergency communication plan?",
    "What should I do if a family member is missing during a disaster?",
    "How can I ensure my family knows what to do if we get separated?",
    "What?s the best way to notify loved ones that I?m safe after a disaster?",
    "How do I keep emergency contact numbers accessible at all times?",
    "What government resources can help with emergency communication planning?",
    "Where can I find the Are You Ready Guide from Ready.gov?",
    "Why is it important to fortify my home against natural disasters?",
    "How can reinforcing my home save me money in the long run?",
    "What are the best ways to protect my home from hurricanes?",
    "How do I strengthen my home?s roof to withstand strong winds?",
    "What steps can I take to secure windows and doors against storms?",
    "How do I prevent water damage from heavy rain and flooding?",
    "What modifications can help protect my home from wildfires?",
    "Where can I find a guide to making my home more resilient to disasters?",
    "How do I reinforce my garage door for extreme weather?",
    "What are the benefits of upgrading my home?s foundation for earthquake resistance?",
    "How do I improve my home?s insulation and ventilation for extreme heat?",
    "What are some cost-effective ways to strengthen my home?s resilience?",
    "What protective measures can I take to reduce hail damage to my home?",
    "How do building codes impact my home?s disaster resilience?",
    "Where can I check if my home meets the latest building codes for resilience?",
    "How can I prepare my mobile home or manufactured home for extreme weather?",
    "What role do sump pumps and drainage systems play in disaster mitigation?",
    "Where can I find professional guidance on fortifying my home?",
    "What upgrades should I prioritize if I live in a disaster-prone area?",
    "How do I share my home resilience upgrades with others to encourage preparedness?",
    "Why is it important to know local emergency contacts before a disaster?",
    "How can having emergency contacts help me during a disaster?",
    "Where can I find my local fire department and police station contact information?",
    "How do I look up the nearest hospitals and medical facilities for emergencies?",
    "What are Disaster Recovery Centers, and how do I find them?",
    "How do I access FEMA resources for declared disasters in my area?",
    "What local community support organizations provide disaster assistance?",
    "Where can I find my nearest emergency shelter before a disaster happens?",
    "What role do community emergency response teams (CERT) play in disaster response?",
    "How can I quickly find evacuation routes in my local area?",
    "How do I set up my phone to receive local emergency alerts and notifications?",
    "How do I find the NOAA weather radio station frequency for my area?",
    "What should I do if I can?t reach 911 during an emergency?",
    "What?s the best way to keep my emergency contacts organized and accessible?",
    "How can I stay informed about road closures and transportation issues during a disaster?",
    "How do I find out if my area has been declared a disaster zone?",
    "What are the benefits of connecting with local emergency management agencies?",
    "Where should I store my community emergency contact information for easy access?",
    "How can I contribute to community resilience and disaster preparedness efforts?",
    "Where do I enter my emergency contacts and disaster details in my BuildSOS profile?",
    "Why is it important to review my insurance policies before a disaster?",
    "How can I find out if I have enough insurance coverage for disasters?",
    "What are the most common types of insurance coverage needed for disasters?",
    "How do I check if my homeowners insurance covers natural disasters?",
    "What does renters insurance typically cover in the event of a disaster?",
    "How do I determine if my small business has adequate disaster insurance?",
    "What steps should I take to review my insurance policy details?",
    "Where can I find digital copies of my insurance policies?",
    "How do I check my policy?s coverage limits and deductibles?",
    "What are common exclusions in insurance policies for disasters?",
    "Where can I compare insurance policies to find better coverage options?",
    "How do I find out if I need additional disaster endorsements or riders?",
    "What resources are available to help me review my insurance coverage?",
    "How do I calculate how much insurance coverage I need for my home?",
    "How do I update my insurance policy if I?ve made home improvements?",
    "Where can I check if I need flood insurance for my home?",
    "What should I do if I realize my insurance coverage is not enough?",
    "How do I store my insurance policies securely for quick access after a disaster?",
    "How can I reach out to my insurance agent to review my coverage?",
    "How do I upload my insurance documents to my BuildSOS profile?",
    "What is an Emergency Financial First Aid Kit (EFFAK)?",
    "Why is financial preparedness important for disaster readiness?",
    "How can having an EFFAK help me recover faster after a disaster?",
    "What key documents should I include in my Emergency Financial First Aid Kit?",
    "Where should I store my EFFAK to keep it safe?",
    "How do I create an emergency savings fund for disaster preparedness?",
    "What are the best ways to protect financial documents from damage?",
    "How do I secure my personal identification documents in case of an emergency?",
    "What financial resources are available to disaster survivors?",
    "How do I access my financial records if I lose everything in a disaster?",
    "Why is it important to have both digital and physical copies of financial records?",
    "What steps should I take to prepare my finances for an emergency?",
    "How do I complete the checklists and forms in the EFFAK toolkit?",
    "Where can I find the FEMA EFFAK guide for financial preparedness?",
    "What should I do if my bank or financial institution is affected by a disaster?",
    "How do I keep my credit and debit cards accessible in an emergency?",
    "What government assistance programs help people with financial recovery after disasters?",
    "How often should I review and update my Emergency Financial First Aid Kit?",
    "What should I do if I don?t have an emergency savings fund?",
    "How do I upload my completed EFFAK to my BuildSOS profile?",
    "Why is it important to have an emergency preparedness kit?",
    "What essential supplies should be in my emergency kit?",
    "How much water should I store for my emergency kit?",
    "What types of non-perishable food should I include in my emergency kit?",
    "How do I choose the best first aid kit for emergencies?",
    "What kind of flashlight is best for an emergency kit?",
    "Why should I have a battery-powered or hand-crank radio in my kit?",
    "What tools should I have in my emergency kit?",
    "How do I store my emergency documents safely?",
    "Where should I keep my emergency kit for quick access?",
    "Should I have separate emergency kits for home and my car?",
    "How do I ensure my emergency kit is up to date?",
    "What special items should I include for infants and young children?",
    "How do I prepare an emergency kit for my pets?",
    "Why is cash important to keep in an emergency kit?",
    "What are the best places to buy emergency preparedness supplies?",
    "How do I create a customized emergency kit for my family?s needs?",
    "What are some budget-friendly ways to build an emergency kit?",
    "How do I safely store medications in my emergency kit?",
    "How do I donate emergency supplies to those in need?",
    "Why is it important to have an emergency evacuation plan?",
    "What should be included in my family?s evacuation plan?",
    "How do I identify primary and alternate evacuation routes?",
    "What factors should I consider when planning an evacuation route?",
    "How do I choose a safe assembly point for my family?",
    "What transportation options should I consider in an emergency evacuation?",
    "How can I ensure my evacuation plan accounts for road closures and detours?",
    "What supplies should I have ready for an evacuation?",
    "How can I prepare an evacuation plan if I have special needs or disabilities?",
    "How do I make sure my pets are included in my evacuation plan?",
    "Where can I find local emergency shelters in my area?",
    "How often should I review and update my family?s evacuation plan?",
    "How can I practice my evacuation plan with my family?",
    "What should I do if I get separated from my family during an evacuation?",
    "How do I prepare an evacuation plan for my workplace?",
    "What should I do if I need to evacuate but don?t have transportation?",
    "How do I stay informed about evacuation orders in my area?",
    "Where should I store copies of my family evacuation plan?",
    "How can I ensure my children understand the evacuation plan?",
    "How do I upload my completed evacuation plan to my BuildSOS profile?",
    "Why is it important to have a pet emergency preparedness plan?",
    "What should be included in a pet emergency kit?",
    "How much food and water should I store for my pet in case of an emergency?",
    "Why is it important to have a pet carrier or crate for emergencies?",
    "How do I find pet-friendly shelters or accommodations for evacuations?",
    "What steps should I take to ensure my pet?s ID tags are up to date?",
    "How does microchipping help keep my pet safe during disasters?",
    "How can I arrange transportation for my pet during an evacuation?",
    "Why is it important to keep my pet?s vaccinations up to date?",
    "Where should I store my pet?s veterinary records and medical history?",
    "What should I do if I must evacuate but cannot take my pet with me?",
    "How do I create a list of emergency contacts for my pet?",
    "What behavioral training can help my pet stay calm during an evacuation?",
    "What are some good comfort items to include in my pet?s emergency kit?",
    "How can I ensure my pet has proper medical care during an emergency?",
    "Why should I practice evacuation drills with my pet?",
    "What should I do if my pet goes missing during a disaster?",
    "How can I prepare a backup plan if pet-friendly shelters are unavailable?",
    "What documentation should I upload to my BuildSOS profile for my pet?",
    "Where can I find more resources on pet emergency preparedness?",
    "Why is it important to have a disaster preparedness plan for individuals with special needs?",
    "What steps should caregivers take to prepare individuals with cognitive disabilities for emergencies?",
    "How can I create an emergency kit for a family member with special needs?",
    "What essential supplies should be included in an emergency kit for individuals with mobility challenges?",
    "How do I ensure emergency responders are aware of my loved one's special needs?",
    "What should I consider when developing an evacuation plan for someone with autism?",
    "How can I help a person with sensory sensitivities remain calm during an emergency?",
    "What are the best communication strategies for individuals with non-verbal disabilities in a disaster?",
    "How do I prepare a medical emergency plan for someone with chronic health conditions?",
    "What resources are available to help individuals with disabilities during an emergency?",
    "How can I ensure accessible transportation during an evacuation for someone with mobility challenges?",
    "What should I do if a loved one with a disability is separated from family during a disaster?",
    "How do I teach a person with an intellectual disability about emergency preparedness?",
    "What role does technology play in disaster preparedness for individuals with disabilities?",
    "How can I ensure medication and medical supplies are available during an emergency?",
    "How do I locate special needs shelters for individuals with disabilities?",
    "What legal rights do individuals with disabilities have in emergency situations?",
    "How can caregivers and community members support individuals with special needs during a disaster?",
    "How often should I review and update an emergency plan for a family member with special needs?",
    "Where can I find training and resources for emergency preparedness for individuals with disabilities?",
    "Why is it important to have a disaster preparedness plan for individuals with special needs?",
    "What steps should caregivers take to prepare individuals with cognitive disabilities for emergencies?",
    "How can I create an emergency kit for a family member with special needs?",
    "What essential supplies should be included in an emergency kit for individuals with mobility challenges?",
    "How do I ensure emergency responders are aware of my loved one's special needs?",
    "What should I consider when developing an evacuation plan for someone with autism?",
    "How can I help a person with sensory sensitivities remain calm during an emergency?",
    "What are the best communication strategies for individuals with non-verbal disabilities in a disaster?",
    "How do I prepare a medical emergency plan for someone with chronic health conditions?",
    "What resources are available to help individuals with disabilities during an emergency?",
    "How can I ensure accessible transportation during an evacuation for someone with mobility challenges?",
    "What should I do if a loved one with a disability is separated from family during a disaster?",
    "How do I teach a person with an intellectual disability about emergency preparedness?",
    "What role does technology play in disaster preparedness for individuals with disabilities?",
    "How can I ensure medication and medical supplies are available during an emergency?",
    "How do I locate special needs shelters for individuals with disabilities?",
    "What legal rights do individuals with disabilities have in emergency situations?",
    "How can caregivers and community members support individuals with special needs during a disaster?",
    "How often should I review and update an emergency plan for a family member with special needs?",
    "Where can I find training and resources for emergency preparedness for individuals with disabilities?",
    "A disaster is approaching?what should I do first?",
    "How do I quickly review my emergency plan before evacuating?",
    "What essential supplies should I gather before a disaster strikes?",
    "How do I secure my home to minimize damage before a hurricane or storm?",
    "Should I unplug my appliances before leaving my home in an emergency?",
    "How do I communicate my evacuation plan with family and friends?",
    "What should I do to prepare my vehicle for evacuation?",
    "Where can I find real-time emergency alerts and evacuation orders?",
    "How can I protect important documents and valuables before evacuating?",
    "What steps should I take to help elderly or disabled family members evacuate safely?",
    "How do I find an open emergency shelter near me?",
    "What items should I take with me when evacuating my home?",
    "What supplies do I need for my pets when evacuating?",
    "How do I stay informed about evacuation routes and road closures?",
    "What are the safest practices when driving during an evacuation?",
    "How do I ensure my household stays together and safe while evacuating?",
    "Where can I access community resources and emergency services during an evacuation?",
    "What should I do if I get separated from my family during an evacuation?",
    "How do I notify emergency responders if I need assistance evacuating?",
    "Should I stay in my home or evacuate when advised by authorities?",
    "What should I do if I am unable to evacuate on my own?",
    "How do I protect my home from looting while evacuating?",
    "How can I support neighbors who may need assistance evacuating?",
    "What should I do if I experience car trouble during an evacuation?",
    "How do I make sure my home is properly secured before I leave?",
    "Should I turn off my utilities before evacuating?",
    "What emergency contacts should I have ready before leaving my home?",
    "How can I communicate with loved ones if phone networks are down?",
    "Where can I find real-time weather updates and alerts?",
    "What should I do if I have medical needs during an evacuation?",
    "How do I handle stress and anxiety during an evacuation?",
    "What should I do if I run out of supplies while evacuating?",
    "How do I safely return home after a disaster has passed?",
    "How can I prepare my home in advance to minimize evacuation risks?",
    "What emergency transportation options are available for people without a car?",
    "How do I recognize and avoid road hazards during an evacuation?",
    "What should I do if I encounter floodwaters while evacuating?",
    "Where can I find financial assistance after a disaster?",
    "How can I help my children feel safe and calm during an evacuation?",
    "What steps should I take if I need to shelter in place instead of evacuating?",
    "How do I assist individuals with disabilities during an evacuation?",
    "What should I do if I have pets but shelters don?t allow them?",
    "Where can I report unsafe evacuation conditions or hazards?",
    "How do I recharge my phone and devices if there is no electricity?",
    "What legal protections do I have if I am forced to evacuate my home?",
    "How do I locate family members after a disaster if we are separated?",
    "What safety measures should I follow when using a generator after evacuation?",
    "What?s the best way to find out when it?s safe to return home?",
    "How can I access mental health resources if I feel overwhelmed after evacuation?",
    "What should I do if I cannot return home for an extended period?",
    "Why is fraud so common after a disaster?",
    "What are the most common scams people face after a disaster?",
    "How can I recognize a fraudulent contractor?",
    "What should I do if someone claiming to be a government official asks for money?",
    "How do I verify the identity of someone claiming to be from FEMA or another agency?",
    "What are impersonation scams, and how can I avoid them?",
    "How do scammers use identity theft after a disaster?",
    "What steps can I take to protect my personal information during disaster recovery?",
    "How can I tell if a contractor is legitimate?",
    "What should I do if someone comes to my door offering repair services?",
    "Where can I report disaster-related fraud?",
    "How do I avoid scams when applying for disaster assistance?",
    "What are some red flags that indicate a contractor might be a scammer?",
    "How do I check if a contractor is properly licensed and insured?",
    "What should I do if I think I?ve already been scammed?",
    "How do scammers trick people into signing fraudulent documents?",
    "Why do scammers target disaster victims specifically?",
    "How can I safely donate to disaster relief without falling for scams?",
    "What are some online scams to watch out for after a disaster?",
    "How can I warn others in my community about post-disaster fraud?",
    "How do I know if it's safe to return home after a disaster?",
    "What are the biggest risks of returning home too soon?",
    "Where can I find official re-entry updates for my area?",
    "How do I sign up for emergency alerts about re-entry?",
    "What safety precautions should I take before going back home?",
    "How do I check if roads are safe and accessible after a disaster?",
    "What should I do if my neighborhood is still flooded?",
    "How do I know if my home is structurally safe to enter?",
    "What should I do if I smell gas or see downed power lines near my home?",
    "Where can I report unsafe conditions like collapsed buildings or toxic spills?",
    "What government resources provide re-entry guidelines?",
    "Should I contact local authorities before attempting to return home?",
    "How do I prepare an emergency kit for returning home safely?",
    "What should I do if my home has significant water damage?",
    "How can I safely remove debris and fallen trees after a storm?",
    "What protective gear should I wear when inspecting my home?",
    "How do I document damage for insurance claims when I return home?",
    "Where can I find temporary housing if my home is unlivable?",
    "How do I reconnect utilities safely after a disaster?",
    "What should I do if I suspect mold or contamination in my home?",
    "What should I do before entering my home after a disaster?",
    "How can I ensure my safety when re-entering a flooded home?",
    "What precautions should I take regarding utilities when returning home?",
    "How do I handle food safety after a disaster?",
    "What should I do if I smell gas upon returning home?",
    "How can I prevent mold growth after flooding?",
    "Are there specific clothing recommendations for re-entering a disaster area?",
    "How do I check if my water is safe to use after a disaster?",
    "What steps should I take if my home was closed for several days after flooding?",
    "How can I safely use a generator after a disaster?",
    "What should I do if I encounter wildlife in my home upon return?",
    "How do I handle debris removal safely after a disaster?",
    "What are the risks of using candles for lighting after a disaster?",
    "How can I ensure my mental well-being during disaster recovery?",
    "What should I do if my home has sewage contamination after flooding?",
    "How do I handle electrical appliances that were submerged in water?",
    "Are there any specific steps to take if my home was damaged by fire?",
    "How can I protect myself from carbon monoxide poisoning during cleanup?",
    "What should I do if I find structural damage in my home?",
    "How do I handle insurance claims after a disaster?",
    "How do I begin assessing damage to my home after a storm?",
    "What are common types of storm damage I should look for?",
    "How can I safely inspect my roof for damage?",
    "What should I do if I find water damage inside my home?",
    "How can I tell if my home's foundation has been compromised?",
    "What steps should I take to document damage for insurance purposes?",
    "How do I handle debris removal after a disaster?",
    "Are there specific hazards I should be aware of during cleanup?",
    "How can I assess smoke damage after a fire?",
    "What should I do if I discover mold during my inspection?",
    "How can I salvage important documents damaged by water?",
    "What are the signs of electrical damage I should look for?",
    "How do I determine if my windows and doors are still secure?",
    "What should I consider when hiring professionals for repairs?",
    "How can I assess damage to my home's insulation?",
    "What precautions should I take when entering a damaged building?",
    "How do I handle potential asbestos exposure during cleanup?",
    "What steps should I take if my heating and cooling systems are damaged?",
    "How can I prevent further damage to my home while awaiting repairs?",
    "What resources are available to assist with post-disaster housing repairs?",
    "How should I document the exterior damage to my home after a disaster?",
    "What specific areas should I focus on when photographing the interior of my home post-disaster?",
    "How can I effectively document damaged personal belongings inside my home?",
    "Should I take videos in addition to photographs when documenting damage?",
    "How can I organize my photos and videos for insurance purposes?",
    "What details are important to note when documenting structural damage?",
    "How do I document temporary repairs made to prevent further damage?",
    "Is it necessary to document areas of my home that appear undamaged?",
    "How can I use technology to enhance my documentation process?",
    "What steps should I take if I cannot access certain damaged areas safely?",
    "How can I document damage to landscaping or external structures?",
    "Should I include utility systems in my damage documentation?",
    "How do I handle documentation if my pre-disaster asset list is outdated or incomplete?",
    "What information should I include in my updated asset list for damaged items?",
    "How can I ensure my documentation is accepted by my insurance company?",
    "Are there tools available to create a 3D model of my home's damage?",
    "",
    "How do I submit my documentation to my insurance company?",
    "What should I do with my documentation after submitting it to my insurer?",
    "How can I document damage if I don't have access to a camera or smartphone?",
    "Why is thorough documentation important for the disaster recovery process?",
    "How soon should I contact my contractor after discovering damage to my property?",
    "What information should I provide to my contractor during our initial post-disaster communication?",
    "How can I verify that my contractor is licensed and insured?",
    "What are the risks of hiring an unlicensed contractor for post-disaster repairs?",
    "How can I protect myself from contractor fraud after a disaster?",
    "What are common signs of contractor scams to watch out for?",
    "How can I find a reputable contractor if I don't have one pre-identified?",
    "What steps should I take to vet a new contractor after a disaster?",
    "Is it advisable to get multiple bids for the repair work?",
    "How much of a deposit is reasonable to pay a contractor upfront?",
    "Should I sign a contract before the repair work begins?",
    "How can I ensure that the work is completed to my satisfaction?",
    "What should I do if my contractor is unresponsive or not showing up as scheduled?",
    "Are there specific permits required for post-disaster repairs?",
    "How can I verify a contractor's track record with past clients?",
    "What should be included in a contract with a contractor?",
    "How do I handle unexpected issues or additional repairs discovered during the project?",
    "Is it normal for contractors to request progress payments?",
    "How can I terminate a contract if I'm dissatisfied with the contractor's performance?",
    "What resources are available if I need assistance with contractor disputes?",
    "Why is it important to review my homeowners insurance policy regularly?",
    "What are coverage limits in a homeowners insurance policy?",
    "How can I find out what my policy covers and excludes?",
    "What is a deductible in homeowners insurance?",
    "",
    "How do I choose the right deductible amount?",
    "",
    "Are there different types of deductibles in homeowners insurance?",
    "",
    "What is the difference between actual cash value and replacement cost coverage?",
    "Does my policy cover flood or earthquake damage?",
    "",
    "How can I ensure my policy covers the full replacement cost of my home?",
    "What are special limits of liability in a homeowners policy?",
    "How do I file a homeowners insurance claim?",
    "What is loss of use coverage?",
    "Are there exclusions I should be aware of in my policy?",
    "How can I update my policy to reflect home renovations?",
    "What is personal liability coverage in a homeowners policy?",
    "How does my credit score affect my homeowners insurance premium?",
    "Can I bundle my homeowners insurance with other policies for discounts?",
    "What should I do if I disagree with my insurer's claim settlement offer?",
    "How often should I review my homeowners insurance policy?",
    "Where can I find more information about homeowners insurance?",
    "What should I do immediately after my home has been damaged by a disaster?",
    "How do I file a homeowners insurance claim after a disaster?",
    "What information will I need when filing an insurance claim?",
    "How soon should I file my insurance claim after a disaster?",
    "What if I can't find my insurance policy documents after the disaster?",
    "Should I make temporary repairs before the insurance adjuster arrives?",
    "How do I document the damage for my insurance claim?",
    "What is an insurance adjuster, and what is their role in the claims process?",
    "How can I prepare for the insurance adjuster's visit?",
    "What if I disagree with the insurance adjuster's assessment?",
    "Will my insurance cover additional living expenses if my home is uninhabitable?",
    "How long does it typically take to receive an insurance payout after filing a claim?",
    "What are common reasons for claim denials after a disaster?",
    "Can I choose my own contractor for repairs, or do I have to use one recommended by my insurer?",
    "How does my deductible affect my insurance claim?",
    "What if I discover additional damage after the initial adjuster's visit?",
    "Are there any deadlines I should be aware of when filing an insurance claim?",
    "How can I track the progress of my insurance claim?",
    "What steps can I take to ensure a smooth claims process?",
    "What should I do if my claim is denied?",
    "What is an insurance policyholder's bill of rights?",
    "How can I find my state's insurance policyholder's bill of rights?",
    "What are some common rights included in a policyholder's bill of rights?",
    "Do all states have a policyholder's bill of rights?",
    "How does understanding my rights help in the claims process?",
    "What should I do if I believe my insurer is violating my rights?",
    "Are there federal protections for insurance policyholders?",
    "Can my insurer cancel my policy without notice?",
    "What is the role of the state Department of Insurance?",
    "How can I verify if an insurance company or agent is licensed in my state?",
    "What is the process for filing a complaint against an insurer?",
    "Are there time limits for filing a complaint or appeal?",
    "Can I seek legal action if my rights are violated?",
    "What is the significance of the NAIC's model laws?",
    "How can I stay informed about my rights as a policyholder?",
    "Are there specific rights related to claim settlements?",
    "What is the right to a readable policy?",
    "How does the policyholder's bill of rights protect against unfair practices?",
    "Can my insurer change my policy terms without informing me?",
    "Where can I find more information about my rights as a policyholder?",
    "How do I access my EFFAK after a disaster?",
    "What should I do first with my EFFAK post-disaster?",
    "How can my EFFAK assist in filing insurance claims?",
    "What financial information in the EFFAK is crucial for disaster assistance applications?",
    "How can the EFFAK help with medical needs after a disaster?",
    "What should I do if some documents in my EFFAK are damaged or missing?",
    "How can the EFFAK assist in communicating with creditors post-disaster?",
    "Can the EFFAK help in applying for federal disaster assistance?",
    "How do I use the EFFAK to verify property ownership for assistance programs?",
    "What steps should I take to protect my EFFAK during ongoing recovery efforts?",
    "How can the EFFAK aid in re-establishing employment records?",
    "How do I update my EFFAK after experiencing a disaster?",
    "Can the EFFAK assist with pet recovery efforts?",
    "How does the EFFAK help in maintaining continuity of bill payments?",
    "What legal documents in the EFFAK are important after a disaster?",
    "How can the EFFAK assist in re-establishing utility services?",
    "How do I use the EFFAK to manage healthcare expenses post-disaster?",
    "Can the EFFAK help with educational records recovery?",
    "How does the EFFAK support communication with emergency contacts?",
    "What steps should I take if I didn't prepare an EFFAK before the disaster?",
    "What are some affordable ways to make my home more disaster-resistant during rebuilding?",
    "How can I ensure my rebuilt home meets modern building codes for disaster resilience?",
    "Are there specific materials recommended for rebuilding in wildfire-prone areas?",
    "How can I protect my home from future flooding during the rebuilding process?",
    "What roofing designs are best for hurricane-prone regions?",
    "Are there energy-efficient upgrades that also improve disaster resilience?",
    "How can landscaping contribute to my home's resilience?",
    "What are the benefits of using insulated concrete forms (ICFs) in rebuilding?",
    "How can I make my home's electrical system more resilient?",
    "Are there specific window features that enhance disaster resilience?",
    "How does the choice of siding material affect my home's durability in disasters?",
    "What role does attic ventilation play in home resilience?",
    "Can upgrading my home's insulation contribute to disaster resilience?",
    "How can I reinforce my garage door to withstand storms?",
    "Are there affordable measures to protect my home from earthquakes?",
    "How does roof overhang length affect my home's resilience?",
    "What are the advantages of a fortified home program?",
    "How can I improve water drainage around my home during rebuilding?",
    "How can I assess if my family understood our evacuation plan during the recent disaster?",
    "What steps should I take to evaluate the effectiveness of our evacuation routes?",
    "How can I improve communication during an evacuation?",
    "What should I do if we felt rushed or unprepared during our last evacuation?",
    "How can I ensure emergency supplies are accessible during an evacuation?",
    "What measures can I take to prevent transportation issues during an evacuation?",
    "How do I evaluate the adequacy of emergency shelters we used?",
    "What strategies can help in reuniting with family members or pets during evacuations?",
    "How can I identify gaps in our current evacuation plan?",
    "What role do regular drills play in improving our evacuation plan?",
    "How can I stay informed about potential evacuation routes and hazards?",
    "What should I consider when choosing an emergency shelter?",
    "How can I ensure my evacuation plan accounts for special needs within my household?",
    "What steps can I take to improve our evacuation plan based on past experiences?",
    "How can I ensure effective communication with local authorities during an evacuation?",
    "What role does community involvement play in evacuation planning?",
    "How can I ensure my evacuation plan is adaptable to different types of emergencies?",
    "What types of disaster relief programs are available to homeowners after a storm?",
    "How can I find financial assistance for home repairs after a disaster?",
    "Where can I find temporary housing if my home is uninhabitable?",
    "How do I apply for disaster unemployment assistance if I lost my job due to a storm?",
    "What mental health support services are available for disaster survivors?",
    "How can I get food assistance after a disaster?",
    "Are there financial grants for businesses affected by natural disasters?",
    "What legal assistance is available for disaster survivors?",
    "How can I get help replacing important documents lost in a disaster?",
    "What resources are available for senior citizens recovering from a disaster?",
    "How do I get assistance for individuals with disabilities affected by a disaster?",
    "Where can I find childcare services if my child's school or daycare was damaged?",
    "How do I access low-interest loans for rebuilding my home?",
    "Are there special assistance programs for renters displaced by a disaster?",
    "How can I find out what support services are available in my community?",
    "What organizations help immigrants and undocumented individuals after a disaster?",
    "How do I apply for emergency utility assistance after a disaster?",
    "What support is available for farmers and rural communities affected by a disaster?",
    "How can I connect with volunteers and organizations helping disaster survivors?",
    "What steps should I take to access FEMA disaster relief programs?",
    "How do I know if my child needs professional help after a disaster?",
    "What should I do if I'm having trouble sleeping due to stress from the disaster?",
    "Can disasters trigger PTSD, and what are the symptoms?",
    "How can I support an elderly family member who is struggling emotionally after a disaster?",
    "What if I can?t afford therapy but need mental health support?",
    "How do I manage survivor?s guilt after a disaster?",
    "What are some grounding techniques I can use if I feel anxious or overwhelmed?",
    "How can journaling help in processing emotions after a disaster?",
    "What should I do if I feel isolated after a disaster?",
    "How can I prepare mentally for potential future disasters?",
    "Are you a contractor, builder, or subcontractor looking for disaster preparedness and recovery resources?",
    "How can I prepare my construction business for disaster response and recovery work?",
    "What should contractors know about disaster recovery before taking on projects in storm-damaged areas?",
    "How do I become certified for disaster response contracting?",
    "What are the key safety protocols for contractors working in post-disaster zones?",
    "What are the best practices for working with insurance claims as a contractor?",
    "How can I secure FEMA or government contracts for rebuilding efforts?",
    "What legal or compliance issues should contractors be aware of when working on disaster-damaged properties?",
    "How can I ensure my company is properly insured for disaster response work?",
    "What should subcontractors know before signing onto post-disaster rebuilding jobs?",
    "How do I verify that a client has legitimate insurance coverage before starting repair work?",
    "How can I help homeowners navigate the insurance claims process for repairs?",
    "What common contractor scams should I be aware of in post-disaster areas?",
    "What are the financial risks of taking on disaster recovery work as a contractor?",
    "What is the process for getting paid on insurance-funded disaster repair jobs?",
    "How can I protect my construction crew when working in hazardous post-disaster environments?",
    "What materials and construction methods should I use to build disaster-resilient homes?",
    "How can I prepare my contracting business for rapid deployment after a disaster?",
    "What disaster-specific building codes should I be aware of when rebuilding damaged properties?",
    "How can I stay compliant with state and federal regulations when performing disaster recovery work?",
    "How can building to code make me more money as a contractor?",
    "What?s the business advantage of using disaster-resistant materials?",
    "Will insurance companies give me a break if I build to resilience standards?",
    "How do resilient construction practices lower my liability as a contractor?",
    "How can I market myself as an expert in disaster-resilient construction?",
    "Are customers really willing to pay more for resilient homes and buildings?",
    "How do I explain the ROI of resilience to my clients?",
    "What are the top three upgrades that make a home more resilient without adding major costs?",
    "How do I get more work in post-disaster rebuilding efforts?",
    "What are the biggest mistakes contractors make when rebuilding after a disaster?",
    "Is building to code enough, or should I go beyond code?",
    "How do I sell resilient construction to customers who just want the cheapest option?",
    "What?s the difference between standard building codes and IBHS Fortified standards?",
    "How do I integrate disaster resilience into my business without raising costs too much?",
    "Can I get government grants or incentives for building more resilient homes?",
    "Do I need special training or certification to market myself as a disaster-resilient contractor?",
    "How do I ensure my subcontractors follow resilience standards on my projects?",
    "What construction mistakes cause the most damage in hurricanes and storms?",
    "How do I get homeowners to invest in storm-resistant features before a disaster?",
    "How does resilient construction help me win more government or commercial contracts?",
    "How do I talk to insurance adjusters when working on disaster repairs?",
    "What?s the biggest misconception contractors have about disaster-resistant construction?",
    "How can I use resilient construction as a competitive advantage?",
    "What?s the best way to train my crew on resilience construction techniques?",
    "How does code compliance help my business grow?",
    "Can I really make more money by following building codes?",
    "What are the financial risks of ignoring building codes?",
    "How do I know if I?m following the most up-to-date codes?",
    "What?s the difference between ?meeting code? and ?going beyond code??",
    "How does code compliance reduce my liability as a contractor?",
    "What kind of legal trouble can I get into for not following codes?",
    "What?s the best way to train my crew on building code compliance?",
    "How do modern building codes help homes survive natural disasters?",
    "Do modern codes really make a difference in storm damage?",
    "What?s the real cost of skipping permits and inspections?",
    "How can code compliance help me win more high-value contracts?",
    "How do I handle clients who want me to cut corners to save money?",
    "What are the most common code violations that get contractors in trouble?",
    "Does code compliance really impact insurance rates?",
    "What are some easy ways to ensure my projects stay compliant?",
    "How do I get my subcontractors to follow building codes?",
    "Can failing to meet code void a homeowner?s insurance policy?",
    "What happens to buildings that don?t comply with modern codes?",
    "What?s the biggest misconception about building code compliance?",
    "Are newer building codes harder to follow than older ones?",
    "What incentives exist for building code compliance?",
    "How do I handle disputes with inspectors over code compliance?",
    "What resources can help me stay on top of code changes?",
    "How can I position myself as a leader in resilient construction?",
    "What?s the business advantage of building for resilience?",
    "How do resilient communities benefit contractors?",
    "What are the top ways contractors can help communities recover faster after disasters?",
    "What?s the difference between standard building and resilience-focused construction?",
    "How does building resilient homes and buildings increase my bottom line?",
    "What?s the ROI for homeowners when they invest in resilient construction?",
    "How do I get homeowners to care about community resilience?",
    "Are there incentives for contractors who build resilient homes?",
    "How do I get involved in post-disaster rebuilding efforts?",
    "How can I market my business as a disaster recovery expert?",
    "What are the most common mistakes contractors make in disaster recovery work?",
    "How do I make sure my subcontractors follow resilience best practices?",
    "What construction techniques make a building more resilient without adding major costs?",
    "What?s the best way to educate my clients on the value of resilient homes?",
    "How does resilience-focused construction affect my insurance as a contractor?",
    "How can I tap into government-funded resilience projects?",
    "What are the biggest challenges in rebuilding communities after a disaster?",
    "How can I future-proof my projects against climate-related disasters?",
    "What role do building codes play in community resilience?",
    "How can contractors work with local governments to improve community resilience?",
    "What?s the future of resilient construction, and how do I stay ahead of it?",
    "How do resilient communities impact my long-term workload as a contractor?",
    "Why should I care about community resilience as a contractor?",
    "What are Fortified Building Standards, and why should I care?",
    "How can building Fortified homes make me more money?",
    "Do Fortified homes really make a difference in storms?",
    "How can I market myself as a Fortified contractor?",
    "Will insurance companies give my clients discounts for Fortified homes?",
    "What?s the difference between regular building codes and Fortified standards?",
    "What are the three levels of Fortified standards, and which should I build to?",
    "How do I convince clients to pay extra for Fortified homes?",
    "How do I get certified to build Fortified homes?",
    "Will building to Fortified standards slow down my projects?",
    "Do Fortified homes sell for more than traditional homes?",
    "How can Fortified construction help me secure more commercial projects?",
    "What materials should I use to meet Fortified Roof standards?",
    "What?s the easiest way to upgrade my builds to meet Fortified standards?",
    "Are there Fortified standards for fire resistance and earthquakes too?",
    "Can I retrofit existing homes to meet Fortified standards?",
    "What?s the ROI of Fortified construction for homeowners?",
    "How does Fortified construction help communities recover faster after disasters?",
    "How do I convince developers to include Fortified standards in their projects?",
    "What?s the main reason contractors hesitate to build to Fortified standards?",
    "How does Fortified Gold differ from Silver and Roof levels?",
    "Do Fortified standards help with energy efficiency?",
    "How do I estimate the cost difference between a standard home and a Fortified home?",
    "What?s the future of Fortified construction, and how do I stay ahead?",
    "Why should I, as a contractor, understand the insurance claims process?",
    "How do insurance claims impact how quickly I get paid?",
    "What?s the biggest mistake contractors make when working with insurance claims?",
    "How can I make sure adjusters approve my repair estimates?",
    "What?s the difference between a field adjuster and a desk adjuster?",
    "How do I build relationships with insurance adjusters?",
    "What?s the best way to document storm damage for an insurance claim?",
    "Can I help homeowners file an insurance claim?",
    "How do I ensure I get paid when insurance underpays a claim?",
    "What role does a mitigation company play in the claims process?",
    "How can I speed up an insurance claim for my client?",
    "What happens if a homeowner disagrees with an adjuster?s payout?",
    "Should I wait for insurance approval before starting repairs?",
    "How do I avoid disputes with insurance companies over pricing?",
    "How can I help homeowners understand what their insurance covers?",
    "What should I do if an insurance company delays payment?",
    "How do I handle insurance claims for major disasters like hurricanes?",
    "What?s the best way to negotiate with adjusters?",
    "How do I handle depreciation on insurance claims?",
    "Can insurance deny claims for improper documentation?",
    "What should I do if an adjuster undervalues a repair?",
    "Are homeowners required to use insurance-preferred contractors?",
    "How do I protect myself from homeowners who don?t pay after an insurance payout?",
    "What are the biggest red flags in fraudulent insurance claims?",
    "How can contractor fraud impact my business, even if I?m honest?",
    "What are the biggest types of contractor fraud I need to watch out for?",
    "How do I know if I?m being used in an insurance fraud scheme?",
    "What?s the fastest way to lose my contractor license?",
    "How can I prove I?m a legitimate contractor and not a ?storm chaser??",
    "What should I do if a homeowner asks me to ?inflate? an insurance claim?",
    "How do I protect myself from fraudulent subcontractors?",
    "What?s the risk of accepting cash payments to avoid paperwork?",
    "What are red flags that a contractor might be committing fraud?",
    "How do fraudulent contractors get caught?",
    "What happens if I unknowingly submit an inflated claim?",
    "Can I get blacklisted by insurance companies?",
    "What?s the safest way to handle insurance-funded jobs?",
    "What?s the risk of subcontracting insurance work to an unlicensed contractor?",
    "How do I educate homeowners on avoiding contractor fraud?",
    "What?s the best way to prove I?m not overcharging for materials and labor?",
    "What should I do if a homeowner refuses to pay after an insurance payout?",
    "Are storm chaser contractors always scammers?",
    "How do I report a contractor committing fraud?",
    "What?s the most common fraud scheme after a disaster?",
    "How does contractor fraud impact insurance premiums?",
    "Can I get in trouble for working with a public adjuster?",
    "How do I protect my company from getting wrapped up in a fraud investigation?",
    "How do I compete against dishonest contractors who undercut pricing?",
    "Why is a quick and accurate damage assessment important for contractors?",
    "How can I ensure my team stays safe when assessing a disaster site?",
    "What PPE is required for post-disaster site assessments?",
    "What are the biggest hazards contractors face when inspecting a disaster site?",
    "How can I conduct a safe and effective walkthrough of a damaged property?",
    "What should I look for in a structural integrity check after a disaster?",
    "How do I assess water damage in a home after a flood?",
    "What?s the best way to document damage for an insurance claim?",
    "How do I communicate my damage assessment to adjusters and homeowners?",
    "What tools should I bring for a post-disaster assessment?",
    "How do I determine if a home is too unsafe to enter after a disaster?",
    "What are the most overlooked dangers in post-disaster assessments?",
    "How do I assess a roof?s safety before stepping on it?",
    "Should I enter a home with standing water after a flood?",
    "How do I check for electrical hazards after a storm?",
    "How can I assess fire damage in a structure safely?",
    "What?s the role of the buddy system in post-disaster assessments?",
    "How do I handle homeowners who want to rush assessments?",
    "What should I do if I suspect mold contamination in a home?",
    "How do I prioritize emergency repairs after an assessment?",
    "What should I do if a site is too dangerous to assess?",
    "How do I prepare my team for post-disaster assessments?",
    "How do I assess commercial buildings versus residential homes?",
    "How can I use drones for safer damage assessments?",
    "Why are temporary repairs so important after a disaster?",
    "How can temporary repairs help me get more work as a contractor?",
    "What are the most common temporary repairs after a hurricane?",
    "How do I properly tarp a roof after storm damage?",
    "What?s the best way to board up broken windows and doors?",
    "How do I handle temporary repairs after a flood?",
    "Can temporary repairs lower insurance claim costs?",
    "What are the biggest safety concerns with temporary repairs?",
    "How do I protect homes from further damage after an earthquake?",
    "What?s the best way to deal with fire-damaged homes?",
    "How do I stabilize a structure after major storm damage?",
    "What tools should I always carry for post-disaster temporary repairs?",
    "How do I set up a temporary power solution after a disaster?",
    "What?s the best approach for mold prevention after water damage?",
    "How do I handle temporary repairs when insurance claims are still pending?",
    "Should I charge separately for temporary repairs and permanent fixes?",
    "How can I use temporary repairs to build trust with insurance adjusters?",
    "How do I prevent liability when performing temporary repairs?",
    "What materials should I keep stocked for emergency repairs?",
    "How do I manage multiple temporary repair jobs after a major disaster?",
    "What?s the best way to handle insurance paperwork for temporary repairs?",
    "How can I prevent further erosion after wildfires?",
    "How do I help homeowners understand the need for temporary repairs?",
    "What are the best ways to market myself as a disaster response contractor?",
    "Why should I build for resilience instead of just meeting code?",
    "How can resilient construction help me get more high-paying clients?",
    "What are the best upgrades to make homes more resilient to hurricanes?",
    "How can I convince homeowners to invest in resilient rebuilding?",
    "What are the best materials for rebuilding stronger homes?",
    "How does resilient construction lower my risk as a contractor?",
    "What?s the ROI for clients who rebuild using resilient techniques?",
    "What?s the easiest way to upgrade a home to be flood-resistant?",
    "How do I get certified in resilient construction?",
    "How do I integrate seismic resilience into my projects?",
    "What?s the best way to protect homes from wildfire damage?",
    "How can smart technology improve resilience?",
    "What?s the biggest mistake contractors make when rebuilding after a disaster?",
    "Are there tax credits or incentives for resilient construction?",
    "How do I differentiate myself as a contractor specializing in resilient construction?",
    "What?s the best way to make roofing more disaster-resistant?",
    "How can modular construction help with resilient rebuilding?",
    "How do I retrofit older homes for better resilience?",
    "What?s the difference between a standard build and a Fortified build?",
    "How does resilient rebuilding help entire communities recover faster?",
    "What?s the role of renewable energy in resilient construction?",
    "What?s the biggest misconception about resilient construction?",
    "How do I future-proof my builds against extreme weather changes?",
    "How can I market myself as a resilience-focused contractor?",
    "Why should I, as a contractor, work with relief agencies after a disaster?",
    "How can coordinating with FEMA help me get more rebuilding work?",
    "How do I connect with local emergency management agencies for post-disaster work?",
    "What?s the best way to work with the Red Cross after a disaster?",
    "How can I leverage National VOAD partnerships for more jobs?",
    "What?s the fastest way to get on FEMA?s contractor list?",
    "How can I help relief agencies assess damage in disaster areas?",
    "What common mistakes do contractors make when working with relief agencies?",
    "How does working with relief agencies improve my reputation as a contractor?",
    "What funding sources are available through relief agencies for contractors?",
    "How can I ensure a smooth partnership with relief agencies?",
    "What?s the best way to communicate with relief agencies during a disaster?",
    "How do I avoid conflicts when multiple agencies are involved in recovery?",
    "Can relief agencies help pay for temporary housing during repairs?",
    "What types of relief agency projects are best suited for contractors?",
    "How can I stand out when competing for relief agency contracts?",
    "What documentation do relief agencies require for payment approval?",
    "How do I get involved with community rebuilding grants through relief agencies?",
    "How can I help relief agencies improve resource allocation?",
    "What?s the biggest benefit of pre-registering with relief agencies?",
    "How do I ensure my work aligns with FEMA?s disaster recovery guidelines?",
    "What?s the process for working on SBA-funded disaster recovery projects?",
    "Can I work with multiple relief agencies at the same time?",
    "How can I turn relief agency partnerships into long-term business growth?",
    "How can I market myself as a compliance expert in disaster rebuilding?",
    "What?s the best way to win more government-funded rebuilding jobs?",
    "How do I stand out from competitors in disaster recovery work?",
    "How can I use my experience in compliance to get more referrals?",
    "What kind of social media strategy works for resilience-focused contractors?",
    "How can I market resilience as a must-have instead of a ?nice-to-have??",
    "What certifications help me win FEMA and government contracts?",
    "How do I get on the preferred contractor list for insurance-backed repairs?",
    "What should I put on my website to attract resilience-focused clients?",
    "How can I build relationships with FEMA and government agencies?",
    "How do I position myself as the top contractor for resilience-focused work?",
    "What kind of marketing materials should I have for resilience-based services?",
    "How do I educate homeowners on insurance benefits tied to resilience?",
    "What?s the best way to get resilience-focused word-of-mouth referrals?",
    "How can I use storytelling to differentiate my resilience services?",
    "How do I secure contracts for federally funded disaster relief programs?",
    "How can I use resilience-focused rebuilds to upsell homeowners?",
    "How can I create a compelling elevator pitch for resilience-focused work?",
    "What networking groups should I join to get more resilience contracts?",
    "How do I secure repeat business in the disaster recovery industry?",
    "How can I train my sales team to sell resilience better?",
    "What?s the best way to partner with insurance companies for resilience rebuilding?",
    "How do I price resilience-focused rebuilding projects competitively?",
    "How do I get involved in government-sponsored resilience-building programs?",
    "How do I sell Fortified homes more effectively to homeowners?",
    "What?s the best way to market Fortified construction to developers?",
    "How can I convince homeowners to upgrade to Fortified standards?",
    "What Fortified certification programs should I get to stand out?",
    "Where can I get trained in Fortified construction techniques?",
    "How does Fortified certification help me get more business?",
    "What?s the ROI for homeowners investing in Fortified construction?",
    "How do I explain the cost vs. benefit of Fortified homes to buyers?",
    "How can I partner with insurance companies to promote Fortified homes?",
    "What Fortified construction upgrades are the easiest to sell?",
    "How do I position myself as the go-to Fortified builder in my market?",
    "How do I use Fortified construction to win government contracts?",
    "How can Fortified building help me secure commercial contracts?",
    "What?s the best way to network for Fortified construction opportunities?",
    "How can Fortified certification increase my credibility with lenders?",
    "What types of Fortified projects are most profitable?",
    "What?s the difference between a standard build and a Fortified build?",
    "How can I bundle Fortified upgrades into my service offerings?",
    "What are the top mistakes contractors make when trying to sell Fortified homes?",
    "How can I position myself as an insurance-savvy contractor?",
    "What?s the best way to win more insurance claims-based jobs?",
    "How can I make my bids more attractive to insurance adjusters?",
    "What are the biggest mistakes contractors make when dealing with insurance companies?",
    "How do I get on an insurance company?s preferred contractor list?",
    "How can I use compliance expertise to gain more insurance jobs?",
    "How do I negotiate better payouts for homeowners? insurance claims?",
    "What?s the best way to handle an insurance claim denial?",
    "How can I make it easier for adjusters to approve my claims?",
    "What should I do if an insurance adjuster underestimates repair costs?",
    "How do I ensure my invoices get paid faster by insurance companies?",
    "How can I build long-term partnerships with insurance adjusters?",
    "What?s the best way to document damage for an insurance claim?",
    "How do I get insurance adjusters to refer me directly to homeowners?",
    "How can I educate homeowners about their insurance coverage?",
    "How do I handle disputes between homeowners and their insurance company?",
    "What should I do if an insurance adjuster doesn?t agree with my repair scope?",
    "How do I train my team to work effectively with insurance adjusters?",
    "How can I leverage my insurance knowledge to grow my business?",
    "How do I market myself as a fraud-free contractor?",
    "What?s the best way to prove I run an honest contracting business?",
    "How do I protect my business from insurance fraud accusations?",
    "What should I do if a homeowner asks me to exaggerate damages for a claim?",
    "How do I market myself to insurance adjusters as a reliable contractor?",
    "What?s the safest way to handle insurance claims as a contractor?",
    "How do I avoid liability when working with insurance claims?",
    "What are red flags of insurance fraud I should watch out for?",
    "How do I make sure insurance payouts are fair without overbilling?",
    "How do I educate homeowners on honest insurance claims?",
    "What should I do if an adjuster tries to lowball the repair estimate?",
    "How do I protect my payment when working on insurance-funded jobs?",
    "What?s the best way to get recommended by insurance companies?",
    "How do I handle situations where insurance doesn?t cover all repairs?",
    "What are the risks of taking on insurance claim jobs without proper documentation?",
    "How do I ensure my work is compliant with insurance standards?",
    "How can I use my fraud-free reputation as a competitive advantage?",
    "What?s the best way to handle disputes between insurers and homeowners?",
    "How can I use digital tools to streamline insurance claim work?",
    "How do I train my crew to conduct more accurate damage assessments?",
    "What are the key things my team should document after a disaster?",
    "How can I make sure my assessments align with what insurance adjusters need?",
    "What?s the best way to train my team to identify hidden damage?",
    "How can I make post-disaster assessments more efficient?",
    "What mistakes should my team avoid when assessing damage?",
    "How do I train my crew to work professionally with insurance adjusters?",
    "What are the best tools for damage assessment after a disaster?",
    "How do I ensure all assessments are consistent across my team?",
    "What?s the best way to integrate insurance documentation into my workflow?",
    "How can I get insurance claims approved faster?",
    "How do I handle disagreements between my damage assessment and an adjuster?s report?",
    "What?s the best way to document damage for an insurance claim?",
    "How do I make sure my post-disaster assessments meet insurance requirements?",
    "What should my crew look for when assessing roof damage after a storm?",
    "How can I train my crew to better assess flood and water damage?",
    "What?s the role of building codes in insurance assessments?",
    "How do I create a post-disaster assessment checklist?",
    "How can I streamline post-disaster assessments to handle more jobs?",
    "How should I structure pricing for temporary vs. permanent repairs?",
    "What?s the best way to price emergency mitigation services?",
    "How can I justify higher prices for emergency repairs?",
    "What are common mistakes contractors make when pricing temporary repairs?",
    "How can I make sure my pricing aligns with insurance expectations?",
    "What?s the best way to create a detailed checklist for emergency mitigation work?",
    "How do I price temporary roof tarping jobs?",
    "What should be included in an emergency mitigation service agreement?",
    "How do I make sure insurers reimburse me for emergency mitigation work?",
    "What?s the fastest way to get insurance claims approved for emergency work?",
    "How can I negotiate with insurers when they try to reduce my emergency repair costs?",
    "Should I bill homeowners directly for temporary repairs, or wait for insurance approval?",
    "What?s the best way to work with insurance adjusters on emergency repairs?",
    "How do I handle disputes over pricing for emergency mitigation work?",
    "How can I use mitigation work to secure long-term repair contracts?",
    "What?s the best way to get paid faster for temporary repair work?",
    "How can I automate documentation for emergency mitigation work?",
    "What?s the most common insurance mistake contractors make in emergency repairs?",
    "How do I educate homeowners about the difference between temporary and permanent repairs?",
    "How do I price resilient construction upgrades for profitability?",
    "What?s the best way to bundle resilience upgrades for clients?",
    "How do I justify the added cost of resilient construction to homeowners?",
    "What?s the most profitable resilience upgrade I can offer?",
    "How do I get blueprints for disaster-resistant homes?",
    "What?s the best way to create a material list for building Fortified homes?",
    "How do I work with government agencies to build disaster-resistant homes?",
    "How do I position myself as an expert in resilient home construction?",
    "How do I estimate costs for flood-resistant foundations?",
    "What financing options are available for homeowners investing in resilient upgrades?",
    "How do I get insurers to cover resilience upgrades in claims?",
    "What?s the best way to integrate resilience-focused pricing into my estimates?",
    "How do I sell resilience upgrades to commercial developers?",
    "What government grants are available for building resilient homes?",
    "How can I differentiate myself from competitors in resilience-focused construction?",
    "What are the top resilience materials every contractor should use?",
    "How do I calculate ROI for homeowners investing in resilience construction?",
    "What?s the best way to work with local governments on resilience projects?",
    "How do I market my resilience construction services to government agencies?",
    "How do I register with FEMA as a contractor for disaster relief work?",
    "What are the steps to become a VOAD-approved contractor?",
    "What documentation do I need for FEMA and VOAD contracts?",
    "How can I find out about upcoming FEMA-funded contractor opportunities?",
    "What?s the best way to work with state-level disaster relief agencies?",
    "What insurance coverage do I need to work on FEMA disaster recovery projects?",
    "How do I structure my bids for relief-funded projects?",
    "What?s the best way to prove my company?s experience in disaster recovery work?",
    "How can I partner with national disaster relief organizations like the Red Cross?",
    "What compliance standards must I follow when working on government-funded disaster projects?",
    "How do I avoid common mistakes when bidding on FEMA contracts?",
    "What?s the best way to get subcontractor opportunities on FEMA projects?",
    "How do I ensure my disaster relief work gets paid on time?",
    "What?s the process for getting approved as a HUD disaster recovery contractor?",
    "How can I get pre-qualified for rapid response disaster work?",
    "What types of projects does FEMA typically fund for disaster recovery?",
    "How do I navigate FEMA?s reimbursement process for work completed?",
    "What?s the best way to get involved in long-term disaster resilience projects?",
    "How do I prove compliance with federal disaster recovery funding requirements?"
  ];

  List<String> responseInput = [
    "Let?s figure this out together. Are you preparing, responding, or recovering from a disaster? I'll guide you step by step.",
    "That?s okay! Let?s start with your current situation. Are you preparing for a potential disaster, responding to one happening now, or recovering from one?",
    "I understand how overwhelming this can be. Let?s take it step by step. First, are you in immediate danger or just trying to plan ahead?",
    "Check emergency alerts from FEMA, your local government, or weather apps. Do you need help finding evacuation routes?",
    "If your home is at risk, identify your safest exit and pack essential supplies. I can guide you through a home safety check.",
    "Look up official weather and disaster reports for your area. I can also help you set up emergency alerts on your phone.",
    "A good place to start is knowing your risks. Do you want help assessing the common disasters in your area?",
    "Your first step depends on your situation. Are you at home, evacuating, or unsure of what?s happening?",
    "Inspect your home for structural damage, gas leaks, and electrical hazards. If you?re unsure, I can provide a home safety checklist.",
    "Sign up for emergency alerts through FEMA, the Red Cross, and local news services. Would you like help setting these up?",
    "Start with a basic emergency plan: identify evacuation routes, stock up on essentials, and create a communication plan. Would you like a step-by-step guide?",
    "Check local government websites or use the FEMA app for real-time evacuation orders. I can help you look up your location.",
    "You can find shelters through the Red Cross, FEMA, or local government websites. Would you like help finding one near you?",
    "I can help you create a personalized checklist based on your needs. Are you looking for short-term or long-term preparedness?",
    "Families with kids and pets need extra supplies and a communication plan. Would you like a guide on preparing for them?",
    "Review your insurance policy or contact your provider to understand coverage. I can help you find key policy details to check.",
    "FEMA, the Red Cross, and other agencies provide disaster assistance. Would you like a list of available resources?",
    "Consider transportation options and shelter accessibility. I can provide an emergency plan tailored to mobility needs.",
    "Keep your phone charged, have a backup power source, and use text messaging instead of calls during high traffic. Want tips on staying connected?",
    "Take deep breaths, focus on immediate tasks, and avoid information overload. Would you like mental health resources for disaster stress?",
    "Administer first aid if trained, and call 911 for emergency medical assistance.",
    "Locate and familiarize yourself with the main shutoff valves and switches in your home. In an emergency, turn them off to prevent leaks or electrical hazards.",
    "Use materials like plywood or tarps to cover broken windows and roof damage. Document the damage with photos for insurance purposes before making temporary repairs.",
    "Monitor local emergency alerts and heed official guidance. If authorities advise staying indoors due to hazards like contaminated air or structural dangers, remain inside.",
    "Save numbers for local emergency services, utility companies, and your area's emergency management office.",
    "Use battery-powered radios to receive information. Establish a family communication plan that includes meeting places and an out-of-town contact.",
    "Keep a battery-powered or hand-crank radio to receive emergency alerts. Consider having portable chargers and extra batteries for essential devices.",
    "Plan ahead by identifying local evacuation routes and transportation options. Contact local authorities to learn about evacuation assistance programs.",
    "Prepare a go bag with essentials like medications, important documents, clothing, non-perishable food, water, and personal hygiene items.",
    "Establish a family communication plan with designated meeting places and an out-of-town contact person to relay information.",
    "Contact local emergency management agencies or community organizations to learn about available transportation assistance during evacuations.",
    "Bring identification, insurance policies, medical records, bank account information, and any other critical personal documents. Store copies in a waterproof container.",
    "Apply for assistance through FEMA and other relief organizations. Keep records of expenses and losses to support your applications.",
    "Visit DisasterAssistance.gov to apply for federal aid. Local charities and non-profits may also offer support.",
    "Safely check on neighbors, especially those who are elderly or have disabilities. Offer assistance as needed and coordinate with local community groups.",
    "Assist with evacuation plans, ensure they have necessary supplies, and help them stay informed about emergency updates.",
    "Contact local emergency management offices or organizations like the Red Cross to learn about volunteer opportunities and services.",
    "Contact your insurance company promptly. Document all damages with photos and keep records of any expenses related to the disaster.",
    "Seek temporary housing through local shelters or FEMA assistance programs. Notify your insurance company and begin the claims process.",
    "Consult your insurance provider for approved contractors. Local government agencies and non-profits may also offer rebuilding assistance.",
    "Be cautious of unsolicited offers for repairs or assistance. Verify credentials and consult local authorities or the Better Business Bureau before hiring contractors.",
    "Inspect for visible cracks, foundation damage, and compromised walls. If unsure, consult a licensed structural engineer before re-entering.",
    "Dry out affected areas within 24-48 hours, remove soaked materials, and use dehumidifiers and fans to ventilate the space.",
    "Wear protective gear, document damage, separate salvageable and damaged items, and follow local waste disposal guidelines.",
    "Check local guidelines for hazardous waste disposal. Avoid handling chemicals, fuel spills, or asbestos-containing materials without professional assistance.",
    "Contact local crisis hotlines, the Red Cross, or community health services for counseling and emotional support.",
    "Maintain routines, encourage open discussions, provide reassurance, and consider professional support if needed.",
    "Use resilient building materials, elevate structures in flood zones, reinforce roofs and walls, and consider Fortified certification.",
    "Look into government relief programs, non-profit grants, and insurance assistance for financial aid.",
    "Contact local shelters, food banks, and relief organizations for immediate assistance.",
    "Visit FEMA?s website or contact local relief agencies for information on temporary housing programs.",
    "Keep them in a secure carrier with food, water, and medical supplies. Identify pet-friendly shelters in advance.",
    "Only reconnect gas, electricity, or water if authorities confirm it's safe. Have a professional inspect for leaks or damage.",
    "Review your policy for coverage details and consider additional protection for floods, earthquakes, or other hazards.",
    "Follow updates from local emergency management offices, FEMA, and relief organizations for distribution schedules and locations.",
    "Develop a continuity plan, back up essential data, secure emergency funds, and train employees on disaster response.",
    "Contact creditors to explain your situation, explore hardship programs, and monitor your credit report for inaccuracies.",
    "You can check your flood risk by visiting www.riskfactor.com and entering your address. FEMA also provides flood maps for high-risk areas.",
    "To see if your area is prone to wildfires, visit www.riskfactor.com and enter your location. The National Interagency Fire Center also tracks wildfire risks.",
    "Hurricane-prone areas are typically coastal regions. You can check www.riskfactor.com to determine your home?s risk for hurricanes and tropical storms.",
    "Extreme heat risk varies based on location. NOAA reports heat trends, and riskfactor.com will show your specific heat risk level.",
    "Air quality risk is important for respiratory health. Use riskfactor.com or AirNow.gov to check real-time air quality in your area.",
    "Go to www.riskfactor.com and enter your address to see your risk profile for Flood, Fire, Wind, Air Quality, and Heat.",
    "Knowing your risk factor helps you take proactive measures, such as reinforcing your home, improving ventilation, or preparing emergency supplies.",
    "Once you?ve checked your risk factor, take action by strengthening your home, updating your insurance, and creating an emergency plan.",
    "If your risk factor is high, your insurance rates may be affected. Contact your provider to ensure you have adequate disaster coverage.",
    "Compare your community?s disaster risk using the National Risk Index: https://hfhi.maps.arcgis.com/apps/webappviewer/index.html?id=f73b053010ff4d31a91b80a5b4195f50.",
    "Monitor your disaster risk over time by checking updates on riskfactor.com and reviewing FEMA?s annual hazard reports.",
    "If your home is in a high-risk flood zone, consider purchasing flood insurance and implementing flood-resistant home improvements.",
    "A high wildfire risk means you should create defensible space around your home, remove dry vegetation, and use fire-resistant materials.",
    "If you have a high wind risk factor, reinforce your roof and windows, and secure outdoor items to prevent wind damage.",
    "Community resilience ratings show how well your area can handle disasters. Use the National Risk Index to explore your community?s resilience.",
    "For extreme heat, increase shade, improve ventilation, and stay hydrated. Urban areas are at higher risk due to the heat island effect.",
    "Poor air quality can lead to respiratory issues. Use air purifiers indoors and check AirNow.gov for real-time air quality alerts.",
    "FEMA offers free preparedness publications tailored to different disaster risks. Order yours at https://orders.gpo.gov/icpd/ICPD.aspx.",
    "FEMA provides free preparedness materials to help individuals prepare for disasters. You can order them at https://orders.gpo.gov/icpd/ICPD.aspx.",
    "To reduce disaster risk, consider home retrofits, improved drainage, and community planning initiatives.",
    "Some of the best disaster preparedness apps include the FEMA App, Red Cross Emergency Weather App, and Red Cross First Aid App.",
    "Disaster preparedness apps provide real-time alerts, emergency shelter locations, and first aid tips to help you respond quickly to emergencies.",
    "Use the FEMA app to find open shelters during active disasters in your local area. It provides real-time shelter availability.",
    "You can download the FEMA emergency app at https://www.fema.gov/about/news-multimedia/mobile-products#download.",
    "The FEMA app provides alerts, evacuation routes, open shelter locations, and emergency contact information during disasters.",
    "The Red Cross Emergency Weather App offers real-time alerts, disaster tracking, and safety tips for severe weather conditions.",
    "Download the Red Cross Emergency Weather App at https://www.redcross.org/get-help/how-to-prepare-for-emergencies/mobile-apps.html.",
    "The Red Cross First Aid App provides step-by-step instructions for handling medical emergencies like burns, cuts, and CPR.",
    "You can download the Red Cross First Aid App at https://www.redcross.org/get-help/how-to-prepare-for-emergencies/mobile-apps.html.",
    "The Red Cross Pet First Aid App gives pet owners guidance on emergency pet care, including CPR and finding pet-friendly shelters.",
    "Download the Red Cross Pet First Aid App at https://www.redcross.org/get-help/how-to-prepare-for-emergencies/mobile-apps.html.",
    "Disaster apps help you stay connected by providing emergency contact lists, group messaging, and location-sharing features.",
    "Many of these apps include emergency planning tools, allowing you to create checklists and response plans for different disasters.",
    "Some apps have offline functionality, enabling access to first aid instructions and emergency contacts even without internet service.",
    "These apps provide alerts for severe weather, local disasters, and public safety notices, helping you stay informed at all times.",
    "Set up emergency notifications in the FEMA and Red Cross apps to receive alerts for your specific location.",
    "These apps allow you to send emergency messages and share your location with family members during a disaster.",
    "Other useful apps include Zello (for push-to-talk communication), Google Maps (for real-time traffic updates), and AirNow (for air quality alerts).",
    "After downloading these apps, set up alerts, input emergency contacts, and familiarize yourself with their features.",
    "Yes! These apps provide real-time disaster updates, evacuation routes, and shelter locations to keep you informed during emergencies.",
    "Start by making a list of all household members, including children, elderly relatives, individuals with disabilities, and pets, and identifying their specific needs.",
    "Disasters impact people differently. By considering individual needs in your plan, you can ensure the safety of vulnerable household members during an emergency.",
    "For elderly family members, arrange transportation, ensure mobility assistance is available, and keep medical supplies and emergency contacts ready.",
    "Identify transportation options, create a mobility plan, and ensure wheelchairs or mobility aids are included in your emergency kit.",
    "Make a list of required medications, medical equipment, and backup power sources for devices like oxygen concentrators.",
    "Include a 7-day supply of medications, a first aid kit, a blood pressure monitor, and any necessary medical records in waterproof storage.",
    "Plan ahead for household members with communication impairments by using visual aids, written instructions, or emergency alert apps with vibration notifications.",
    "Use text-based or visual communication apps and prearrange emergency signals with family members who have hearing impairments.",
    "Determine if special accommodations are needed, such as a caregiver, medical transport, or a designated support network.",
    "Ensure your emergency kit includes allergy-friendly food, formula for infants, and food that meets religious or dietary restrictions.",
    "Pack comfort items, snacks, and activities for children to help them stay calm during emergencies.",
    "Include diapers, wipes, formula, baby food, and a lightweight blanket in your emergency kit.",
    "Identify pet-friendly shelters, pack a pet emergency kit, and ensure your pet has an ID tag and microchip.",
    "Check the Red Cross and FEMA websites for lists of pet-friendly shelters in your area.",
    "Designate meeting points, ensure multiple exit strategies, and assign roles for each family member to streamline evacuations.",
    "Research accessible transportation services in your area, such as paratransit or community evacuation resources for individuals with disabilities.",
    "Practice your evacuation plan twice a year and adjust based on feedback from family members.",
    "Use storytelling, games, and role-playing to teach children emergency procedures without causing fear.",
    "Ensure that all family members understand the evacuation plan, and conduct practice drills for different scenarios.",
    "Review your emergency plan every six months, update emergency contacts, and check the condition of your emergency supplies.",
    "Documenting your home before a disaster ensures you have proof of its pre-damage condition, which can make insurance claims easier and faster.",
    "A 3D model of your home provides detailed measurements and visuals that help insurance adjusters assess damages more accurately.",
    "The best way to document your home is by taking clear photos, videos, and creating a 3D model for reference.",
    "To take proper documentation photos, use good lighting, ensure your entire home is visible, and capture multiple angles.",
    "You should take at least 8 photos?one from each corner and one from each side of your home.",
    "Capture 45-degree angle shots from all four corners and straight-on shots of each side to provide a complete exterior view.",
    "Store your home documentation in multiple locations, such as cloud storage, external hard drives, and in your BuildSOS profile.",
    "Hover.com is a tool that lets you create a 3D model of your home, providing a detailed record of its structure and design.",
    "To create a 3D model with Hover, take guided photos of your home using the app and let the software generate a digital model.",
    "Yes! Your 3D home model can be shared with contractors to provide accurate estimates for repairs or renovations.",
    "You can save your 3D model, photos, and any reports in your BuildSOS profile for easy access during the claims process.",
    "Besides photos, include a written inventory of home features, blueprints (if available), and receipts for major home improvements.",
    "Update your home documentation at least once a year and after any significant renovations.",
    "If your insurance company requests proof, provide your photos, 3D model, and any receipts or property records you have.",
    "Having a detailed pre-damage record helps prevent claim disputes, making it more likely your insurance payout will be approved quickly.",
    "Yes, documenting the inside of your home, including valuable items, can further strengthen your claim in case of interior damage.",
    "Purchasing a full 3D home report provides complete specifications that are useful for renovations, claims, and home value assessments.",
    "Using a 3D model in a claim submission speeds up processing by giving adjusters precise details about your home's structure.",
    "Yes, 3D models can be used by contractors and insurance adjusters to estimate repair costs more accurately.",
    "Keep home documentation updated by taking new photos annually, after major home improvements, or when significant weather events are forecasted.",
    "Documenting your belongings before a disaster ensures you have proof of ownership, making the insurance claims process easier and more accurate.",
    "An inventory provides detailed evidence of your lost or damaged items, increasing the likelihood of a full insurance payout.",
    "The best way to document your home is by taking photos, a video walkthrough, and creating a written list of all major assets.",
    "Both photos and videos are useful. A video walkthrough can capture details quickly, while photos allow for close-up documentation of specific items.",
    "To create an asset list, document major items like furniture, appliances, electronics, and valuables. Include estimated values and purchase dates.",
    "Your home inventory should include the item name, purchase date, model/serial number, estimated value, and any available receipts or warranties.",
    "If you don?t know exact values, estimate based on similar items or online pricing. Keeping receipts can improve claim accuracy.",
    "Store your documentation in multiple locations?cloud storage, an external hard drive, and in your BuildSOS profile for easy access.",
    "Apps like Contents360 and Hover.com allow you to scan and document your home inventory digitally, making asset tracking easier.",
    "A 3D model provides an accurate representation of your home's interior, helping adjusters verify damage and ensuring a smoother insurance process.",
    "Contents360 is a mobile tool that creates a real-time 3D scan of your home?s interior, allowing you to catalog and track your belongings digitally.",
    "Many smartphones support lidar scanning, allowing you to create an interactive 3D model of your home simply by walking through each room.",
    "Yes! Keep receipts, warranties, and serial numbers when available, as they provide strong evidence of ownership and value.",
    "Update your inventory annually, after major purchases, or when you renovate your home to ensure the most accurate records.",
    "Upload your inventory, 3D model, and supporting documents to your BuildSOS profile for secure storage and easy access during claims.",
    "If you lack receipts for older purchases, take clear photos, estimate values based on similar items, and describe them in detail.",
    "Yes! A spreadsheet is a simple way to track assets?list item names, values, and purchase details in an organized format.",
    "Categorizing by room or item type (electronics, furniture, clothing) makes it easier to track and update your home inventory over time.",
    "You can take an emergency preparedness training course online or in person through the Red Cross: https://www.redcross.org/take-a-class.",
    "Organizing your insurance documents alongside your inventory ensures all records are accessible when filing a claim. Keep digital and physical copies.",
    "Finding a verified contractor before a disaster ensures that you have someone reliable and licensed to call when you need repairs.",
    "You can verify a contractor?s credentials by checking their license with your state licensing board and ensuring they carry proper insurance.",
    "Unverified contractors may overcharge, provide poor-quality work, or disappear with your money without completing repairs.",
    "Use the BuildZoom database or check with the Better Business Bureau (BBB) to find verified, well-rated contractors in your area.",
    "Look for licensed contractors with strong customer reviews, experience in storm repairs, and proper insurance coverage.",
    "Check a contractor?s license by searching your state licensing board?s website or asking the contractor for proof of insurance.",
    "Ask contractors about their experience, licensing, insurance, references, and how they handle unexpected repair costs.",
    "Check reviews on BuildZoom, BBB, or Google Reviews, and ask for references from past clients before hiring a contractor.",
    "Common scams include contractors asking for full payment upfront, offering unusually low bids, or refusing to provide written contracts.",
    "Avoid high-pressure tactics by refusing to sign contracts on the spot and getting multiple estimates before making a decision.",
    "Never pay a contractor the full amount upfront?legitimate contractors typically ask for a reasonable deposit with payments tied to milestones.",
    "If a contractor asks for full payment upfront, this is a red flag. Consider hiring someone else who follows standard payment structures.",
    "Request detailed estimates from multiple contractors and compare pricing, materials, and timelines before making a choice.",
    "Customer reviews and ratings can be found on BuildZoom, BBB, Yelp, or state contractor licensing websites.",
    "Report scams to your state licensing board, the Better Business Bureau, or the Federal Trade Commission (FTC).",
    "A proper contract should include project timelines, materials to be used, costs, payment schedules, and warranties on work.",
    "Ensure the contractor follows through by setting clear expectations in a written contract and checking their past work references.",
    "Store your contractor?s contact details in your BuildSOS profile and keep a digital and printed backup for quick access.",
    "Having multiple contractors on your list gives you options in case one is unavailable or overbooked after a major disaster.",
    "BuildZoom allows you to search for top-rated, licensed contractors in your area, helping you find trusted professionals before disaster strikes.",
    "An emergency communication plan ensures you can reach loved ones during disasters when normal communication may be disrupted.",
    "Create a group chat on WhatsApp or another messaging app to quickly share updates with friends and family during an emergency.",
    "WhatsApp, Signal, and Zello are good choices because they work on Wi-Fi and allow voice and text communication.",
    "WhatsApp is free, encrypted, and widely used, making it a reliable choice for emergency messaging.",
    "In WhatsApp, go to ?New Group,? add family members, name the group ?Disaster Communication,? and encourage everyone to participate.",
    "Your communication plan should include contact details, meeting points, and alternative ways to communicate if cell service is down.",
    "Review and update emergency contacts at least twice a year to ensure accuracy.",
    "Use apps like Zello (walkie-talkie style) or satellite messaging tools if cell service is unavailable.",
    "Send a brief text message instead of calling?texts require less bandwidth and are more likely to go through in emergencies.",
    "Backup methods include using landlines, battery-powered radios, or emergency apps that work offline.",
    "Set up simple call and text check-ins for elderly relatives to make it easy for them to confirm their safety.",
    "Use live location sharing features in WhatsApp, Google Maps, or Apple?s Find My app to update family on your whereabouts.",
    "Your meeting point should be a safe, easily recognizable location like a park, school, or community center.",
    "Practice using your communication plan by sending test messages and confirming response times with family members.",
    "If someone is missing, contact local emergency services, check social media updates, and reach out to neighbors or shelters.",
    "Decide in advance where to meet if separated, and have a backup contact outside the disaster area who can relay messages.",
    "After a disaster, update your WhatsApp group, use FEMA?s Safe & Well registry, or mark yourself safe on Facebook?s Crisis Response.",
    "Keep emergency contact lists saved on your phone, printed on paper, and uploaded to a cloud service like Google Drive.",
    "FEMA, Ready.gov, and the Red Cross offer guides on creating a solid emergency communication plan.",
    "Download the Are You Ready Guide from Ready.gov and share it with family members to help them prepare: https://www.ready.gov/are-you-ready-guide.",
    "Fortifying your home helps minimize damage from natural disasters and can reduce insurance costs.",
    "For every \$1 spent on hazard mitigation, homeowners save an average of \$6 in future repair costs, according to IBHS.",
    "To protect against hurricanes, install storm shutters, reinforce your roof, and anchor outdoor furniture.",
    "Strengthen your roof by using hurricane straps, upgrading to impact-resistant shingles, and sealing vulnerable areas.",
    "Secure windows with impact-resistant glass and install reinforced doors to prevent wind and debris damage.",
    "Prevent water damage by installing sump pumps, sealing foundation cracks, and maintaining proper drainage around your home.",
    "Use fire-resistant materials, clear vegetation near your home, and install ember-resistant vents to reduce wildfire risk.",
    "Find guides on home resilience at FEMA, IBHS, and disaster preparedness websites like Ready.gov.",
    "Reinforce your garage door by installing a wind-rated door with additional bracing to prevent storm damage.",
    "Upgrading your home?s foundation with seismic retrofits can reduce earthquake damage and improve stability.",
    "Improve insulation, use energy-efficient windows, and install attic fans to manage extreme heat conditions.",
    "Affordable upgrades include sealing leaks, securing loose roofing, and adding weather-resistant coatings to vulnerable areas.",
    "Hail-resistant roofing materials, window protection, and reinforced siding can help prevent costly hail damage.",
    "Building codes ensure homes are constructed to withstand extreme weather. Updating your home to meet modern codes can improve resilience.",
    "Check local government websites or FEMA?s Building Codes Toolkit to determine if your home meets current resilience standards.",
    "Anchor your mobile home, install tie-downs, and reinforce skirting to reduce vulnerability to high winds and storms.",
    "Sump pumps help prevent basement flooding, while improved drainage reduces standing water risks around your property.",
    "Consult with a licensed contractor or disaster mitigation specialist to assess and upgrade your home?s resilience.",
    "Prioritize roof reinforcement, window protection, and foundation strengthening if you live in a high-risk disaster area.",
    "Brag about your home?s resilience upgrades on social media to encourage others to prepare and strengthen their homes too!",
    "Knowing your local emergency contacts allows you to act quickly in a crisis, reducing response times and ensuring you get the help you need.",
    "Having emergency contacts on hand ensures that you can reach the right authorities and support services without delay during a disaster.",
    "You can find local fire and police department contacts on your city?s official website or through FEMA?s location resource: https://www.fema.gov/locations.",
    "Look up the nearest hospitals by searching your local health department website or using FEMA?s emergency location tool.",
    "Disaster Recovery Centers provide support after disasters, including FEMA assistance. Find one near you at https://www.fema.gov/locations.",
    "Visit https://www.fema.gov/locations to check declared disasters and learn what assistance is available in your area.",
    "Community support organizations, such as the Red Cross and local nonprofits, offer shelter, food, and medical care after disasters.",
    "You can find your nearest emergency shelter by checking local government websites or using the Red Cross Shelter Finder tool.",
    "Community Emergency Response Teams (CERT) provide local training and response assistance in disasters. Find a CERT program near you through FEMA.",
    "Check your city?s emergency management website for evacuation routes, or use FEMA and local transportation department resources.",
    "Set up emergency alerts through FEMA?s Integrated Public Alert & Warning System (IPAWS) or your city?s emergency management office.",
    "Find your NOAA weather radio station frequency at https://www.weather.gov/nwr/ and enter it into your BuildSOS profile for quick reference.",
    "If 911 is unavailable, use backup emergency numbers for your area, reach out to neighbors, or send a text message if supported.",
    "Keep emergency contacts saved in your phone, printed in a waterproof folder, and uploaded to your BuildSOS profile for easy access.",
    "Use local transportation department websites or radio stations to stay updated on road closures and evacuation routes.",
    "Check FEMA?s disaster declaration page or your state?s emergency management office to see if your area has been officially declared a disaster zone.",
    "Local emergency management agencies provide preparedness tips, evacuation plans, and real-time alerts to keep you informed.",
    "Store your emergency contact list in multiple places: your phone, a printed version, cloud storage, and your BuildSOS profile.",
    "Getting involved in CERT programs, community drills, or local emergency planning committees helps strengthen disaster preparedness efforts.",
    "Enter your emergency contacts, disaster details, and NOAA radio frequency in your BuildSOS profile to keep all crucial information in one place.",
    "Reviewing your insurance policies ensures you have adequate coverage to protect against financial losses from disasters.",
    "Compare your policy?s coverage limits to the estimated cost of rebuilding your home or replacing lost items.",
    "Homeowners, renters, and business insurance policies should include disaster protection such as flood, fire, and windstorm coverage.",
    "Check your homeowners policy for coverage against floods, hurricanes, and earthquakes?these may require separate policies.",
    "Renters insurance typically covers personal belongings, temporary housing, and liability protection during disasters.",
    "Small business owners should review commercial property insurance, business interruption insurance, and disaster contingency plans.",
    "Review your policy declarations page to check covered risks, exclusions, deductibles, and any necessary endorsements.",
    "Your insurance company?s website or mobile app typically provides access to digital copies of your policies.",
    "Your policy documents will list your coverage limits and deductibles?compare these to your potential disaster risks.",
    "Many policies exclude floods, earthquakes, and certain windstorm damages. Check exclusions and consider additional coverage.",
    "Websites like Policygenius, NerdWallet, and Insure.com allow you to compare policies and coverage options.",
    "Additional endorsements or riders may be needed for high-value items, flood damage, or specific disaster risks in your area.",
    "FEMA, NAIC, and the Insurance Information Institute offer free guides to help you assess your insurance needs.",
    "Use online insurance calculators at Insurance.com or Bankrate to estimate your needed coverage based on home value and location risks.",
    "Notify your insurance provider about renovations or upgrades to ensure they are reflected in your coverage.",
    "Check FEMA?s flood maps or visit FloodSmart.gov to see if your home is in a high-risk flood zone requiring flood insurance.",
    "If your insurance coverage is insufficient, speak with your agent about increasing limits or purchasing supplemental policies.",
    "Store copies of your policies in cloud storage, on a USB drive, and in your BuildSOS profile for quick access after a disaster.",
    "Reach out to your insurance agent by phone or email to discuss your coverage and whether adjustments are necessary.",
    "Log in to your BuildSOS profile and upload your insurance documents under the ?Preparedness? section for safekeeping.",
    "The Emergency Financial First Aid Kit (EFFAK) is a toolkit that helps you organize and secure important financial and personal documents for disaster preparedness.",
    "Financial preparedness ensures that you can cover emergency expenses, replace lost documents, and access funds quickly after a disaster.",
    "Having an EFFAK helps speed up the recovery process by giving you quick access to financial, insurance, and identification documents.",
    "Your EFFAK should include identification, banking records, insurance policies, property records, and emergency contacts.",
    "Store your EFFAK in a fireproof, waterproof safe and keep digital copies in a secure cloud storage service.",
    "Start an emergency savings fund by setting aside small amounts regularly in a high-yield savings account.",
    "Keep financial documents in a waterproof folder, use a safety deposit box, and back up copies to a secure cloud service.",
    "Secure copies of your passport, driver?s license, birth certificates, and social security cards in both digital and paper formats.",
    "FEMA, SBA, and nonprofit organizations offer financial assistance to disaster survivors. Research available programs in advance.",
    "Use online banking, cloud storage, and mobile apps to access your financial records if your physical copies are lost.",
    "Digital copies ensure backup access if physical records are lost, while paper copies provide security when digital systems fail.",
    "Prepare for emergencies by reviewing your insurance policies, setting up direct deposit for benefits, and automating bill payments.",
    "Follow the instructions in the FEMA EFFAK toolkit to complete checklists and fill out essential forms for financial preparedness.",
    "Download the FEMA EFFAK guide at https://www.fema.gov/sites/default/files/documents/fema_effak-toolkit.pdf.",
    "If your bank is affected by a disaster, use online banking services or contact their disaster assistance department for alternative access to funds.",
    "Keep credit and debit cards in a safe but accessible location, and consider having a backup prepaid card with emergency funds.",
    "Government programs like FEMA Disaster Assistance, the Red Cross, and SBA Disaster Loans help with financial recovery after disasters.",
    "Review and update your EFFAK at least once a year or after major life changes like moving, marriage, or financial shifts.",
    "If you don?t have emergency savings, start by setting aside small amounts and explore assistance programs that offer financial planning support.",
    "Log in to your BuildSOS profile and upload your completed EFFAK under the ?Preparedness? section for safekeeping.",
    "Having an emergency preparedness kit ensures you have essential supplies to survive independently for at least 72 hours after a disaster.",
    "Your kit should include food, water, first aid supplies, flashlights, extra batteries, a radio, hygiene products, and emergency contacts.",
    "Store at least one gallon of water per person per day for drinking and sanitation, with a minimum three-day supply.",
    "Include ready-to-eat canned goods, protein bars, dried fruits, nuts, and other non-perishable foods that don?t require refrigeration or cooking.",
    "Choose a first aid kit that includes bandages, antiseptic wipes, pain relievers, gauze, medical tape, and any necessary prescription medications.",
    "Select a durable, battery-powered flashlight with extra batteries or a rechargeable solar-powered model for extended use.",
    "A battery-powered or hand-crank radio helps you stay informed with emergency alerts if power and internet are unavailable.",
    "Include a multi-tool or Swiss Army knife, duct tape, a manual can opener, and plastic sheeting for temporary repairs or sheltering.",
    "Store copies of important documents like IDs, insurance policies, and medical records in a waterproof and fireproof container.",
    "Keep your emergency kit in an accessible indoor location, such as a closet or cupboard, and ensure all family members know where it is.",
    "Yes! Keep a smaller emergency kit in your car with water, non-perishable snacks, a first aid kit, a flashlight, and a blanket.",
    "Check your kit twice a year, replace expired items, and update it based on changes in family needs or weather risks.",
    "Pack formula, diapers, wipes, baby food, and comfort items to meet the needs of infants and toddlers in an emergency.",
    "For pets, include food, water, a leash, a carrier, vaccination records, and medications they may need.",
    "Keep small denominations of cash, as ATMs and credit card machines may not work during power outages.",
    "Buy emergency supplies from Ready.gov, the Red Cross Store, Amazon, REI, Walmart, or The Home Depot.",
    "Customize your kit by considering family medical conditions, dietary restrictions, and specific regional disaster risks.",
    "Look for bulk discount packs, dollar stores, or use household items you already have to build a cost-effective emergency kit.",
    "Store medications in a waterproof, labeled container, and check expiration dates regularly to keep them up to date.",
    "You can donate emergency supplies to Habitat for Humanity, the Red Cross, or local disaster relief organizations.",
    "An emergency evacuation plan ensures that you and your family can leave safely and quickly in case of a disaster.",
    "Your plan should include evacuation routes, assembly points, transportation options, and a list of emergency contacts.",
    "Identify the best exit routes from your home and workplace, and determine alternative paths in case of road closures.",
    "Consider factors like traffic congestion, road conditions, flood zones, and potential hazards when choosing an evacuation route.",
    "Choose a meeting place that is safe, easy to access, and known to all family members, such as a school or community center.",
    "If driving, keep your car fueled and emergency-ready. If you don?t have a car, identify public transportation or carpool options.",
    "Monitor local news and emergency alert systems to stay updated on road closures and detour routes.",
    "Have a go-bag with essentials like food, water, first aid supplies, flashlights, and personal identification ready at all times.",
    "Ensure special accommodations are made for mobility needs, medical equipment, and accessible transportation routes.",
    "Prepare pet carriers, food, water, and vaccination records to ensure pets are safely evacuated with you.",
    "Check FEMA?s shelter locator or local government websites to find designated emergency shelters near you.",
    "Review and update your evacuation plan at least once a year, or whenever your living situation changes.",
    "Practice evacuation drills twice a year to ensure all family members know what to do in an emergency.",
    "Designate an emergency contact outside your area and agree on a meeting point in case family members get separated.",
    "Workplace evacuation plans should include exit routes, shelter-in-place procedures, and a communication strategy.",
    "If you don?t have transportation, coordinate with neighbors, emergency services, or use public evacuation transport options.",
    "Sign up for local emergency alerts through FEMA, NOAA, or your city?s emergency management office.",
    "Store copies of your evacuation plan in your emergency kit, on your phone, and in a secure cloud storage service.",
    "Use age-appropriate explanations and role-playing to help children understand and remember evacuation procedures.",
    "Log in to your BuildSOS profile and upload your evacuation plan under the ?Preparedness? section for easy access.",
    "A pet emergency preparedness plan ensures your pet's safety and reduces stress during disasters when evacuation or sheltering is necessary.",
    "Your pet?s emergency kit should include food, water, medications, a leash, ID tags, a carrier, veterinary records, and comfort items like blankets or toys.",
    "Store at least three days' worth of food and water for each pet to ensure they have enough sustenance during an emergency.",
    "A secure pet carrier or crate provides safety during transport and evacuation, helping prevent escapes and injuries.",
    "Research pet-friendly shelters, hotels, and boarding facilities along your evacuation route to ensure you have a safe place to stay with your pet.",
    "Check that your pet's collar has an up-to-date ID tag with your name, phone number, and emergency contact information.",
    "Microchipping increases the chances of reuniting with a lost pet by providing permanent identification that shelters and vets can scan.",
    "Ensure you have a travel plan for your pet, whether it?s using a personal vehicle, pet-friendly public transportation, or emergency rescue services.",
    "Up-to-date vaccinations protect your pet from disease and may be required for entry into shelters, boarding facilities, or hotels.",
    "Store copies of veterinary records, vaccination history, and any medical conditions in your pet?s emergency kit and in digital cloud storage.",
    "If you must evacuate without your pet, leave them with a trusted neighbor or contact a local animal shelter for temporary care options.",
    "Maintain a list of emergency contacts, including veterinarians, local animal shelters, and pet-friendly accommodations along evacuation routes.",
    "Train your pet to enter their carrier willingly and stay calm during car rides to make evacuations less stressful.",
    "Comfort items like familiar blankets, favorite toys, and treats help reduce anxiety for pets during stressful situations.",
    "Ensure you have a backup veterinarian or mobile vet service identified in case your regular vet is unavailable during an emergency.",
    "Practice evacuation drills with your pet so they become familiar with the process and are less stressed when an actual emergency occurs.",
    "If your pet goes missing, notify local shelters, post on social media, and use pet tracking services to aid in their recovery.",
    "Have a backup plan in case pet-friendly shelters are full?this could include nearby boarding facilities, hotels, or staying with family or friends.",
    "Upload your pet?s medical records, ID details, and emergency contact list to your BuildSOS profile for easy access during an evacuation.",
    "For more resources, check websites like ASPCA, Ready.gov, and the American Red Cross for pet disaster preparedness tips.",
    "A disaster preparedness plan ensures individuals with special needs receive the care, support, and accommodations required during emergencies. Learn more at Ready.gov.",
    "Caregivers should create a personalized emergency plan, practice drills, and ensure essential medical and assistive supplies are available. Find caregiver-specific disaster planning resources at FEMA.",
    "An emergency kit should include medications, adaptive equipment, extra batteries for medical devices, and sensory comfort items. See a full checklist at Ready.gov.",
    "Individuals with mobility challenges need extra medical supplies, durable medical equipment, and a backup power source for assistive devices. Learn more at CDC Emergency Preparedness.",
    "Register your loved one with local emergency services and carry a medical ID card with their condition and emergency contacts. Learn more about disability registries at The Red Cross.",
    "An evacuation plan for someone with autism should include a familiar comfort item, noise-canceling headphones, and a clear step-by-step process. Get autism-specific emergency planning resources at Autism Speaks.",
    "Sensory sensitivities can be managed with noise-canceling headphones, weighted blankets, and a designated quiet space in emergency shelters. Learn about shelter accommodations at ADA.gov.",
    "For non-verbal individuals, use communication cards, text-to-speech apps, or pre-written emergency instructions to facilitate communication. Find visual communication tools at FEMA?s Disability Preparedness.",
    "Keep an updated medical history, medication list, and doctor?s contact information in both physical and digital formats for emergencies. Use FEMA?s emergency health form at FEMA.gov.",
    "Organizations such as FEMA, the Red Cross, and the National Organization on Disability offer support and resources for emergency preparedness. Find disability-specific disaster planning at NOD.org.",
    "Research paratransit services, accessible evacuation vehicles, and community programs that provide transportation assistance for individuals with mobility challenges. Check Easter Seals for accessible transport options.",
    "If separated, contact local emergency shelters, use medical alert bracelets, and notify authorities of the individual's condition and needs. Learn about emergency reunification programs at Safe & Well.",
    "Use simple language, visual aids, and hands-on practice to teach individuals with intellectual disabilities about emergency procedures. Find interactive training at The Arc.",
    "Technology, such as emergency alert apps, GPS trackers, and medical alert systems, can provide critical support during disasters. Learn about assistive tech options at AT3 Center.",
    "Stockpile a 7-day supply of medications and keep prescriptions on file at multiple pharmacies to ensure availability during an emergency. The American Society of Health-System Pharmacists provides medication management tips for disasters.",
    "Find special needs shelters through local emergency management offices, the Red Cross, or FEMA?s disaster assistance program. Use the Red Cross Shelter Locator.",
    "Individuals with disabilities are protected under the ADA and should have equal access to emergency services and accommodations. Read about your rights at ADA.gov.",
    "Caregivers and community members can offer support by creating accessible evacuation routes and advocating for inclusive disaster planning. Get involved through FEMA?s Whole Community Approach.",
    "Review and update emergency plans annually or whenever there is a change in medical needs or living situations. Download FEMA?s emergency plan template at FEMA.gov.",
    "Training programs for disability-inclusive disaster preparedness can be found through FEMA, the Red Cross, and local disability organizations. Take a course at Red Cross Training.",
    "A disaster preparedness plan ensures individuals with special needs receive the care, support, and accommodations required during emergencies. Learn more at Ready.gov.",
    "Caregivers should create a personalized emergency plan, practice drills, and ensure essential medical and assistive supplies are available. Find caregiver-specific disaster planning resources at FEMA.",
    "An emergency kit should include medications, adaptive equipment, extra batteries for medical devices, and sensory comfort items. See a full checklist at Ready.gov.",
    "Individuals with mobility challenges need extra medical supplies, durable medical equipment, and a backup power source for assistive devices. Learn more at the CDC Emergency Preparedness.",
    "Register your loved one with local emergency services and carry a medical ID card with their condition and emergency contacts. Learn more about disability registries at the American Red Cross.",
    "An evacuation plan for someone with autism should include a familiar comfort item, noise-canceling headphones, and a clear step-by-step process. Get autism-specific emergency planning resources at Autism Speaks.",
    "Sensory sensitivities can be managed with noise-canceling headphones, weighted blankets, and a designated quiet space in emergency shelters. Learn about shelter accommodations at ADA.gov.",
    "For non-verbal individuals, use communication cards, text-to-speech apps, or pre-written emergency instructions to facilitate communication. Find visual communication tools at FEMA?s Disability Preparedness.",
    "Keep an updated medical history, medication list, and doctor?s contact information in both physical and digital formats for emergencies. Use FEMA?s emergency health form at FEMA.gov.",
    "Organizations such as FEMA, the Red Cross, and the National Organization on Disability offer support and resources for emergency preparedness. Find disability-specific disaster planning at NOD.org.",
    "Research paratransit services, accessible evacuation vehicles, and community programs that provide transportation assistance for individuals with mobility challenges. Check Easter Seals for accessible transport options.",
    "If separated, contact local emergency shelters, use medical alert bracelets, and notify authorities of the individual's condition and needs. Learn about emergency reunification programs at Safe & Well.",
    "Use simple language, visual aids, and hands-on practice to teach individuals with intellectual disabilities about emergency procedures. Find interactive training at The Arc.",
    "Technology, such as emergency alert apps, GPS trackers, and medical alert systems, can provide critical support during disasters. Learn about assistive tech options at the AT3 Center.",
    "Stockpile a 7-day supply of medications and keep prescriptions on file at multiple pharmacies to ensure availability during an emergency. The American Society of Health-System Pharmacists provides medication management tips for disasters.",
    "Find special needs shelters through local emergency management offices, the Red Cross, or FEMA?s disaster assistance program. Use the Red Cross Shelter Locator.",
    "Individuals with disabilities are protected under the ADA and should have equal access to emergency services and accommodations. Read about your rights at ADA.gov.",
    "Caregivers and community members can offer support by creating accessible evacuation routes and advocating for inclusive disaster planning. Get involved through FEMA?s Whole Community Approach.",
    "Review and update emergency plans annually or whenever there is a change in medical needs or living situations. Download FEMA?s emergency plan template at FEMA.gov.",
    "Training programs for disability-inclusive disaster preparedness can be found through FEMA, the Red Cross, and local disability organizations. Take a course at Red Cross Training.",
    "Stay calm. First, determine if you need to evacuate or shelter in place. If evacuation is necessary, grab your emergency kit, secure your home, and leave as soon as possible. Follow official evacuation routes and alerts from FEMA.",
    "Review your emergency plan by checking evacuation routes, gathering essential items, and ensuring all household members understand where to meet. Download FEMA?s emergency plan checklist here.",
    "Gather food, water, medications, important documents, cash, and essential supplies for at least 72 hours. See a full list of emergency supplies at Ready.gov.",
    "Secure your home by reinforcing windows and doors, bringing outdoor furniture inside, and unplugging non-essential electronics. Learn more at National Hurricane Survival Initiative.",
    "Yes, unplug electronics but keep your refrigerator and freezer plugged in unless flooding is likely. This will help prevent electrical damage when power is restored.",
    "Inform family, friends, and neighbors of your evacuation plans. Share your destination and contact numbers, and check in with them regularly. Use Safe & Well for updates.",
    "Fuel up your car, check tire pressure, and ensure emergency supplies are packed inside. Keep a physical map in case GPS is unavailable.",
    "Stay informed through FEMA?s mobile app, NOAA radio, or your local emergency management office. Download the FEMA app here.",
    "Place important documents in waterproof containers and take them with you. Store digital copies in cloud storage for extra security.",
    "Ensure elderly or disabled family members have mobility assistance and medications. Use paratransit services or register for emergency assistance with The Red Cross.",
    "Use the FEMA Shelter Locator to find open emergency shelters in your area.",
    "Pack clothes, important documents, food, water, and first aid supplies. Use this evacuation checklist from Join Cake.",
    "Pack pet food, medication, a leash, vaccination records, and a pet carrier. Locate pet-friendly shelters at Red Rover.",
    "Monitor real-time road updates from local traffic apps, NOAA alerts, and news stations. Avoid flooded or damaged roads.",
    "Follow designated evacuation routes, avoid floodwaters, and drive cautiously. Keep an emergency roadside kit in your car.",
    "Keep your household together, use a buddy system, and establish a meeting point in case of separation.",
    "Use your local emergency contact list to access food, shelter, and medical assistance. Find help at 211.org.",
    "If separated, report to emergency shelters, post on Safe & Well, and check with local disaster agencies for reunification services.",
    "Call 911 for urgent medical needs. If you need evacuation assistance, register with your local emergency management office.",
    "Follow official guidance on whether to evacuate or stay. If unsure, check FEMA for real-time al",
    "If you cannot evacuate, seek higher ground, inform emergency responders, and stay connected to local alert systems. Contact 211 for additional resources.",
    "Secure doors, windows, and valuables. If time allows, notify neighbors and local authorities of your evacuation. Learn more at FEMA.",
    "Check on vulnerable neighbors and offer assistance if possible. Use community emergency contacts for help. Find support at Red Cross.",
    "If you experience car trouble, pull over safely, contact emergency services, and avoid leaving your vehicle in dangerous conditions. Keep a roadside emergency kit in your car.",
    "Turn off gas lines, unplug appliances, and lock all doors and windows before evacuating. Read more at Ready.gov.",
    "Shut off utilities only if instructed by authorities or if flooding is imminent. Contact your utility company for guidance.",
    "Keep emergency contacts saved in your phone and written down in case of power loss. Use Safe & Well to stay connected.",
    "Use emergency apps, NOAA radio, or text messaging to communicate if cell networks are down. FEMA?s App can help.",
    "Check NOAA for real-time disaster updates and alerts.",
    "Have a list of nearby hospitals and urgent care centers. Keep medications and prescriptions in your emergency kit. Find medical resources at CDC.",
    "Use deep breathing exercises and listen to calming music. Stay informed but avoid panic. If overwhelmed, seek support at MentalHealth.gov.",
    "Find emergency supply stations through local disaster relief organizations such as The Red Cross.",
    "Check with local officials for re-entry guidelines. Avoid floodwaters and structural damage when returning home. Follow instructions from FEMA.",
    "Trim trees, reinforce windows, and secure loose outdoor items ahead of storm season. Learn more at IBHS.",
    "Check with local emergency services for transportation options, such as paratransit or public buses. Find resources at Easter Seals.",
    "Avoid downed power lines, flooded areas, and debris. Follow road closure warnings from Department of Transportation.",
    "Never drive through floodwaters. Six inches of moving water can knock you down, and one foot can sweep away a vehicle. Read more at NOAA.",
    "Apply for financial aid from FEMA at DisasterAssistance.gov.",
    "Reassure children, keep familiar routines, and bring comfort items. Learn more at Save The Children.",
    "Stay indoors, listen to local authorities, and use emergency supplies. Follow guidelines at Ready.gov.",
    "Ensure accessibility to evacuation transportation and emergency shelters. Contact FEMA?s Disability Services.",
    "Call local shelters in advance to find pet-friendly accommodations. If unavailable, use Red Rover for assistance.",
    "Report hazardous evacuation conditions to local emergency officials or FEMA?s Disaster Hotline at 1-800-621-3362.",
    "Use solar chargers, hand-crank power banks, or car adapters to charge devices. See backup options at Energy.gov.",
    "Evacuation orders protect your safety and rights. Read about your legal protections at HUD Disaster Relief.",
    "Use Safe & Well to find missing family members, or contact the Red Cross reunification program.",
    "Only use generators outdoors, away from windows, and never in enclosed spaces. Follow generator safety guidelines at CDC.",
    "Wait for official clearance before returning home. Check updates from FEMA and local emergency management services.",
    "If struggling with stress or trauma after evacuation, reach out for help through SAMHSA?s Disaster Distress Helpline.",
    "If unable to return home, seek temporary housing through FEMA or disaste",
    "Fraud is common after disasters because scammers take advantage of vulnerable people who need urgent help. Learn how to stay protected at FTC Disaster Fraud.",
    "Common scams include fake contractors, government impersonators, fraudulent charities, and identity theft. Be cautious and verify before making payments.",
    "A fraudulent contractor may demand full payment upfront, refuse to show a license, or pressure you into quick decisions. Verify contractors at BBB.",
    "Federal workers do not solicit or accept money. Ask for an official, government-issued laminated photo ID before providing any personal information.",
    "Always ask for ID and call the agency they claim to represent. Official FEMA workers will have credentials and will never ask for money. Verify FEMA representatives at FEMA.gov.",
    "Impersonation scams involve fraudsters pretending to be officials, contractors, or relief workers. Always verify their credentials before engaging with them.",
    "Identity thieves may use stolen information to open credit accounts, file false insurance claims, or commit tax fraud. Protect your information by checking Identity Theft Resource Center.",
    "Safeguard personal details by never sharing Social Security numbers, bank information, or insurance details with unknown individuals.",
    "Check a contractor?s license, insurance, and references. Avoid those demanding full payment upfront or using aggressive sales tactics.",
    "If someone comes to your door offering repair services, do not sign anything immediately. Ask for credentials and verify them through your state licensing board.",
    "Report fraud to the National Center for Disaster Fraud (NCDF) at 866-720-5721 or the FEMA Fraud Hotline.",
    "Only apply for assistance through official government websites like DisasterAssistance.gov. Be cautious of unsolicited offers.",
    "Red flags include lack of a physical business address, refusal to provide references, demanding payment in cash, or pressuring you to sign contracts immediately.",
    "Check contractor credentials through your state?s licensing board, the Better Business Bureau (BBB), and online customer reviews.",
    "If you believe you have been scammed, contact your local police, report it to FEMA Fraud Prevention, and dispute any unauthorized transactions with your bank.",
    "Scammers may use pressure tactics to trick you into signing documents that give them control over your insurance claims or financial information.",
    "Scammers target disaster victims because they are in urgent need and may not have time to verify credentials. Always take your time and do your research before making financial decisions.",
    "Donate only to reputable organizations listed at Charity Navigator or GuideStar to ensure your funds go to legitimate causes.",
    "Online disaster scams include fake relief fund websites, phishing emails asking for donations, and fraudulent crowdfunding campaigns. Verify legitimacy before donating.",
    "Warn your community by reporting scams to local news, posting on neighborhood forums, and sharing fraud prevention tips from FTC.",
    "Check official sources such as your local emergency management website, FEMA, and NOAA for re-entry guidelines before attempting to return.",
    "Returning too soon can expose you to floodwaters, downed power lines, gas leaks, and structural instability. Wait for official clearance before going back.",
    "Find re-entry updates on your local government website or through FEMA and emergency alert services.",
    "Sign up for local emergency alerts through your city or county?s emergency management website or FEMA?s text alert system.",
    "Bring protective gear, bottled water, a flashlight, and a first aid kit. Avoid entering areas with standing water or visible damage.",
    "Check your state?s department of transportation website for road closures, washed-out bridges, and detour routes.",
    "Do not drive through flooded areas. Floodwaters may contain sewage, debris, and hidden hazards. Wait for waters to recede and follow road closure updates.",
    "Look for visible structural damage such as cracks, leaning walls, or sagging roofs. If in doubt, contact a professional before entering.",
    "If you smell gas, leave immediately and call your utility provider or 911. Downed power lines should be reported to local authorities.",
    "Report hazardous conditions to your local emergency management office or FEMA?s Disaster Assistance Hotline at 1-800-621-3362.",
    "FEMA provides re-entry guidelines and safety resources at DisasterAssistance.gov.",
    "Yes, always follow instructions from local authorities and check if your area is under a restricted re-entry order.",
    "Pack gloves, a mask, sturdy shoes, and tools like a crowbar and flashlight. Be ready for potential hazards like mold and contaminated water.",
    "If your home has water damage, turn off electricity before entering. Dry out affected areas quickly to prevent mold growth. Read more at EPA.",
    "Use caution when clearing debris. Wear thick gloves and boots, and be mindful of nails, glass, or unstable structures.",
    "Wear gloves, boots, a respirator mask, and eye protection when entering a disaster-affected area to prevent exposure to mold, dust, and sharp objects.",
    "Take photos and videos of all damage before cleaning up. Contact your insurance provider and use FEMA?s claims guide at FEMA.gov.",
    "Contact FEMA?s Transitional Sheltering Assistance program or check Red Cross Shelters if your home is uninhabitable.",
    "Do not attempt to reconnect gas or electricity yourself. Contact your utility provider for professional assistance.",
    "If you suspect mold, wear a mask and gloves, ventilate the space, and remove wet materials. Read mold removal guidelines at CDC.",
    "Before entering your home, inspect the exterior for structural damage, downed power lines, and gas leaks. If you notice any hazards, contact professionals before proceeding. FEMA Tips for Returning Home Safely",
    "Use battery-powered flashlights instead of candles to prevent fire hazards. Be cautious of potential mold or sewage contamination. CDC Guidelines for Reentering Your Flooded Home",
    "Turn off the main electrical power and water systems until they are confirmed safe. Never operate electrical equipment while standing in water. FEMA Tips for Returning Home Safely",
    "Discard any food that has come into contact with floodwater or has been unrefrigerated for an extended period. When in doubt, throw it out. CDC Guidelines for Reentering Your Flooded Home",
    "If you smell gas, evacuate immediately, avoid using electrical devices, and contact your gas company or emergency services. Do not re-enter until it's declared safe. FEMA Tips for Returning Home Safely",
    "Dry out your home as soon as possible by using fans, dehumidifiers, and opening windows. Remove wet materials to prevent mold proliferation. CDC Guidelines for Reentering Your Flooded Home",
    "Wear protective clothing, including sturdy shoes, long sleeves, gloves, and masks, to safeguard against debris and contaminants. FEMA's Recovering from Disaster Guide",
    "Follow local guidance on water safety. If uncertain, use bottled, boiled, or treated water for drinking, cooking, and hygiene. CDC Guidelines for Reentering Your Flooded Home",
    "Ventilate your home by opening doors and windows for at least 30 minutes before staying inside to reduce potential mold and gas hazards. CDC Guidelines for Reentering Your Flooded Home",
    "Never use generators inside your home, basement, or garage. Place them at least 20 feet away from windows, doors, and vents to prevent carbon monoxide poisoning. CDC Guidelines for Reentering Your Flooded Home",
    "Use a stick to poke through debris and be cautious of animals, especially snakes. If you find dangerous wildlife, contact local animal control for assistance. FEMA's Recovering from Disaster Guide",
    "Wear protective gear, be cautious of sharp objects, and avoid lifting heavy debris alone. Follow local guidelines for debris disposal. FEMA Tips for Returning Home Safely",
    "Using candles can pose fire hazards, especially if there are gas leaks. Opt for battery-powered lighting instead. CDC Guidelines for Reentering Your Flooded Home",
    "Recovery is a gradual process. Prioritize your mental health by seeking support from community resources and taking breaks when needed. Ready.gov Recovering from Disaster",
    "Avoid contact with contaminated areas, wear protective gear, and consult professionals for cleanup. Ensure proper sanitation to prevent illness. CDC Guidelines for Reentering Your Flooded Home",
    "Do not use electrical appliances that have been wet until they have been inspected by a qualified electrician. They may pose electrocution or fire risks. FEMA Tips for Returning Home Safely",
    "Before entering, ensure the structure is safe and has been inspected. Be cautious of weakened floors and walls. FEMA Tips for Returning Home Safely",
    "Avoid using gasoline-powered equipment indoors or near windows and vents. Ensure proper ventilation when using such equipment. CDC Guidelines for Reentering Your Flooded Home",
    "If you notice significant structural issues, evacuate the area and consult a structural engineer or building inspector before re-entering. FEMA's Recovering from Disaster Guide",
    "Document all damages with photos and videos, keep receipts of expenses, and contact your insurance provider promptly to initiate the claims process. Ready.gov Recovering from Disaster",
    "Start by conducting a thorough exterior inspection, looking for structural issues, roof damage, and broken windows. Document all findings with photos and notes. Storm Damage Center: Identifying Storm Damage",
    "Common storm damages include wind damage, hail damage, water intrusion, and structural compromises. Each type has specific indicators to watch for. Storm Damage Center: Types of Storm Damage",
    "Use binoculars to assess the roof from the ground, looking for missing shingles, dents, or sagging areas. Avoid climbing onto the roof yourself; hire a professional if necessary.",
    "Document the damage with photos, remove standing water safely, and begin drying the area using fans and dehumidifiers to prevent mold growth. EPA: Resources for Flood Cleanup and Indoor Air Quality",
    "Look for cracks in walls, uneven floors, or doors and windows that no longer close properly, which may indicate foundation issues.",
    "Take clear, detailed photographs of all damages, make a comprehensive list of affected items, and keep receipts for any temporary repairs or expenses incurred.",
    "Wear protective gear, sort debris into categories (e.g., electronics, hazardous waste, general debris), and follow local guidelines for disposal. EPA: Dealing with Debris and Damaged Buildings",
    "Be cautious of sharp objects, unstable structures, mold growth, and potential asbestos or lead exposure in older homes. HUD: Post Disaster Housing Repair and Restoration",
    "Check for discoloration on walls and ceilings, a lingering smoke odor, and soot accumulation. Professional assessment may be necessary for extensive damage. FEMA: After the Fire",
    "Wear protective equipment, avoid disturbing the mold, and consult professional mold remediation services to handle the cleanup safely. EPA: Resources for Flood Cleanup and Indoor Air Quality",
    "Gently rinse off debris, freeze items to prevent further deterioration, and consult conservation experts for specialized drying techniques. National Archives: Emergency Salvage of Flood Damaged Family Papers",
    "Look for frayed wires, scorch marks on outlets, and appliances that no longer function properly. Always turn off the main power before inspecting.",
    "Check for broken glass, damaged frames, and ensure that locks and seals are functioning correctly to maintain security and energy efficiency.",
    "Verify their licenses, check references, ensure they have experience with disaster repairs, and obtain written estimates before proceeding.",
    "Inspect areas like the attic and walls for dampness, mold, or compression, which can reduce insulation effectiveness and lead to energy loss.",
    "Ensure the structure is stable, avoid using open flames due to potential gas leaks, and wear protective clothing to guard against hazards. EPA: Dealing with Debris and Damaged Buildings",
    "Avoid disturbing materials that may contain asbestos and consult professionals trained in hazardous material handling for assessment and removal. HUD: Post Disaster Housing Repair and Restoration",
    "Have a licensed HVAC professional inspect and service the systems before use, as water or debris can cause significant damage.",
    "Use tarps to cover damaged roofs, board up broken windows, and remove standing water to mitigate additional harm.",
    "Federal and state agencies offer programs to help homeowners with repairs and rebuilding efforts. HUD: Post Disaster Housing Repair and Restoration",
    "Begin by taking clear photographs of all four sides of your house, as well as each corner, to capture a comprehensive view of the exterior damage. Ensure the images are well-lit and focused.",
    "Document each room thoroughly, capturing walls, ceilings, floors, and any built-in appliances. Pay special attention to visible damage, such as cracks, water stains, or structural issues.",
    "Create a detailed inventory by photographing each damaged item individually. Include close-up shots of serial numbers or unique features, and accompany each photo with a written description noting the item's make, model, and estimated value.",
    "Yes, recording videos can provide a more comprehensive view of the damage. Narrate the footage to highlight specific issues and describe the extent of the damage as you move through your property.",
    "Organize your media by categorizing them into folders based on rooms or damage types. Rename files with descriptive titles and maintain a corresponding inventory list to streamline the claims process.",
    "Capture images of cracks, shifts, or any deformations in the structure. Use a ruler or another object for scale to illustrate the size of the damage, and take notes on the location and severity of each issue.",
    "Take before-and-after photos of the areas where temporary repairs were made. Keep all receipts and records of materials purchased and hired labor, as these may be reimbursable by your insurance company.",
    "Yes, documenting undamaged areas can provide a contrast to affected zones and serve as evidence of the disaster's selective impact, which may be useful during the claims assessment.",
    "Utilize apps and software designed for home inventories to catalog items and damages efficiently. Some platforms allow you to attach photos, receipts, and notes, creating a comprehensive digital record.",
    "Do not risk personal safety to document damage. Instead, inform your insurance adjuster about inaccessible areas; they may arrange for a professional inspection to assess those parts of your property.",
    "Photograph any damage to fences, sheds, pools, and landscaping features. Provide wide-angle shots to show the context within your property and close-ups to detail specific damages.",
    "Yes, document any damage to electrical panels, HVAC systems, plumbing, and other utilities. Take photos of affected areas and note any functional issues or safety concerns.",
    "Update your asset list by adding any new items and noting those that were present during the disaster. Use purchase records, warranties, and credit card statements to help reconstruct an accurate inventory.",
    "For each item, list the name, description, purchase date, original cost, and estimated current value. Note the extent of the damage and whether the item is repairable or a total loss.",
    "Follow your insurer's guidelines for documentation, which may include specific photo angles, required information, and preferred formats. Contact your insurance representative for any clarifications.",
    "Yes, platforms like HOVER allow you to upload photos and generate a detailed 3D model of your property, which can be useful for assessments and insurance claims. ",
    "hover.to",
    "Compile all photos, videos, and inventories into a digital format. Many insurance companies offer online portals or apps for claim submissions; alternatively, you can provide the documentation via email or physical copies, as per your insurer's instructions.",
    "Retain copies of all documentation for your records. It's advisable to back up digital files to cloud storage or an external hard drive to prevent loss.",
    "Consider borrowing a device from a neighbor or friend. If that's not possible, take detailed written notes describing the damage, and sketch affected areas to the best of your ability.",
    "Comprehensive documentation substantiates your insurance claims, facilitates accurate repair estimates, and provides a clear record of losses, all of which are crucial for efficient recovery and financial reimbursement.",
    "Reach out to your contractor as soon as possible to inform them of the damage and to schedule an assessment. Early communication ensures you're prioritized in their repair schedule.",
    "Share details about the extent of the damage, any immediate safety concerns, and your insurance claim status. Providing photos or videos can help them prepare for the assessment.",
    "Request copies of their license and insurance certificates. You can also verify their credentials through your state's licensing board or local regulatory agency.",
    "Unlicensed contractors may perform substandard work, lack proper insurance, and leave you liable for any injuries or damages that occur during the repair process.",
    "Use contractors you've vetted prior to the disaster. If you need to find a new contractor, utilize reputable sources like BuildZoom or your local chapter of the National Association of Home Builders. Always confirm their credentials and avoid those who demand large upfront payments.",
    "Be cautious of contractors who solicit door-to-door, offer unsolicited services, request full payment upfront, or pressure you into quick decisions.",
    "Seek recommendations from friends, family, or neighbors. Additionally, consult reputable sources like BuildZoom or your local chapter of the National Association of Home Builders to identify qualified contractors.",
    "Verify their license and insurance, check references, review their past work, and consult online reviews. Ensure they have experience with post-disaster repairs.",
    "Yes, obtaining multiple bids allows you to compare prices, timelines, and the scope of work, helping you make an informed decision.",
    "Typically, a deposit should not exceed 10% of the total project cost or \$1,000, whichever is less. Be wary of contractors who demand larger upfront payments.",
    "Absolutely. A detailed contract outlining the scope of work, materials to be used, timelines, payment schedules, and warranties protects both you and the contractor.",
    "Regularly communicate with your contractor, monitor the progress, and address any concerns promptly. Withhold final payment until all work is completed to your satisfaction and any agreed-upon inspections are passed.",
    "Document all communication attempts and express your concerns in writing. If the issue persists, consider finding another contractor and report the unprofessional behavior to relevant licensing authorities.",
    "Depending on the extent of the damage and local regulations, certain repairs may require permits. Your contractor should be knowledgeable about local permitting requirements and obtain them on your behalf.",
    "Request a list of references and contact them to inquire about their experience. Additionally, check online reviews and ratings on reputable platforms.",
    "The contract should detail the scope of work, materials to be used, start and completion dates, payment terms, warranties, and dispute resolution procedures.",
    "Discuss any unforeseen issues with your contractor promptly. Ensure that any changes to the original scope of work are documented in a written change order, including any cost adjustments.",
    "Yes, it's common for contractors to set up a payment schedule based on project milestones. Ensure these terms are clearly outlined in your contract.",
    "Review the termination clause in your contract to understand the conditions and any penalties. Provide written notice of termination, citing specific breaches or issues, and consult legal advice if necessary.",
    "You can contact your state's consumer protection office, the Better Business Bureau, or your local licensing board. They can offer guidance and mediation services.",
    "Regularly reviewing your policy ensures that your coverage aligns with any changes in your home's value, renovations, or new possessions. It helps prevent surprises during the claims process and ensures adequate protection.",
    "Coverage limits are the maximum amounts your insurer will pay for a covered loss. They apply to different sections of your policy, such as dwelling, personal property, and liability coverage.",
    "Read your policy's declarations page and the detailed terms and conditions. Pay attention to sections outlining covered perils and exclusions. If unclear, contact your insurance provider for clarification.",
    "A deductible is the amount you pay out-of-pocket before your insurance coverage kicks in for a covered loss. For example, if your deductible is \$1,000 and you have \$5,000 in damages, you'll pay \$1,000, and your insurer will cover the remaining \$4,000. ",
    "libertymutual.com",
    "Select a deductible that balances affordable premiums with an out-of-pocket amount you can manage in the event of a claim. Higher deductibles typically lower premiums but increase your financial responsibility during a claim.",
    "progressive.com",
    "Yes, there are standard (fixed dollar amount) and percentage-based deductibles. Percentage deductibles are often applied to specific perils like wind or hail damage and are calculated based on a percentage of your home's insured value. ",
    "iii.org",
    "Actual cash value coverage reimburses you for the depreciated value of damaged items, while replacement cost coverage pays the amount needed to replace the items with new ones of similar kind and quality.",
    "Standard homeowners insurance policies typically exclude flood and earthquake damage. Separate policies or endorsements are usually required for these perils.",
    "en.wikipedia.org",
    "Verify that your dwelling coverage limit reflects the current cost to rebuild your home, considering factors like construction costs and home improvements. Some policies offer extended or guaranteed replacement cost endorsements for added protection.",
    "These are sub-limits within your policy that cap the amount payable for specific categories of personal property, such as jewelry, firearms, or electronics. Review these limits and consider endorsements if necessary.",
    "Contact your insurance provider promptly after a loss, provide necessary documentation (photos, inventory lists), and complete any required claim forms. An adjuster will assess the damage to determine the payout.",
    "Also known as additional living expenses (ALE) coverage, it reimburses you for extra costs incurred if your home becomes uninhabitable due to a covered loss, such as hotel stays or increased meal expenses.",
    "Common exclusions include wear and tear, neglect, intentional damage, and certain natural disasters like floods or earthquakes. Reviewing these exclusions helps you understand potential coverage gaps.",
    "Notify your insurance provider of any significant renovations or additions to ensure your coverage limits are adjusted accordingly, protecting your investment and ensuring adequate coverage.",
    "It provides financial protection if you're held legally responsible for bodily injury or property damage to others, covering legal fees and potential settlements.",
    "Insurers often use credit-based insurance scores to assess risk. A higher credit score can lead to lower premiums, while a lower score may result in higher costs.",
    "Many insurers offer discounts for bundling multiple policies, such as homeowners and auto insurance, which can lead to cost savings.",
    "Review your policy to understand your coverage, gather supporting documentation, and discuss your concerns with your insurer. If unresolved, consider mediation, arbitration, or consulting a public adjuster.",
    "It's advisable to review your policy annually or after significant life events, such as home renovations, major purchases, or changes in occupancy, to ensure adequate coverage.",
    "Resources like the National Association of Insurance Commissioners (NAIC) and your state's insurance department offer guides and tools to help you understand and compare homeowners insurance policies.",
    "Ensure the safety of all occupants first. Once safe, document the damage with photos and videos, and contact your insurance company promptly to initiate the claims process. ",
    "Contact your insurance agent or company directly to report the damage. Provide detailed information about the extent of the damage and any immediate repairs needed.",
    "Be prepared to provide your policy number, a description of the damage, the date of the incident, and any photos or videos you've taken. Having a home inventory list can also be beneficial. ",
    "File your claim as soon as possible. Prompt reporting can expedite the assessment and settlement process. Delays might lead to complications or potential denial of the claim.",
    "Contact your insurance company or agent; they can provide your policy details and guide you through the claims process even if your documents are lost.",
    "Yes, make necessary temporary repairs to prevent further damage, such as covering broken windows or tarping a damaged roof. Keep all receipts and document these repairs for reimbursement. ",
    "Take clear, detailed photos and videos of all affected areas and items. Create a written list of damaged or lost belongings, including descriptions and estimated values. ",
    "An insurance adjuster is a professional assigned by your insurer to assess the damage to your property and determine the payout amount based on your policy coverage.",
    "Ensure the damaged areas are accessible, provide them with your documentation (photos, videos, inventory lists), and be ready to discuss the extent of the damage and any temporary repairs you've made. ",
    "If you disagree, review your policy details and gather any additional evidence to support your claim. You can request a re-assessment or consider hiring a public adjuster for an independent evaluation. ",
    "Many homeowners insurance policies include Additional Living Expenses (ALE) coverage, which reimburses costs like hotel stays and meals if you're temporarily displaced. Confirm this with your insurer. ",
    "The timeline varies based on the complexity of the claim and the insurer's processes. Prompt documentation and communication can help expedite the process.",
    "Claims can be denied due to policy exclusions (e.g., flood or earthquake damage not covered), lack of maintenance, or insufficient documentation. Reviewing your policy and providing thorough evidence can mitigate these risks. ",
    "Generally, you can choose your own contractor. However, it's advisable to select a licensed and insured professional. Some insurers may have preferred contractors, but the choice is typically yours. ",
    "Your deductible is the amount you'll pay out-of-pocket before your insurance coverage applies. For example, if your damage is \$10,000 and your deductible is \$1,000, the insurer will pay \$9,000. ",
    "Notify your insurance company immediately. They may send the adjuster back for a re-assessment or request additional documentation to cover the newly discovered damage.",
    "Yes, policies often have specific time frames for reporting claims and submitting required documentation. Check your policy or consult your insurer to ensure timely compliance. ",
    "Maintain regular communication with your insurance adjuster or representative. Some insurers offer online portals where you can monitor the status of your claim.",
    "Provide prompt and thorough documentation, maintain open communication with your insurer, understand your policy coverage, and keep detailed records of all interactions and expenses related to the claim. ",
    "Request a detailed explanation for the denial, review your policy to understand the reasoning, and gather any additional evidence that may support your claim. You can appeal the decision or seek assistance from your state's insurance department if necessary. ",
    "An insurance policyholder's bill of rights is a set of protections and entitlements designed to ensure fair treatment of consumers by insurance companies. These rights often include transparency in policy terms, timely processing of claims, and avenues for dispute resolution. Specific rights can vary by state.",
    "To locate your state's policyholder bill of rights, visit your state's Department of Insurance website. Look for sections dedicated to consumer resources or policyholder information. If you have difficulty finding it online, consider contacting the department directly for assistance.",
    "Common rights often include: the right to a readable policy, the right to receive a complete insurance policy, the right to competitive pricing, the right to be treated fairly and free from unfair practices, and the right to file complaints against insurers or agents. For example, Louisiana's policyholder bill of rights outlines these protections. ",
    "Not all states have a formalized policyholder's bill of rights. However, many states have regulations and statutes that protect policyholders. It's important to review your state's specific laws and consult with the state insurance department for detailed information.",
    "Being aware of your rights ensures you can advocate for fair treatment, understand the claims process, and recognize when an insurer may be acting improperly. This knowledge empowers you to seek appropriate remedies if issues arise during the claims process.",
    "If you suspect your insurer is violating your rights, document all interactions and gather supporting evidence. Contact your state's Department of Insurance to file a complaint and seek guidance on the next steps. They can investigate and mediate disputes between policyholders and insurers.",
    "Insurance is primarily regulated at the state level. However, federal laws, such as those enforced by the Federal Trade Commission (FTC), provide protections against deceptive practices. Additionally, organizations like the National Association of Insurance Commissioners (NAIC) develop model laws to promote uniformity across states. ",
    "Generally, insurers must provide advance written notice before canceling or nonrenewing a policy, except in cases of non-payment of premiums. The required notice period varies by state. For instance, Louisiana requires at least 30 days' notice prior to cancellation or nonrenewal. ",
    "State Departments of Insurance regulate the insurance industry within their jurisdiction. They enforce state insurance laws, handle consumer complaints, provide educational resources, and ensure that insurers operate fairly and solvently.",
    "You can verify the licensing status of an insurance company or agent by visiting your state's Department of Insurance website. Many states offer online tools or databases where consumers can search for licensed entities.",
    "To file a complaint, gather all relevant documentation, including your policy, correspondence, and claim details. Visit your state's Department of Insurance website to access their complaint form or submission process. Provide a detailed account of the issue and submit any supporting evidence. ",
    "Yes, there are often time limits for filing complaints or appeals. These limits vary by state and the specific circumstances of your case. It's advisable to act promptly and consult your state's Department of Insurance for specific timelines.",
    "If your rights are violated and the issue cannot be resolved through the Department of Insurance or mediation, you may consider legal action. Consult with an attorney experienced in insurance law to explore your options and understand the potential outcomes.",
    "The National Association of Insurance Commissioners (NAIC) develops model laws to promote uniformity and best practices across states. While these models are not binding, many states adopt or adapt them into their own regulations to enhance consumer protections. ",
    "Regularly review communications from your insurer, stay updated with information from your state's Department of Insurance, and consult reputable resources like the NAIC. Attending consumer education workshops or webinars can also be beneficial.",
    "Yes, policyholders often have rights related to claim settlements, such as the right to a prompt and fair settlement, the right to receive a written explanation for claim denials, and the right to appeal unfavorable decisions. These rights can vary by state.",
    "The right to a readable policy ensures that policyholders receive insurance policies written in clear and understandable language. This right aims to help consumers comprehend their coverage, exclusions, and obligations without requiring specialized knowledge. ",
    "The bill of rights often includes provisions that prohibit unfair or deceptive acts by insurers, such as misrepresentation of policy terms, unjust claim denials, or discriminatory practices. These protections aim to ensure fair treatment of consumers.",
    "Insurers are generally required to provide written notification detailing any changes in policy provisions at renewal. This ensures that policyholders are aware of modifications and can make informed decisions about their coverage.",
    "For more information, consult your state's Department of Insurance, review your insurance policy documents, and visit reputable organizations like the NAIC. These sources offer comprehensive guidance on policyholder rights and insurance regulations.",
    "Retrieve your EFFAK from its secure storage location, whether it's a physical copy in a waterproof/fireproof safe or a digital version stored electronically. If stored digitally, ensure you have the necessary devices and internet access to retrieve it. ",
    "Begin by reviewing your Household Identification documents to verify everyone's identity and support any assistance applications. Ensure all personal identification documents are intact and accessible.",
    "Utilize the Financial and Legal Documentation section to access your insurance policies, contact information, and account numbers. This information is vital for initiating and expediting insurance claims. ",
    "Your EFFAK contains Financial Account Information, including bank statements and income sources, which are essential when applying for disaster assistance programs to demonstrate financial need. ",
    "The Medical Information section provides details like physician contacts, prescription medications, and health insurance information, facilitating continuity of care and assistance with medical claims. ",
    "Contact relevant institutions (banks, insurance companies, government agencies) promptly to request replacements. Your EFFAK's Household Contacts section can provide necessary contact information. ",
    "Use the Financial Obligations section to identify creditors, account numbers, and payment schedules. Inform them of your situation to discuss possible payment deferments or assistance programs. ",
    "Yes, the EFFAK includes essential information needed for applications, such as personal identification, financial records, and property details, streamlining the process with agencies like FEMA. ",
    "Present documents from the Housing Payments section, such as mortgage statements or deeds, to establish ownership when seeking housing assistance or rebuilding permits. ",
    "Keep your EFFAK in a secure, waterproof, and fireproof location. If possible, create digital backups and store them in encrypted cloud services to prevent loss from subsequent events. ",
    "The Employment Information section contains employer contacts and employment details, which can be crucial for verifying employment status and income if needed. ",
    "Review and revise any information that has changed due to the disaster, such as new contact information, updated financial obligations, or changes in insurance coverage. ",
    "Yes, the EFFAK's Pet Information section includes veterinarian contacts, vaccination records, and microchip information, aiding in locating and caring for pets post-disaster. ",
    "By referencing the Financial Obligations section, you can keep track of due dates and amounts, ensuring timely payments or arranging for deferments as needed. ",
    "Documents such as wills, powers of attorney, and property deeds found in the Legal Documentation section are crucial for legal proceedings and verifying ownership or authority. ",
    "Use the contact information and account details in the Financial Obligations section to communicate with utility providers for service restoration or billing inquiries.",
    "Access your health insurance policy details and medical contacts in the Medical Information section to coordinate care and manage medical billing or claims.",
    "Yes, if you've included school contact information and records in the Household Identification section, it can assist in retrieving or verifying educational documents. ",
    "The Household Contacts section provides a centralized list of important contacts, facilitating efficient communication with family, friends, and service providers. ",
    "Begin gathering essential documents and information as outlined in the EFFAK guidelines. Seek assistance from local resources or disaster recovery centers to help reconstruct necessary records.",
    "Implementing cost-effective measures can enhance your home's resilience. For instance, installing storm shutters protects windows during hurricanes, and reinforcing garage doors can prevent wind damage. Upgrading to impact-resistant roofing materials can also offer significant protection. Many of these improvements can be made for under \$50. ",
    "Consult with local building authorities to understand current codes and standards. Incorporate reinforced framing, hurricane straps, and elevated foundations to meet or exceed these requirements, enhancing your home's ability to withstand severe weather. ",
    "Yes, using non-combustible materials such as metal or tile roofing, and fiber-cement siding can reduce fire risk. Installing ember-resistant vents and maintaining defensible space around your home are also crucial steps. ",
    "Elevate your home's foundation above the base flood elevation level. Use water-resistant materials for walls and floors, and install backflow prevention valves in plumbing to prevent sewage backup during floods. ",
    "A hip roof design, which slopes on all sides, offers better wind resistance compared to gable roofs. Additionally, securing the roof with hurricane straps can enhance its stability during high winds. ",
    "Yes, installing impact-resistant windows not only provides storm protection but also improves energy efficiency. Similarly, insulated concrete forms (ICFs) offer superior insulation and enhanced structural strength against disasters. ",
    "Implement defensible space by clearing flammable vegetation near the home in wildfire areas. In flood-prone zones, use native plants and design rain gardens to enhance water absorption and reduce runoff. ",
    "ICFs provide excellent insulation, leading to energy efficiency, and offer superior strength against natural disasters like hurricanes and tornadoes. They also have a higher resistance to fire compared to traditional wood framing. ",
    "Elevate electrical outlets and service panels above potential flood levels. Consider installing a whole-house surge protector to safeguard appliances during power surges caused by storms.",
    "Installing impact-resistant windows can protect against windborne debris during storms. Alternatively, using storm shutters provides an additional layer of protection and can be more cost-effective. ",
    "Opting for fiber-cement siding offers enhanced resistance to fire, moisture, and pests compared to traditional wood siding. It's a durable choice for various climates and disaster scenarios. ",
    "Proper attic ventilation helps prevent moisture buildup, reducing mold risk after heavy rains. In wildfire-prone areas, using ember-resistant vents can prevent embers from entering and igniting the attic space. ",
    "Yes, using spray foam insulation can strengthen walls and roofs, providing additional structural support against high winds. It also acts as a barrier against water intrusion during heavy rains. ",
    "Install a reinforcement kit to strengthen the door's structure. Ensuring the garage door is wind-rated and properly braced can prevent it from failing during high-wind events, which can compromise the entire home's integrity. ",
    "Securing heavy appliances and furniture to walls can prevent injuries and damage during seismic activity. Installing seismic bracing for water heaters and using flexible gas lines can also reduce risks.",
    "Limiting roof overhangs can reduce the risk of uplift during high winds. Shorter overhangs are less susceptible to wind damage, enhancing the roof's overall stability. ",
    "Participating in a fortified home program ensures your home meets specific resilience standards, potentially reducing insurance premiums and enhancing protection against various natural disasters. ",
    "Ensure the ground slopes away from the foundation to prevent water accumulation. Installing French drains and maintaining clean gutters and downspouts can also aid in effective water management.",
    "Conduct a debriefing session with all household members to discuss their experiences and understanding of the evacuation procedures. Encourage open dialogue to identify any confusion or uncertainties they may have encountered. This feedback is crucial for refining the plan.",
    "Review the routes you took during the evacuation, noting any obstacles such as traffic congestion or road closures. Consider alternative paths and assess their viability. Engage with local authorities to stay informed about potential hazards on primary evacuation routes. ",
    "Establish a clear communication plan that includes multiple methods, such as mobile phones, two-way radios, or designated meeting points. Ensure all family members are familiar with these methods and conduct regular drills to practice. ",
    "Analyze the factors that contributed to the rushed feeling. Was it due to delayed alerts, lack of readiness, or other issues? Adjust your plan to allow more time for preparation, such as packing emergency kits in advance and staying updated with real-time alerts. ",
    "Store emergency supplies in a designated, easily accessible location known to all household members. Regularly check and update the contents to ensure everything is functional and up-to-date. Consider having smaller kits in multiple locations, like vehicles or workplaces. ",
    "Regularly maintain your vehicles to ensure they are in good working condition. Keep fuel tanks at least half full, especially during high-risk seasons. Identify multiple evacuation routes and consider alternative transportation options if necessary. ",
    "Assess the conditions of the shelters, including capacity, cleanliness, accessibility, and available resources. Gather feedback from all family members about their experiences and note any areas needing improvement. This information can guide future shelter choices or preparations. ",
    "Establish a family reunification plan that includes designated meeting points and communication methods. Ensure all family members, including children, understand the plan. For pets, have carriers and leashes ready, and consider microchipping for easy identification. ",
    "Conduct a thorough review of your recent evacuation experience, noting any challenges or areas of confusion. Engage all household members in this discussion to gain diverse perspectives. Regularly update the plan based on these insights and changes in circumstances. ",
    "Regular drills help identify weaknesses in the plan and familiarize all members with procedures, reducing panic during actual emergencies. After each drill, evaluate performance and make necessary adjustments to the plan. ",
    "Stay connected with local emergency management agencies and subscribe to alert systems. Use reliable apps and websites that provide real-time information on road conditions and hazards. Regularly review and update your knowledge of local evacuation routes.",
    "Consider the shelter's location, capacity, accessibility, and the resources it offers. Ensure it can accommodate any special needs your family members may have. Have multiple shelter options in different directions to account for various emergency scenarios. ",
    "Identify any specific requirements, such as medical equipment, mobility aids, or dietary needs. Incorporate these considerations into your plan, ensuring that necessary items are easily accessible during an evacuation. Communicate these needs to emergency personnel if necessary. ",
    "Reflect on previous evacuations to identify what worked well and what didn't. Update your plan to address any shortcomings, and involve all household members in the revision process to ensure comprehensive understanding and buy-in. ",
    "Familiarize yourself with local emergency communication channels, such as official social media accounts, websites, and alert systems. Keep a list of important contact numbers and consider investing in a battery-powered or hand-crank radio for updates during power outages. ",
    "Engaging with your community can provide additional resources and support during evacuations. Participate in local emergency preparedness groups, share knowledge, and collaborate on evacuation strategies to enhance overall resilience. ",
    "Develop a flexible plan that accounts for various scenarios, such as natural disasters",
    "Disaster relief programs provide temporary housing, financial assistance, home repair grants, and crisis counseling. Programs vary by state and can be accessed through national agencies and local organizations.",
    "Financial aid is available through federal, state, and nonprofit programs. Many homeowners qualify for grants, low-interest disaster loans, or insurance payouts. Reach out to relief organizations to check eligibility.",
    "Temporary housing options include FEMA-provided housing, rental assistance programs, and local shelter services. Some states also have disaster housing assistance initiatives for displaced residents.",
    "Disaster unemployment benefits may be available to those whose employment was affected by a federally declared disaster. Applications are typically processed through the state?s workforce or labor department.",
    "Post-disaster counseling and crisis support are offered by national mental health hotlines, local crisis centers, and nonprofit organizations. Many services are free and provide trauma-informed care.",
    "Food assistance is available through emergency food banks, community relief organizations, and government food assistance programs. Many disaster-affected areas also receive emergency SNAP benefits.",
    "Small business owners may qualify for disaster recovery grants, business interruption loans, and emergency assistance programs through both government and private-sector relief funds.",
    "Free or low-cost legal aid services can help with insurance claims, landlord disputes, and FEMA application appeals. Disaster-related legal aid is often provided through state bar associations and pro bono networks.",
    "Vital records such as birth certificates, Social Security cards, and property deeds can be replaced through state and federal agencies. Many states waive fees for document replacements after a disaster.",
    "Seniors can access specialized housing, medical care, and transportation assistance through aging services organizations, nonprofit groups, and government agencies tailored to older adults.",
    "Disability support programs provide accessible sheltering, medical aid, transportation, and advocacy services. Many organizations ensure disaster relief services accommodate special needs.",
    "Many relief organizations offer temporary childcare assistance, emergency daycare centers, and education grants to families affected by disasters. Schools may also provide resources for displaced students.",
    "Homeowners may qualify for disaster recovery loans through government programs and private lenders. These loans help cover repairs, rebuilding costs, and other disaster-related expenses.",
    "Renters can apply for rental assistance, housing vouchers, and temporary shelter programs. Local housing agencies often coordinate support for displaced tenants.",
    "Community relief centers, local government offices, and disaster recovery organizations provide area-specific assistance programs. Connecting with local nonprofits can also be beneficial.",
    "Many humanitarian groups, faith-based organizations, and legal aid services assist immigrant families with housing, medical aid, and legal advocacy, regardless of legal status.",
    "Utility companies and nonprofit organizations offer assistance programs to cover electricity, water, and gas bills for those affected by natural disasters.",
    "Farmers may qualify for federal disaster relief programs, emergency farm loans, and agricultural assistance grants. Rural community aid programs provide rebuilding resources for affected areas.",
    "Many nonprofits, faith-based groups, and local volunteer organizations provide disaster relief efforts, home cleanup, and recovery aid. Look for organizations that specialize in post-disaster assistance.",
    "Apply for FEMA assistance through their online portal, mobile app, or disaster recovery centers. Have identification, proof of residence, and financial records ready for the application process.",
    "Signs that a child may need professional support include persistent nightmares, withdrawal from family or friends, extreme irritability, loss of interest in activities, or regressive behaviors (such as bedwetting). If these persist, consulting a child therapist or counselor is recommended.",
    "Sleep disturbances are common after traumatic events. Try establishing a calming bedtime routine, reducing caffeine intake, and engaging in relaxation techniques like deep breathing or meditation. If the problem persists, a mental health professional can provide further guidance.",
    "Yes, natural disasters can trigger Post-Traumatic Stress Disorder (PTSD). Symptoms include flashbacks, nightmares, heightened anxiety, emotional numbness, and avoidance of reminders of the disaster. If symptoms interfere with daily life, professional support is recommended.",
    "Older adults may experience heightened distress after disasters. Encourage open conversations, help them connect with support groups, and assist them in accessing local senior mental health services. Ensuring they have a sense of routine and social connection is vital.",
    "Many organizations offer free or low-cost mental health services, especially after disasters. Community centers, nonprofits, and federally funded programs often provide counseling services at no cost. Reach out to local agencies for assistance.",
    "Survivor?s guilt is common among those who lived through a disaster while others suffered losses. Seeking therapy, joining support groups, and finding ways to contribute to recovery efforts (such as volunteering) can help process these emotions in a healthy way.",
    "Grounding techniques such as the 5-4-3-2-1 method (naming five things you see, four things you touch, etc.), deep breathing exercises, and mindful movement like yoga or walking can help refocus your thoughts and calm anxiety.",
    "Journaling allows for self-reflection, emotional processing, and stress reduction. Writing about thoughts and feelings helps individuals gain clarity and recognize patterns in their emotions, which can be useful for healing.",
    "Isolation can worsen mental health struggles. Try reaching out to friends or family, joining local support groups, or participating in community recovery efforts to rebuild social connections.",
    "Building emotional resilience includes practicing self-care, maintaining a support network, learning stress management techniques, and staying informed about disaster preparedness. Knowing that you have a plan in place can reduce anxiety about future events.",
    "Contractors play a critical role in disaster recovery and rebuilding. This section provides guidance on safety protocols, insurance processes, compliance, and best practices for working in disaster-affected areas. Let?s get started!",
    "Start by registering as a disaster response contractor, ensuring you have proper insurance, and training your crew on safety in disaster zones. You should also establish connections with local agencies and suppliers to streamline response efforts.",
    "Contractors should understand hazardous work conditions, insurance claim procedures, FEMA funding, and fraud prevention. It's also crucial to follow local building codes and disaster mitigation best practices.",
    "Certifications vary by state and agency, but common programs include FEMA contractor registration, OSHA disaster site worker certification, and state-specific disaster response programs. Many government contracts require these certifications.",
    "Safety is critical. Assess structural stability, wear personal protective equipment (PPE), and be cautious of electrical hazards, gas leaks, and flood contamination. Ensure your team is trained in hazardous material handling.",
    "Contractors should document all damage thoroughly, provide detailed repair estimates, and understand depreciation, deductibles, and claim timelines. Avoid starting work before verifying insurance coverage and payout schedules.",
    "To work on FEMA-related projects, register with SAM.gov, complete disaster contracting courses, and bid on open opportunities through local and federal procurement systems. Having prior disaster recovery experience can be beneficial.",
    "Contractors must adhere to state licensing requirements, building codes, and federal disaster regulations. Be cautious of laws regarding price gouging, fraud, and unlicensed work in disaster areas.",
    "Make sure you have general liability, workers? compensation, and pollution liability insurance. Some projects may require specific disaster-response coverage. Consult with your insurance provider to ensure compliance.",
    "Subcontractors should confirm licensing requirements, payment terms, and safety protocols before accepting work. It?s essential to verify that the general contractor is reputable and financially stable to avoid non-payment risks.",
    "Ask for a copy of their insurance policy, confirm coverage with the insurance adjuster, and ensure that the scope of work is approved before starting. Beware of homeowners who may not have sufficient coverage.",
    "Educate homeowners on filing claims, gathering documentation, understanding claim settlements, and requesting supplemental payments for unforeseen damages. Guide them through working with adjusters and understanding depreciation.",
    "Be aware of fraudulent adjuster claims, property owner scams, unlicensed competitors, and underbidding schemes. Always use clear contracts, verify funding sources, and report any suspicious activities to state authorities.",
    "Risks include delayed insurance payments, contract disputes, unexpected labor/material costs, and legal liabilities. Ensure all work is properly documented, contracted, and approved before beginning a project.",
    "Typically, payments are issued in phases: initial deposit, progress payments upon milestone completion, and final payment after inspection. Confirm with insurance carriers and mortgage companies about their payout structure.",
    "Enforce OSHA safety regulations, conduct daily site safety meetings, and provide PPE (hard hats, respirators, gloves, boots, etc.). Train workers in hazard recognition, fall protection, and emergency response procedures.",
    "Use impact-resistant roofing, reinforced concrete, hurricane straps, flood-resistant materials, and fireproof siding. Follow IBHS and FEMA building resilience standards to reduce future damage risks.",
    "Establish pre-negotiated supplier agreements, train response teams, maintain a ready fleet of vehicles and equipment, and register with local emergency contracting agencies to secure priority access to rebuilding work.",
    "Different states and localities have storm, fire, flood, and earthquake-resistant building codes. Check local government websites and FEMA resources to ensure compliance with the latest disaster resilience standards.",
    "Stay informed about licensing, safety laws, contracting rules, and disaster response ethics. Participate in continuing education courses and contractor disaster preparedness programs to remain up-to-date.",
    "Homes and buildings that meet modern codes have higher resale values, lower insurance premiums, and fewer warranty claims. Clients trust contractors who build resilient structures, leading to more referrals and repeat business.",
    "Investing in hurricane-rated windows, fire-resistant siding, and impact-resistant roofing can reduce maintenance costs for clients, making your projects stand out in the market. Homebuyers and businesses are willing to pay more for durability.",
    "Yes! Some insurers offer discounts or better coverage for projects that meet IBHS Fortified standards or state disaster-resistant building codes. These benefits help contractors sell their projects more effectively.",
    "If you build to modern codes and best practices, your liability decreases. You avoid lawsuits over faulty construction, preventable storm damage, or non-compliant builds, reducing warranty issues and legal risks.",
    "Get IBHS Fortified certification, promote before-and-after disaster case studies, and showcase how your homes outperform others in severe weather. Builders who specialize in resilience win more contracts in high-risk areas.",
    "Yes! After disasters, homebuyers and business owners prioritize storm-resistant features, fireproofing, and energy efficiency. Highlighting these upgrades in your projects justifies premium pricing.",
    "Tell them: For every \$1 spent on disaster-resistant construction, they save \$6 in future repairs. Fewer repairs, lower insurance, and a safer investment make resilient homes a smarter financial decision.",
    "1?? Impact-resistant roofing (protects from wind & hail) 2?? Fire-resistant siding (prevents wildfire spread) 3?? Elevated foundations & floodproofing (reduces water damage). These are affordable but high-value upgrades.",
    "Register with FEMA, state emergency management offices, and insurance networks for disaster-recovery contracting. Offer fast response teams and market yourself as a resilient construction expert to get priority jobs.",
    "1?? Using cheap materials that won?t withstand the next disaster 2?? Rushing jobs without meeting code standards 3?? Ignoring insurance claim processes, which leads to disputes. Avoid these, and your reputation (and profits) will grow.",
    "Building to code is the minimum standard. If you want repeat clients and word-of-mouth referrals, go beyond code with reinforced connections, energy-efficient systems, and disaster-resistant materials.",
    "Show them the long-term savings: A stronger roof costs \$3,000 more now but saves \$20,000+ in storm repairs. Use real-world case studies to prove that cheap construction is actually more expensive over time.",
    "Standard codes are minimum requirements; IBHS Fortified adds layers of protection against wind, hail, and hurricanes. Building to IBHS Fortified levels makes homes 50% less likely to suffer major storm damage.",
    "Focus on high-impact, low-cost upgrades: Better roof fasteners, stronger doors & windows, and water-resistant materials. Small changes create a huge value-add for customers without pricing yourself out of the market.",
    "Some states offer tax incentives, rebates, or insurance discounts for contractors who build to Fortified, LEED, or modern resilience standards. Check with local programs for financial benefits.",
    "While not required, getting IBHS Fortified certification, LEED accreditation, or FEMA mitigation training makes you more credible and can win you higher-paying contracts.",
    "Use strict quality control: Set clear job specs, inspect work frequently, and train your crews on resilience-focused installations. Your reputation is at stake, so demand high standards.",
    "1?? Weak roof connections that let wind tear off shingles 2?? Poor drainage systems that lead to flood damage 3?? Non-reinforced walls that can collapse under storm stress. Avoid these for better resilience.",
    "Educate them! Show them case studies of storm-resistant homes, emphasize insurance savings, and explain how a \$10,000 upgrade today can prevent a \$50,000 repair later.",
    "Many government & commercial projects require resilient construction. Getting certified in IBHS Fortified, FEMA resilience standards, or state disaster programs makes you eligible for higher-value bids.",
    "Know the claim process! Get written scopes of work, take detailed photos, and communicate clearly with adjusters. The more professional you are, the faster you get paid and the more likely you?ll get referrals.",
    "Many think it?s too expensive, but small upgrades like hurricane clips, impact-resistant glass, and better drainage make a huge difference at a low extra cost.",
    "Market yourself as the go-to contractor for storm-resistant, energy-efficient, and low-maintenance buildings. Offer warranties, partner with insurers, and build customer trust through better-built homes.",
    "Invest in hands-on workshops, supplier training, and online courses from IBHS, FEMA, and the ICC. A well-trained team delivers higher-quality work, which means fewer call-backs and more referrals.",
    "Being known as a code-compliant contractor builds your reputation, reduces liability, and increases customer trust. Clients are willing to pay more for work that meets modern safety and resilience standards.",
    "Absolutely. Insurance companies prefer code-compliant buildings, and clients looking for resilient construction are willing to pay a premium for durability and long-term savings.",
    "Non-compliance can lead to fines, lawsuits, costly rework, and potential project shutdowns. Contractors caught cutting corners often lose licenses and future contracts.",
    "Stay updated through your local building department, industry training programs, and ICC/FEMA guidelines. New codes are adopted regularly, so keeping current ensures your projects meet legal and insurance requirements.",
    "Meeting code is the legal minimum, but going beyond code adds value?like hurricane straps for wind resilience or extra insulation for energy savings. It?s a great sales point for premium clients.",
    "If a disaster happens and a structure fails due to code violations, you could be held responsible. Compliance protects you from lawsuits, penalties, and expensive warranty claims.",
    "Non-compliance can lead to stop-work orders, fines, lawsuits, insurance claim denials, and even criminal charges if negligence causes harm.",
    "Regular toolbox talks, industry certifications, and on-site quality control checks help ensure your team follows current codes and best practices. Investing in training reduces costly mistakes.",
    "Stronger foundations, impact-resistant materials, better drainage, and fireproofing reduce damage from hurricanes, earthquakes, and wildfires?protecting your clients? investments and your reputation.",
    "Yes! FEMA studies show that adopting modern building codes could save \$132 billion in property losses by 2040. Structures built to updated codes suffer far less damage than older ones.",
    "Skipping permits and inspections might save time upfront, but if an inspector catches it, you could face fines, forced demolition, and major delays?costing you far more in the long run.",
    "Government projects, insurance-backed repairs, and large commercial jobs require strict code compliance. Contractors with a strong track record of compliance are more likely to secure lucrative contracts.",
    "Explain that non-compliant work can void their insurance, create safety risks, and reduce their home?s value. Offer cost-effective compliance solutions instead of outright rejecting the job.",
    "Skipping permits, using substandard materials, ignoring egress/fire codes, improper electrical wiring, and inadequate structural support are among the biggest compliance failures that lead to costly problems.",
    "Yes! Homes built to code are eligible for lower insurance premiums, and many insurers require compliance for storm, fire, or earthquake-prone areas. Compliance reduces claims, benefiting homeowners and insurers.",
    "Hire experienced project managers, use code compliance software, conduct regular site inspections, and build relationships with local inspectors. Staying proactive prevents costly rework.",
    "Set clear job specs, require certification, conduct spot inspections, and refuse to pay for non-compliant work. Making compliance a requirement protects your business and reputation.",
    "Yes! If a home isn?t built to the proper code, insurers may deny claims after a disaster, leaving the homeowner?and possibly you?on the hook for repairs.",
    "Non-compliant buildings are more likely to collapse in disasters, sustain major damage, and have higher long-term costs. Many case studies show that code violations lead to tragic failures.",
    "Many contractors think codes are just extra red tape, but in reality, they reduce liability, improve work quality, and make your business more competitive.",
    "Some codes have become stricter, but they also come with better materials and improved building techniques that actually make construction more efficient and durable.",
    "Tax credits, insurance discounts, FEMA grants, and reduced liability exposure make compliance a smart business decision. Some states offer financial assistance for code upgrades.",
    "Keep thorough documentation, ask for clarification, escalate concerns if needed, and collaborate professionally. Most inspectors want to help, not create problems.",
    "The International Code Council (ICC), FEMA, OSHA, and local building departments all offer training, updates, and certification programs to help contractors stay compliant.",
    "Specialize in disaster-resistant building techniques, educate your clients on resilience benefits, and get certified in IBHS Fortified or FEMA resilience programs. Contractors who lead in resilience win more contracts and higher-paying jobs.",
    "Resilient buildings suffer less damage, have lower insurance costs, and attract premium clients. Plus, government and commercial projects increasingly require resilience standards?which means more work for you.",
    "The faster a community recovers from disasters, the more work becomes available. Contractors who help strengthen infrastructure before disasters position themselves as go-to experts after the storm.",
    "1?? Reinforce key infrastructure, 2?? Build to stronger codes, 3?? Use disaster-resistant materials. Communities with resilient structures recover up to 40% faster?meaning less economic loss and faster rebuilding work for contractors.",
    "Standard building meets code minimums, but resilience-focused construction goes beyond code?using stronger materials, smarter designs, and future-proofing strategies that make buildings disaster-resistant and more valuable.",
    "Premium clients, higher resale values, lower warranty claims, and fewer repairs. Plus, resilient structures reduce long-term maintenance costs, which keeps customers coming back to you for new projects.",
    "Every \$1 spent on resilience saves \$6 in future disaster costs. Stronger homes mean lower insurance, less repair work, and better resale value?making it a smart long-term investment.",
    "Educate them on real-world cost savings, reduced insurance premiums, and the long-term durability of their investment. Use case studies of communities that thrived after disasters due to better-built homes.",
    "Yes! Some states offer tax credits, grant programs, and insurance discounts for contractors who build disaster-resistant homes. Check local and federal programs for opportunities.",
    "Register with FEMA, state emergency response programs, and local recovery initiatives. Offer fast response teams, damage assessments, and rebuilding services to secure contracts.",
    "Showcase successful resilience projects, partner with emergency management agencies, and educate clients on disaster-resistant construction. Being proactive in recovery efforts builds trust and credibility.",
    "1?? Using low-quality materials to cut costs, 2?? Rushing jobs without following updated codes, 3?? Ignoring insurance claim procedures. These lead to delays, disputes, and lost contracts.",
    "Set clear contract expectations, require proper certifications, and conduct on-site inspections. If subs cut corners, it reflects poorly on you and can cost you future work.",
    "Hurricane straps, impact-resistant windows, fire-resistant siding, and elevated foundations are low-cost, high-impact ways to improve resilience.",
    "Use real disaster case studies, highlight long-term cost savings, and show how resilient homes have lower insurance costs and higher resale values.",
    "If you build resilient structures, your liability risks decrease, and some insurers offer better coverage rates for contractors using approved disaster-resistant methods.",
    "Get pre-qualified with FEMA, HUD, and local emergency response programs. Government contracts require contractors who understand and implement resilient design.",
    "Material shortages, labor shortages, code enforcement delays, and financing issues. Contractors who plan ahead and have supply chain solutions are the first to secure work.",
    "Build above code, use flood-resistant materials, improve wind resistance, and incorporate fireproofing. Climate resilience is becoming a major factor in construction and insurance underwriting.",
    "Strict code enforcement ensures structures can withstand natural disasters. Communities with modern building codes recover faster and contractors who follow them win more trust and business.",
    "Join resilience planning committees, offer expertise in disaster recovery, and advocate for better building codes. Contractors with government relationships get priority rebuilding work.",
    "Smart technology, reinforced materials, and data-driven design will shape the next era of resilience. Stay ahead by getting certified, following industry trends, and networking with resilience-focused professionals.",
    "Stronger communities mean continuous work, from new builds to retrofits and disaster repairs. Contractors who specialize in resilience stay busy year-round.",
    "The stronger a community, the more stable the local economy, the more projects get funded, and the faster businesses recover?all of which means steady work for contractors like you.",
    "Fortified standards go beyond regular building codes to make structures more resistant to hurricanes, high winds, and hail. For contractors, they mean higher-paying jobs, fewer warranty claims, and a better reputation.",
    "Homebuyers, insurers, and government agencies pay a premium for Fortified homes. Plus, Fortified structures suffer less damage, meaning fewer callbacks and repairs?saving you money long-term.",
    "Yes! Research shows that Fortified homes suffer 50% less storm damage compared to traditional homes. That means fewer costly repairs and higher resale values.",
    "Get IBHS Fortified certification, promote your expertise in storm-resistant construction, and show before-and-after case studies of how Fortified homes outperform standard builds.",
    "Yes! Many insurers offer premium discounts for homes built to Fortified standards because they are at lower risk for major damage claims.",
    "Regular codes set the minimum standard for safety, but Fortified standards go beyond by requiring stronger roof systems, impact-resistant windows, and continuous load paths for superior disaster resistance.",
    "1?? Fortified Roof (stronger roof systems) 2?? Fortified Silver (protects doors, windows, and roof) 3?? Fortified Gold (ties entire structure together). The higher the level, the stronger the home?and the higher the resale value.",
    "Show them the math! A \$5,000 investment in Fortified upgrades can save them \$50,000+ in future repairs after a storm. Plus, insurance discounts help offset costs.",
    "Get IBHS Fortified certification, attend industry workshops, and register with local insurance and resilience programs to position yourself as an expert.",
    "No! Fortified construction integrates small, cost-effective upgrades that add minimal time to projects but significantly increase durability and client satisfaction.",
    "Yes! Buyers are willing to pay a premium for storm-resistant homes because they offer long-term savings on insurance and maintenance.",
    "Many government and corporate clients require Fortified standards for disaster resilience. By building to these standards, you qualify for more contracts and higher-value bids.",
    "Ring-shank nails for stronger roof decking, sealed roof decks to prevent water intrusion, and high-wind-rated shingles all help Fortified homes survive hurricanes and severe storms.",
    "Start with Fortified Roof upgrades, including better deck attachment, sealed roof underlayment, and stronger fasteners. These small steps add huge value.",
    "Yes! Fortified guidelines include wildfire-resistant materials and seismic reinforcements to make homes safer against multiple disaster types.",
    "Yes! Older homes can be upgraded with reinforced roofing, impact-resistant doors, and stronger wall-to-foundation connections to improve storm resistance.",
    "Lower insurance premiums, reduced maintenance costs, and higher resale values mean homeowners recoup their investment quickly while enjoying better storm protection.",
    "Homes built to Fortified standards suffer less damage, meaning fewer insurance claims, faster repairs, and lower rebuilding costs. This keeps communities stable and businesses running.",
    "Show them the financial benefits! Fortified developments attract higher-value buyers, reduce liability risks, and offer insurance incentives?making them more profitable in the long run.",
    "Many think it?s too expensive or complicated, but in reality, small upgrades like better fasteners and impact-resistant windows make a huge difference with minimal cost increases.",
    "Fortified Gold ties the entire building together, reinforcing the roof, walls, and foundation to withstand high winds, earthquakes, and extreme weather. It?s the strongest level of disaster resilience.",
    "Yes! Many upgrades?like sealed roofs, insulated windows, and impact-resistant siding?also improve energy efficiency and lower utility bills.",
    "The added cost for basic Fortified upgrades is usually 3-5% of total construction costs but can save thousands in repair costs and insurance over time.",
    "More states and insurers are adopting Fortified standards, meaning contractors who specialize in resilient builds will secure more jobs, higher profits, and long-term business success.",
    "Knowing the claims process helps you get paid faster, avoid disputes, and position yourself as an expert who can guide homeowners through complex insurance paperwork. Contractors who understand claims win more repeat business.",
    "Accurate claims processing can speed up payouts by up to 30%. If your documentation is clear and complete, insurers approve payments faster, reducing cash flow delays for your business.",
    "Failing to document damage properly. Insurers won?t approve repairs they can?t verify, so detailed photos, written reports, and itemized estimates are key to getting claims approved quickly.",
    "Speak their language! Use standardized Xactimate estimates, include before-and-after damage documentation, and be prepared to negotiate based on policy terms and replacement costs.",
    "Field adjusters inspect damage on-site, while desk adjusters review claims remotely and approve payouts. Contractors must communicate with both to ensure their repair estimates are accepted.",
    "Be professional, detailed, and responsive. Adjusters remember contractors who provide clear documentation, fair pricing, and timely communication?leading to more referrals for future claims.",
    "Take clear photos from multiple angles, record videos of structural damage, and note pre-existing conditions. The more evidence you provide, the harder it is for insurers to deny a claim.",
    "Yes, but you can?t act as a public adjuster unless licensed. Instead, guide homeowners on proper documentation, damage reporting, and policy terms to help speed up the claims process.",
    "Negotiate with adjusters. If an estimate is too low, present additional documentation, break down replacement costs, and escalate the claim if necessary.",
    "Mitigation companies handle emergency repairs (like water extraction or board-ups). Contractors should coordinate with them to ensure no work is duplicated and claims remain accurate.",
    "Submit all documentation upfront, maintain regular follow-ups, and ensure repair estimates match the policy coverage. Claims with complete paperwork process 30% faster.",
    "The homeowner can request a reinspection, submit additional proof, or hire a public adjuster to negotiate. Contractors should support them with detailed damage reports.",
    "It depends. For emergency repairs (like roof tarping), you can start immediately. For full rebuilds, get written insurer approval to ensure you?re paid.",
    "Use Xactimate or other industry-standard estimating tools, include itemized costs, and align pricing with local material and labor rates to reduce disputes.",
    "Review their policy with them, explain deductibles, and clarify exclusions. Helping clients understand their coverage builds trust and reduces frustration during claims.",
    "Follow up consistently, request a claim status update, and escalate issues if needed. A well-documented claim leaves insurers with little room to stall.",
    "Expect longer processing times due to high claim volume. Contractors should prioritize documentation, be patient with adjusters, and prepare for phased payments.",
    "Stay professional, present documented proof, and compare estimates. If an adjuster?s payout is too low, challenge it with repair justifications and industry pricing standards.",
    "Some policies pay Actual Cash Value (ACV) upfront, with Replacement Cost Value (RCV) paid after work is completed. Ensure homeowners understand their policy terms.",
    "Absolutely. If a claim lacks photos, receipts, or damage details, insurers can reduce payouts or deny claims altogether. Contractors must ensure thorough documentation.",
    "Request a re-evaluation with supporting documents. If needed, bring in an independent adjuster or engineer to provide an expert assessment.",
    "No. Homeowners can choose their own contractor, but insurers push preferred vendors because they control pricing more easily. Stand out by offering expertise in insurance-backed repairs.",
    "Get a signed contract stating insurance funds must be used for repairs, and consider filing a lien if payments aren?t made. Protect yourself before starting work.",
    "Exaggerated damages, missing documentation, or inflated repair costs can trigger audits. Contractors should document everything honestly to avoid legal issues.",
    "Fraudulent claims increase insurance costs by 15-20%, making it harder for ethical contractors to compete. Insurers and clients become more skeptical, making legitimate claims harder to approve.",
    "1?? Overcharging for materials/labor, 2?? Billing for work not done, 3?? Rushed, substandard repairs, 4?? Storm chaser scams, 5?? Bid rigging. Avoiding these protects your business and reputation.",
    "Be cautious if a homeowner or public adjuster pressures you to inflate estimates, bill for unneeded work, or use materials that don?t match the claim scope. If it feels shady, it probably is.",
    "Getting caught in insurance fraud, taking large deposits and disappearing, or doing substandard work that results in lawsuits. Even if you don?t go to jail, you could be banned from working in insurance-backed repairs.",
    "Maintain a strong local reputation, get certified, have proper licensing and insurance, and NEVER pressure homeowners into unnecessary repairs. Ethical contractors stand out by being transparent.",
    "Walk away. Inflating claims is fraud, and even if the homeowner asks for it, you could be held legally responsible. Politely explain that you only bill for actual work performed.",
    "Vet your subs carefully, require proper licenses and insurance, and inspect their work before submitting invoices. If they commit fraud under your contract, you could be held responsible.",
    "Huge legal trouble. Cash payments to avoid taxes or insurance paperwork can be considered tax evasion and fraud. Always use contracts and proper invoicing to protect yourself.",
    "1?? Large upfront payments with no contract, 2?? No license or insurance, 3?? Pressuring homeowners to file exaggerated claims, 4?? Refusing to provide written estimates, 5?? Door-to-door high-pressure sales tactics.",
    "Homeowners report suspicious activity, insurers audit claims, and state fraud task forces investigate unusual billing patterns. Many contractors get caught through random claims audits.",
    "You?re still liable. Insurance fraud laws don?t care if it was a mistake or not?you could face fines, loss of your contractor license, or even criminal charges. Always verify claim details.",
    "Yes! If insurers flag you as a high-risk contractor for poor documentation, excessive claims, or suspected fraud, they may refuse to approve your future claims, cutting off major revenue streams.",
    "1?? Get everything in writing, 2?? Submit detailed estimates with photos, 3?? Only bill for actual work performed, 4?? Keep organized records, 5?? Communicate transparently with adjusters and homeowners.",
    "If a subcontractor commits fraud under your contract, YOU could be held responsible. Always verify licensing, require written contracts, and inspect their work before submitting claims.",
    "Give them a checklist: Hire licensed contractors, get multiple bids, avoid large upfront payments, verify insurance, and beware of high-pressure sales tactics after disasters.",
    "Use standardized estimating software (like Xactimate), provide itemized invoices, and keep records of actual material costs. Transparency is key to preventing disputes.",
    "1?? Have a signed contract upfront stating funds will be used for repairs, 2?? File a mechanic?s lien if necessary, 3?? Consult a lawyer if payment disputes escalate.",
    "Not all, but many are. Ethical traveling contractors exist, but those who rush work, disappear after disasters, or lack local licensing/insurance are high-risk.",
    "Report fraud to the state contractor licensing board, insurance fraud bureau, or local law enforcement. Many states have hotlines for insurance fraud reports.",
    "?Storm chasers? asking for large upfront payments, doing low-quality work, then disappearing. Always advise homeowners to verify licenses and never pay in full upfront.",
    "Fraudulent claims increase overall insurance costs by 15-20%, leading to higher premiums for everyone. Ethical contractors pay the price for dishonest ones.",
    "No, but be careful. Some adjusters inflate claims illegally and try to involve contractors in fraud. Only work with reputable, licensed adjusters.",
    "1?? Keep detailed records, 2?? Only bill for actual work, 3?? Require written contracts, 4?? Never accept cash for ?off the books? work, 5?? Vet all subcontractors carefully.",
    "Sell your credibility. Show clients your licenses, certifications, insurance, and Fortified training. Cheap work isn?t always good work, and smart homeowners will pay for quality.",
    "Fast assessments can reduce recovery time by 20%, helping homeowners rebuild sooner and allowing contractors to secure work and get paid faster.",
    "Use PPE, conduct structural checks, and avoid electrical hazards. Always follow OSHA and FEMA safety protocols before entering any damaged buildings.",
    "Hard hats, gloves, safety boots, respirators, high-visibility vests, and eye protection are standard. In flood areas, waterproof gear and mold-rated respirators are essential.",
    "Structural collapse, electrical hazards, mold exposure, gas leaks, and unstable debris. Never enter a structure without verifying stability first.",
    "1?? Check for immediate dangers, 2?? Document visible damage with photos, 3?? Assess structural integrity, 4?? Identify environmental hazards, 5?? Communicate findings clearly.",
    "Cracks in foundations, sagging roofs, leaning walls, damaged load-bearing supports, and signs of severe stress on beams or trusses.",
    "Look for warped floors, water stains, mold growth, and soft drywall. Check behind walls if possible?hidden moisture can cause major structural damage.",
    "Take high-resolution photos, record videos, use a detailed checklist, and write clear notes on the cause and extent of damage.",
    "Provide a written report with images, estimated repair costs, and priority repairs. Clear, professional documentation helps speed up insurance approvals.",
    "Moisture meters, infrared cameras, drones for roof inspections, structural assessment tools, and a flashlight for dark or unstable areas.",
    "Check for foundation cracks, leaning walls, sagging roofs, gas leaks, or standing water. If in doubt, consult an engineer before entering.",
    "Hidden mold, weakened floors, unstable debris, gas leaks, and overloaded electrical panels. Always test air quality and wear a respirator in flood-damaged homes.",
    "Look for sagging areas, missing supports, damaged trusses, or detached flashing. If unsure, use a drone or binoculars instead of climbing up.",
    "Not unless electrical power is confirmed shut off. Standing water can be electrically charged and contaminated with sewage or chemicals.",
    "Look for downed power lines, exposed wires, damaged breaker panels, and wet electrical systems. Always test circuits before touching anything.",
    "Check for compromised structural elements, melted wiring, and air quality hazards. Avoid entering until fire officials declare it safe.",
    "No one should assess a damaged site alone. The buddy system ensures someone is available for emergencies and helps with documentation and hazard identification.",
    "Explain that a proper assessment prevents missed damage and costly mistakes. Rushing can lead to unsafe conditions and denied insurance claims.",
    "Wear a respirator, avoid disturbing affected areas, and recommend professional mold testing and remediation before repairs begin.",
    "1?? Secure structural hazards, 2?? Prevent water intrusion, 3?? Address electrical risks, 4?? Remove unstable debris, 5?? Begin drying and stabilization.",
    "Mark the property as hazardous, notify local authorities, and request a structural engineer?s evaluation before re-entry.",
    "Hold a safety briefing, assign roles, check equipment, and review emergency procedures before stepping onto a damaged site.",
    "Commercial buildings have more complex structural systems, fire suppression requirements, and larger electrical loads?hire engineers for large-scale damage assessments.",
    "Drones help inspect unstable roofs, high-rise structures, and hard-to-reach areas without putting your team in danger.",
    "Temporary repairs prevent further damage, reduce overall repair costs by up to 15%, and help homeowners stay in their homes safely while waiting for permanent fixes.",
    "Homeowners and insurers trust contractors who provide quick, effective temporary fixes, leading to long-term repair contracts and referrals.",
    "Roof tarping, boarding up windows and doors, securing loose structures, and addressing water intrusion are critical to preventing further damage.",
    "Use heavy-duty tarps, secure them with wooden strips, nails, or sandbags, and overlap edges to prevent leaks. Proper tarping can prevent water damage while waiting for full repairs.",
    "Cut plywood to size, secure with screws or bolts, and reinforce door frames if needed. This prevents further wind or water damage and protects against theft.",
    "Pump out standing water, install dehumidifiers, remove soaked materials, and use sandbags to prevent further flooding. Preventing mold is a top priority.",
    "Yes! Mitigation efforts can reduce repair costs by 15% or more, which insurers appreciate and often reimburse. It also speeds up claim approvals.",
    "Electrical hazards, structural instability, mold exposure, and falling debris. Always assess risks before starting work and follow OSHA guidelines.",
    "Shore up walls and ceilings, reinforce structural weaknesses, and seal foundation cracks to prevent worsening damage while waiting for major repairs.",
    "Cover broken windows and doors with fire-resistant materials, secure structures to prevent collapse, and install erosion control to prevent post-fire landslides.",
    "Use bracing, temporary walls, or jacks to reinforce weakened areas, but always consult a structural engineer for severe cases.",
    "Roof tarps, plywood, fasteners, a generator, water pumps, sandbags, a chainsaw, and PPE are essential for emergency mitigation work.",
    "Use portable generators with proper ventilation, check for electrical system damage before reconnecting, and avoid backfeeding power into the grid.",
    "Remove wet materials ASAP, use dehumidifiers, and apply antimicrobial treatments to prevent mold growth before permanent repairs start.",
    "Document everything, provide homeowners with detailed reports, and keep costs reasonable. Insurance companies often reimburse temporary mitigation work.",
    "Yes! Temporary repairs are separate billable services, and insurers typically cover them as part of loss mitigation efforts.",
    "Provide detailed documentation, use cost-effective materials, and follow best practices. Adjusters prefer working with contractors who understand the claims process.",
    "Use signed contracts, document all work with photos and descriptions, and follow safety regulations to protect yourself from claims of improper repairs.",
    "Heavy-duty tarps, plywood, fasteners, waterproof sealants, sandbags, and basic framing materials are essential for quick mitigation work.",
    "Prioritize structural safety, schedule efficiently, and have a rapid response plan to ensure work gets done quickly and effectively.",
    "Provide itemized invoices, include before-and-after photos, and clearly label work as ?emergency mitigation? to ensure insurance covers it properly.",
    "Use straw wattles, silt fences, mulch, and erosion blankets to stabilize soil and prevent landslides in fire-damaged areas.",
    "Explain that waiting can lead to secondary damage, increased repair costs, and potential claim denials. Quick action saves money and speeds up recovery.",
    "Build relationships with insurance adjusters, get certified in emergency mitigation, and provide free assessments to show expertise and reliability.",
    "Resilient buildings suffer 30% less damage in future disasters, lowering repair costs and increasing client satisfaction. Plus, insurers and homeowners prefer contractors who offer durability.",
    "Government agencies, insurance companies, and premium homeowners seek out contractors who build to higher resilience standards, making it easier to win contracts and charge premium prices.",
    "1?? Reinforced roof structures, 2?? Impact-resistant windows and doors, 3?? Elevated foundations, 4?? Wind-resistant siding, 5?? Hurricane straps and clips. These upgrades reduce storm damage by 50%.",
    "Show them the math! A \$10,000 resilience investment can save them \$50,000+ in future storm repairs. Plus, many insurers offer premium discounts for resilient homes.",
    "Reinforced concrete, impact-resistant glass, high-performance roofing, fiber cement siding, and fire-resistant insulation all increase durability and reduce long-term maintenance costs.",
    "If a home you build withstands the next disaster, your reputation skyrockets. If it fails due to poor construction, you could face lawsuits and warranty claims.",
    "Lower insurance premiums, higher resale values, fewer repair costs, and reduced downtime after disasters. Resilient homes retain value better than standard builds.",
    "1?? Elevate the foundation, 2?? Use waterproof materials, 3?? Install flood vents, 4?? Apply water-resistant coatings, 5?? Raise mechanical systems above flood levels.",
    "Get IBHS Fortified certification, FEMA disaster training, and advanced building code certifications to set yourself apart as an expert in disaster-resistant construction.",
    "Use reinforced concrete, seismic bracing, base isolators, and flexible utility connections to help buildings withstand earthquake shocks.",
    "1?? Fire-resistant roofing, 2?? Ember-resistant vents, 3?? Non-combustible siding, 4?? Defensible landscaping, 5?? Fire-rated windows and doors all reduce wildfire risk significantly.",
    "Smart sensors monitor structural health, fire risks, and air quality in real-time, alerting homeowners to potential issues before disaster strikes.",
    "Rebuilding to pre-disaster standards instead of upgrading for future resilience. If the home was destroyed once, it can be destroyed again unless improvements are made.",
    "Yes! Many states and insurance providers offer incentives for Fortified homes, energy-efficient upgrades, and disaster-resistant retrofits. Check FEMA and IBHS programs for funding opportunities.",
    "Market your expertise, get certified, and educate homeowners on long-term savings. Offering insurance-backed Fortified upgrades sets you apart from competitors.",
    "Use hurricane-rated shingles, install reinforced roof decking, add metal fasteners, and apply a secondary water barrier to prevent storm and wind damage.",
    "Modular components can be pre-engineered for high wind, fire, and seismic resistance, allowing for faster rebuild times and stronger, standardized structures.",
    "Upgrade roofing, reinforce walls, install impact-resistant windows, add floodproofing, and improve insulation to strengthen older homes against future disasters.",
    "A Fortified home goes beyond code, using stronger connections, impact-resistant materials, and water/flood-resistant techniques to cut future storm damage by half.",
    "If more homes withstand disasters, recovery is faster, insurance claims are lower, and rebuilding costs are reduced, leading to economic stability for homeowners and contractors.",
    "Solar panels, battery storage, and energy-efficient systems allow homes to function off-grid during power outages, increasing independence and reducing long-term costs.",
    "Many homeowners think it?s too expensive, but small, strategic upgrades (like hurricane straps or fire-resistant siding) add huge protection with minimal cost increases.",
    "Design for adaptability?use modular features, passive cooling/heating, storm-resistant structures, and durable materials to withstand rising risks from climate change.",
    "Showcase real-life case studies, get certified, partner with insurance providers, and educate homeowners on the financial benefits of resilient construction.",
    "Relief agencies provide funding, resources, and logistical support that can help you get paid faster, access more projects, and streamline recovery efforts.",
    "FEMA provides grants and funding for home repairs, and contractors who are registered with FEMA-approved programs have priority access to rebuilding projects.",
    "Reach out to your local emergency management office, attend disaster planning meetings, and register as a pre-approved contractor for emergency repairs.",
    "Red Cross provides emergency sheltering and coordinates with contractors to restore homes. Partnering with them can help you get contracts for rebuilding and mitigation work.",
    "National VOAD connects contractors with nonprofit rebuilding programs, giving you consistent post-disaster work while contributing to community recovery efforts.",
    "Register with SAM.gov and FEMA?s Disaster Recovery Assistance database. This ensures you?re eligible for government-funded repair and mitigation projects.",
    "Partner with FEMA and local emergency teams to provide professional damage assessments, helping speed up insurance claims and repair approvals.",
    "Lack of proper documentation, poor communication, and failing to understand agency protocols can delay projects and cause payment issues.",
    "Contractors who work with relief agencies are seen as trusted professionals, leading to more referrals, long-term contracts, and priority status in future disasters.",
    "FEMA disaster relief funds, HUD grants, SBA disaster loans, and nonprofit rebuilding programs all provide funding for contractor-led recovery projects.",
    "Follow their protocols, provide clear documentation, attend coordination meetings, and communicate regularly to build trust and ensure efficient collaboration.",
    "Use multiple channels like email, phone, and online portals, and attend daily briefings with agency representatives to stay informed and align on recovery priorities.",
    "Clarify roles and responsibilities upfront, use standardized documentation, and establish a primary point of contact for each agency to reduce miscommunication.",
    "Yes! FEMA and HUD offer funding for temporary housing while rebuilding occurs, which can help contractors keep projects moving without homeowner delays.",
    "Roof tarping, structural stabilization, debris removal, water damage mitigation, and full home reconstruction are commonly funded by relief agencies.",
    "Get disaster recovery certifications, specialize in resilient construction, and maintain a strong track record of compliance with agency requirements.",
    "Detailed repair estimates, before-and-after photos, work logs, and compliance reports are critical for fast payment approvals.",
    "Partner with organizations like Habitat for Humanity, Rebuilding Together, and state housing agencies to work on grant-funded recovery projects.",
    "Provide real-time damage assessments, track material and labor needs, and coordinate with other contractors to avoid duplication of efforts.",
    "You get priority access to post-disaster contracts, faster payment processing, and pre-approved status for government-backed recovery programs.",
    "Review FEMA?s construction standards, follow their funding documentation process, and attend their contractor training programs.",
    "Register as an SBA-approved contractor, submit detailed cost estimates, and follow their compliance guidelines for reconstruction projects.",
    "Yes, but coordination is key. Keep clear documentation and assign separate project managers to oversee agency-specific requirements.",
    "Maintain strong relationships, deliver quality work, document success stories, and leverage past relief agency projects to win future contracts.",
    "Get certified in FEMA guidelines, IBHS Fortified construction, and HUD compliance. Use this expertise in marketing materials, presentations, and social media to build credibility.",
    "Pre-register with FEMA, HUD, and SBA programs, network with government officials, and showcase experience in resilience-based construction.",
    "Emphasize compliance expertise, highlight resilience-focused projects, and provide transparent, professional documentation that insurance and relief agencies trust.",
    "Adjusters, insurance companies, and relief agencies prefer contractors who understand compliance. Build strong relationships with them to become their go-to referral.",
    "Showcase before-and-after projects, post educational content on disaster recovery, and highlight your certifications to attract insurance companies and government contracts.",
    "Educate homeowners on the long-term cost savings, insurance benefits, and reduced risk of damage when rebuilding resiliently. Use case studies and real-world success stories.",
    "FEMA disaster recovery certification, IBHS Fortified Builder status, HUD-approved contractor credentials, and SBA contractor registration boost your credibility.",
    "Demonstrate compliance expertise, provide detailed documentation, and maintain a strong reputation for transparent pricing and quality resilience-focused work.",
    "Include sections on disaster recovery expertise, case studies of resilient rebuilds, proof of compliance certifications, and an FAQ on why resilience matters.",
    "Attend disaster preparedness summits, register as a federal contractor, and provide free training sessions on resilience for local emergency management agencies.",
    "Highlight case studies, invest in third-party certifications, speak at industry events, and create educational content on how resilience saves money.",
    "Professional brochures, case studies, before-and-after photo galleries, and a strong digital presence will help showcase expertise and attract high-value clients.",
    "Create simple guides showing how Fortified construction, impact-resistant materials, and elevated foundations lead to lower premiums and fewer denied claims.",
    "Deliver exceptional work, document everything professionally, and build relationships with local real estate agents, adjusters, and community organizations.",
    "Tell real stories of homeowners whose resilient rebuilds survived the next storm, proving the value of investing in stronger construction.",
    "Get certified as a government contractor (SAM.gov), apply for HUD and FEMA contracts, and ensure all work meets federal compliance guidelines.",
    "Offer premium packages with hurricane-resistant windows, reinforced roofing, and energy-efficient upgrades to homeowners who want long-term protection.",
    "We don?t just rebuild homes?we future-proof them. Our resilience-focused construction cuts future storm damage by 30% and lowers insurance costs.",
    "Join National VOAD, IBHS Fortified Builder networks, local emergency planning committees, and disaster relief industry groups.",
    "Build relationships with insurance adjusters, document every project professionally, and offer maintenance and resilience upgrades post-rebuild.",
    "Develop scripts focusing on cost savings, insurance benefits, and long-term durability. Provide training on disaster recovery funding options.",
    "Showcase compliance expertise, streamline insurance paperwork, and offer free consultations for policyholders to discuss resilience-focused upgrades.",
    "Bundle resilience upgrades into premium packages, highlight long-term savings, and offer financing options to help homeowners invest in future-proof construction.",
    "Monitor HUD, FEMA, and SBA funding programs, attend public meetings, and register as a contractor for grant-funded resilience upgrades.",
    "Focus on long-term savings, insurance discounts, and reduced repair costs. Explain how Fortified homes withstand storms better and increase property value.",
    "Emphasize the financial benefits: lower insurance costs, fewer liability claims, and higher resale values. Offer case studies showing Fortified buildings? performance.",
    "Use real-world examples of Fortified homes that survived hurricanes, tornadoes, and wildfires while neighbors had to rebuild. Offer side-by-side cost comparisons.",
    "IBHS Fortified Builder Certification, FEMA disaster recovery training, and HUD resilience-building programs are key for securing high-value contracts.",
    "IBHS Fortified training programs, NAHB?s resilient building courses, and local building code seminars provide hands-on knowledge and credentials.",
    "Certified Fortified contractors get priority access to insurance-backed repairs, government resilience grants, and high-end residential and commercial projects.",
    "Up to 50% fewer repairs after disasters, lower insurance premiums, and increased home resale value make Fortified construction a high-return investment.",
    "Show them that the upfront cost is offset by long-term savings on insurance, energy bills, and future storm damage repairs. Offer financing options.",
    "Work with insurers offering Fortified home discounts. Provide free assessments and explain how resilience upgrades lower claims, benefiting both insurers and homeowners.",
    "Impact-resistant roofs, reinforced garage doors, hurricane-rated windows, and elevated foundations are affordable, high-impact upgrades that homeowners quickly understand.",
    "Get Fortified-certified, showcase past projects, partner with insurance agents, and educate homeowners through workshops, social media, and blog content.",
    "Many government contracts require resilience-focused construction. Having IBHS Fortified certification makes you eligible for FEMA, HUD, and SBA rebuilding projects.",
    "Developers and corporate clients prefer resilient buildings to minimize future repair costs and disruptions. Highlight how Fortified structures reduce business downtime.",
    "Attend insurance industry events, resilience summits, local emergency planning meetings, and FEMA rebuilding workshops to connect with decision-makers.",
    "Banks and mortgage lenders favor Fortified-certified builders because resilient homes are lower risk. This can help homeowners qualify for better loans.",
    "Multi-family housing, high-end custom homes, and government-backed resilience programs offer the highest margins due to insurance incentives and demand for durability.",
    "A Fortified build exceeds code requirements, using stronger roofing, wind-resistant materials, and reinforced structures to reduce disaster damage by up to 50%.",
    "Create tiered packages: Basic (impact-resistant roofing), Mid-Level (roofing + windows + doors), and Premium (full Fortified certification with insurance savings).",
    "Failing to educate buyers, not explaining cost-benefit analysis, skipping certification, and not promoting insurance discounts as a financial incentive.",
    "Get familiar with policy coverage details, document everything professionally, and communicate effectively with adjusters. Becoming a trusted partner makes you first in line for referrals.",
    "Build relationships with adjusters, get certified in insurance documentation, and provide fast, detailed estimates that align with industry standards.",
    "Use Xactimate or Symbility (industry-standard estimating software), provide itemized costs, and document damages with clear photos and reports.",
    "Not understanding policy limitations, failing to provide detailed documentation, submitting vague estimates, and arguing instead of negotiating professionally.",
    "Complete insurance-related training, maintain a strong track record of compliance, and develop direct relationships with adjusters and claim managers.",
    "Adjusters prefer working with contractors who follow proper claims procedures, use correct documentation, and minimize disputes. Prove your expertise in resilience-focused repairs.",
    "Show adjusters detailed repair documentation, include third-party inspections if needed, and highlight code upgrade requirements to justify additional costs.",
    "Appeal with stronger documentation, show comparable repair estimates, and request a second adjuster review if necessary. The key is professional persistence.",
    "Provide clear damage reports, include before-and-after documentation, submit a properly formatted estimate, and be proactive in communication.",
    "Use Xactimate pricing, provide third-party damage assessments, reference local material costs, and explain why additional repairs are necessary.",
    "Submit all required documents upfront, follow up regularly, and ensure estimates match the insurance company?s approved format.",
    "Be responsive, provide fast and professional estimates, follow up on claims, and avoid inflating repair costs?adjusters remember who makes their job easier.",
    "Take high-resolution photos, provide videos, include detailed repair estimates, and reference building codes that justify repairs.",
    "Develop a reputation for fair pricing, detailed documentation, and smooth claims processing. Offer free claim reviews and consultations to homeowners.",
    "Help them understand their policy limits, deductible amounts, and what?s covered under code upgrade provisions to prevent disputes later.",
    "Mediate professionally?explain realistic repair costs, provide independent estimates, and guide homeowners through the appeal process if needed.",
    "Remain professional, back up your estimate with industry standards, show code upgrade requirements, and request a supervisor review if necessary.",
    "Teach them to document everything thoroughly, use insurance estimating software, and communicate clearly with adjusters without being confrontational.",
    "Offer free claim assistance, market yourself as an insurance-friendly contractor, and build relationships with real estate agents and adjusters for consistent referrals.",
    "Emphasize your transparency, certifications, and compliance with insurance guidelines. Use testimonials and case studies to build credibility with homeowners and insurers.",
    "Showcase your licenses, bonding, and insurance, follow industry-standard pricing (Xactimate), and document every repair with photos and reports.",
    "Avoid inflating repair costs, never bill for unperformed work, and always provide detailed documentation that aligns with the insurance adjuster?s scope.",
    "Politely refuse, educate them on the risks of insurance fraud, and remind them that insurers may investigate false claims. Protecting your reputation is key.",
    "Build a track record of submitting clean, well-documented claims, resolving disputes professionally, and helping adjusters process claims efficiently.",
    "Ensure all estimates are accurate, document damage properly, avoid taking over the claim negotiation process, and maintain open communication with all parties.",
    "Use contracts that clearly outline scope, payment terms, and disclaimers that prevent disputes. Require written approvals for any claim-related repairs.",
    "Requests to inflate damage, backdate contracts, use cheaper materials than billed, or pressure adjusters into approving higher estimates without justification.",
    "Use Xactimate pricing, reference local material costs, and justify upgrades with building code requirements. Proper documentation protects both you and the homeowner.",
    "Explain their coverage limits, deductible, and why proper documentation is key. Offer free claim reviews to help them understand their policy without misleading them.",
    "Politely provide detailed justification for your scope, reference code requirements, and request a second review if necessary. Always keep the discussion professional.",
    "Require deposits, use legally binding contracts, and ensure all work is approved in writing before proceeding. Keep copies of all communications.",
    "Maintain an ethical, professional reputation, process claims quickly and efficiently, and never inflate costs. Insurers prefer contractors who make their job easier.",
    "Explain gaps in coverage to the homeowner, offer financing or phased work, and help them communicate with their insurer to explore supplemental claims.",
    "You could face non-payment, legal disputes, or even fraud accusations if your estimates and repair scope don?t match what was approved by the insurer.",
    "Follow industry best practices, meet local building codes, and keep up-to-date on insurer policies and documentation requirements.",
    "Market your clean track record to homeowners and insurance companies. Use case studies that highlight how you?ve helped clients without claim disputes.",
    "Act as a neutral expert. Provide clear documentation, explain necessary repairs professionally, and encourage open communication between both parties.",
    "Use estimating software like Xactimate, cloud-based documentation tools, and digital contracts to keep everything organized and easily accessible for insurers.",
    "Develop structured training that covers structural integrity checks, moisture detection, roofing assessments, and insurance-compliant documentation. FEMA and IBHS offer specialized courses.",
    "Structural damage, water intrusion, HVAC and electrical damage, roofing impact, foundation issues, and all visible wear caused by the disaster. Every detail counts for insurance claims.",
    "Use insurer-approved estimate formats, document damage in stages (before, during, after repairs), and reference local building codes to justify necessary repairs.",
    "Use moisture meters, thermal imaging, and probe tests to check for water intrusion, structural weakening, and electrical issues that aren?t visible to the naked eye.",
    "Use standardized checklists, train your team in quick and thorough evaluations, and implement digital reporting tools like Xactimate or Symbility for faster claims processing.",
    "Skipping detailed documentation, underestimating repair costs, not taking enough photos, failing to note pre-existing damage, and not referencing insurance coverage limits.",
    "Teach them to provide detailed, unbiased reports, be proactive in communication, and back up every repair recommendation with clear documentation and justifications.",
    "Moisture meters, drones for aerial roof inspections, thermal cameras, digital notepads, high-powered flashlights, and laser measuring tools for precise damage calculations.",
    "Develop a standardized checklist for every job, require photographic evidence of each damage type, and have supervisors review assessments before submission.",
    "Use claim management software like Xactimate, train your team on industry-standard estimate formats, and ensure all reports are completed in compliance with insurance company requirements.",
    "Submit clean, detailed reports upfront with proper documentation, reference industry pricing (Xactimate), and follow up regularly with adjusters to push claims forward.",
    "Remain professional, provide additional supporting documentation, reference building code requirements, and request a re-evaluation if necessary.",
    "Take clear before-and-after photos, provide video documentation, write detailed descriptions, and include estimated repair costs broken down by category.",
    "Train your team to align assessments with insurance policy language, use proper terminology, and avoid vague descriptions that could lead to claim rejections.",
    "Missing shingles, lifted or loose materials, water intrusion, granule loss, impact marks from hail, and weakened structural components.",
    "Teach them to look for foundation cracks, warped flooring, soaked insulation, mold growth, and water stains inside walls using moisture detection tools.",
    "Insurance companies will often cover required code upgrades. Make sure your assessments highlight code compliance needs, especially for electrical, structural, and roofing work.",
    "Include structural stability checks, electrical and plumbing inspections, roofing and foundation assessments, moisture detection, and comprehensive photographic documentation.",
    "Use mobile documentation apps, implement real-time reporting systems, and train multiple team members in insurance-approved damage assessment techniques.",
    "Temporary repairs should be billed at cost-plus pricing (materials + labor + markup), while permanent repairs should use standard insurance-approved pricing (Xactimate/Symbility).",
    "Charge per-hour or per-square-foot rates for emergency work, with clear tiers for board-ups, water extraction, debris removal, and stabilization.",
    "Emergency repairs require immediate response, specialized equipment, and after-hours labor. Use documentation showing urgency and material cost fluctuations.",
    "Failing to account for emergency labor costs, underestimating material price fluctuations, and not including follow-up work in estimates.",
    "Use industry-standard estimating tools like Xactimate and provide clear itemized breakdowns that adjusters can easily verify.",
    "Include tasks such as structural stabilization, water extraction, mold prevention, debris removal, temporary roofing, and securing openings.",
    "Charge based on roof square footage, material costs, and hazard level. Include separate pricing for high-risk conditions like steep pitches or major storm damage.",
    "Scope of work, pricing structure, estimated time for completion, liability disclaimers, and payment terms (especially for insurance-paid work).",
    "Provide before-and-after photos, detailed invoices, proof of urgency (weather reports, safety risks), and reference Xactimate pricing where applicable.",
    "Submit a well-documented claim package including photos, detailed scope of work, labor hours, and materials used, and follow up persistently.",
    "Show cost comparisons, highlight the urgency of the work, reference insurance industry standards, and escalate if needed to claims supervisors.",
    "Have homeowners sign an agreement acknowledging they are responsible for payment if insurance delays or denies coverage.",
    "Be proactive?provide real-time updates, use detailed photo documentation, and align your pricing with insurer expectations for faster approvals.",
    "Provide documentation of costs, include third-party verification (if possible), and request a reassessment or supervisor review.",
    "Offer free assessments for permanent repairs, bundle mitigation services with follow-up rebuilds, and build trust with insurers and homeowners.",
    "Submit invoices immediately, include all necessary documentation, and use direct billing options with insurers when possible.",
    "Use mobile apps for on-site data collection, cloud-based storage for real-time updates, and digital invoicing tools for instant submissions.",
    "Not getting written approval from insurers before work starts, failing to document damage properly, and misaligning pricing with insurance standards.",
    "Explain that temporary repairs prevent further damage while permanent repairs restore the structure fully. Provide a breakdown of insurance coverage for both.",
    "Use tiered pricing models?basic resilience (roofing/windproofing), mid-level (elevated foundations, impact windows), and premium (full Fortified-certified structures).",
    "Create packages that combine high-demand features like hurricane-resistant roofing, reinforced garage doors, and flood-resistant foundations into a single pricing structure.",
    "Showcase insurance savings, lower long-term repair costs, and real-world case studies of homes that survived disasters while others had to rebuild.",
    "Impact-resistant roofing and hurricane-rated windows are high-margin items that also qualify for insurance discounts, making them an easy sell to homeowners.",
    "Use FEMA and IBHS Fortified design resources, work with resilience-focused architects, or join programs like HUD?s disaster recovery housing initiatives.",
    "Start with IBHS Fortified construction standards and FEMA floodproofing recommendations, then source wind- and fire-resistant materials from certified suppliers.",
    "Register as a vendor with FEMA, HUD, and state housing agencies, and apply for government-funded rebuilding programs that prioritize resilient construction.",
    "Get IBHS Fortified certification, attend resilience-focused industry events, and create marketing materials that showcase your expertise in disaster-proof building.",
    "Factor in elevation height, soil conditions, and waterproofing materials, and ensure compliance with FEMA?s base flood elevation (BFE) requirements.",
    "Many states offer resilience grants, low-interest loans, and insurance premium discounts for Fortified upgrades?help homeowners leverage these options.",
    "Highlight required code upgrades, use before-and-after documentation, and provide justification that aligns with insurer-approved pricing models.",
    "Use a standard markup for labor and materials but offer tiered upgrade options so clients can choose between basic code compliance and full resilience packages.",
    "Focus on risk reduction, lower insurance premiums, and the long-term financial benefits of constructing disaster-resistant buildings.",
    "HUD?s Community Development Block Grants for Disaster Recovery (CDBG-DR) and FEMA?s Hazard Mitigation Grant Program (HMGP) fund resilience-focused housing projects.",
    "Offer Fortified certification, document past successes, provide energy-efficient resilience upgrades, and showcase partnerships with insurers and government agencies.",
    "Hurricane-rated roofing, impact-resistant windows, reinforced concrete, flood-resistant insulation, and fireproof siding are essential for long-term resilience.",
    "Compare upfront costs vs. long-term savings from lower insurance premiums, reduced repair costs, and higher property values in disaster-prone areas.",
    "Attend municipal planning meetings, partner with urban resilience initiatives, and offer consulting on updating building codes to meet modern disaster mitigation standards.",
    "Showcase compliance expertise, highlight past projects, and register for pre-approved contractor lists with FEMA, HUD, and state-level emergency agencies.",
    "Start by creating an account on SAM.gov, complete the FEMA Industry Liaison Program registration, and apply for the Disaster Response Registry.",
    "Contact your state or regional VOAD chapter, demonstrate experience in disaster recovery, and attend training sessions to align with their response protocols.",
    "A DUNS number, SAM.gov registration, business licensing, proof of insurance, past performance references, and a capability statement.",
    "Check the Federal Business Opportunities (FBO) website, SAM.gov contract listings, and FEMA?s procurement notices.",
    "Register with state procurement offices, attend emergency management briefings, and ensure compliance with state resilience and rebuilding guidelines.",
    "General liability, workers? comp, commercial auto, and performance bonding are typically required for disaster relief contracts.",
    "Follow FEMA?s cost estimation standards, include detailed line-item pricing, and provide justification for materials, labor, and equipment costs.",
    "Submit case studies, client references, before-and-after project documentation, and certifications in resilience-focused construction.",
    "Volunteer for local response efforts, establish relationships with regional coordinators, and align your services with their rebuilding priorities.",
    "Adhere to FEMA Public Assistance Program guidelines, HUD Community Development Block Grant-Disaster Recovery (CDBG-DR) rules, and prevailing wage laws (Davis-Bacon Act).",
    "Ensure accurate cost estimates, provide all required documentation, follow contract terms precisely, and comply with FEMA?s procurement policies.",
    "Network with prime contractors already awarded FEMA contracts, register as a subcontractor on SAM.gov, and attend disaster response bid meetings.",
    "Submit invoices promptly, follow proper documentation protocols, and maintain clear communication with contract officers and funding agencies.",
    "Apply through HUD?s procurement portal, demonstrate financial stability, and provide evidence of experience with federally funded housing projects.",
    "Register for emergency contractor databases at the local, state, and federal levels, and maintain all necessary certifications and bonding.",
    "Emergency debris removal, temporary housing setup, infrastructure repairs, and community resilience-building projects.",
    "Submit project documentation through the FEMA Grants Portal, follow cost-tracking best practices, and work closely with local government partners managing disbursements.",
    "Align your company with HUD and FEMA mitigation programs, participate in VOAD partnerships, and build expertise in climate-adaptive construction methods.",
    "Maintain organized records of all contracts, payrolls, material purchases, and project approvals to pass audits and funding reviews.",
  ];

  List<ConvModel> conversationModel = [];
  final GlobalKey _latestAssistantBubbleKey = GlobalKey();
  final _controller = TextEditingController();
  var icon = Icons.mic_rounded;
  final _node = FocusNode();
  String? _firstName;
  String? _zipCode;
  final BriefingService _briefingService = BriefingService();
  List<String>? _activeAlerts;
  bool _loadingAlerts = false;
  bool _greetingSeeded = false;

  bool get _hasActiveAlert => _activeAlerts?.isNotEmpty ?? false;
  late final AnimationController _pulseController;

  List<_SuggestionChip> _suggestionChipsFor(AppLocalizations t) => [
        _SuggestionChip(
          label: t.topicPrepareTitle,
          subtitle: t.topicPrepareSubtitle,
          prompt: t.topicPreparePrompt,
          promptType: "topicPrepare",
        ),
        _SuggestionChip(
          label: t.topicRespondTitle,
          subtitle: t.topicRespondSubtitle,
          prompt: t.topicRespondPrompt,
          promptType: "topicRespond",
        ),
        _SuggestionChip(
          label: t.topicRecoverTitle,
          subtitle: t.topicRecoverSubtitle,
          prompt: t.topicRecoverPrompt,
          promptType: "topicRecover",
        ),
      ];

  String? _topicPromptFor(String? type, AppLocalizations t) {
    switch (type) {
      case "topicPrepare":
        return t.topicPreparePrompt;
      case "topicRespond":
        return t.topicRespondPrompt;
      case "topicRecover":
        return t.topicRecoverPrompt;
      default:
        return null;
    }
  }

  bool get _showSuggestionChips =>
      conversationModel.length == 1 &&
      !(conversationModel.first.isSender ?? false);

  static const _whatsNewPrefsKey = '@buildsos/last_seen_version';

  @override
  void initState() {
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
    callback();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _maybeShowWhatsNew();
    });
  }

  Future<void> _maybeShowWhatsNew() async {
    final release = latestReleaseNote;
    if (release == null) return;
    final prefs = await SharedPreferences.getInstance();
    final lastSeen = prefs.getString(_whatsNewPrefsKey);
    if (lastSeen == kCurrentVersion) return;
    if (!mounted) return;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => WhatsNewModal(
        release: release,
        onClose: () => Navigator.of(ctx).pop(),
      ),
    );
    await prefs.setString(_whatsNewPrefsKey, kCurrentVersion);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _loadUserProfile() async {
    try {
      final email = FirebaseAuth.instance.currentUser?.email;
      if (email == null) return;
      final snap = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();
      if (snap.docs.isEmpty) return;
      final data = snap.docs.first.data();
      _firstName = data['firstName']?.toString();
      _zipCode = data['zipCode']?.toString();
    } catch (_) {
      // Silent fail — fall back to generic greeting.
    }
  }

  String _buildGreeting(AppLocalizations t) {
    final name = (_firstName?.trim().isNotEmpty ?? false) ? _firstName!.trim() : null;
    final hour = DateTime.now().hour;
    if (name != null) {
      if (hour < 12) return t.greetingMorningNamed(name);
      if (hour < 17) return t.greetingAfternoonNamed(name);
      return t.greetingEveningNamed(name);
    }
    if (hour < 12) return t.greetingMorningAnon;
    if (hour < 17) return t.greetingAfternoonAnon;
    return t.greetingEveningAnon;
  }

  String _buildBriefing(AppLocalizations t) {
    final locale = Localizations.localeOf(context).languageCode;
    final dateStr = DateFormat('EEEE, MMMM d', locale).format(DateTime.now());
    final zip = (_zipCode?.trim().isNotEmpty ?? false) ? _zipCode!.trim() : null;
    final area = zip != null ? t.briefingAreaZip(zip) : t.briefingAreaGeneric;

    if (_loadingAlerts) return t.briefingLoading(dateStr, area);

    final alerts = _activeAlerts;
    if (alerts == null) return t.briefingUnavailable(dateStr);
    if (alerts.isEmpty) return t.briefingNoAlerts(dateStr, area);

    final unique = alerts.toSet().toList();
    final summary = unique.length == 1
        ? unique.first
        : '${unique.length} (${unique.take(2).join(", ")}${unique.length > 2 ? "…" : ""})';
    return t.briefingAlertsSummary(dateStr, summary, area);
  }

  Future<void> _loadBriefing() async {
    final zip = _zipCode?.trim();
    if (zip == null || zip.isEmpty) return;
    if (mounted) setState(() => _loadingAlerts = true);
    final alerts = await _briefingService.fetchActiveAlerts(zip);
    if (!mounted) return;
    setState(() {
      _activeAlerts = alerts;
      _loadingAlerts = false;
    });
  }

  callback() async {
    await _loadUserProfile();
    if (!mounted) return;
    setState(() {});

    _loadBriefing();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final t = AppLocalizations.of(context)!;
    if (!_greetingSeeded) {
      _greetingSeeded = true;
      conversationModel.clear();
      conversationModel.add(ConvModel(
        isSender: false,
        message: _buildGreeting(t),
        messageType: "greeting",
      ));
    } else if (conversationModel.isNotEmpty &&
        conversationModel.first.messageType == "greeting") {
      conversationModel[0] = ConvModel(
        isSender: false,
        message: _buildGreeting(t),
        messageType: "greeting",
      );
    }

    for (var i = 0; i < conversationModel.length; i++) {
      final m = conversationModel[i];
      if (m.messageType == "error") {
        conversationModel[i] = ConvModel(
          isSender: false,
          message: t.chatErrorGeneric,
          messageType: "error",
          timestamp: m.timestamp,
        );
        continue;
      }
      final topicPrompt = _topicPromptFor(m.messageType, t);
      if (topicPrompt != null) {
        conversationModel[i] = ConvModel(
          isSender: m.isSender,
          message: topicPrompt,
          messageType: m.messageType,
          timestamp: m.timestamp,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xff1B2E4B),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            showMenu(
                color: Colors.white,
                context: context,
                position: const RelativeRect.fromLTRB(0, 88, 0, 0),
                items: [
                  PopupMenuItem(
                    padding: EdgeInsets.zero,
                    child: ListTile(
                      // tileColor: Colors.white,
                      onTap: () async {
                        // _showLogoutWarningDialog(context);
                        Get.to(() => const TermsConditions());
                      },
                      leading: const Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Icon(
                          Icons.privacy_tip,
                          color: Colors.black,
                        ),
                      ),
                      title: Text(
                        AppLocalizations.of(context)!.menuTermsConditions,
                      ),
                    ),
                  ),
                  // PopupMenuItem(
                  //   padding: EdgeInsets.zero,
                  //   child: ListTile(
                  //     // tileColor: Colors.white,
                  //     onTap: () async {
                  //       _showDeleteWarningDialog(context);
                  //       // Get.offAll(() => const LoginScreen());
                  //     },
                  //     leading: const Padding(
                  //       padding: EdgeInsets.only(left: 10),
                  //       child: Icon(
                  //         Icons.delete_forever_sharp,
                  //         color: Colors.black,
                  //       ),
                  //     ),
                  //     title: const Text(
                  //       "Delete Account",
                  //     ),
                  //   ),
                  // ),
                  PopupMenuItem(
                    padding: EdgeInsets.zero,
                    child: ListTile(
                      // tileColor: Colors.white,
                      onTap: () async {
                        Get.to(() => const Reports());
                        // Get.offAll(() => const LoginScreen());
                      },
                      leading: const Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Icon(
                          Icons.report,
                          color: Colors.black,
                        ),
                      ),
                      title: const Text(
                        "Reports Submitted",
                      ),
                    ),
                  ),
                ]);
            //
          },
        ),
        centerTitle: true,
        title: Text(
          "Disaster AIDvisor",
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 22,
              letterSpacing: 0.3,
            ),
          ),
        ),
        actions: [
          if (!_showSuggestionChips)
            Builder(builder: (ctx) {
              final t = AppLocalizations.of(ctx)!;
              return IconButton(
                tooltip: t.homeTooltip,
                icon: const Icon(Icons.home_outlined, color: Colors.white),
                onPressed: () {
                  conversationModel.clear();
                  conversationModel.add(ConvModel(
                    isSender: false,
                    message: _buildGreeting(t),
                    messageType: "txt",
                  ));
                  setState(() {});
                },
              );
            }),
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () {
              showMenu(
                  color: Colors.white,
                  context: context,
                  position: RelativeRect.fromLTRB(
                      MediaQuery.of(context).size.width, 88, 0, 0),
                  items: [
                    PopupMenuItem(
                      padding: EdgeInsets.zero,
                      child: ListTile(
                        // tileColor: Colors.white,
                        onTap: () async {
                          _showLogoutWarningDialog(context);
                          // Get.offAll(() => const LoginScreen());
                        },
                        leading: const Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Icon(
                            Icons.power_settings_new_rounded,
                            color: Colors.black,
                          ),
                        ),
                        title: Text(
                          AppLocalizations.of(context)!.menuLogout,
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      padding: EdgeInsets.zero,
                      child: ListTile(
                        // tileColor: Colors.white,
                        onTap: () async {
                          _showDeleteWarningDialog(context);
                          // Get.offAll(() => const LoginScreen());
                        },
                        leading: const Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Icon(
                            Icons.delete_forever_sharp,
                            color: Colors.black,
                          ),
                        ),
                        title: Text(
                          AppLocalizations.of(context)!.menuDeleteAccount,
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      padding: EdgeInsets.zero,
                      child: ListTile(
                        onTap: () {
                          Navigator.pop(context);
                          Future.delayed(const Duration(milliseconds: 250),
                              () => _shareConversation());
                        },
                        leading: const Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Icon(
                            Icons.ios_share,
                            color: Colors.black,
                          ),
                        ),
                        title: Text(
                          AppLocalizations.of(context)!.menuShareConversation,
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      padding: EdgeInsets.zero,
                      child: ListTile(
                        onTap: () async {
                          Navigator.pop(context);
                          _showClearChatWarningDialog(context);
                        },
                        leading: const Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Icon(
                            Icons.refresh,
                            color: Colors.black,
                          ),
                        ),
                        title: Text(
                          AppLocalizations.of(context)!.menuClearChat,
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      padding: EdgeInsets.zero,
                      child: ListTile(
                        // tileColor: Colors.white,
                        onTap: () async {
                          reportIssueDialogue(context);
                          // Get.offAll(() => const LoginScreen());
                        },
                        leading: const Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Icon(
                            Icons.report,
                            color: Colors.black,
                          ),
                        ),
                        title: Text(
                          AppLocalizations.of(context)!.menuReportIssue,
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      padding: EdgeInsets.zero,
                      child: ListTile(
                        onTap: () async {
                          Navigator.pop(context);
                          await _showLanguagePicker(context);
                        },
                        leading: const Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Icon(
                            Icons.language,
                            color: Colors.black,
                          ),
                        ),
                        title: Text(
                          AppLocalizations.of(context)!.menuLanguage,
                        ),
                      ),
                    ),
                  ]);
            },
          ),
          // IconButton(
          //   onPressed: () {
          //     _showLogoutWarningDialog(context);
          //   },
          //   icon: Icon(
          //     Icons.logout,
          //     color: MyColors.whiteColor,
          //   ),
          // ),
        ],
      ),
      body: Column(
        children: [
          buildChat(),
          Container(
            padding: EdgeInsets.fromLTRB(
                20,
                MediaQuery.of(context).padding.bottom + 10,
                20,
                MediaQuery.of(context).padding.bottom + 10),
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    ChatBox(
                      onChanged: (v) {
                        setState(() {});
                      },
                      focusNode: _node,
                      controller: _controller,
                    ),
                    const SizedBox(width: 5.0),
                    CustomRoundButton(
                      onTap: () async {
                        if (_controller.text.isNotEmpty) {
                          final txt = _controller.text;
                          _controller.clear();
                          await _submitUserMessage(txt);
                        }
                      },
                      icon: Icons.send_rounded,
                      iconSize: 20.0,
                      padding: 8.0,
                    )
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  AppLocalizations.of(context)!.inputDisclaimer,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      color: Color(0xff888888),
                      fontSize: 12,
                      height: 1.35,
                    ),
                  ),
                ),
                const CopyrightFooter(
                    padding: EdgeInsets.only(top: 4)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _scrollLatestAssistantBubbleIntoView() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = _latestAssistantBubbleKey.currentContext;
      if (ctx == null) return;
      Scrollable.ensureVisible(
        ctx,
        // ListView is `reverse: true`, so its "leading" edge is the
        // bottom of the viewport. To pin the bubble's TOP to the
        // viewport's top, align to the trailing edge — alignment: 1.0.
        alignment: 1.0,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOut,
      );
    });
  }

  Widget _fadeIntoInputBar({required Widget child}) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black, Colors.black, Colors.transparent],
          stops: [0.0, 0.94, 1.0],
        ).createShader(bounds);
      },
      blendMode: BlendMode.dstIn,
      child: child,
    );
  }

  buildChat() {
    final t = AppLocalizations.of(context)!;
    if (_showSuggestionChips) {
      return Flexible(
        child: _fadeIntoInputBar(
          child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 4),
              Center(
                child: Image.asset(
                  "assets/images/newimage.jpeg",
                  height: 56,
                ),
              ),
              const SizedBox(height: 4),
              Center(
                child: Text(
                  t.tagline,
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      color: Color(0xff1B2E4B),
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xffFBEDEC),
                    borderRadius: BorderRadius.circular(4),
                    border: const Border(
                      left: BorderSide(color: Color(0xffC62828), width: 3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.briefingLabel,
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            color: Color(0xff888888),
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _buildBriefing(t),
                        style: const TextStyle(
                          color: Color(0xff1B2E4B),
                          fontSize: 13,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 8),
              RecieveChatBubble(
                message: conversationModel.first.message ?? '',
                messagetype: 'txt',
                isSender: false,
              ),
              const SizedBox(height: 8),
              _buildSuggestionChipsRow(),
              const SizedBox(height: 16),
            ],
          ),
          ),
        ),
      );
    }

    final chats = conversationModel.reversed.toList();
    return Expanded(
        child: _fadeIntoInputBar(
          child: ListView.builder(
            itemCount: chats.length,
            reverse: true,
            shrinkWrap: true,
            itemBuilder: (itemBuilder, index) {
              final user = chats[index];
              final isMedia = user.messageType == "image" ||
                  user.messageType == "media";
              final isText = !isMedia;
              if (user.isSender) {
                return SendBubble(
                    message: isText
                        ? (user.message ?? '')
                        : "Media Attached ",
                    messagetype: user.messageType ?? '',
                    isSender: true);
              }
              final isLatestAssistantBubble =
                  index == 0 && user.message != "loading";
              return KeyedSubtree(
                key: isLatestAssistantBubble
                    ? _latestAssistantBubbleKey
                    : null,
                child: GestureDetector(
                  onLongPress: () async {
                    await Clipboard.setData(
                        ClipboardData(text: user.message ?? ''));
                    Fluttertoast.showToast(msg: t.copiedToClipboard);
                  },
                  child: RecieveChatBubble(
                      message: isText
                          ? (user.message ?? '')
                          : "Media Attached",
                      messagetype: user.messageType ?? '',
                      isSender: false),
                ),
              );
            })));
  }

  Future<void> _submitUserMessage(String txt, {String messageType = "txt"}) async {
    final trimmed = txt.trim();
    if (trimmed.isEmpty) return;

    // Capture the locale at submit time. The 2-second canned-KB delay
    // below means sendMessage runs *after* the user could have toggled
    // the language picker; reading the locale there would mismatch the
    // language the user actually saw when they tapped send.
    final langCode = Localizations.localeOf(context).languageCode;

    final date = DateTime.now().millisecondsSinceEpoch.toString();
    final emailKey =
        FirebaseAuth.instance.currentUser?.email?.replaceAll('.', '') ?? '';

    chatref.child(emailKey).child(date).set({
      "message": trimmed,
      "isSender": true,
      "messagetype": messageType,
      "timestamp": date,
    });

    conversationModel.add(ConvModel(
        isSender: true,
        message: trimmed,
        messageType: messageType,
        timestamp: DateTime.now().toString()));
    conversationModel.add(ConvModel(
        isSender: false,
        message: 'loading',
        messageType: "txt",
        timestamp: DateTime.now().toString()));
    setState(() {});

    Future.delayed(const Duration(seconds: 2)).then((_) {
      final idx = userInput.indexWhere((test) => test
          .toLowerCase()
          .replaceAll("'", '')
          .replaceAll("?", '')
          .contains(trimmed
              .toLowerCase()
              .replaceAll("'", '')
              .replaceAll("?", '')));
      if (idx != -1) {
        conversationModel.removeWhere((m) => m.message == "loading");
        conversationModel.add(ConvModel(
            isSender: false,
            message: responseInput[idx],
            messageType: "txt",
            timestamp: DateTime.now().toString()));
        setState(() {});
        _scrollLatestAssistantBubbleIntoView();
      } else {
        sendMessage(txt: trimmed, langCode: langCode);
      }
    });
  }

  Widget _buildSuggestionChipsRow() {
    final t = AppLocalizations.of(context)!;
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _suggestionChipsFor(t).map((c) {
          final recommended =
              _hasActiveAlert && c.label == t.topicRespondTitle;
          final effectivePrompt = recommended
              ? t.topicRespondPromptForAlert(_activeAlerts!.first)
              : c.prompt;
          const recommendedBorder = Color(0xff4A90D9);
          final borderColor =
              recommended ? recommendedBorder : const Color(0xffE8960C);
          final cardChild = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (recommended) ...[
                Text(
                  'RECOMMENDED',
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      fontSize: 10,
                      color: recommendedBorder,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
              ],
              Text(
                c.label,
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    fontSize: 16,
                    color: Color(0xff1B2E4B),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                c.subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xff888888),
                  letterSpacing: 0.2,
                ),
              ),
            ],
          );
          Widget buildCard(Color border) => Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    horizontal: 18, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  border:
                      Border.all(color: border, width: recommended ? 2.5 : 1),
                ),
                child: cardChild,
              );
          final card = (recommended && !reduceMotion)
              ? AnimatedBuilder(
                  animation: _pulseController,
                  builder: (_, __) {
                    final curved =
                        Curves.easeInOut.transform(_pulseController.value);
                    final alpha = 115 + (140 * (1 - curved)).round();
                    return buildCard(recommendedBorder.withAlpha(alpha));
                  },
                )
              : buildCard(borderColor);
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: InkWell(
              borderRadius: BorderRadius.circular(6),
              onTap: () =>
                  _submitUserMessage(effectivePrompt, messageType: c.promptType),
              child: card,
            ),
          );
        }).toList(),
      ),
    );
  }

  sendMessage({txt, required String langCode}) async {
    String? date;
    List<ModelforMyBot> allmessages = [];
    // {'role': 'system', 'content': 'You are a helpful assistant.'},
    //       {'role': 'user', 'content': prompt},
    for (var v in conversationModel) {
      if (v.message == "loading") continue;
      allmessages.add(
        ModelforMyBot(
          role: v.isSender ? "user" : "assistant",
          content: v.message,
        ),
      );
    }
    try {
      final aiResponse = await _chatService
          .getChatResponse(allmessages, languageCode: langCode);
      date = DateTime.now().millisecondsSinceEpoch.toString();
      _controller.clear();

      chatref
          .child(
              FirebaseAuth.instance.currentUser?.email?.replaceAll('.', '') ??
                  '')
          .child(date)
          .set({
        "message": aiResponse,
        "isSender": false,
        "messagetype": "txt",
        "timestamp": date,
      });
      // Future.delayed(const Duration(seconds: 2)).then((v) {
      conversationModel.removeWhere((test) => test.message == "loading");
      conversationModel.add(ConvModel(
          isSender: false,
          message: aiResponse,
          messageType: "txt",
          timestamp: DateTime.now().toString()));
      setState(() {});
      _scrollLatestAssistantBubbleIntoView();
    } catch (e) {
      final errorMsg = AppLocalizations.of(context)!.chatErrorGeneric;
      date = DateTime.now().millisecondsSinceEpoch.toString();
      conversationModel.removeWhere((test) => test.message == "loading");
      chatref
          .child(
              FirebaseAuth.instance.currentUser?.email?.replaceAll('.', '') ??
                  '')
          .child(date)
          .set({
        "message": errorMsg,
        "isSender": false,
        "messagetype": "error",
        "timestamp": date,
      });
      conversationModel.add(ConvModel(
          isSender: false,
          message: errorMsg,
          messageType: "error",
          timestamp: DateTime.now().toString()));
      _controller.clear();
      setState(() {});
    }
  }

  Future<void> _showLanguagePicker(BuildContext screencontext) async {
    final t = AppLocalizations.of(screencontext)!;
    final current = LocaleController.instance.locale?.languageCode;
    await showDialog(
      context: screencontext,
      builder: (context) {
        return SimpleDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(t.menuLanguage),
          children: [
            RadioListTile<String?>(
              value: 'en',
              groupValue: current,
              title: Text(t.languageEnglish),
              activeColor: const Color(0xffE8960C),
              onChanged: (v) async {
                await LocaleController.instance.setLocale(const Locale('en'));
                if (context.mounted) Navigator.pop(context);
              },
            ),
            RadioListTile<String?>(
              value: 'es',
              groupValue: current,
              title: Text(t.languageSpanish),
              activeColor: const Color(0xffE8960C),
              onChanged: (v) async {
                await LocaleController.instance.setLocale(const Locale('es'));
                if (context.mounted) Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showClearChatWarningDialog(BuildContext screencontext) {
    final t = AppLocalizations.of(screencontext)!;
    showDialog(
      context: screencontext,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 10,
          backgroundColor: Colors.white,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.refresh,
                  size: 50,
                  color: Colors.orange,
                ),
                const SizedBox(height: 16),
                Text(
                  t.clearChatTitle,
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      color: Color(0xff032553),
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  t.clearChatBody,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      color: Color(0xff032553),
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: Colors.orange),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      child: Text(
                        t.cancel,
                        style: const TextStyle(
                          color: Colors.orange,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                        await _clearChat();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      child: Text(
                        t.clear,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _shareConversation() async {
    final t = AppLocalizations.of(context)!;
    final messages = conversationModel
        .where((m) => m.message != "loading" && (m.message?.isNotEmpty ?? false))
        .toList();

    if (messages.isEmpty ||
        (messages.length == 1 && !(messages.first.isSender ?? false))) {
      Fluttertoast.showToast(msg: t.noConversationToShare);
      return;
    }

    final locale = Localizations.localeOf(context).languageCode;
    final dateStr = DateFormat('MMM d, y', locale).format(DateTime.now());
    final buffer = StringBuffer();
    buffer.writeln(t.shareHeader(dateStr));
    buffer.writeln();

    for (final m in messages) {
      final speaker = (m.isSender ?? false) ? t.shareSpeakerYou : t.shareSpeakerBot;
      buffer.writeln('$speaker: ${m.message?.trim() ?? ''}');
      buffer.writeln();
    }

    try {
      final box = context.findRenderObject() as RenderBox?;
      await Share.share(
        buffer.toString().trim(),
        subject: t.shareSubject(dateStr),
        sharePositionOrigin:
            box != null ? box.localToGlobal(Offset.zero) & box.size : null,
      );
    } catch (e) {
      print('Share failed: $e');
    }
  }

  Future<void> _clearChat() async {
    final t = AppLocalizations.of(context)!;
    final currentUser =
        FirebaseAuth.instance.currentUser?.email?.replaceAll('.', '') ?? '';
    await chatref.child(currentUser).remove();
    conversationModel.clear();
    conversationModel.add(ConvModel(
      isSender: false,
      message: _buildGreeting(t),
      messageType: "txt",
    ));
    if (mounted) setState(() {});
  }

  void _showDeleteWarningDialog(BuildContext screencontext) {
    showDialog(
      context: screencontext,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 10,
          backgroundColor: Colors.white,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  size: 50,
                  color: Color(0xffe45a04),
                ),
                const SizedBox(height: 16),
                Text(
                  'Delete Confirmation',
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      color: Color(0xff032553),
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Are you sure you want to Delete Account?',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      color: Color(0xff032553),
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: Color(0xffe45a04)),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      child: const Text(
                        'No',
                        style: TextStyle(
                          color: Color(0xffe45a04),
                          fontSize: 16,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        // Remove isLogin key from SharedPreferences
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        await prefs.remove('isLogin');
                        prefs.clear();

                        await FirebaseAuth.instance.app.delete();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (builder) => const Login()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffe45a04),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      child: const Text(
                        'Yes',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  reportIssueDialogue(context) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Report An Issue'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Describe the issue with Picture'),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: reportIssueController,
                    decoration: InputDecoration(
                      hintText: "Enter Issue",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          style: BorderStyle.solid,
                          width: 2,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () async {
                      final img = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);
                      if (img != null) {
                        setState(() {
                          image = img;
                        });
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      height: MediaQuery.of(context).size.height * 0.2,
                      width: MediaQuery.of(context).size.width,
                      child: image != null
                          ? Image.file(File(image!.path))
                          : const Center(child: Icon(Icons.add)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (reportIssueController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Add Some Issue"),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        } else if (image == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Add an Image"),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        } else {
                          await reportIssue();
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff032553),
                        elevation: 5,
                      ),
                      child: const Text(
                        "Send",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  child: const Text('CANCEL'),
                  onPressed: () {
                    setState(() {
                      image = null;
                      reportIssueController.clear();
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  final reportIssueController = TextEditingController();
  XFile? image;
  reportIssue() async {
    await FirebaseFirestore.instance.collection('reports').add({
      'email': FirebaseAuth.instance.currentUser?.email?.replaceAll('.', ''),
      'issue': reportIssueController.text,
      'image': jsonEncode(await image!.readAsBytes()),
    });
    image = null;
    reportIssueController.clear();
  }
}

void _showLogoutWarningDialog(BuildContext screencontext) {
  showDialog(
    context: screencontext,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 10,
        backgroundColor: Colors.white,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                size: 50,
                color: Colors.orange,
              ),
              const SizedBox(height: 16),
              Text(
                'Logout Confirmation',
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    color: Color(0xff032553),
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Are you sure you want to log out?',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    color: Color(0xff032553),
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Colors.orange),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    child: const Text(
                      'No',
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.clear();
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (builder) => const Login()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    child: const Text(
                      'Yes',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

String myFormatDateTime(DateTime dateTime) {
  String formattedTime = DateFormat('hh:mm a').format(dateTime);
  return formattedTime;
}

class ModelforMyBot {
  String? role;
  String? content;

  ModelforMyBot({this.content, this.role});

  ModelforMyBot.fromJson(Map<String, dynamic> json) {
    content = json['content'].toString();
    role = json['role'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['role'] = role;
    data['content'] = content;
    return data;
  }
}

class _SuggestionChip {
  final String label;
  final String subtitle;
  final String prompt;
  final String promptType;

  const _SuggestionChip({
    required this.label,
    required this.subtitle,
    required this.prompt,
    required this.promptType,
  });
}
