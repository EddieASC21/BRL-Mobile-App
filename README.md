# BRL-Mobile-App

---
Ticket #104 (Mobile P.2): Implement “Connect a Bank” UI and OAuth Flow Initiation (SwiftUI)
Due Date: 04/11/2025 at 11:59 PM (EST)
SWEs: Steven Lin, Alyssa Hsu

Task: Implement “Connect a Bank” UI and OAuth Flow Initiation (SwiftUI)
Now that login is functional, users should be able to view a list of available banks and initiate an OAuth linking flow (e.g., with Capital One). This ticket focuses on building the “Connect a Bank” screen and integrating the front-end redirect logic to the backend's /api/oauth/initiate?bank=c1 endpoint.

Key Goals
Design a SwiftUI screen titled “Connect Your Bank”

Display a list of available bank options (start with Capital One)

When a user taps a bank, send a request to BRL backend to begin OAuth flow

Handle the redirect to the external OAuth provider (e.g., Capital One login page)

Prepare UI for success/failure redirection handling

Steps to Complete
1. Create “Connect a Bank” UI

Create a new SwiftUI view: BankLinkView

Add:

A title (“Link Your Bank”)

A list or buttons for bank options (e.g., Capital One)

For now, hardcode Capital One with an associated value like bank=c1

2. Connect to OAuth Flow

On selection (e.g., user taps Capital One):

Send a GET request to:

bash
Copy
Edit
/api/oauth/initiate?bank=c1
with JWT Authorization header

Parse the redirect URL from the response or handle a 302 redirect

Open the OAuth provider’s URL using:

swift
Copy
Edit
UIApplication.shared.open(URL)
3. Handle Redirect Return

Implement a placeholder OAuthReturnView to handle the return from /api/oauth/callback

This view will be triggered when the app is reopened with a deep link (e.g., brl://oauth-callback)

Add comments or prepare for future integration with backend storage and encryption

4. Error Handling

Display alerts for:

Failure to load OAuth URL

Unauthorized (expired token)

Network issues

Provide “Try again” or “Back to Dashboard” navigation options

Preparation for Next Subteam Meeting
Be ready to demo:

Full flow from login to “Connect a Bank” screen

Redirect opening Capital One’s sandbox OAuth login page

Returning to the app from the OAuth provider (even if unprocessed)

Coordinate with backend team to test /api/oauth/initiate behavior and redirect URL correctness

Notes & Considerations
Backend must validate JWT and return/redirect to the correct OAuth page

Final storage and encryption of OAuth tokens will happen in a later ticket (Backend #105)

Handle iOS deep link registration in Info.plist for brl:// scheme

Prepare state restoration in case of app termination during OAuth

Dependencies
Requires that user is logged in (JWT must be available in memory or retrieved from Keychain)

Assumes /api/oauth/initiate is available and working (Backend Ticket #103)

Requires iOS setup for handling external redirects back into the app (e.g., Universal Links or Custom URL Schemes)

Resources
SwiftUI Navigation: Apple SwiftUI Navigation Docs

Open External URL: UIApplication.shared.open

Deep Linking in iOS: RayWenderlich Guide

OAuth Best Practices: RFC 8252 - OAuth 2.0 for Native Apps
