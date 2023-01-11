class SleepDurationModel {
  late String dateTime;
  late  String stSleep;
  late  String stAwake;
  late  String stLight;
  late  String stDeep;
}
class HeartRateModel {
  late String stAvgHr;
  late String stMinHr;
  late String stMaxHr;
  late String stRealTimeHr;
}
class TempModel {
  late String stBodyTemp;
  late String stTempUnit;
}
class StepsModel {
  late String stTargettedSteps;
  late String stWalkedSteps;
  late String stWalkedKM;
  late String stBruntCal;

}
class Spo2Model {
  late String stMySPo2;
}

class DeviceDataModel {
  List<SleepDurationModel> sleepDurationList = [];
  List<HeartRateModel> heartRateList = [];
  List<TempModel> tempList = [];
  List<StepsModel> stepsList = [];
  List<Spo2Model> spo2List = [];


  DeviceDataModel(item) {
    if (item == null) {
      return;
    }

    if (item['walking'] != null) {
      for (var steps in item['walking']) {
        StepsModel stepsModel =  StepsModel();
        stepsModel.stWalkedSteps = steps['walked_steps'].toString();
        stepsModel.stTargettedSteps = steps['target_steps'].toString();
        this.stepsList.add(stepsModel);
      }
    }
    if (item['heart_rate'] != null) {
      for (var steps in item['heart_rate']) {
        HeartRateModel hrModel =  HeartRateModel();
        hrModel.stAvgHr = steps['avg'];
        hrModel.stMaxHr = steps['max'];
        hrModel.stMinHr = steps['min'];
        hrModel.stRealTimeHr = steps['real_time_value'];
        this.heartRateList.add(hrModel);
      }
    }
    if (item['temperature'] != null) {
      for (var steps in item['temperature']) {
        TempModel tempModel =  TempModel();
        tempModel.stTempUnit = steps['unit'];
        tempModel.stBodyTemp = steps['unit'];
        this.tempList.add(tempModel);
      }
    }
    if (item['sleep'] != null) {
      for (var steps in item['sleep']) {
        SleepDurationModel sleepModel =  SleepDurationModel();
        sleepModel.stDeep = steps['deep'];
        sleepModel.stAwake = steps['awake_hrs'];
        sleepModel.stLight = steps['light'];
        sleepModel.stSleep = steps['sleep_hrs'];
        this.sleepDurationList.add(sleepModel);
      }
    }
    if (item['spo2'] != null) {
      for (var steps in item['spo2']) {
        Spo2Model spo2Model =  Spo2Model();
        spo2Model.stMySPo2 = steps['device_type'];
        this.spo2List.add(spo2Model);
      }
    }
  }
}