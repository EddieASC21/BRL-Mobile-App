# BRL-Mobile-App

---

# Ticket #103 (Backend P.2)

### Ticket #103 (Backend P.2): Implement OAuth Flow Initiation and Callback Handling  
**Due Date:** 04/18/2025 at 11:59 PM (EST)  
**SWEs:** Kai Patragnoni, Jason Chen

---

### Task: Implement OAuth Flow Initiation and Callback Handling

This ticket enables BRL users to begin linking their bank accounts via OAuth (e.g., Capital One).  
When a user taps a “Connect Bank” button in the mobile app, this ticket handles the logic to:

1. Redirect them to the bank's OAuth page.  
2. Receive the redirect callback with an authorization code.  
3. Exchange that code for access and refresh tokens.  

This ticket does not store or encrypt the tokens yet — that will be handled in the next ticket.

---

### Key Goals

- Create `/api/oauth/initiate?bank=c1` route to begin OAuth flow.  
- Redirect the user to the bank’s login page.  
- Create `/api/oauth/callback` route to handle redirect from the bank.  
- Exchange the authorization code for `access_token`, `refresh_token`, and `expires_in`.  
- Temporarily log the tokens and return a placeholder success response.

---

### Steps to Complete

1. **Add OAuth Config to Environment**  
   Add these variables to `.env`:
    - CAPITALONE_CLIENT_ID=...
    - CAPITALONE_CLIENT_SECRET=...
    - CAPITALONE_REDIRECT_URI=https://yourdomain.com/api/oauth/callback

2. **Create `/api/oauth/initiate`**
- Accept query param: `bank=c1`  
- Require valid JWT (user must be authenticated)  
- Redirect user to Capital One OAuth login page:  
  ```
  https://sandbox.capitalone.com/oauth/authorize?  
  client_id=...&redirect_uri=...&response_type=code&scope=...&state=randomString  
  ```

3. **Create `/api/oauth/callback`**
- Extract `code` and `state` from query  
- Make POST request to Capital One token endpoint to exchange code for tokens  
- Parse and log:  
  - `access_token`  
  - `refresh_token`  
  - `expires_in`  
- Return success response to frontend:  
  ```json
  { "message": "OAuth success, tokens received" }
  ```

4. **Validate & Test**
- Simulate full redirect flow using Postman or browser  
- Log the token response (do not store yet)  
- Ensure all routes require proper JWT authentication

---

### Preparation for Next Subteam Meeting

- Be ready to demo:  
- Full OAuth redirect loop working end-to-end  
- Backend receiving code and retrieving tokens  
- Response returned to mobile team  
- Coordinate with mobile team to prepare for OAuth link UI

---

### Notes & Considerations

- Use `state` param to prevent CSRF (can be static for now)  
- Capital One sandbox should be pre-configured for redirect URI  
- Do not store tokens in this ticket — only log and confirm functionality  
- All routes must be JWT-protected

---

### Resources

- Capital One OAuth Documentation: https://developer.capitalone.com/documentation/o-auth  
- RFC 6749 (OAuth 2.0 Spec): https://datatracker.ietf.org/doc/html/rfc6749  
- Gin Route Handling: https://github.com/gin-gonic/gin  
- HTTP Client for Go (net/http or resty): https://github.com/go-resty/resty  


  
