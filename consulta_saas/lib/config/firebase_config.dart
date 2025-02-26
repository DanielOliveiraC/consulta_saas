class FirebaseConfig {
  static const String apiKey = "YOUR_API_KEY";
  static const String appId = "YOUR_APP_ID";
  static const String messagingSenderId = "YOUR_SENDER_ID";
  static const String projectId = "YOUR_PROJECT_ID";
  static const String storageBucket = "YOUR_STORAGE_BUCKET";
  static const String authDomain = "YOUR_AUTH_DOMAIN";

  static const Map<String, String> firebaseConfig = {
    'apiKey': apiKey,
    'appId': appId,
    'messagingSenderId': messagingSenderId,
    'projectId': projectId,
    'storageBucket': storageBucket,
    'authDomain': authDomain,
  };

  static const Map<String, String> collections = {
    'doctors': 'doctors',
    'patients': 'patients',
    'appointments': 'appointments',
  };

  static const Map<String, String> appointmentStatus = {
    'scheduled': 'scheduled',
    'completed': 'completed',
    'cancelled': 'cancelled',
  };

  static const Map<String, String> userTypes = {
    'doctor': 'doctor',
    'patient': 'patient',
  };

  static bool isDoctorEmail(String email) {
    return email.endsWith('@doctor.com');
  }
}
