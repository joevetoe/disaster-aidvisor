# Disaster AIDvisor — App Update Proposal

## Project Overview

Disaster AIDvisor is a live mobile application on the Apple App Store and Google Play Store that provides AI-powered disaster preparedness and recovery guidance, trained on BuildSOS's curated knowledge base of 1,000+ expert-reviewed Q&A pairs.

This proposal focuses on cleaning up the existing app — fixing bugs, securing the backend, improving the chat experience, and polishing the UI. The goal is a robust, professional user experience that reflects the quality of the content behind it, without adding new features or rebuilding from scratch.

---

## Phase 1 — Security, AI Upgrade & Terms Compliance

**Priority: Critical**
**Estimated Timeline: 2–3 weeks**
**Investment: $1,170 – $1,625**

### What's Included

- **Terms & Conditions Acceptance Screen**: Add a required disclaimer pop-up that users must accept before using the app. This ensures legal compliance and protects BuildSOS from liability. Users will see the full disclaimer and must tap "I Agree" before accessing the chat. Acceptance is recorded with a timestamp in their user profile.
- **Secure API Key Management**: Move the AI service API key from the app's source code to a secure server-side Firebase Cloud Function. Currently, the API key is embedded directly in the published app — anyone with basic technical knowledge can extract it and use it at your expense. This eliminates that vulnerability.
- **Upgrade AI Model**: Migrate from OpenAI GPT-3.5-turbo to Anthropic Claude Sonnet, a more advanced AI model that provides higher quality responses, better safety guardrails for emergency-related advice, and stronger adherence to its role as a disaster advisor.
- **Custom AI System Prompt — "Bumpers"**: Develop a comprehensive system prompt that keeps the AI focused on disaster preparedness, response, and recovery topics. The AI will stay in character as Disaster AIDvisor and won't respond to off-topic requests like restaurant recommendations. It will draw from your curated knowledge base as its primary source of truth.
- **Integrate Knowledge Base into AI System**: Migrate the 1,000+ curated Q&A pairs (57 entry, 320 prepare, 270 recovery, 50 respond, 398 contractor) from hardcoded app logic into a structured Firestore collection. The AI will use this content as its primary reference, delivering natural conversational responses grounded in your expert-reviewed material. Your team can add, edit, or remove Q&A entries at any time without requiring an app update.
- **Secure User Data Storage**: Fix an existing vulnerability where user passwords are stored in plaintext in the database and on-device. Implement encrypted secure storage.

### Why This Phase Is Urgent

The current app has the AI service API key embedded directly in the source code. Anyone can extract this key from the published app and run up charges on your account. Additionally, the terms and conditions acceptance is a legal necessity that protects BuildSOS from liability.

### Cost Breakdown

| Task | Est. Hours | Cost | Justification |
|------|-----------|------|---------------|
| Terms & conditions acceptance screen | 2–3 hrs | $130 – $195 | Building a mandatory disclaimer pop-up that appears before first use, with scrollable terms text, "I Agree" button, and timestamp recording in Firestore. Integrated into the app launch flow so it cannot be bypassed. |
| Firebase Cloud Function setup & deployment | 4–5 hrs | $260 – $325 | Creating a secure server-side function, configuring Firebase project settings, setting up environment variables, deploying, and testing end-to-end connectivity from the app to the cloud function to the AI service. |
| Claude AI integration & API migration | 3–4 hrs | $195 – $260 | Rewriting the chat service layer to use the Anthropic API format, updating request/response handling, error handling, and verifying response quality across different question types. |
| Custom AI system prompt development | 3–4 hrs | $195 – $260 | Crafting and testing a detailed system prompt that keeps the AI on-topic with "bumpers" — covering disaster preparedness, FEMA processes, insurance guidance, evacuation planning, and contractor advice. Requires iterative testing to ensure it stays in character and gives accurate, safe responses. |
| Knowledge base migration & integration | 4–6 hrs | $260 – $390 | Migrating 1,000+ curated Q&A pairs from hardcoded app logic into a structured Firestore collection. Building the retrieval system that feeds relevant knowledge base entries to the AI as context. Organized by your existing categories (entry, prepare, recovery, respond, contractor) so entries can be managed without app updates. |
| Secure user data storage | 2–3 hrs | $130 – $195 | Replacing plaintext password storage with encrypted secure storage on-device, removing raw passwords from Firestore, and testing across iOS and Android. |
| **Phase 1 Total** | **18–25 hrs** | **$1,170 – $1,625** | |

---

## Phase 2 — Chat Experience & UI Polish

**Priority: High**
**Estimated Timeline: 2–3 weeks**
**Investment: $910 – $1,495**

### What's Included

- **Suggested Conversation Starters**: Add clickable prompt buttons on the chat screen so users know what to ask. Organized by your existing categories — Preparing, Responding, Recovery, Contractors — so users can tap a topic and see relevant questions to get the conversation started.
- **UI Cleanup & Button Fixes**: Fix awkward button styling, spacing, and layout issues throughout the app. Clean up clunky visual elements to give the app a polished, professional feel without a full redesign.
- **Improved Loading Experience**: Replace the current plain text "loading" indicator with a professional typing animation while the AI generates its response.
- **Formatted AI Responses**: Render AI responses with proper formatting — bold text, bullet points, numbered lists, and clickable links — instead of plain text walls.
- **Bug Fixes & Testing**: Comprehensive testing and fixing of existing bugs across both iOS and Android, including edge cases in the chat flow, authentication issues, and error handling.
- **Placeholder Logo**: Replace the current AI-generated-looking logo with a cleaner placeholder until the new branding is ready (~6 weeks). Easy to swap out later.

### Why This Phase Matters

These are the "easy wins" that make the biggest difference in how the app feels to users. Suggested prompts solve the blank-screen problem, and UI polish makes the app look intentional rather than unfinished.

### Cost Breakdown

| Task | Est. Hours | Cost | Justification |
|------|-----------|------|---------------|
| Suggested conversation starters | 4–6 hrs | $260 – $390 | Building the prompt suggestion UI with category tabs matching your knowledge base categories (entry, prepare, recovery, respond, contractor). Each category shows 5–8 tappable starter questions. Tapping a question sends it to the AI automatically. Includes styling to match the existing chat design. |
| UI cleanup & button fixes | 3–5 hrs | $195 – $325 | Fixing awkward button sizing, spacing, and alignment across all screens. Cleaning up visual inconsistencies in the chat bubbles, input bar, and menu items. Making the overall layout feel polished and intentional. |
| Loading animation | 1–2 hrs | $65 – $130 | Replacing the plain text "loading" with a professional typing/thinking animation in the chat bubble area. |
| Markdown rendering for AI responses | 2–3 hrs | $130 – $195 | Integrating a markdown renderer into chat bubbles so AI responses display with proper bold text, bullet points, numbered lists, and clickable hyperlinks instead of raw unformatted text. |
| Bug fixes & testing | 3–5 hrs | $195 – $325 | Comprehensive testing across iOS and Android — fixing authentication flow issues, chat edge cases (empty messages, very long responses, rapid sending), error handling, and any other bugs discovered during testing. |
| Placeholder logo | 1–2 hrs | $65 – $130 | Designing or sourcing a cleaner placeholder logo that doesn't look obviously AI-generated. Set up so it's easy to swap when the new branding arrives. |
| **Phase 2 Total** | **14–23 hrs** | **$910 – $1,495** | |

---

## Investment Summary

| Phase | Scope | Investment Range |
|-------|-------|-----------------|
| Phase 1 | Security, AI Upgrade, Knowledge Base & Terms Compliance | $1,170 – $1,625 |
| Phase 2 | Chat Experience & UI Polish | $910 – $1,495 |
| **Total** | **Complete Cleanup & Improvement** | **$2,080 – $3,120** |

### Package Options

**Essential (Phase 1 only) — Starting at $1,170**
The app is secure, legally compliant with terms acceptance, powered by a superior AI model, and your curated knowledge base drives every response. The most urgent issues are resolved.

**Complete (Both Phases) — Starting at $2,080**
Everything in Phase 1, plus the chat experience improvements and UI polish that make the app feel professional and easy to use. Recommended for the best user experience before re-pushing to the app stores.

---

## Ongoing Costs

After the update, the following recurring costs apply:

- **AI API Usage (Claude by Anthropic)**: Approximately $0.02 per conversation. Estimated $20–$50/month depending on user volume.
- **Firebase**: Likely remains on the free tier unless user volume increases significantly.
- **Apple Developer Account**: $99/year (existing).
- **Google Play Developer Account**: $25 one-time (existing).

---

## What's Next — Policy Advisor & Claims Advisor

Once Disaster AIDvisor is cleaned up and re-published, the same approach and lessons learned will be applied to the Policy Advisor and Claims Advisor apps. Separate proposals will be provided for each, but the security improvements (Cloud Function, secure storage) and AI upgrade (Claude migration) built for Disaster AIDvisor will carry over and reduce the scope of work for the other two apps.

---

## Next Steps

1. Review and approve the desired phase(s)
2. Create an Anthropic API account at console.anthropic.com for the AI upgrade
3. Share any additional training documents, user flow docs, and requirements via Google Drive or GitHub
4. Development begins immediately upon approval
5. Each phase concludes with a review and testing before re-publishing to the app stores

---

*Prepared for BuildSOS, LLC*
