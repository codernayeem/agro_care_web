# agro_care_web

A simple __Admin Panel__ for the Agro Care Project 

## Prerequisites

- [Flutter](https://flutter.dev/docs/get-started/install) (v3.16)
- [Firebase account](https://firebase.google.com/)
- [Dart](https://dart.dev/get-dart)

## Getting Started

1. **Clone the repository**:
    ```sh
    git clone https://github.com/codernayeem/agro_care_web.git
    cd flutterfire-project
    ```

2. **Install dependencies**:
    ```sh
    flutter pub get
    ```

3. **Set up Firebase**:
    - Follow the [Firebase setup guide](https://firebase.flutter.dev/docs/overview) to configure your Firebase project.
    - Generate the `firebase_options.dart` file using the FlutterFire CLI (_select only web_):
    
      ```sh
      flutterfire configure
      ```

4. **Run the App**:
      ```sh
      flutterfire run
      ```

5. **Deploy**:
    - Make sure you logged in using `firebse login` & used `firebase init` if needed.

      ```sh
      flutter build web
      firebase deploy
      ```

## Features

* **User Authentication** : Secure user authentication using Firebase Auth.
* **User Management**: View and manage the list of users within the app.
* **App Settings**: Configure and manage various application settings.
* **Disease Information**: Access and manage detailed information about  different diseases.
* **Predictions**: View prediction data and insights.
* **User Preferences**: Access and manage individual user preferences.
