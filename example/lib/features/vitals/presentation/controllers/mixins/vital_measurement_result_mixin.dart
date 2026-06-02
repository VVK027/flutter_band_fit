import 'package:flutter_band_fit_app/features/vitals/presentation/controllers/mixins/vital_detail_date_mixin.dart';
import 'package:get/get.dart';

/// Helpers for applying manual vital readings to detail-screen state.
mixin VitalMeasurementResultMixin on GetxController {
  VitalDetailDateMixin get dateMixin => this as VitalDetailDateMixin;

  DateTime parseVitalPointTime(DateTime day, String time) {
    final trimmed = time.trim();
    if (trimmed.isEmpty) return day;

    final parts = trimmed.split(':');
    if (parts.length >= 2) {
      return DateTime(
        day.year,
        day.month,
        day.day,
        int.tryParse(parts[0]) ?? 0,
        int.tryParse(parts[1]) ?? 0,
        parts.length >= 3 ? (int.tryParse(parts[2]) ?? 0) : 0,
      );
    }

    if (trimmed.length >= 4) {
      final hourPart = trimmed.substring(0, trimmed.length - 2);
      final minutePart = trimmed.substring(trimmed.length - 2);
      return DateTime(
        day.year,
        day.month,
        day.day,
        int.tryParse(hourPart) ?? 0,
        int.tryParse(minutePart) ?? 0,
      );
    }

    return day;
  }

  Future<void> refreshTodayAfterReading(
    Future<void> Function(DateTime day) loadDay,
  ) async {
    final now = DateTime.now();
    dateMixin.syncSelectedDay(now);
    await loadDay(now);
  }

  bool mapAlreadyContainsReading(List data, Map<String, dynamic> reading) {
    return data.any((entry) {
      if (entry is! Map) return false;
      final entryMap = Map<String, dynamic>.from(entry);
      return entryMap['calender']?.toString() == reading['calender']?.toString() &&
          entryMap['time']?.toString() == reading['time']?.toString() &&
          _readingValue(entryMap) == _readingValue(reading);
    });
  }

  String _readingValue(Map<String, dynamic> entry) {
    if (entry.containsKey('value')) {
      return entry['value'].toString();
    }
    if (entry.containsKey('high') && entry.containsKey('low')) {
      return '${entry['high']}/${entry['low']}';
    }
    if (entry.containsKey('inCelsius')) {
      return entry['inCelsius'].toString();
    }
    return entry.toString();
  }
}
