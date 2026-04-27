import 'package:json_annotation/json_annotation.dart';

part 'subscription_plan_model.g.dart';

@JsonSerializable()
class SubscriptionPlanModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String currency;
  final int durationDays;
  final double speed;
  final String speedUnit;
  final List<String> features;
  final bool isPopular;
  final bool isCurrentPlan;

  SubscriptionPlanModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.currency = 'ج.م',
    required this.durationDays,
    required this.speed,
    this.speedUnit = 'Mbps',
    required this.features,
    this.isPopular = false,
    this.isCurrentPlan = false,
  });

  factory SubscriptionPlanModel.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionPlanModelFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionPlanModelToJson(this);

  static List<SubscriptionPlanModel> mockPlans() => [
        SubscriptionPlanModel(
          id: '1',
          name: 'الباقة الأساسية',
          description: 'مثالية للاستخدام الخفيف',
          price: 100,
          durationDays: 30,
          speed: 30,
          features: [
            'سرعة 30 ميجابت',
            'دعم فني على مدار الساعة',
            'بدون حد أقصى للتحميل',
          ],
        ),
        SubscriptionPlanModel(
          id: '2',
          name: 'باقة بريميوم',
          description: 'الأفضل للعائلات',
          price: 200,
          durationDays: 30,
          speed: 100,
          features: [
            'سرعة 100 ميجابت',
            'دعم فني على مدار الساعة',
            'بدون حد أقصى للتحميل',
            'أولوية في الدعم الفني',
          ],
          isPopular: true,
          isCurrentPlan: true,
        ),
        SubscriptionPlanModel(
          id: '3',
          name: 'الباقة الذهبية',
          description: 'للمستخدمين المحترفين',
          price: 350,
          durationDays: 30,
          speed: 200,
          features: [
            'سرعة 200 ميجابت',
            'دعم فني VIP',
            'بدون حد أقصى للتحميل',
            'IP ثابت',
            'أولوية قصوى',
          ],
        ),
      ];
}
