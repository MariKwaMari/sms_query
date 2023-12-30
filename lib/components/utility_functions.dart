// utility_functions.dart
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';

void extractCommonData(List<String> parts, String amount, String receiptNo) {
  if (parts.length >= 2) {
    receiptNo = parts[0].trim();
    amount = parts[1].split('.')[0].trim();
  }
}

// Add any other utility functions or classes here if needed
