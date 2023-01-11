/*
import 'dart:convert';

AllDataForSync welcomeFromMap(String str) => AllDataForSync.fromMap(json.decode(str));

String welcomeToMap(AllDataForSync data) => json.encode(data.toMap());

class AllDataForSync {
  AllDataForSync({
    this.deviceType,
    this.deviceId,
    this.deviceMacAddress,
    this.walking,
    this.bp,
    this.hr,
    this.temp,
    this.sleep,
    this.spo2,
  });

  final String deviceType;
  final String deviceId;
  final String deviceMacAddress;
  final List<Walking> walking;
  final List<Bp> bp;
  final List<Hr> hr;
  final List<Temp> temp;
  final List<Sleep> sleep;
  final List<Spo2> spo2;

  factory AllDataForSync.fromMap(Map<String, dynamic> json) => AllDataForSync(
        deviceType: json["device_type"],
        deviceId: json["device_id"],
        deviceMacAddress: json["device_macAddress"],
        walking:
            List<Walking>.from(json["walking"].map((x) => Walking.fromMap(x))),
        bp: List<Bp>.from(json["bp"].map((x) => Bp.fromMap(x))),
        hr: List<Hr>.from(json["hr"].map((x) => Hr.fromMap(x))),
        temp: List<Temp>.from(json["temp"].map((x) => Temp.fromMap(x))),
        sleep: List<Sleep>.from(json["sleep"].map((x) => Sleep.fromMap(x))),
        spo2: List<Spo2>.from(json["spo2"].map((x) => Spo2.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "device_type": deviceType,
        "device_id": deviceId,
        "device_macAddress": deviceMacAddress,
        "walking": List<dynamic>.from(walking.map((x) => x.toMap())),
        "bp": List<dynamic>.from(bp.map((x) => x.toMap())),
        "hr": List<dynamic>.from(hr.map((x) => x.toMap())),
        "temp": List<dynamic>.from(temp.map((x) => x.toMap())),
        "sleep": List<dynamic>.from(sleep.map((x) => x.toMap())),
        "spo2": List<dynamic>.from(spo2.map((x) => x.toMap())),
      };
}

class Bp {
  Bp({
    this.date,
    this.systolic,
    this.dystolic,
    this.unit,
  });

  final DateTime date;
  final String systolic;
  final String dystolic;
  final String unit;

  factory Bp.fromMap(Map<String, dynamic> json) => Bp(
        date: DateTime.parse(json["date"]),
        systolic: json["systolic"],
        dystolic: json["dystolic"],
        unit: json["unit"],
      );

  Map<String, dynamic> toMap() => {
        "date": date.toUtc().toIso8601String(),
        "systolic": systolic,
        "dystolic": dystolic,
        "unit": unit,
      };
}

class BpSystolic {
  BpSystolic({
    this.date,
    this.systolic,
  });

  final DateTime date;
  final String systolic;

  factory BpSystolic.fromMap(Map<String, dynamic> json) => BpSystolic(
        date: DateTime.parse(json["date"]),
        systolic: json["systolic"],
      );

  Map<String, dynamic> toMap() => {
        "date": date.toUtc().toIso8601String(),
        "systolic": systolic,
      };
}

class BpDystolic {
  BpDystolic({
    this.date,
    this.dystolic,
  });

  final DateTime date;
  final String dystolic;

  factory BpDystolic.fromMap(Map<String, dynamic> json) => BpDystolic(
        date: DateTime.parse(json["date"]),
        dystolic: json["dystolic"],
      );

  Map<String, dynamic> toMap() => {
        "date": date.toUtc().toIso8601String(),
        "dystolic": dystolic,
      };
}

class Hr {
  Hr({
    this.date,
    // this.avg,
    // this.min,
    // this.max,
    this.realTimeValue,
  });

  final DateTime date;

  // final String avg;
  // final String min;
  // final String max;
  final String realTimeValue;

  factory Hr.fromMap(Map<String, dynamic> json) => Hr(
        date: DateTime.parse(json["date"]),
        // avg: json["avg"],
        // min: json["min"],
        // max: json["max"],
        realTimeValue: json["real_time_value"],
      );

  Map<String, dynamic> toMap() =>
      {
        "date": date.toUtc().toIso8601String(),
        // "avg": avg,
        // "min": min,
        // "max": max,
        "real_time_value": realTimeValue,
      };
}

class Sleep {
  Sleep({
    this.date,
    this.deep,
    this.light,
    this.awakeHrs,
    this.sleepHrs,
    this.startTime,
    this.endTime,
  });

  final DateTime date;
  final String deep;
  final String light;
  final String awakeHrs;
  final String sleepHrs;
  final String startTime;
  final String endTime;

  factory Sleep.fromMap(Map<String, dynamic> json) => Sleep(
        date: DateTime.parse(json["date"]),
        deep: json["deep"],
        light: json["light"],
        awakeHrs: json["awake_hrs"],
        sleepHrs: json["sleep_hrs"],
        startTime: json["start_time"],
        endTime: json["end_time"],
      );

  Map<String, dynamic> toMap() =>
      {
        "date": date.toUtc().toIso8601String(),
        "deep": deep,
        "light": light,
        "awake_hrs": awakeHrs,
        "sleep_hrs": sleepHrs,
        "start_time": startTime,
        "end_time": endTime,
      };
}

class SleepInBed {
  SleepInBed({
    this.date,
    this.deep,
  });

  final DateTime date;
  final double deep;

  factory SleepInBed.fromMap(Map<String, dynamic> json) =>
      SleepInBed(
        date: DateTime.parse(json["date"]),
        deep: json["deep"],

      );

  Map<String, dynamic> toMap() =>
      {
        "date": date.toUtc().toIso8601String(),
        "deep": deep,

      };
}

class SleepAsleep {
  SleepAsleep({
    this.date,
    this.light,

  });

  final DateTime date;
  final double light;

  factory SleepAsleep.fromMap(Map<String, dynamic> json) =>
      SleepAsleep(
        date: DateTime.parse(json["date"]),
        light: json["light"],
      );

  Map<String, dynamic> toMap() =>
      {
        "date": date.toUtc().toIso8601String(),
        "light": light,
      };
}

class SleepAwake {
  SleepAwake({
    this.date,
    this.awakeHrs,
  });

  final DateTime date;
  final double awakeHrs;

  factory SleepAwake.fromMap(Map<String, dynamic> json) =>
      SleepAwake(
        date: DateTime.parse(json["date"]),
        awakeHrs: json["awake_hrs"],
      );

  Map<String, dynamic> toMap() =>
      {
        "date": date.toUtc().toIso8601String(),
        "awake_hrs": awakeHrs,
      };
}

class SleepTotal {
  SleepTotal({
    this.date,
    this.totalKm,
    this.totalDayCal,
    this.totalSleepInBed
  });

  final DateTime date;
  final double totalKm;
  final double totalDayCal;
  final double totalSleepInBed;

  factory SleepTotal.fromMap(Map<String, dynamic> json) =>
      SleepTotal(
        date: DateTime.parse(json["date"]),
        totalKm: json["totalKm"],
        totalDayCal: json["totalDayCal"],
        totalSleepInBed: json["totalSleepInBed"],
      );

  Map<String, dynamic> toMap() =>
      {
        "date": date.toUtc().toIso8601String(),
        "totalKm": totalKm,
        "totalDayCal": totalDayCal,
        "totalSleepInBed": totalSleepInBed,
      };
}

class Spo2 {
  Spo2({
    this.date,
    this.spo2,
  });

  final DateTime date;
  final String spo2;

  factory Spo2.fromMap(Map<String, dynamic> json) =>
      Spo2(
        date: DateTime.parse(json["date"]),
        spo2: json["spo2"],
      );

  Map<String, dynamic> toMap() =>
      {
        "date": date.toUtc().toIso8601String(),
        "spo2": spo2,
      };
}

class Temp {
  Temp({
    this.date,
    this.unit,
    this.temperature,
  });

  final DateTime date;
  final String unit;
  final String temperature;

  factory Temp.fromMap(Map<String, dynamic> json) =>
      Temp(
        date: DateTime.parse(json["date"]),
        unit: json["unit"],
        temperature: json["temperature"],
      );

  Map<String, dynamic> toMap() =>
      {
        "date": date.toUtc().toIso8601String(),
       // "temp_unit": temp_unit,
        "unit": unit,
        "temperature": temperature,
      };
}

class Walking {
  Walking({
    this.date,
    this.targetSteps,
    this.walked_steps,
    this.calories,
    this.distance,
  });


  final DateTime date;
  final String targetSteps;
  final int walked_steps;
  final String calories;
  final String distance;

  factory Walking.fromMap(Map<String, dynamic> json) =>
      Walking(
        date: DateTime.parse(json["date"]),
        targetSteps: json["target_steps"],
        walked_steps: json["walked_steps"],
        calories: json["calories"],
        distance: json["distance"],
      );

  Map<String, dynamic> toMap() =>
      {
        "date": date.toUtc().toIso8601String(),
        "target_steps": targetSteps,
        "walked_steps": walked_steps,
        "calories": calories,
        "distance": distance,
      };
}

class WalkingSteps {
  WalkingSteps({
    this.date,
    this.steps,
  });

  final DateTime date;
  final int steps;

  factory WalkingSteps.fromMap(Map<String, dynamic> json) =>
      WalkingSteps(
        date: DateTime.parse(json["date"]),
        steps: json["steps"],

      );

  Map<String, dynamic> toMap() =>
      {
        "date": date.toUtc().toIso8601String(),
        "steps": steps,

      };
}
*/
