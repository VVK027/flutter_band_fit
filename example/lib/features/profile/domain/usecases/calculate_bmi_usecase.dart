class BmiResult {
  const BmiResult({
    required this.value,
    required this.status,
  });

  final String value;
  final String status;
}

class CalculateBmiUseCase {
  BmiResult call({
    required int heightInCm,
    required double weightInKg,
  }) {
    final bmiValueNum = 10000 * weightInKg / (heightInCm * heightInCm);
    final bmiRounded = bmiValueNum.roundToDouble().toString();

    if (bmiValueNum < 18.5) {
      return BmiResult(value: bmiRounded, status: 'bmi_under_weight');
    }
    if (bmiValueNum > 18.5 && bmiValueNum < 24.9) {
      return BmiResult(value: bmiRounded, status: 'bmi_fit');
    }
    if (bmiValueNum > 25.0 && bmiValueNum < 29.0) {
      return BmiResult(value: bmiRounded, status: 'bmi_over_weight');
    }
    if (bmiValueNum > 30.0) {
      return BmiResult(value: bmiRounded, status: 'bmi_obese');
    }
    return BmiResult(value: bmiRounded, status: 'bmi_fit');
  }
}
