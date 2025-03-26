# BRL-Mobile-App

---

### **Ticket #1 (Mobile P.1): Build Login UI and Prepare JWT Handling (SwiftUI)**  
**Due Date:** 04/11/2025 at 11:59 PM (EST)  
**SWEs:** Steven Lin, Alyssa Hsu

---

### **Task: Build Login UI and Prepare JWT Handling (SwiftUI)**  
This ticket establishes the core login interface and logic for the Big Red Link iOS mobile app using SwiftUI. While the backend authentication API (`/api/auth/login`) may not be finalized by the due date, the mobile app will still complete all frontend components and **mock the backend response** in preparation for integration.

This foundation will support authentication and secure communication with the backend in all future mobile features, including bank linking and user dashboards.

---

### **Key Goals**
- Build a SwiftUI login screen with email and password fields
- Prepare the login request using `URLSession`
- Simulate backend response using a mock or local JSON
- Store the access token securely using Keychain
- Set up the structure for authenticated API requests
- Ensure easy switch-over to live backend when available

---

### **Steps to Complete**

**1. Create Login UI (SwiftUI)**
- Implement a `LoginView` with:
  - `TextField` for email
  - `SecureField` for password
  - `Button` to initiate login
- Provide inline error messaging or alerts on validation

**2. Create Login Request Logic**
- Write a network service (`AuthService.swift`) to handle:
  - POST request to `/api/auth/login`
  - JSON body: `{ "email": "...", "password": "..." }`
- For now, use:
  - A local mock JSON file, or
  - A mock server such as [Postman Mock Server](https://www.postman.com/mock-api/), to simulate:
    ```json
    { "access_token": "mocked.jwt.token" }
    ```

**3. Store Access Token Securely**
- Use iOS Keychain to store the `access_token`
  - Implement helper in `TokenManager.swift`
  - Use either native `Keychain Services` or a wrapper like `KeychainAccess`
- Confirm stored token is retrievable and used in:
  ```http
  Authorization: Bearer <access_token>
  ```

**4. Prepare for Token Expiration**
- Parse the JWT payload (using `JWTDecode.swift`) to extract expiration if needed
- Add a placeholder `refreshToken()` function to be implemented in a future ticket

**5. Error Handling & Validation**
- Handle:
  - Empty or invalid form fields
  - Simulated “invalid credentials” errors from the mock server
- Provide user feedback using `Alert`, `Text`, or `Toast`

---

### **Preparation for Next Subteam Meeting**
- Be ready to demo:
  - Working SwiftUI login screen
  - Simulated login success and error handling
  - Secure token stored in Keychain
  - Token attached to a test API request
- Confirm compatibility with backend team’s `/api/auth/login` response

---

### **Notes & Considerations**
- All API requests must use HTTPS (even for mock servers)
- Do not log sensitive information (tokens, passwords)
- Keychain storage should be used instead of `UserDefaults`
- This ticket does not implement token refresh or logout — those will follow

---

### **Dependencies**
- This ticket assumes `/api/auth/login` will be implemented by the backend team by 04/11.
- If not available by the demo date, continue testing with mocks.
- Mobile and backend teams should align on:
  - Request/response structure
  - HTTP status codes
  - Token format and naming

---

### **Resources**
- Apple Keychain Services: [https://developer.apple.com/documentation/security/keychain_services](https://developer.apple.com/documentation/security/keychain_services)  
- JWTDecode.swift (JWT parsing): [https://github.com/auth0/JWTDecode.swift](https://github.com/auth0/JWTDecode.swift)  
- Swift HTTP Networking (URLSession): [https://developer.apple.com/documentation/foundation/urlsession](https://developer.apple.com/documentation/foundation/urlsession)  
- Mock Server: [Postman Mock Servers](https://www.postman.com/mock-api/)
