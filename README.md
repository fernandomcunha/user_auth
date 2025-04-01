# User Authentication App

The app provides basic user authentication features such as **sign-up**, **sign-in**, and **sign-out**. It does not use a database and instead stores user data in the session for simplicity.

---

## Features

- **Sign-Up**: Users can create an account by providing their name, email, and password.
- **Sign-In**: Users can log in with their email and password.
- **Sign-Out**: Users can securely log out of their account.
- **User Dashboard**: Displays user details and location information based on their IP address.
- **IP Location Service**: Fetches city, region, and country information using the `IpInfoService`.

---

## Technologies Used

- **Ruby on Rails**: Framework for building the app.
- **BCrypt**: For securely hashing and validating passwords.
- **Bootstrap**: For responsive and modern UI design.
- **IpInfo API**: To fetch location details based on the user's IP address.

---

## Prerequisites

Before setting up the app, ensure you have the following installed:

- **Ruby**: Version 3.0 or higher.
- **Rails**: Version 7.0 or higher.
- **Bundler**: To manage Ruby gems.
- **Node.js** and **Yarn**: For managing JavaScript dependencies.

---

## Setup Instructions

Follow these steps to set up and run the app locally:

### 1. Clone the Repository

```bash
git clone https://github.com/your-username/user_auth.git
cd user_auth
```

### 2. Install Dependencies

Run the following command to install all required gems:

```bash
bundle install
```

### 3. Configure the IP Info API

The app uses the [IpInfo API](https://ipinfo.io/) to fetch location details. You need an API token to use this service.

1. Create a `.env` file in the root directory of the project:
   ```bash
   touch .env
   ```

2. Add your `IP_INFO_TOKEN` to the `.env` file:
   ```env
   IP_INFO_TOKEN=your_ip_info_api_token
   ```

3. Check the `.env.example` file for an example of how to structure your `.env` file.

4. Ensure the `dotenv-rails` gem is installed and configured in your app. This gem will load the environment variables from the `.env` file.

### 4. Start the Rails Server

Run the following command to start the Rails server:

```bash
bin/rails server
```

### 5. Access the App
Open your browser and navigate to:

```
http://localhost:3000
```

## Usage

### Sign-Up
1. Navigate to the **Sign-Up** page.
2. Enter your name, email, and password.
3. Click "Sign Up" to create an account.

### Sign-In
1. Navigate to the **Sign-In** page.
2. Enter your email and password.
3. Click "Sign In" to log in.

### User Dashboard
- After signing in, you will be redirected to the **User Dashboard**.
- The dashboard displays:
  - Your name and email.
  - Your location details (city, region, and country) based on your IP address.

### Sign-Out
- Click the **Sign Out** button to log out of your account.

---

## File Structure

Here’s an overview of the key files and directories in the app:

- **`app/controllers/users_controller.rb`**: Handles user-related actions (sign-up, sign-in, sign-out, etc.).
- **`app/services/user_authentication_service.rb`**: Handles user authentication logic.
- **`app/services/ip_info_service.rb`**: Fetches location details based on the user's IP address.
- **`app/controllers/concerns/session_management.rb`**: Manages session-related logic.
- **`app/views/users/`**: Contains the views for user-related pages (sign-up, sign-in, dashboard).

---

## Testing

The app includes unit tests for service objects and controller actions. To run the tests, use the following command:

```bash
rspec
```