import Flutter
import UIKit
import UTESmartBandApi

public class SwiftFlutterBandFitPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
    private var eventChannelSink: FlutterEventSink?
    private var bpChannelSink: FlutterEventSink?

    //private var callbackId :NSMutableDictionary

    var smartBandMgr = UTESmartBandClient.init()
    var smartBandTool = BandDelegateTool.init()

    open var listDevices : [UTEModelDevices] = NSMutableArray.init() as! [UTEModelDevices]

    var connectedDevice : UTEModelDevices?
    //var uteManagerDelegate = UTEManagerDelegate
    //weak var connectVc : BandConnectedControl?

    private var syncDateTime : String = "2022-01-01-01-01"

    override init() {
        //self.callbackId = NSMutableDictionary()
        super.init()
        self.smartBandMgr = UTESmartBandClient.sharedInstance()
        self.smartBandMgr.initUTESmartBandClient();
        //EN:Print log
        self.smartBandMgr.debugUTELog = true


        self.smartBandMgr.delegate = self.smartBandTool
        //self.connectivityProvider.connectivityUpdateHandler = connectivityUpdateHandler
        print(GlobalConstants.GET_LAST_DEVICE_ADDRESS)
        self.registerDeviceCallback()
    }


    public static func register(with registrar: FlutterPluginRegistrar) {
        let binaryMessenger = registrar.messenger()
        let instance = SwiftFlutterBandFitPlugin()

        let methodChannel = FlutterMethodChannel(name: GlobalConstants.SMART_METHOD_CHANNEL, binaryMessenger: binaryMessenger)

        let eventChannel = FlutterEventChannel(name: GlobalConstants.SMART_EVENT_CHANNEL, binaryMessenger: binaryMessenger)
        let bpEventChannel = FlutterEventChannel(name: GlobalConstants.SMART_BP_TEST_CHANNEL, binaryMessenger: binaryMessenger)
       // let oxygenEventChannel = FlutterEventChannel(name: GlobalConstants.SMART_OXYGEN_TEST_CHANNEL, binaryMessenger: binaryMessenger)
       // let tempEventChannel = FlutterEventChannel(name: GlobalConstants.SMART_TEMP_TEST_CHANNEL, binaryMessenger: binaryMessenger)

        //let callBackChannel = FlutterMethodChannel(name: GlobalConstants.SMART_CALLBACK, binaryMessenger: binaryMessenger)

        eventChannel.setStreamHandler(instance)
        bpEventChannel.setStreamHandler(instance)
       // oxygenEventChannel.setStreamHandler(instance)
       // tempEventChannel.setStreamHandler(instance)


        registrar.addMethodCallDelegate(instance, channel: methodChannel)
        // registrar.addMethodCallDelegate(instance, channel: callBackChannel)
    }

    public func detachFromEngine(for registrar: FlutterPluginRegistrar) {
        eventChannelSink = nil
        bpChannelSink = nil
        //connectivityProvider.stop()

    }
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        // connectivityProvider.stop()
       // eventChannelSink = nil
       // bpChannelSink = nil
        print("onCancel_arguments>> \(String(describing: arguments))")
        if let argument = arguments as? String {
           if (argument == GlobalConstants.SMART_EVENT_CHANNEL) {
               eventChannelSink = nil
            }
            else if (argument == GlobalConstants.SMART_BP_TEST_CHANNEL) {
                bpChannelSink = nil
            }else{
                // Unknown stream listener registered
            }
        }
        return nil
    }
    public func onListen(withArguments arguments: Any?,eventSink events: @escaping FlutterEventSink) -> FlutterError? {
       // eventSink = events
        print("onListen_arguments>> \(String(describing: arguments))")
        print("on_events>> \(String(describing: events))")
        if let argument = arguments as? String {
           if (argument == GlobalConstants.SMART_EVENT_CHANNEL) {
               eventChannelSink = events
            }
            else if (argument == GlobalConstants.SMART_BP_TEST_CHANNEL) {
                bpChannelSink = events
            }else{
                // Unknown stream listener registered
            }
        }
        // connectivityProvider.start()
        //connectivityUpdateHandler(connectivityType: connectivityProvider.currentConnectivityType)
        return nil
    }

    func registerDeviceCallback(){
        DispatchQueue.main.async {

            self.smartBandTool.getDevicesList = {(mArrayDevices : [UTEModelDevices]) in
                print("count in update>> \(mArrayDevices.count)")
                self.listDevices = mArrayDevices
                var deviceData : [Any] = [];

                self.listDevices.forEach{model in
                    let jsonObject = ["name": model.name as NSString, "address": model.advertisementAddress!.uppercased() as NSString,"rssi": model.rssi as NSInteger,"identifier": model.identifier as NSString,"bondState":"","alias":""] as [String : Any]
                    deviceData.append(jsonObject)
                }
                print(deviceData);
                self.pushEventCallBack(result: GlobalConstants.UPDATE_DEVICE_LIST, status: GlobalConstants.SC_SUCCESS, sendData: deviceData)
            }

            self.smartBandTool.manageStateCallback = {(resultant :String, data : Any) in
                print("main>>event>>resultant>> \(resultant)")
                self.pushEventCallBack(result: resultant, status: GlobalConstants.SC_SUCCESS, sendData: data)
            }
            self.smartBandTool.otherStateCallback = {(resultant :String, data : Any) in
                print("main>>bp>>resultant>> \(resultant)")
                self.pushBPEventCallBack(result: resultant, status: GlobalConstants.SC_SUCCESS, sendData: data)
            }
        }
    }

    private func pushEventCallBack(result: String, status: String, sendData: Any) {

        let jsonSendObj: [String: Any] = [
            "status" : status,
            "result" : result,
            "data": sendData
        ]

        print("jsonSendObj>> \(jsonSendObj)")
        //DispatchQueue.main.async {
        DispatchQueue.global().async {
            let resultData = try! JSONSerialization.data(withJSONObject: jsonSendObj)
            let jsonString = String(data: resultData, encoding: .utf8)!
            self.eventChannelSink?(jsonString)
        }
    }

    private func pushBPEventCallBack(result: String, status: String, sendData: Any) {

        let jsonSendObj: [String: Any] = [
            "status" : status,
            "result" : result,
            "data": sendData
        ]

        print("jsonSendObj>> \(jsonSendObj)")
        //DispatchQueue.main.async {
        DispatchQueue.global().async {
            let resultData = try! JSONSerialization.data(withJSONObject: jsonSendObj)
            let jsonString = String(data: resultData, encoding: .utf8)!
            self.bpChannelSink?(jsonString)
        }
    }



    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        print("IOS_HANDLER " + call.method)
        switch call.method {
            //        case GlobalConstants.DEVICE_RE_INITIATE:
            //            self.deviceReInitialize(returnResult: result)

        case GlobalConstants.DEVICE_INITIALIZE:
            self.deviceInitialize(result: result)

        case GlobalConstants.START_DEVICE_SEARCH:
            self.searchForBTDevices(result: result)

        case GlobalConstants.BIND_DEVICE:
            self.connectBluDevice(call: call,result: result)

        case GlobalConstants.RE_BIND_DEVICE:
            self.reconnectBluDevice(call: call,result: result)

        case GlobalConstants.UNBIND_DEVICE:
            self.disconnectBluDevice(result: result);

        case GlobalConstants.SET_USER_PARAMS:
            self.setUserParams(call: call, result: result);

        case GlobalConstants.CHECK_CONNECTION_STATUS:
            self.getCheckConnectionStatus(result: result)

        case GlobalConstants.GET_LAST_DEVICE_ADDRESS:
            self.getLastConnectedAddress(result: result)

        case GlobalConstants.SET_24_HEART_RATE:
            self.set24HeartRate(call: call,result: result)

        case GlobalConstants.SET_24_OXYGEN:
            self.set24BloodOxygen(call: call,result: result)

        case GlobalConstants.SET_24_TEMPERATURE_TEST:
            self.set24HrTemperatureTest(call: call,result: result)

        case GlobalConstants.SET_WEATHER_INFO:
            self.setSevenDaysWeatherInfo(call: call,result: result)

        case GlobalConstants.SET_BAND_LANGUAGE:
            self.setDeviceBandLanguage(call: call, result: result)

        case GlobalConstants.SET_DO_NOT_DISTURB:
            self.setDoNotDisturb(call: call, result: result)


        case GlobalConstants.GET_DEVICE_VERSION:
            self.getDeviceVersion(result: result)

        case GlobalConstants.GET_DEVICE_BATTERY_STATUS:
            self.getDeviceBatteryStatus(result: result)
        case GlobalConstants.CHECK_QUICK_SWITCH_SETTING:
            self.callCheckQuickSwitchStatus(result: result)


        case GlobalConstants.START_BP_TEST:
            self.startBloodPressure(result: result)
        case GlobalConstants.STOP_BP_TEST:
            self.stopBloodPressure(result: result)
        case GlobalConstants.START_OXYGEN_TEST:
            self.startOxygenSaturation(result: result)
        case GlobalConstants.STOP_OXYGEN_TEST:
            self.stopOxygenSaturation(result: result)
        case GlobalConstants.START_TEST_TEMP:
            self.startTempTest(result: result)

            //sync calls
        case GlobalConstants.GET_SYNC_STEPS:
            self.syncAllStepsData(result: result)
        case GlobalConstants.GET_SYNC_SLEEP:
            self.syncAllSleepData(result: result)
        case GlobalConstants.GET_SYNC_RATE:
            self.syncRateData(result: result)
        case GlobalConstants.GET_SYNC_BP:
            self.syncBloodPressure(result: result)
        case GlobalConstants.GET_SYNC_OXYGEN:
            self.syncOxygenSaturation(result: result)
        case GlobalConstants.GET_SYNC_TEMPERATURE:
            self.syncBodyTemperature(result: result)
        case GlobalConstants.GET_SYNC_SPORT_INFO:
            self.syncAllSportsInfo(result: result)

       // case GlobalConstants.FETCH_STEPS_BY_DATE:
         //   self.fetchStepsBySelectedDate(call: call, result: result)

            //fetchoveralldata
        case GlobalConstants.FETCH_OVERALL_DEVICE_DATA:
            self.fetchOverAllDeviceData(result: result)

        case GlobalConstants.FIND_BAND_DEVICE:
            self.findBandDevice(result: result)

        case GlobalConstants.RESET_DEVICE_DATA:
            self.deleteDevicesAllData(result: result)

        case GlobalConstants.READ_ONLINE_DIAL_CONFIG:
            self.readOnlineDialConfig(result: result)

        case GlobalConstants.PREPARE_SEND_ONLINE_DIAL:
            self.prepareSendOnlineDialData(result: result)

        case GlobalConstants.SEND_ONLINE_DIAL_PATH:
            self.sendOnlineDialPath(call: call,result: result)

        case GlobalConstants.STOP_ONLINE_DIAL_DATA:
            self.stopOnlineDialData(result: result)


        case "ios":
            result("iOS " + UIDevice.current.systemVersion)

        default:
            result(FlutterMethodNotImplemented)
        }
    }



    // SDK Methods Starts Here
    public func deviceReInitialize(returnResult: FlutterResult){

        self.smartBandMgr = UTESmartBandClient.sharedInstance()
        self.smartBandMgr.initUTESmartBandClient();
        //EN:Print log
        self.smartBandMgr.debugUTELog = true
        self.smartBandMgr.delegate = self.smartBandTool
        self.smartBandMgr.isScanRepeat = true
        self.smartBandMgr.filerRSSI = -90
        self.smartBandMgr.filerServers = ["5533","2222","FEE7"]

        print("re-sdk vsersion = \(self.smartBandMgr.sdkVersion())")
        self.smartBandMgr.delegate = self.smartBandTool
        // return nil
        //self.smartBandMgr.startScanDevices()
        //self.smartBandMgr.stopScanDevices()

        //self.smartBandMgr.delegate = self.smartBandTool

        returnResult(GlobalConstants.SC_RE_INIT)
    }

    func deviceInitialize(result: FlutterResult){
        //do {
        //self.smartBandMgr.initUTESmartBandClient()
        self.smartBandMgr.debugUTELog = true
        self.smartBandMgr.isScanRepeat = true
        self.smartBandMgr.filerRSSI = -99
        self.smartBandMgr.filerServers = ["5533","2222","FEE7"]
        print("log sdk vsersion = \(self.smartBandMgr.sdkVersion())")

        //self.smartBandMgr.delegate = self.smartBandTool
        //                if let bundlePath = Bundle.main.path(forResource: name,
        //                                                     ofType: "json"),
        //                    let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
        //                    return jsonData
        //                }
        result(GlobalConstants.SC_INIT)
        //} catch {
        //     print("IOS: Could not initalize")
        //     returnResult(GlobalConstants.SC_FAILURE)
        // }
    }



    public func searchForBTDevices(result: FlutterResult){
        //print("inseide device start scan")
        //self.registerDeviceCallback()

        //print(self.smartBandMgr.isScanRepeat)
        //self.smartBandMgr.isScanRepeat = true
        print(self.smartBandMgr.isScanRepeat)
        self.smartBandTool.mArrayDevices.removeAll()
        // DispatchQueue.main.async {
        self.smartBandMgr.startScanDevices()

        let jsonObject: [String: Any] = [
            "status" : GlobalConstants.SC_SUCCESS,
            "data": []
        ]

        let resultData = try! JSONSerialization.data(withJSONObject: jsonObject)
        let jsonString = String(data: resultData, encoding: .utf8)!
        result(jsonString)
    }

    func connectBluDevice(call: FlutterMethodCall, result: FlutterResult){
        var bleResult : NSNumber? = false
        if let args = call.arguments as? Dictionary<String, Any>{
            print("connect_arguments  \(String(describing: args))")

            let address = args["address"] as? String
            let name = args["name"] as? String
            let identifier = args["identifier"] as? String

            print("connect_arguments_address  \(String(describing: address))")
            print("connect_arguments_address  \(String(describing: name))")


            if self.smartBandTool.mArrayDevices.count == 0 {
                self.smartBandMgr.startScanDevices()
                return
            } else{
                let index = self.smartBandTool.mArrayDevices.firstIndex(where: {$0.advertisementAddress.uppercased() == address?.uppercased()}) ?? nil

                print("connect_index \(String(describing: index))")

                if index != nil {
                    let model = self.smartBandTool.mArrayDevices[index!]
                    print("connect_with  \(String(describing: model.name))")


                    self.smartBandMgr.connect(model)
                    self.connectedDevice = model
                    bleResult = true

                    print("isHasBluetooth \(String(describing: self.connectedDevice?.isHasBluetooth3))")
                    result(bleResult)
                }else{
                    result(bleResult)
                }
            }
        } else {
            result(bleResult)
            //result(FlutterError.init(code: "errorSetDebug", message: "data or format error", details: nil))
        }
    }

    func reconnectBluDevice(call: FlutterMethodCall, result: FlutterResult){
        var bleResult : NSNumber? = false
        if let args = call.arguments as? Dictionary<String, Any>{
            let address = args["address"] as? String
            //let name = args["name"] as? String
            //let identifier = args["identifier"] as? String

            if self.smartBandTool.mArrayDevices.count > 0 {
                let index = self.smartBandTool.mArrayDevices.firstIndex(where: {$0.advertisementAddress.uppercased() == address?.uppercased()}) ?? nil
                print("connect_index \(String(describing: index))")
                if index != nil {
                    let model = self.smartBandTool.mArrayDevices[index!]
                    self.smartBandMgr.stopScanDevices()
                    self.smartBandMgr.connect(model)
                    self.connectedDevice = model
                    bleResult = true
                    result(bleResult)
                }else{
                    result(bleResult)
                }
            }else{
                result(bleResult)
            }
        }else{
            result(bleResult)
        }
    }

    func disconnectBluDevice(result: FlutterResult) {
       if self.connectedDevice != nil {
            DispatchQueue.main.async {
            self.smartBandMgr.disConnect(self.connectedDevice!)
            }
         result(true)
       }else{
         result(false)

       }
        //devicesID = connectDevices.identifier;
//        UTEModelDevices devices = [[UTEModelDevices alloc] init];
//        devices.identifier = _devicesID;
//        [self.smartBandMgr disConnectUTEModelDevices:connectedDevice];
//        let devices = UTEModelDevices.init()
//        //devices.identifier = self.devicesID as String?
//        print("devices \(String(describing: devices.name))")
//        self.smartBandMgr.disConnect(devices)
    }

    func setUserParams(call: FlutterMethodCall, result: FlutterResult) {
        if let args = call.arguments as? Dictionary<String, Any>{
            print("user_params_arguments \(String(describing: args))")
            let group = DispatchGroup()
            group.enter()

            DispatchQueue.global().async {
                let ageStr = args["age"] as? String
                let heightStr = args["height"] as? String
                let weightStr = args["weight"] as? String
                let genderStr = args["gender"] as? String
                let stepsStr = args["steps"] as? String
                let isCelsiusStr = args["isCelsius"] as? String
                let screenOffTimeStr = args["screenOffTime"] as? String
                let isChineseLangStr = args["isChineseLang"] as? String
                let raiseHandWakeUpStr = args["raiseHandWakeUp"] as? String

                //print("user1 age =\(String(describing: ageStr)) height =\(String(describing: heightStr)) weight =\(String(describing: weightStr))")
                // print("user2 gender =\(String(describing: genderStr)) steps =\(String(describing: stepsStr)) isCelsius =\(String(describing: isCelsiusStr))")
                // print("user3 screenOffTime =\(String(describing: screenOffTimeStr)) isChineseLang =\(String(describing: isChineseLangStr)) raiseHandWakeUp =\(String(describing: raiseHandWakeUpStr)) ")

                //EN:Turn off scan
                self.smartBandMgr.stopScanDevices()
                //EN:Set device time
                self.smartBandMgr.setUTEOption(UTEOption.syncTime)
                //EN:Set device unit: meters or inches
                // self.smartBandMgr.setUTEOption(UTEOption.unitInch)
                self.smartBandMgr.setUTEOption(UTEOption.unitMeter)


                var heightFloat: CGFloat?
                var weightFloat: CGFloat?

                if let doubleValue = Double(heightStr ?? "0.0") {
                    heightFloat = CGFloat(doubleValue)
                }

                if let doubleValue = Double(weightStr ?? "0.0") {
                    weightFloat = CGFloat(doubleValue)
                }

                let age = Int(ageStr ?? "0")

                let genderSex : UTEDeviceInfoSex
                if genderStr?.lowercased() == "female" {
                    genderSex = UTEDeviceInfoSex.female
                }else if genderStr?.lowercased() == "male"{
                    genderSex =  UTEDeviceInfoSex.male
                }else{
                    genderSex = UTEDeviceInfoSex.default
                }

                let stepsTarget = Int(stepsStr ?? "8000")

                let screenLightTime = Int(screenOffTimeStr ?? "6")

                var handLight = 0
                if raiseHandWakeUpStr?.lowercased() == "true" {
                    handLight = 1
                } else if raiseHandWakeUpStr?.lowercased() == "false" {
                    handLight = -1
                }else{
                    handLight = 0
                }

                print("values_after H=\(String(describing: heightFloat)) W=\(String(describing: weightFloat)) A=\(String(describing: age)) G=\(String(describing: genderSex)) T=\(String(describing: stepsTarget)) SL=\(String(describing: screenLightTime)) HL=\(String(describing: handLight))")

                let infoModel = UTEModelDeviceInfo.init()
                infoModel.heigh = heightFloat!
                infoModel.weight = weightFloat!
                infoModel.age = age!
                infoModel.sex = genderSex
                infoModel.sportTarget = stepsTarget!
                // light  (unit second), range<5,60>
                infoModel.lightTime = screenLightTime!
                // Hand Light 1 is open, -1 is close, 0 is default
                infoModel.handlight = handLight


                var isChinese : Bool = false
                var isCelFah : Bool = false

                if isChineseLangStr?.lowercased() == "true" {
                    isChinese = true
                }else{
                    isChinese = true
                }

                if isCelsiusStr?.lowercased() == "true" {
                    isCelFah = false
                }else{
                    isCelFah = true
                }
                self.connectedDevice = self.smartBandMgr.connectedDevicesModel!
                if self.smartBandMgr.connectedDevicesModel!.isHasSwitchCH_EN {
                    infoModel.languageIsChinese = isChinese
                }

                if self.smartBandMgr.connectedDevicesModel!.isHasSwitchTempUnit {
                    infoModel.isFahrenheit = isCelFah
                }

                self.smartBandMgr.setUTEInfoModel(infoModel)
                group.leave()
            }
            group.wait()
            //print("information_set_returning")
            result(GlobalConstants.SC_INIT)
        }else {
            result(GlobalConstants.SC_FAILURE)
            // result(FlutterError.init(code: "errorSetDebug", message: "data or format error", details: nil))
        }
    }

//    func setConnectedDeviceControl() {
//        DispatchQueue.main.async {
//            if weakSelf!.connectVc == nil {
//
//                let vc = SmartBandConnectedControl.init(style: UITableView.Style.grouped)
//                vc.devicesID = self.smartBandMgr.connectedDevicesModel?.identifier as NSString?
//            }
//        }
//
//        dispatch_async(dispatch_get_main_queue(), ^(void) {
//            if (!self.connectVc) {
//
//                UINavigationController *nav = (UINavigationController *)window.rootViewController;
//                SmartBandConnectedControl *vc = [[SmartBandConnectedControl alloc] initWithStyle:UITableViewStyleGrouped];
//                vc.devicesID = connectDevices.identifier;
//                [nav pushViewController:vc animated:YES];
//                self.connectVc = vc;
//                __weak typeof(self)weakSelf = self;
//                vc.onClickModifyPasswordBlock = ^{
//                    [weakSelf onClickModifyPassword];
//                };
//
//            }
//
//        });
//    }

    func getCheckConnectionStatus(result: FlutterResult) {
        var connectResult : NSNumber? = false
        let connectedModel = self.smartBandMgr.connectedDevicesModel
        print("connectedModel==\(String(describing: connectedModel))")

        //self.smartBandMgr.connectedDevicesModel?.isHasBluetooth3

       // print("readUTEBluetooth3StatushashValue==\(String(describing: self.smartBandMgr.readUTEBluetooth3Status().hashValue))")
       // print("readUTEBluetooth3Description==\(String(describing: self.smartBandMgr.readUTEBluetooth3Status().description))")

       // self.smartBandMgr.setUTEBluetooth3_0Key(T##key: Int##Int, allowConnect: <#T##Bool#>)

        let modelArray = self.smartBandMgr.retrieveConnectedDevice(withServers: ["5533"])
        print("modelArray1==\(String(describing: modelArray))")
        if modelArray?.count != 0 {
            let model : UTEModelDevices = (modelArray?.first)!
            print("modelArray2==\(String(describing: model.versionName))-\(String(describing: model.addressStr))")
        }

        if connectedModel != nil && connectedModel!.isConnected {
            //let status = connectedModel!.isConnected
            //connectResult = status as NSNumber
            connectResult = true
            result(connectResult)
        }else{
            result(connectResult)
        }
    }

    func getLastConnectedAddress(result: FlutterResult) {
        var connectAddress = "";
        let connectedModel = self.smartBandMgr.connectedDevicesModel
        if connectedModel != nil {
            //let status = connectedModel!.isConnected
            //connectResult = status as NSNumber
            //connectAddress = connectedModel!.advertisementAddress
            if connectedModel?.advertisementAddress != nil{
               connectAddress = connectedModel?.advertisementAddress ?? ""
            }
            result(connectAddress)
        }else{
            result(connectAddress)
        }
    }

    func getDeviceVersion(result: FlutterResult) {
        self.smartBandMgr.readUTEDeviceVersion()
        result(GlobalConstants.SC_INIT)
    }

    func getDeviceBatteryStatus(result: FlutterResult) {

        if self.smartBandMgr.connectedDevicesModel!.isConnected {
            self.smartBandMgr.setUTEOption(UTEOption.readDevicesBattery)
            result(GlobalConstants.SC_INIT)
        }else{
            result(GlobalConstants.SC_FAILURE)
        }
    }

    func findBandDevice(result: FlutterResult) {
        if self.smartBandMgr.connectedDevicesModel!.isConnected {

            self.smartBandMgr.setUTEOption(UTEOption.findBand)
            //self.smartBandMgr.setvi(UTEOption.findBand)

            //self.smartBandMgr.setUTEOption(UTEOption.findPhoneFunctionOpen)
            //self.smartBandMgr.setUTEOption(UTEOption.findPhoneFunctionClose)
            result(GlobalConstants.SC_INIT)
        }else{
            result(GlobalConstants.SC_FAILURE)
        }
    }

    func deleteDevicesAllData(result: FlutterResult) {
        if self.smartBandMgr.connectedDevicesModel!.isConnected {
            self.smartBandMgr.setUTEOption(UTEOption.deleteDevicesAllData)
            result(GlobalConstants.SC_INIT)
        }else{
            result(GlobalConstants.SC_FAILURE)
        }
    }


    func startBloodPressure(result: FlutterResult) {
        if self.smartBandMgr.connectedDevicesModel!.isConnected {
            DispatchQueue.global().async {
                //self.smartBandMgr.setUTEOption(UTEOption.bloodOxygenDetectingStart)
                self.smartBandMgr.setUTEOption(UTEOption.bloodDetectingStart)
            }
            result(GlobalConstants.SC_INIT)
        }else{
            result(GlobalConstants.SC_FAILURE)
        }
    }

    func stopBloodPressure(result: FlutterResult) {
        if self.smartBandMgr.connectedDevicesModel!.isConnected {
            DispatchQueue.global().async {
                self.smartBandMgr.setUTEOption(UTEOption.bloodDetectingStop)
            }
            result(GlobalConstants.SC_INIT)
        }else{
            result(GlobalConstants.SC_FAILURE)
        }
    }

    func startOxygenSaturation(result: FlutterResult) {
        if self.smartBandMgr.connectedDevicesModel!.isConnected {
            DispatchQueue.global().async {
                self.smartBandMgr.setUTEOption(UTEOption.bloodOxygenDetectingStart)
            }
            result(GlobalConstants.SC_INIT)
        }else{
            result(GlobalConstants.SC_FAILURE)
        }
    }

    func stopOxygenSaturation(result: FlutterResult) {
        if self.smartBandMgr.connectedDevicesModel!.isConnected {
            DispatchQueue.global().async {
                self.smartBandMgr.setUTEOption(UTEOption.bloodOxygenDetectingStop)
            }
            result(GlobalConstants.SC_INIT)
        }else{
            result(GlobalConstants.SC_FAILURE)
        }
    }

    func startTempTest(result: FlutterResult) {
        if self.smartBandMgr.connectedDevicesModel!.isConnected {
            DispatchQueue.global().async {
                self.smartBandMgr.readBodyTemperatureCurrent()
            }
            result(GlobalConstants.SC_INIT)
        }else{
            result(GlobalConstants.SC_FAILURE)
        }
    }


    func set24HeartRate(call: FlutterMethodCall, result: FlutterResult) {
        if let args = call.arguments as? Dictionary<String, Any>{
            let enableStr = args["enable"] as? String
            DispatchQueue.global().async {
                if enableStr?.lowercased() == "true" {
                    self.smartBandMgr.setUTEOption(UTEOption.open24HourHRM)
                }else {
                    self.smartBandMgr.setUTEOption(UTEOption.close24HourHRM)
                }
            }
            //self.smartBandMgr.connectedDevicesModel?.isHas24HourHRM
            print("24_hrm_status \(String(describing: self.smartBandMgr.connectedDevicesModel?.isHas24HourHRM))")
            result(GlobalConstants.SC_INIT)
        }else{
            result(GlobalConstants.SC_FAILURE)
        }
    }

    func set24BloodOxygen(call: FlutterMethodCall, result: FlutterResult) {
        if let args = call.arguments as? Dictionary<String, Any>{
            let enableStr = args["enable"] as? String
            DispatchQueue.global().async {
                if enableStr?.lowercased() == "true" {
                    self.smartBandMgr.setBloodOxygenAutoTest(true, time: UTECommonTestTime.time1Hour)
                }else {
                    self.smartBandMgr.setBloodOxygenAutoTest(false, time: UTECommonTestTime.time1Hour)
                }
            }
            result(GlobalConstants.SC_INIT)
        }else{
            result(GlobalConstants.SC_FAILURE)
        }
    }

    func set24HrTemperatureTest(call: FlutterMethodCall, result: FlutterResult) {
        if let args = call.arguments as? Dictionary<String, Any>{
            let enableStr = args["enable"] as? String
            DispatchQueue.global().async {
                if enableStr?.lowercased() == "true" {
                    self.smartBandMgr.setBodyTemperatureAutoTest(true, time: UTECommonTestTime.time1Hour)
                }else {
                    self.smartBandMgr.setBodyTemperatureAutoTest(false, time: UTECommonTestTime.time1Hour)
                }
            }
            result(GlobalConstants.SC_INIT)
        }else{
            result(GlobalConstants.SC_FAILURE)
        }
    }

    func getWeatherType(code: Int) -> (UTEWeatherType) {
        //print("inside_code>> \(String(describing: code))")
        if code == 100 || code == 900{
            return UTEWeatherType.sunny
        }
        if code >= 101 && code <= 103 {
            return UTEWeatherType.cloudy
        }
        if code == 104{
            return UTEWeatherType.overcast
        }
        if code >= 200 && code <= 213{
            return UTEWeatherType.wind
        }

        if code == 300 || code == 301 {
            return UTEWeatherType.shower
        }

        if code >= 302 && code <= 304 {
            return UTEWeatherType.thunderStorm
        }

        if code == 305 {
            return UTEWeatherType.lightRain
        }

        if code >= 306 && code <= 309 {
            return UTEWeatherType.rainSnow
        }

        if code >= 310 && code <= 313 {
            return UTEWeatherType.pouring
        }

        if code >= 400 && code <= 407 {
            return UTEWeatherType.snow
        }

        if code >= 500 && code <= 502 {
            return UTEWeatherType.mistHaze
        }

        if code >= 503 && code <= 508 {
            return UTEWeatherType.sandstorm
        }else{
            return UTEWeatherType.overcast
        }
    }

    func setSevenDaysWeatherInfo(call: FlutterMethodCall, result: FlutterResult) {
        // let resultData = try! JSONSerialization.data(withJSONObject: jsonSendObj)

        if let args = call.arguments as? Dictionary<String, Any>{

            let dataStr = args["data"] as? String
            print("dataStr: \(String(describing: dataStr))")

            var returnResult = ""
            let group = DispatchGroup()
            group.enter()

            DispatchQueue.global().async {
                let data = dataStr?.data(using: .utf8)!
                do {
                    if let jsonArray = try JSONSerialization.jsonObject(with: data!, options : .allowFragments) as? NSDictionary
                    {
                        print(jsonArray) // use the json here

                        let cityName = jsonArray["cityName"] as? String

                        let todayWeatherCode = jsonArray["todayWeatherCode"] as? String
                        let todayTmpCurrent = jsonArray["todayTmpCurrent"] as? Int
                        let todayTmpMax = jsonArray["todayTmpMax"] as? Int
                        let todayTmpMin = jsonArray["todayTmpMin"] as? Int
                        let todayPm25 = jsonArray["todayPm25"] as? Int
                        let todayAqi = jsonArray["todayAqi"] as? Int

                        let secondDayTmpMax = jsonArray["secondDayTmpMax"] as? Int
                        let secondDayTmpMin = jsonArray["secondDayTmpMin"] as? Int
                        let thirdDayTmpMax = jsonArray["thirdDayTmpMax"] as? Int
                        let thirdDayTmpMin = jsonArray["thirdDayTmpMin"] as? Int
                        let fourthDayTmpMax = jsonArray["fourthDayTmpMax"] as? Int
                        let fourthDayTmpMin = jsonArray["fourthDayTmpMin"] as? Int
                        let fifthDayTmpMax = jsonArray["fifthDayTmpMax"] as? Int
                        let fifthDayTmpMin = jsonArray["fifthDayTmpMin"] as? Int
                        let sixthDayTmpMax = jsonArray["sixthDayTmpMax"] as? Int
                        let sixthDayTmpMin = jsonArray["sixthDayTmpMin"] as? Int
                        let seventhDayTmpMax = jsonArray["seventhDayTmpMax"] as? Int
                        let seventhDayTmpMin = jsonArray["seventhDayTmpMin"] as? Int

                        let todayWeather = UTEModelWeather();
                        todayWeather.city = cityName
                        todayWeather.type = self.getWeatherType(code: Int(todayWeatherCode!)!)
                        todayWeather.temperatureCurrent = todayTmpCurrent!
                        todayWeather.temperatureMax = todayTmpMax!
                        todayWeather.temperatureMin = todayTmpMin!
                        todayWeather.pm25 = todayPm25!
                        todayWeather.aqi  = todayAqi!

                        let secondDayWeatherCode = jsonArray["secondDayWeatherCode"] as? String
                        let secondWeather = UTEModelWeather();
                        secondWeather.city = cityName
                        secondWeather.type = self.getWeatherType(code: Int(secondDayWeatherCode!)!)
                        secondWeather.temperatureMax = secondDayTmpMax!
                        secondWeather.temperatureMin = secondDayTmpMin!

                        let thirdDayWeatherCode = jsonArray["thirdDayWeatherCode"] as? String
                        let thirdWeather = UTEModelWeather();
                        thirdWeather.city = cityName
                        thirdWeather.type = self.getWeatherType(code: Int(thirdDayWeatherCode!)!)
                        thirdWeather.temperatureMax = thirdDayTmpMax!
                        thirdWeather.temperatureMin = thirdDayTmpMin!

                        let fourthDayWeatherCode = jsonArray["fourthDayWeatherCode"] as? String
                        let fourthWeather = UTEModelWeather();
                        fourthWeather.city = cityName
                        fourthWeather.type = self.getWeatherType(code: Int(fourthDayWeatherCode!)!)
                        fourthWeather.temperatureMax = fourthDayTmpMax!
                        fourthWeather.temperatureMin = fourthDayTmpMin!

                        let fifthDayWeatherCode = jsonArray["fifthDayWeatherCode"] as? String
                        let fifthhWeather = UTEModelWeather();
                        fifthhWeather.city = cityName
                        fifthhWeather.type = self.getWeatherType(code: Int(fifthDayWeatherCode!)!)
                        fifthhWeather.temperatureMax = fifthDayTmpMax!
                        fifthhWeather.temperatureMin = fifthDayTmpMin!

                        let sixthDayWeatherCode = jsonArray["sixthDayWeatherCode"] as? String
                        let sixthWeather = UTEModelWeather();
                        sixthWeather.city = cityName
                        sixthWeather.type = self.getWeatherType(code: Int(sixthDayWeatherCode!)!)
                        sixthWeather.temperatureMax = sixthDayTmpMax!
                        sixthWeather.temperatureMin = sixthDayTmpMin!

                        let seventhDayWeatherCode = jsonArray["seventhDayWeatherCode"] as? String
                        let seventhWeather = UTEModelWeather();
                        seventhWeather.city = cityName
                        seventhWeather.type = self.getWeatherType(code: Int(seventhDayWeatherCode!)!)
                        seventhWeather.temperatureMax = seventhDayTmpMax!
                        seventhWeather.temperatureMin = seventhDayTmpMin!

                        print("cityName: \(String(describing: cityName))")

                        var mArrayWeather : [UTEModelWeather] = NSMutableArray.init() as! [UTEModelWeather]

                        mArrayWeather.append(todayWeather)
                        mArrayWeather.append(secondWeather)
                        mArrayWeather.append(thirdWeather)
                        mArrayWeather.append(fourthWeather)
                        mArrayWeather.append(fifthhWeather)
                        mArrayWeather.append(sixthWeather)
                        mArrayWeather.append(seventhWeather)

                        self.smartBandTool.weatherSync = 0
                        self.smartBandMgr.sendUTESevenWeather(mArrayWeather)

                        returnResult = GlobalConstants.SC_INIT
                        //result(GlobalConstants.SC_INIT)
                    } else {
                        print("bad json")
                        returnResult = GlobalConstants.SC_FAILURE
                        // result(GlobalConstants.SC_FAILURE)
                    }

                } catch let error as NSError {
                    print("NSerror",error)
                    print("\(error.localizedDescription)")
                    //result(GlobalConstants.SC_FAILURE)
                    returnResult = GlobalConstants.SC_FAILURE
                }

                group.leave()
            }

            group.wait()
            result(returnResult)
        }else{
            result(GlobalConstants.SC_FAILURE)
        }
    }

    func setDeviceBandLanguage(call: FlutterMethodCall, result: FlutterResult) {
        if let args = call.arguments as? Dictionary<String, Any>{
            let langStr = args["lang"] as? String
            var returnResult = ""
            let group = DispatchGroup()
            group.enter()
            DispatchQueue.global().async {
                if self.smartBandMgr.connectedDevicesModel!.isHasLanguageSwitchDirectly {
                    if langStr?.lowercased() == "es" {
                        self.smartBandMgr.setUTELanguageSwitchDirectly(UTEDeviceLanguage.spanish)
                    }else{
                        self.smartBandMgr.setUTELanguageSwitchDirectly(UTEDeviceLanguage.english)
                    }

                    //self.smartBandMgr.readDeviceLanguage { (language) in
                    //  print("read_lang>> rawValue: \(language.rawValue) hashValue: \(language.hashValue) value: \(language)")
                    // }
                    // result(GlobalConstants.SC_INIT)
                    returnResult = GlobalConstants.SC_INIT
                }else{
                    //result(GlobalConstants.SC_FAILURE)
                    returnResult = GlobalConstants.SC_FAILURE
                }
                group.leave()
            }
            group.wait()
            result(returnResult)
        }else{
            result(GlobalConstants.SC_FAILURE)
        }
    }

    func setDoNotDisturb(call: FlutterMethodCall, result: FlutterResult) {
        if let args = call.arguments as? Dictionary<String, Any>{

            let isMessageOn = args["isMessageOn"] as? String //Message Reminder
            let isMotorOn = args["isMotorOn"] as? String // Band Vibration
            let disturbTimeSwitch = args["disturbTimeSwitch"] as? String

            let from_time_hour = args["from_time_hour"] as? String ?? "23"
            let from_time_minute = args["from_time_minute"] as? String ?? "00"
            let to_time_hour = args["to_time_hour"] as? String ?? "08"
            let to_time_minute = args["to_time_minute"] as? String ?? "00"

            var isEnableMessageOn : Bool = false
            var isEnableMotorOn : Bool = false
            var isDisturbTimeSwitch : Bool = false

            if isMessageOn != nil && isMessageOn!.lowercased() == "true" {
                isEnableMessageOn = true
            }

            if isMotorOn != nil && isMotorOn!.lowercased() == "true" {
                isEnableMotorOn = true
            }

            if disturbTimeSwitch != nil && disturbTimeSwitch!.lowercased() == "true" {
                isDisturbTimeSwitch = true
            }


            var returnResult = ""
            let group = DispatchGroup()
            group.enter()
            DispatchQueue.global().async {
                if self.smartBandMgr.connectedDevicesModel!.isConnected {

                    let startTime : String = "\(from_time_hour):\(from_time_minute)"
                    let endTime : String = "\(to_time_hour):\(to_time_minute)"

                    print("from_time_hour>> \(from_time_hour) from_time_minute>> \(from_time_minute) to_time_hour>> \(to_time_hour) to_time_minute>> \(to_time_minute)")

                    var utetype: UInt8

                    if isDisturbTimeSwitch {

                       // let silencetype = UTESilenceType(rawValue: ) as UTESilenceType
                        //var utetype: UTESilenceType = .message
                        print("startTime>> \(startTime)")
                        print("endTime>> \(endTime)")

                        if isEnableMessageOn  && isEnableMotorOn {
                            print("DND isEnableMessageOn  && isEnableMotorOn")
                            utetype = UInt8(UTESilenceType.phone.rawValue) | UInt8(UTESilenceType.message.rawValue) | UInt8(UTESilenceType.vibration.rawValue) | UInt8(UTESilenceType.screen.rawValue)
                        }else if isEnableMessageOn  {
                            print("DND isEnableMessageOn")
                            utetype = UInt8(UTESilenceType.message.rawValue)
                        }else if isEnableMotorOn {
                           // UTESilenceType silentType = UTESilenceType.vibration;
                            print("DND isEnableMotorOn")
                            utetype = UInt8(UTESilenceType.vibration.rawValue)
                        }else{
                            utetype = UInt8(UTESilenceType.phone.rawValue)|UInt8(UTESilenceType.screen.rawValue)
                        }


                        self.smartBandMgr.sendUTEAllTime(UTESilenceType(rawValue: UTESilenceType.RawValue(utetype))!, exceptStartTime: startTime, endTime: endTime, except: true);

//                        self.smartBandMgr.sendUTEAllTime(UTESilenceType(rawValue: UTESilenceType.RawValue(UInt8(UTESilenceType.phone.rawValue)|UInt8(UTESilenceType.message.rawValue)))!, exceptStartTime: startTime, endTime: endTime, except: false);

//                        self.smartBandMgr.sendUTEAllTimeSilence(UTESilenceType(rawValue: UTESilenceType.RawValue(UInt8(UTESilenceType.phone.rawValue)|UInt8(UTESilenceType.message.rawValue)), exceptStartTime: startTime, endTime: endTime, except: true)

                    }else{

                        //  mWriteCommand.sendDisturbToBle(isEnableMessageOn, isEnableMotorOn, isDisturbTimeSwitch, 0, 0, 0, 0);
                        print("DND Turn Off")

                        let tempStartTime = "22:00"
                        let tempEndTime = "08:00"

                        if isEnableMessageOn  && isEnableMotorOn {
                            print("DND isEnableMessageOn")
                            utetype = UInt8(UTESilenceType.message.rawValue) | UInt8(UTESilenceType.vibration.rawValue)
                        }else if isEnableMessageOn {
                            print("DND isEnableMessageOn")
                            utetype = UInt8(UTESilenceType.message.rawValue)
                        } else if isEnableMotorOn {
                           // UTESilenceType silentType = UTESilenceType.vibration;
                            print("DND isEnableMotorOn")
                            utetype = UInt8(UTESilenceType.vibration.rawValue)
                        }else{
                            utetype = UInt8(UTESilenceType.none.rawValue)
                        }

                        self.smartBandMgr.sendUTEAllTime(UTESilenceType(rawValue: UTESilenceType.RawValue(utetype))!, exceptStartTime: tempStartTime, endTime: tempEndTime, except: false)
                       // self.smartBandMgr.sendUTEAllTime(UTESilenceType.none, exceptStartTime: tempStartTime, endTime: tempEndTime, except: false)
                    }

                    returnResult = GlobalConstants.SC_INIT
                }else{
                    //result(GlobalConstants.SC_FAILURE)
                    returnResult = GlobalConstants.SC_FAILURE
                }
                group.leave()
            }
            group.wait()
            result(returnResult)
        }else{
            result(GlobalConstants.SC_FAILURE)
        }
    }

    func fetchStepsBySelectedDate(call: FlutterMethodCall, result: FlutterResult) {
        if let args = call.arguments as? Dictionary<String, Any>{
            //let dateTime = args["dateTime"] as? String
            //self.smartBandMgr.

            // String dateTime = call.argument("dateTime");
        }
    }

    func callCheckQuickSwitchStatus(result: FlutterResult) {
        DispatchQueue.global().async {
           // self.smartBandMgr.setUTEOption(UTEOption.)
            //print("BtnStatus>> : \(String(describing: self.smartBandMgr.readDeviceShortcutBtnStatus))")
           // print("BtnSupport>> : \(String(describing: self.smartBandMgr.readDeviceShortcutBtnSupport))")

            //self.smartBandMgr.setUTEOption(UTEOption.readBaseStatus)
            let statusBtn = self.smartBandMgr.readDeviceShortcutBtnStatus();

          //  let supportBtn =  self.smartBandMgr.readDeviceShortcutBtnSupport();

            print("statusBtn>> : \(String(describing: statusBtn))")
        //    print("supportBtn>> : \(String(describing: supportBtn))")

          //  let isHasSilence = self.smartBandMgr.connectedDevicesModel?.isHasSilence;
         //   print("isHasSilence>> : \(String(describing: isHasSilence))")

          //  let isHasDataStatus = self.smartBandMgr.connectedDevicesModel?.isHasDataStatus;
           // print("isHasDataStatus>> : \(String(describing: isHasDataStatus))")

           // let isHasSwitchHand = self.smartBandMgr.connectedDevicesModel?.isHasSwitchHand;
           // print("isHasSwitchHand>> : \(String(describing: isHasSwitchHand))")

           // self.smartBandTool.

        }
        //}
        result(GlobalConstants.SC_INIT)
    }

    func readOnlineDialConfig(result: FlutterResult) {
        self.smartBandMgr.readUTEDisplayInfoFormDevice{ (model) in

            print("Read dial information successfully   \(String(describing: model?.versionName))_\(String(describing: model?.width))_\(String(describing: model?.height))")

            let width : UInt =  model!.width
            let height : UInt =  model!.height

            let displayData = [
                "dialSupport":  self.smartBandMgr.connectedDevicesModel?.isHasSwitchDialOnline ?? "",
                "mac":  self.smartBandMgr.connectedDevicesModel?.addressStr!.uppercased() ?? "", //advertisementAddress!.uppercased()
                "type":  0,
                "shape":  model?.screenType.rawValue ?? "",
                "status": GlobalConstants.SC_SUCCESS,
                "bleName": model?.versionName ?? "",
                "maxCapacity": model?.maxCapacity ?? "",
                "dpi": "\(width)*\(height)",
                "compatible": model?.compatible ?? "",
            ] as [String : Any]
            //print("displayData>>  \(displayData)")
            self.smartBandTool.uteDeviceData(displayData)
        }

        result(GlobalConstants.SC_INIT)
    }

    func prepareSendOnlineDialData(result: FlutterResult) {
        if self.smartBandMgr.connectedDevicesModel!.isConnected {
            //self.smartBandMgr.getUTEDisplayInfoFormServer()
            result(GlobalConstants.SC_INIT)
        }else{
            result(GlobalConstants.SC_FAILURE)
        }
    }

    func stopOnlineDialData(result: FlutterResult) {
        if self.smartBandMgr.connectedDevicesModel!.isConnected {
            //self.smartBandMgr.getUTEDisplayInfoFormServer()
            result(GlobalConstants.SC_INIT)
        }else{
            result(GlobalConstants.SC_FAILURE)
        }
    }

    func sendOnlineDialPath(call: FlutterMethodCall, result: FlutterResult) {
        if let args = call.arguments as? Dictionary<String, Any>{
            let downloadedPath = args["path"] as? String
            print("downloadedPath>>  \(String(describing: downloadedPath))")
            let data = NSData.init(contentsOfFile: downloadedPath!)
           // print("data>>  \(data)")
            if data != nil {
                self.smartBandMgr.sendUTEDisplayData(toDevice: data! as Data, process: { (process) in
                    print("Dial synchronization progress---\(process)")

                    var progressValue : Int = Int(floor(process*100))
                    if progressValue > 0 {
                        let progressData = [
                            "progress": progressValue,
                        ] as [String : Any]
                        self.smartBandTool.updateDialProgress(progressData)
                    }
                }, success: {
                    print("Sync watch face successfully")
                }) { (error) in
                    //EN:Please make sure the bin file path exists
                    print("Failed to sync watch face")
                }
            }else{
                //EN:Please make sure the bin file path exists
                print("Failed to sync watch face")
            }

        }
    }



    //sync related
    func syncAllStepsData(result: FlutterResult) {
        if self.smartBandMgr.connectedDevicesModel!.isConnected {
            //if self.smartBandMgr.connectedDevicesModel!.isHasDataStatus {
            //   self.smartBandMgr.syncDataCustomTime("2022-01-01-01-01", type: UTEDeviceDataType.steps)
            //     print("syncAllStepsData>> Inside IF")
            // }else{

            //print("syncAllStepsData>> Inside ELSE")
            DispatchQueue.global().async {
                self.smartBandMgr.setUTEOption(UTEOption.syncAllStepsData)
                // self.smartBandMgr.setUTEOption(UTEOption.syncAllSleepData)
                // self.smartBandMgr.setUTEOption(UTEOption.syncAllHRMData)
                //self.smartBandMgr.setUTEOption(UTEOption.syncAllBloodData)
                //self.smartBandMgr.setUTEOption(UTEOption.syncAllBloodOxygenData)
                //self.smartBandMgr.setUTEOption(UTEOption.syncAllRespirationData)
            }
            //}
            result(GlobalConstants.SC_INIT)
        }else{
            result(GlobalConstants.SC_FAILURE)
        }

    }

    func syncAllSleepData(result: FlutterResult) {
        if self.smartBandMgr.connectedDevicesModel!.isConnected {
            //            if self.smartBandMgr.connectedDevicesModel!.isHasDataStatus {
            //                self.smartBandMgr.syncDataCustomTime("2022-01-01-01-01", type: UTEDeviceDataType.sleep)
            //            }else{
            //                self.smartBandMgr.setUTEOption(UTEOption.syncAllSleepData)
            //            }
            DispatchQueue.global().async {
                self.smartBandMgr.setUTEOption(UTEOption.syncAllSleepData)
            }
            result(GlobalConstants.SC_INIT)
        }else{
            result(GlobalConstants.SC_FAILURE)
        }

    }

    func syncRateData(result: FlutterResult) {
        if self.smartBandMgr.connectedDevicesModel!.isConnected {
            //            if self.smartBandMgr.connectedDevicesModel!.isHasDataStatus {
            //                self.smartBandMgr.syncDataCustomTime("2022-01-01-01-01", type: UTEDeviceDataType.HRM)
            //            }else{
            //                self.smartBandMgr.setUTEOption(UTEOption.syncAllHRMData)
            //            }
            DispatchQueue.global().async {
                self.smartBandMgr.setUTEOption(UTEOption.syncAllHRMData)
            }
            result(GlobalConstants.SC_INIT)
        }else{
            result(GlobalConstants.SC_FAILURE)
        }

    }
    func syncBloodPressure(result: FlutterResult) {
        if self.smartBandMgr.connectedDevicesModel!.isConnected {
            //            if self.smartBandMgr.connectedDevicesModel!.isHasDataStatus {
            //                self.smartBandMgr.syncDataCustomTime("2022-01-01-01-01", type: UTEDeviceDataType.blood)
            //            }else{
            //                self.smartBandMgr.setUTEOption(UTEOption.syncAllBloodData)
            //            }
            DispatchQueue.global().async {
                self.smartBandMgr.setUTEOption(UTEOption.syncAllBloodData)
            }
            result(GlobalConstants.SC_INIT)
        }else{
            result(GlobalConstants.SC_FAILURE)
        }

    }

    func syncOxygenSaturation(result: FlutterResult) {
        if self.smartBandMgr.connectedDevicesModel!.isConnected {
            //            if self.smartBandMgr.connectedDevicesModel!.isHasDataStatus {
            //                self.smartBandMgr.syncDataCustomTime("2022-01-01-01-01", type: UTEDeviceDataType.bloodOxygen)
            //            }else{
            //                self.smartBandMgr.setUTEOption(UTEOption.syncAllBloodOxygenData)
            //            }
            DispatchQueue.global().async {
                self.smartBandMgr.setUTEOption(UTEOption.syncAllBloodOxygenData)
            }
            result(GlobalConstants.SC_INIT)
        }else{
            result(GlobalConstants.SC_FAILURE)
        }

    }

    func syncBodyTemperature(result: FlutterResult) {
        if self.smartBandMgr.connectedDevicesModel!.isConnected {
            DispatchQueue.global().async {
                //                if self.smartBandMgr.connectedDevicesModel!.isHasBodyTemp{
                //                    print("isHasBodyTemp>> value: \(self.smartBandMgr.connectedDevicesModel!.isHasBodyTemp)")
                //                }
                //                if self.smartBandMgr.connectedDevicesModel!.isHasBodyTemperature{
                //
                //                }
                //
                //                if self.smartBandMgr.connectedDevicesModel!.isHasBodyTemperatureFunction2{
                //
                //                }

                print("isHasBodyTemp>> value: \(self.smartBandMgr.connectedDevicesModel!.isHasBodyTemp)")
                print("isHasBodyTemperature>> value: \(self.smartBandMgr.connectedDevicesModel!.isHasBodyTemperature)")
                print("isHasBodyTemperatureFunction2>> value: \(self.smartBandMgr.connectedDevicesModel!.isHasBodyTemperatureFunction2)")

                self.smartBandMgr.syncBodyTemperature(self.syncDateTime)
                //self.smartBandMgr.syncUTESportModelCustomTime("2020-08-08-08-08")
                // self.smartBandMgr.setUTEOption(UTEOption.syncTime)
            }
            result(GlobalConstants.SC_INIT)
        }else{
            result(GlobalConstants.SC_FAILURE)
        }

    }

    func syncAllSportsInfo(result: FlutterResult) {
        if self.smartBandMgr.connectedDevicesModel!.isConnected {
            DispatchQueue.global().async {
                self.smartBandMgr.syncUTESportModelCustomTime(self.syncDateTime)
            }
            result(GlobalConstants.SC_INIT)
        }else{
            result(GlobalConstants.SC_FAILURE)
        }

    }

    func fetchOverAllDeviceData(result: FlutterResult) {
        //            if self.smartBandMgr.connectedDevicesModel!.isConnected {
        //                if self.smartBandMgr.connectedDevicesModel!.isHasDataStatus {
        //                    self.smartBandMgr.syncDataCustomTime("2022-01-01-01-01", type: UTEDeviceDataType.HRM24)
        //                }else{
        //                    self.smartBandMgr.setUTEOption(UTEOption.syncAllRespirationData)
        //                }
        //                result(GlobalConstants.SC_INIT)
        //            }else{
        //                result(GlobalConstants.SC_FAILURE)
        //            }

    }

}

//struct WeatherInfo: HandyJSON {
//    var name: String?
//    var type: AnimalType?
//}
