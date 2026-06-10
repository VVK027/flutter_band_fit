import 'package:flutter_band_fit_app/core/constants/global_constants.dart';
import 'package:flutter_band_fit_app/features/vitals/domain/repositories/vitals_sync_repository.dart';
import 'package:intl/intl.dart';

class ShouldSyncVitalsUseCase {
  ShouldSyncVitalsUseCase(this._repository);

  final VitalsSyncRepository _repository;

  bool call({DateTime? now}) {
    final lastSyncTime = _repository.getLastSyncDated();
    if (lastSyncTime.isEmpty) {
      return true;
    }

    DateTime parsedLastSync;
    try {
      parsedLastSync = DateFormat(defaultLastSyncDateTimeFormat)
          .parse(
            lastSyncTime,
            true,
          )
          .toLocal();
    } catch (_) {
      // If stored sync timestamp is malformed, force a sync.
      return true;
    }
    final currentTime = now ?? DateTime.now();
    final diffDays = currentTime.difference(parsedLastSync).inDays;

    if (diffDays >= 1) {
      return true;
    }

    final diffMinutes = currentTime.difference(parsedLastSync).inMinutes;
    return diffMinutes >= 3;
  }
}
