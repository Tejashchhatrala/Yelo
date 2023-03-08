import 'package:gharelu/src/core/entity/cancellation_reason_entity.dart';
import 'package:gharelu/src/core/entity/help_and_support_entity.dart';

class AppConstant {
  const AppConstant._();

  static const String users = 'users';
  static const String merchant = 'merchant';
  static const String merchants = 'merchants';
  static const String banners = 'banners';
  static const String services = 'services';
  static const String feedback = 'feedback';
  static const String rooms = 'rooms';
  static const String messages = 'messages';

  /// value `categories`
  static const String categories = 'categories';

  /// value `products`
  static const String products = 'products';

  static const List<CancellationReasonEntity> cancellationReason = [
    CancellationReasonEntity(
      title: 'Incorrect appointment',
      id: 1,
      description: 'The appointment was scheduled for the wrong date, time, or location.',
    ),
    CancellationReasonEntity(
      title: 'Rescheduling',
      id: 2,
      description: 'I needs to reschedule the appointment for a different date or time',
    ),
    CancellationReasonEntity(
      title: 'Conflict with owner',
      id: 3,
      description: 'I has a conflict with the person or organization that they were scheduled to meet with.',
    ),
    CancellationReasonEntity(
      title: 'Other',
      id: 4,
      description: 'There may be other reasons not listed here that are specific to the individual or the situation.',
    ),
  ];

  static List<HelpAndSupportEntity> helpAndSupport = const [
    HelpAndSupportEntity(
      name: 'Facebook Messenger',
      content: 'https://me.m/theaayushb',
      type: UtilityEnum.EMAIL,
    ),
    HelpAndSupportEntity(
      name: 'WhatsApp',
      content: 'https://web.whatsapp.com/+9779818630213',
      type: UtilityEnum.WEB,
    ),
    HelpAndSupportEntity(
      name: 'Viber',
      content: 'viber.com',
      type: UtilityEnum.WEB,
    ),
    HelpAndSupportEntity(
      name: 'Call +977 9818630213',
      content: '+977 9818630213',
      type: UtilityEnum.MOBILE,
    ),
    HelpAndSupportEntity(
      name: 'Email',
      content: 'theaayushb@gmail.com',
      type: UtilityEnum.MOBILE,
    ),
  ];
}

///
/// Incorrect appointment: The appointment was scheduled for the wrong date, time, or location.
// Rescheduling: The individual needs to reschedule the appointment for a different date or time.
// Change of mind: The individual no longer wants or needs the service or product that the appointment was for.
// Conflict with owner: The individual has a conflict with the person or organization that they were scheduled to meet with.
// Other: There may be other reasons not listed here that are specific to the individual or the situation.

enum MessageType { text, image }
