# ALAGUIDE APP DOCUMENTATION

## Overview

The Alaguide App is a cross-platform application developed using Django for the backend and Flutter for the frontend. This documentation provides a step-by-step guide on how to set up and run the project locally.

## Installation and Setup

### Requirements

Before you get started, ensure you have the following dependencies installed:

- Python 3.10
- pip3
- Django 5.1
- MySQL (or the database of your choice)
- Other dependencies listed in `requirements.txt` (e.g., Django REST framework)

### Steps to Run the Project Locally

1. **Clone the Repository**

   Open your terminal and run the following command to clone the GitHub repository:

   ```bash
   git clone https://github.com/RAIQASVL/alaguide-CrossPlatformApp-development.git
   ```

   Rename the resulting folder to `alaguide_arc` for consistency:

   ```bash
   mv alaguide-CrossPlatformApp-development alaguide_arc
   cd alaguide_arc
   ```

2. **Create and Activate a Virtual Environment**

   Set up a virtual environment to manage project dependencies:

   ```bash
   python -m venv .venv
   source .venv/bin/activate  # For Windows, use .venv\Scripts\activate
   ```

3. **Install Dependencies**

   Ensure that the `requirements.txt` file is present in the `/BACKEND` directory, then install the necessary packages:

   ```bash
   cd backend
   pip install -r requirements.txt
   ```

4. **Set Up Environment Variables**

   1. Create a `.env` file in the root of the project and add the necessary environment variables:

      ```
      SECRET_KEY='your_secret_key'
      DEBUG=True
      ALLOWED_HOSTS=localhost,127.0.0.1

      DATABASE_NAME='your_database_name'
      DATABASE_USER='your_username'
      DATABASE_PASSWORD='your_password'
      DATABASE_HOST='localhost'
      DATABASE_PORT='3306'  # Use '5432' for PostgreSQL
      ```

   2. Create a `local_vars.py` file in the `/BACKEND/src/server` directory with the following content:

      ```python
      SECRET_KEY = "your_django_secret_key"
      BASE_URL = "http://192.168.1.235:8000"  # replace with your local IP address
      MYSQL_TEST_NAME = "test_alaguide_db"
      MYSQL_NAME = "alaguide_db"
      MYSQL_USER = "your_database_user"
      MYSQL_PASSWORD = "your_database_password"
      MYSQL_HOST = "mysql-db"  # as specified in docker-compose.yml
      ```

   3. Create an `api_url_constants.dart` file in the `/FRONTEND/lib/constants` directory:

      ```dart
      class ApiConstants {
        static const String baseUrl = 'http://192.168.1.235:8000';  // replace with your local IP address
      }
      ```

   4. To find your correct local IP address, use the following command:

      ```bash
      ifconfig
      ```

      Look for the `en1` tag to identify your correct IP address.

5. **Apply Database Migrations (Optional)**

   Run the following command to apply migrations. Use the `--fake` option to avoid duplicate migrations if necessary:

   ```bash
   python manage.py migrate --fake
   ```

6. **Create a Superuser (Optional)**

   If you want to access the Django admin interface, create a superuser account:

   ```bash
   python manage.py createsuperuser
   ```

   Fill in the required fields as prompted.

7. **Run the Server**

   Start the Django server with the command:

   ```bash
   python manage.py runserver 0.0.0.0:8000
   ```

   You can then access your application at: [http://127.0.0.1:8000](http://localhost:8000).

---

### Frontend Setup

8. **Navigate to the /FRONTEND Directory**

   To run the frontend, you can choose to use FVM (Flutter Version Manager) or the standard Flutter method.

   1. **Using Standard Flutter Commands:**

      ```bash
      cd frontend
      flutter pub get
      flutter run
      ```

   2. **Using FVM:**

      ```bash
      fvm flutter pub get
      fvm flutter run
      ```

9. **Enjoy Your Project!**

   You are now set up to use the Alaguide App! Have fun and enjoy developing your application! 😊

---

Feel free to customize any of the instructions above to better fit your development needs or project specifics!