// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get hello => 'Hello';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get forgot_password => 'Forgot Password?';

  @override
  String get signin => 'Sign In';

  @override
  String get username => 'Username';

  @override
  String get welcome_back => 'Welcome Back';

  @override
  String get signin_subtitle => 'Sign in to continue to your account';

  @override
  String get username_required => 'Please enter your username';

  @override
  String get password_required => 'Please enter your password';

  @override
  String get password_min_length => 'Password must be at least 6 characters';

  @override
  String get dont_have_account => 'Don\'t have an account?';

  @override
  String get signup => 'Sign Up';

  @override
  String get speed_test => 'Speed Test';

  @override
  String get start_test => 'Start Test';

  @override
  String get stop_test => 'Stop Test';

  @override
  String get download_speed => 'Download Speed';

  @override
  String get upload_speed => 'Upload Speed';

  @override
  String get ping => 'Ping';

  @override
  String get testing_download => 'Testing Download...';

  @override
  String get testing_upload => 'Testing Upload...';

  @override
  String get test_completed => 'Test Completed';

  @override
  String get mbps => 'Mbps';

  @override
  String get ms => 'ms';

  @override
  String get idle => 'Tap Start to begin';

  @override
  String get test_again => 'Test Again';

  @override
  String get connected_devices => 'Connected Devices';

  @override
  String get scan_network => 'Scan Network';

  @override
  String get scanning => 'Scanning...';

  @override
  String get stop_scan => 'Stop Scan';

  @override
  String get no_devices_found => 'No devices found';

  @override
  String devices_found(int count) {
    return '$count device(s) found';
  }

  @override
  String get device_details => 'Device Details';

  @override
  String get ip_address => 'IP Address';

  @override
  String get mac_address => 'MAC Address';

  @override
  String get hostname => 'Hostname';

  @override
  String get vendor => 'Vendor';

  @override
  String get unknown => 'Unknown';

  @override
  String get this_device => 'This Device';

  @override
  String get active => 'Active';

  @override
  String get filter_all => 'All';

  @override
  String get filter_active => 'Active';

  @override
  String get search_devices => 'Search devices...';

  @override
  String scan_progress(int progress) {
    return 'Scanning: $progress%';
  }

  @override
  String get network_error => 'Network error. Please check your connection.';

  @override
  String get scan_complete => 'Scan complete';
}
