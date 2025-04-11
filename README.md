# book-recommendation-backend
This repository contains the backend code for the book recommendation system.User authentication and profile management Book data storage and retrieval Personality analysis based on user preferences API endpoints for book recommendations

## 📚 API Documentation

### 1. User Registration (`POST /register`)
- **Description:** Registers a new user.
- **Endpoint:** `https://intelligent-shockley-8ynjnlm8e.liara.run/api/auth/register`
- **Request Body (JSON):**
```json
{
  "name": "Ali",
  "email": "ali@example.com",
  "password": "mypassword123"
}
```
- **Responses:**
  - ✅ `200 OK`: Registration successful and verification code sent
    ```json
    { "message": "Verification code sent to email." }
    ```
  - ❌ `400 Bad Request`: User already exists or invalid input
    ```json
    { "message": "This user has already registered!" }
    ```
  - ❌ `500 Internal Server Error`: Server error

---

### 2. User Login (`POST /login`)
- **Description:** Authenticates a user and returns a JWT token.
- **Endpoint:** `https://intelligent-shockley-8ynjnlm8e.liara.run/api/auth/login`
- **Request Body (JSON):**
```json
{
  "email": "ali@example.com",
  "password": "mypassword123"
}
```
- **Responses:**
  - ✅ `200 OK`: Successful login
    ```json
    {
      "message": "Logged in successfully",
      "token": "<JWT_TOKEN>",
      "user": { "id": 1, "name": "Ali", "email": "ali@example.com" }
    }
    ```
  - ❌ `400 Bad Request`: User not found, email not verified, or wrong password
  - ❌ `500 Internal Server Error`: Server error

---

### 3. Email Verification (`POST /verify-code`)
- **Description:** Verifies a user's email using the code sent.
- **Endpoint:** `https://intelligent-shockley-8ynjnlm8e.liara.run/api/auth/verify-code`
- **Request Body (JSON):**
```json
{
  "email": "ali@example.com",
  "code": "123456"
}
```
- **Responses:**
  - ✅ `200 OK`: Verification successful
    ```json
    { "message": "User verified successfully. You can now log in." }
    ```
  - ❌ `400 Bad Request`: Wrong code, account removed
  - ❌ `500 Internal Server Error`: Server error

---

### 4. Get User Profile (`GET /profile`)
- **Description:** Retrieves the user's profile data (requires authentication).
- **Endpoint:** `https://intelligent-shockley-8ynjnlm8e.liara.run/api/auth/profile`
- **Headers:**
```json
{ "Authorization": "Bearer <YOUR_TOKEN_HERE>" }
```
- **Responses:**
  - ✅ `200 OK`: User profile data returned
  - ❌ `401 Unauthorized`: Invalid or missing token
  - ❌ `404 Not Found`: User not found
  - ❌ `500 Internal Server Error`: Server error

---

### 5. Change Password (`PUT /newPassword`)
- **Description:** Updates the user's password (requires authentication).
- **Endpoint:** `https://intelligent-shockley-8ynjnlm8e.liara.run/api/auth/newPassword`
- **Headers:**
```json
{ "Authorization": "Bearer <YOUR_TOKEN_HERE>" }
```
- **Request Body (JSON):**
```json
{
  "oldPassword": "mypassword123",
  "newPassword": "newpass456"
}
```
- **Responses:**
  - ✅ `200 OK`: Password updated successfully
  - ❌ `400 Bad Request`: Incorrect current password
  - ❌ `500 Internal Server Error`: Server error

---

### 6. Google Login (`POST /google-login`)
- **Description:** Authenticates user using a Google account.
- **Endpoint:** `https://intelligent-shockley-8ynjnlm8e.liara.run/api/auth/google-login`
- **Request Body (JSON):**
```json
{ "googleToken": "your_google_token_here" }
```
- **Responses:**
  - ✅ `200 OK`: Login successful
  - ❌ `500 Internal Server Error`: Server error

---

### 7. Update Profile (`PUT /updateProfile`)
- **Description:** Updates user profile information (requires authentication).
- **Endpoint:** `https://intelligent-shockley-8ynjnlm8e.liara.run/api/auth/updateProfile`
- **Headers:**
```json
{ "Authorization": "Bearer <YOUR_TOKEN_HERE>" }
```
- **Request Body (JSON):**
```json
{
  "new_firstName": "Ali",
  "new_lastName": "Rezaei",
  "new_userName": "ali_rz",
  "new_bio": "Developer and tech lover",
  "new_gender": "male",
  "new_birthday": "1995-04-01",
  "new_phoneNumber": "09123456789"
}
```
- **Responses:**
  - ✅ `200 OK`: Profile updated successfully
  - ❌ `500 Internal Server Error`: Update failed or server error

---

### 8. Search Books (`GET /search`)
- **Description:** Searches books by keyword and paginates results.
- **Endpoint:** `https://intelligent-shockley-8ynjnlm8e.liara.run/api/book/search`
- **Request Body (JSON):**
```json
{
  "searchterm": "history",
  "pagenum": 1
}
```
- **Responses:**
  - ✅ `200 OK`: List of matched books
  - ❌ `500 Internal Server Error`: Error processing search

---

### 9. Get Book Image (`GET /image/:bookid`)
- **Description:** Returns the image of a specific book by its ID.
- **Endpoint:** `https://intelligent-shockley-8ynjnlm8e.liara.run/api/book/image/:bookid`
- **URL Parameter:** `:bookid` = Book ID
- **Responses:**
  - ✅ `200 OK`: Image stream
  - ❌ `500 Internal Server Error`: Failed to fetch image

---

### 10. Get Popular Books (`GET /popularBooks`)
- **Description:** Returns a paginated list of top-rated books.
- **Endpoint:** `https://intelligent-shockley-8ynjnlm8e.liara.run/api/book/popularBooks`
- **Request Body (JSON):**
```json
{
  "pagenum": 1
}
```
- **Responses:**
  - ✅ `200 OK`: List of popular books
  - ❌ `204 No Content`: No books available
  - ❌ `500 Internal Server Error`: Server error

