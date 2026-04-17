// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get hello => 'مرحبا';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get forgot_password => 'نسيت كلمة المرور؟';

  @override
  String get signin => 'تسجيل الدخول';

  @override
  String get username => 'اسم المستخدم';

  @override
  String get welcome_back => 'مرحباً بعودتك';

  @override
  String get signin_subtitle => 'سجل دخولك للمتابعة إلى حسابك';

  @override
  String get username_required => 'الرجاء إدخال اسم المستخدم';

  @override
  String get password_required => 'الرجاء إدخال كلمة المرور';

  @override
  String get password_min_length => 'يجب أن تكون كلمة المرور 6 أحرف على الأقل';

  @override
  String get dont_have_account => 'ليس لديك حساب؟';

  @override
  String get signup => 'إنشاء حساب';

  @override
  String get speed_test => 'اختبار السرعة';

  @override
  String get start_test => 'بدء الاختبار';

  @override
  String get stop_test => 'إيقاف الاختبار';

  @override
  String get download_speed => 'سرعة التحميل';

  @override
  String get upload_speed => 'سرعة الرفع';

  @override
  String get ping => 'زمن الاستجابة';

  @override
  String get testing_download => 'جاري اختبار التحميل...';

  @override
  String get testing_upload => 'جاري اختبار الرفع...';

  @override
  String get test_completed => 'اكتمل الاختبار';

  @override
  String get mbps => 'ميجابت/ث';

  @override
  String get ms => 'مللي ثانية';

  @override
  String get idle => 'اضغط بدء للاختبار';

  @override
  String get test_again => 'اختبار مرة أخرى';

  @override
  String get connected_devices => 'الأجهزة المتصلة';

  @override
  String get scan_network => 'فحص الشبكة';

  @override
  String get scanning => 'جاري الفحص...';

  @override
  String get stop_scan => 'إيقاف الفحص';

  @override
  String get no_devices_found => 'لم يتم العثور على أجهزة';

  @override
  String devices_found(int count) {
    return 'تم العثور على $count جهاز';
  }

  @override
  String get device_details => 'تفاصيل الجهاز';

  @override
  String get ip_address => 'عنوان IP';

  @override
  String get mac_address => 'عنوان MAC';

  @override
  String get hostname => 'اسم المضيف';

  @override
  String get vendor => 'المصنع';

  @override
  String get unknown => 'غير معروف';

  @override
  String get this_device => 'هذا الجهاز';

  @override
  String get active => 'نشط';

  @override
  String get filter_all => 'الكل';

  @override
  String get filter_active => 'نشط';

  @override
  String get search_devices => 'البحث عن الأجهزة...';

  @override
  String scan_progress(int progress) {
    return 'جاري الفحص: $progress%';
  }

  @override
  String get network_error => 'خطأ في الشبكة. يرجى التحقق من الاتصال.';

  @override
  String get scan_complete => 'اكتمل الفحص';
}
