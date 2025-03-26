# BRL-Mobile-App

---

### **Ticket #101 (Backend P.1): Implement JWT Authentication and Go Backend Initialization**  
**Due Date:** 04/11/2025 at 11:59 PM (EST)  
**SWEs:** Kai Patragnoni, Jason Chen

---

### **Task: Implement JWT Authentication and Go Backend Initialization**  
Big Red Link currently does not have a backend authentication system. This ticket establishes a clean and secure backend infrastructure in **Golang** using the **Gin web framework**. It includes **JWT-based authentication**, connection to **Google Cloud Firestore**, and route protection middleware. This is foundational for OAuth bank linking, token encryption, and all future backend features.

---

### **Key Goals**
- Create the initial Go backend with Gin.
- Implement registration, login, logout, and token refresh endpoints.
- Use JWT for stateless access control.
- Store refresh tokens in Firestore.
- Use HTTP-only cookies to store refresh tokens.
- Add middleware to protect routes via access tokens.

---

### **Steps to Complete**

**1. Backend Project Initialization**
- Initialize Go module
- Install necessary packages:
  - `github.com/gin-gonic/gin`
  - `github.com/golang-jwt/jwt/v5`
  - `golang.org/x/crypto/bcrypt`
  - `cloud.google.com/go/firestore`
- Create base folder structure:
  - `controllers/`, `routes/`, `middleware/`, `models/`, `utils/`

- Set up `.env`:
  ```
  JWT_SECRET=your-jwt-secret
  JWT_REFRESH_SECRET=your-refresh-secret
  GCP_PROJECT_ID=your-gcp-project-id
  GCP_FIRESTORE_CREDENTIALS=path/to/service-account-key.json
  ```

**2. Implement JWT Authentication**
- Create Firestore user model:
  ```go
  type User struct {
      ID            string `firestore:"id"`
      Email         string `firestore:"email"`
      PasswordHash  string `firestore:"passwordHash"`
      RefreshToken  string `firestore:"refreshToken"`
  }
  ```

- Implement routes:
  - `POST /api/auth/register`:
    - Hash password with `bcrypt`
    - Store user in Firestore
  - `POST /api/auth/login`:
    - Validate password
    - Issue access token (expires in 15 min)
    - Issue refresh token (expires in 7 days)
    - Store refresh token in Firestore and send via HTTP-only cookie
  - `POST /api/auth/refresh`:
    - Validate refresh token from cookie
    - Issue new access token
  - `POST /api/auth/logout`:
    - Remove refresh token from Firestore
    - Clear the cookie

**3. Add JWT Middleware**
- Implement middleware to verify access tokens
- Apply to:
  ```
  GET /api/user/me
  ```
  Return the authenticated user's email or ID

**4. Testing**
- Test endpoints with Postman or curl:
  - User registration and login
  - Token issuance and refresh
  - Protected route access
  - Logout and token invalidation

---

### **Preparation for Next Subteam Meeting**
- Be prepared to demo:
  - User registration and login flow
  - Token refresh logic and JWT protection
  - Firestore read/write from Go
- Discuss coordination with mobile team’s login screen

---

### **Notes & Considerations**
- Access tokens are signed using HS256 (do not encrypt JWTs)
- Passwords should be hashed and salted with bcrypt
- Refresh tokens should be stored only server-side and tied to a single user
- Use secure cookies with `HttpOnly`, `SameSite=Strict`, and `Secure` flags

---

### **Resources**
- Gin Framework: [https://github.com/gin-gonic/gin](https://github.com/gin-gonic/gin)  
- Go JWT Docs: [https://pkg.go.dev/github.com/golang-jwt/jwt/v5](https://pkg.go.dev/github.com/golang-jwt/jwt/v5)  
- bcrypt in Go: [https://pkg.go.dev/golang.org/x/crypto/bcrypt](https://pkg.go.dev/golang.org/x/crypto/bcrypt)  
- Firestore Client for Go: [https://cloud.google.com/firestore/docs/reference/libraries#client-libraries-usage-go](https://cloud.google.com/firestore/docs/reference/libraries#client-libraries-usage-go)  
- Secure Cookie Handling in Go: [https://pkg.go.dev/net/http](https://pkg.go.dev/net/http)

