//
//  ViewController.swift
//  BluetoothPW
//
//  Created by Luiz Fernando dos Santos on 22/12/18.
//  Copyright © 2018 LFSantos. All rights reserved.
//

import UIKit

import CoreBluetooth

class ViewController: UIViewController , CBCentralManagerDelegate, CBPeripheralDelegate{

    var centralManager: CBCentralManager!
    var scale: CBPeripheral!
    var peripheralManager: CBPeripheralManager!
    var service:CBService?
    var characteristic: CBCharacteristic?

    var servicesList: [CBService]?
    var charList: [CBCharacteristic]?
    var canRec = 0
    var canWrite = true
    var sizeWrite = 0
    var conta = 0
    
    var lastFunc: PinpadCommands?
    var resultLasGetCard:String = "0"
    
    var charToWrite: CBCharacteristic?

    var callbackMessage = Data()
    var callbackStatus = StatusDeviceMessage.beginning
    
    let idList = ["1001", "1003", "1005", "1006", "1007"]
    var currentAmount = 0
    let currentTimeStampKey: String = "timeStampKey"
    var currentTimeStamp: String {
        return UserDefaults.standard.string(forKey: currentTimeStampKey) ?? ""
    }
    
    var valueDataToWrite: [String] = [String]()
    
    var items: [ItemCollection] = [ItemCollection(ppfunc: "OPN", color: UIColor(named: "open")! ), ItemCollection(ppfunc: "READ", color: UIColor(named: "read")!), ItemCollection(ppfunc: "CLO", color: UIColor(named: "close")!), ItemCollection(ppfunc: "GIN", color: UIColor(named: "open")!), ItemCollection(ppfunc: "SGC", color: UIColor(named: "tableEnd")!), ItemCollection(ppfunc: "GCR", color: UIColor(named: "tableEnd")!), ItemCollection(ppfunc: "GCRR", color: UIColor(named: "tableEnd")!), ItemCollection(ppfunc: "TLI", color: UIColor(named: "tableIniti")!), ItemCollection(ppfunc: "GTS", color: UIColor(named: "open")!), ItemCollection(ppfunc: "GOCS", color: UIColor(named: "read")!), ItemCollection(ppfunc: "GOC", color: UIColor(named: "read")!), ItemCollection(ppfunc: "FNC", color: UIColor(named: "read")!)]

    

    @IBOutlet weak var tableCharac: UITableView!
    @IBOutlet weak var tableServices: UITableView!
    @IBOutlet weak var readBtn: UIButton!
    @IBOutlet weak var ppFuncTextFiled: UITextField!
    @IBOutlet weak var text: UITextView!
    
    var pinpad: PinPad?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        centralManager = CBCentralManager()
        centralManager.delegate = self

        tableServices.delegate = self
        tableCharac.delegate = self

        tableServices.dataSource = self
        tableCharac.dataSource = self

        self.hideKeyboardWhenTappedAround()
        

    }


    @IBAction func write(_ sender: Any) {
        
        if ppFuncTextFiled.text!.isEmpty {
            scale.writeValue(Data(bytes: BCBuildMessages().showDisplay(msg: "     muxiPAY")), for: charToWrite!, type: .withResponse)
        } else {
            scale.writeValue(Data(bytes: BCBuildMessages().showDisplay(msg: ppFuncTextFiled.text ?? "muxiPAY")), for: charToWrite!, type: .withResponse)
        }
    }

    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("state: \(central.state)")
        if central.state == .poweredOn {
            print("open")
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        }
    }

    @IBAction func setNotify(_ sender: Any) {
        if let char = characteristic {
            scale.setNotifyValue(true, for: char)
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {

        scale = peripheral
        print(peripheral)

        if peripheral.identifier.uuidString == "0D16ED8B-ABB1-81BB-1F36-76BE5D559FE4" /*3F431D68-922F-D574-028C-BBA0497AAB44" "BC09EFF0-F1F6-418C-62CA-E3EEEA425610"  "F4A4339D-AF47-55D0-FE6F-B75ADCDD3C07" */{
            centralManager.stopScan()
            scale = peripheral
            pinpad = PinPad(device: peripheral)
            centralManager.connect(peripheral, options: nil)
        }
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }


    //Peripheral delegate
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {

        servicesList = peripheral.services
        tableServices.reloadData()

        peripheral.services?.forEach { ser in
            peripheral.discoverCharacteristics(nil, for: ser)

        }

    }
    
    func setServiceNotify(service: CBService) {
        service.characteristics?.forEach{
            if $0.properties == .notify {
                scale.setNotifyValue(true, for: $0)
                print("notifying OK")
            }
        }
        
    }
    
    
    func setCharToWrite(service: CBService) {
        service.characteristics?.forEach({ (char) in
            if char.properties.contains(.write) {
                charToWrite = char
                print("more 1")
            }
        })
    }
    

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        charList = service.characteristics
        tableCharac.reloadData()

        setServiceNotify(service: service)
        setCharToWrite(service: service)
    }

    func checkResponse(response: ResponseBC) {
        
        switch response.function {
        case .tableLoadInit?:
            self.recTableOnDevice()
        case .tableLoadRec?:
            self.recTableOnDevice()
        case .tableLoadEnd?:
            self.finishLoadTable()
        case .getInfo?:
            self.getDeviceInfos(info: response.message)
        case .getCard?:
            if lastFunc! == .startGetCard {
                let readGCR = BCBuildMessages().readMessage(data: callbackMessage)
                let getcard = GetCard.from(bc: readGCR.message)
                print(getcard)
                getCardResult()
            } else {
                startGoOnChip(amount: currentAmount)
            }
            
            callbackMessage = Data()
        case .startGetCard?:
            let readGCR = BCBuildMessages().readMessage(data: callbackMessage)
            let getcard = GetCard.from(bc: readGCR.message)
            print(getcard)
            getCardResult()
        case .goOnChip?:
            let readed = BCBuildMessages().readMessage(data: callbackMessage)
            let goOnChip = GoOnChip.from(bc: readed.message)
            print(goOnChip)
        default:
            print("without continuation.")
        }
        
        callbackMessage = Data()
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print("didUpdateValueFor")
        
        if let error = error {
            print(error)
        }
        
        if let data = characteristic.value {

            callbackMessage += data
            
            print(String(data: data, encoding: .ascii))
            
            let response = BCBuildMessages().readMessage(data: data, lastFunc: lastFunc)
            
            switch response.resposeCode {
            case .pp_ok?:
                print("pp ok")
            default:
                print("Error to send data commnad: \(response.function?.rawValue) code: \(response.resposeCode?.rawValue)")
            }
            switch response.statusMessage {
            case .beginning: print("beginning")
            lastFunc = response.function
            case .middle:
                print("middle")
                print(response.message)
            case .end: do {
                print("end")
                print(response.message)
                
                checkResponse(response: response)
                canWrite = true
                }
            }
        
            self.text.text = " Func:  \(response.function?.rawValue), \n msg: \(response.message)"

        }
    }
   
    func getCurrentTime() -> String {
        //get current hour
        let hourFormatter = DateFormatter()
        hourFormatter.dateFormat = "HHmmss"
        return hourFormatter.string(from: Date())
    }
    
    func getCurrentDate( isInitialization: Bool) -> String {
        
        if isInitialization{
            //get current date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMddHHmmss"
            return dateFormatter.string(from: Date())
        } else {
            //get current date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyMMdd"
            return dateFormatter.string(from: Date())
        }
        
    }
    
    func getNewTimeStamp()-> String {
        var sequencial = (UserDefaults.standard.integer(forKey: "timeStamp"))
        
        sequencial += 1
        UserDefaults.standard.set(sequencial, forKey: "timeStamp")
        
        let newSeq = String(format: "%02d", sequencial)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ddMMyyyy"
    
        return dateFormatter.string(from: Date()) + newSeq
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if (tableView.dequeueReusableCell(withIdentifier: "services") != nil) {
            if let serviceSelected = servicesList?[indexPath.row] {
                service = serviceSelected
                
                scale.discoverCharacteristics(nil, for: serviceSelected)

            }
        } else {
            if let charSelected = charList?[indexPath.row] {
                characteristic = charSelected
                print(" charc: \(charSelected) descriptions: \(charSelected.description) \n properties: \(charSelected.properties) / uuid: \(charSelected.uuid)  ")

            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView.dequeueReusableCell(withIdentifier: "services") != nil) {
            return servicesList?.count ?? 0
        } else {
            return charList?.count ?? 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell()

        if (tableView.dequeueReusableCell(withIdentifier: "services") != nil) {
            cell.textLabel?.text = servicesList?[indexPath.row].description
        } else {
            cell.textLabel?.text = charList?[indexPath.row].description
        }

        return cell
    }


    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}


extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collection = collectionView.dequeueReusableCell(withReuseIdentifier: "funcs", for: indexPath) as! CollectionFuncs
    
        collection.label.text = items[indexPath.row].ppfunc
        collection.layer.cornerRadius = collection.frame.height / 2
        collection.backgroundColor = items[indexPath.row].color
        return collection
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        clickFunc(items[indexPath.row].ppfunc)
    }
    
    
    
    fileprivate func startGetCard(amount: Int, acquirer: Common.AcquirerID, appType: ApplicationType) {
        
        var entries: [String]
        if appType == .credito {
            entries = DataManager.getCreditEntries()
        } else {
            entries = DataManager.getDebitEntries()
        }
        

        
        let startGetCard = StartGetCard(idAcquirer: acquirer.rawValue, applicationType: appType.getInputValue(), transactionValue: amount, transactionDate: getCurrentDate(isInitialization: false), transactionHour: getCurrentTime(), timeStamp: currentTimeStamp, entries: entries, supportCTLS: "0")
        
        lastFunc = .startGetCard
        let inputStartGetCard = BCBuildMessages().startGetCard(input: startGetCard.getStartGetCardInput())
        writeMessage(bytes: inputStartGetCard)
        
    }
    
    fileprivate func finishChip() {
        
        let finishChip = FinishChip(comunicationStatus: "0", emitterType: "0", authotizationResponseCode: "00", field55: "", acquirerEntries: "", psTags: "9F029F039F1A955F2A9A9C9F379F359F279F26829F369F109F345F349F339F1E9F099F419F069F0D9F0E9F0F9F429F3B5F285F555F569F07")
        
        print(finishChip.getFinishChipInput() + finishChip.getPsTagsInput())
        writeMessage(bytes: BCBuildMessages().finishChip(input: finishChip.getFinishChipInput(), inputTags: finishChip.getPsTagsInput()))
    }
    
    func clickFunc(_ ppFunc: String) {
        if ppFunc.contains("GIN") {
            print("func: GIN")
            writeMessage(bytes: BCBuildMessages().getInfo(input: "00"))
        } else if ppFunc.contains("OPN") {
            print("func: \(ppFunc)")

            writeMessage(bytes: BCBuildMessages().open())
            
        } else if ppFunc.contains("CLO") {
            print("func: \(ppFunc)")

            writeMessage(bytes: BCBuildMessages().close())
            
        } else if ppFunc.contains("READ") {
            if let char = characteristic {
                scale.readValue(for: char)
            }
        } else if ppFunc.contains("SGC") {
            print("func: \(ppFunc)")

            let amount  = Int(ppFuncTextFiled.text!) ?? 0
            currentAmount = amount
            startGetCard(amount: amount, acquirer: .clearent, appType: .credito)
            
        } else if ppFunc.contains("GCR") {
            print("func: \(ppFunc)")
            writeMessage(bytes: BCBuildMessages().getCard())
        } else if ppFunc.contains("GCRR") {
            
        } else if ppFunc.contains("TLI") {
            print("func: \(ppFunc)")
            
            initializeTerminal()
            
//            writeMessage(bytes: BCBuildMessages().loadTableLoadInit(input: "000903201903"))
//            valueDataToWrite = DataManagerDefault().tables
            
        } else if ppFunc.contains("GTS") {
            print("func: \(ppFunc)")
            let mMsg = String(format: "%03d", ppFuncTextFiled.text!)
            writeMessage(bytes: BCBuildMessages().getTimeStampt(input:"10"))
            
        } else if ppFunc.contains("GOCS") {
            print("func: \(ppFunc)")
            
            startGoOnChip(amount: currentAmount)

            
        } else if ppFunc.contains("GOC") {
            print("func: \(ppFunc)")

            writeMessage(bytes: BCBuildMessages().goOnChip(input: "086000000000500000000000000010301                                100000FA010000003E899000049023829F279F269F36959F349F379F335F289F109A5F349F0B003000"))

        } else if ppFunc.contains("FNC") {
            finishChip()
        }

    }

    func writeMessage(bytes: [UInt8]) {

        callbackMessage = Data()
        var buffer = bytes

        let commandLength = buffer.count
        let dataToSend = NSData(bytes: &buffer, length: commandLength + 1)
        var sendDataIndex: Int = 0


        print("\(String(data: dataToSend as Data, encoding: .utf8) ?? "")")
        var didSend = true

        while didSend {
            // minus 1 to avoid exceeding the maximum value
            let mtu: Int = scale.maximumWriteValueLength(for: .withoutResponse) - 1
            var amountToSend: Int = dataToSend.length - sendDataIndex

            if amountToSend > mtu {
                amountToSend = mtu
            } else {
                didSend = false
            }

            let chunk = Data(bytes: (dataToSend.bytes + sendDataIndex), count: amountToSend)

            scale.writeValue(chunk, for: charToWrite!, type: .withResponse)

            let stringFromData = String(data: chunk, encoding: .utf8)
            print("Sent: \(stringFromData ?? "")")

            sendDataIndex += amountToSend
        }
    }
}

extension ViewController {
    
    func initializeTerminal() {
        let initService = InitializationService()
        
        let initializationRequest = InitializationRequest.init(mti: MTIValue.initialization.rawValue, processingCode: ProcessingCode.initialization.rawValue, transmissionDate: getCurrentDate(isInitialization: true) , stan: "000001", transactionDate: getCurrentDate(isInitialization: true), acquirerID: Common.AcquirerID.global.rawValue, terminalID: "00000000", merchantID: "1234", customerID: "muxi", manufacturer: "Apple", pverfm: "CQMAN", serialNumber: "1234567890", chipLibraryVersion: "1.08v2", emvKernelVersion: "1.2.212", browserVersion: "0", posnetVersion: "0", ipVersion: "1.08a", applicationVersion: "0.1", connectionMode: "05", connectionDetails: "2123123;21999999999;10.10.8.3", pinpadSerialNumber: "7B499090", pinpadFirmware: "PP_GetInfo", initializationFormatVersion: "0.1", model: "iPhone", memoryCapacity: "0M")
        
        initService.initialize(initializationRequest: initializationRequest) { (success, obj) in
            if let tables = obj?.initialization?.aidTable {
                
                var listIdsCredit: [String] = []
                var listIdsDebit: [String] = []
                
                //save index table register
                tables.forEach { (tab) in
                    if let appType = tab.aidTableRegistry?.getApplicationType(){
                        if let aidCode = tab.aidTableRegistry?.aidCode {
                            let aidTab = String(format: "%02d", aidCode)
                            
                            if appType == .credito {
                                listIdsCredit.append(aidTab)
                            } else {
                                listIdsDebit.append(aidTab)
                            }
                        }
                        
                    }
                }
                DataManager.setCreditEntries(entries: listIdsCredit)
                DataManager.setDebitEntries(entries: listIdsDebit)
                
                
                self.valueDataToWrite = []

                tables.forEach { t in
                    if let input = t.aidTableRegistry?.getInputTable(acquirerID: "10", countryCode: 076, merchandID: 123456789, merchantCategoryCode: 3502, terminalID: "00000643") {
                        print(input)
                        self.valueDataToWrite.append(input)
                    }
                    
                }
                self.tableInit()
                
            }
        }
    }
    
    func tableInit() {
        
        let timestamp = getNewTimeStamp()
        UserDefaults.standard.set(timestamp, forKey: currentTimeStampKey)
        writeMessage(bytes: BCBuildMessages().loadTableLoadInit(input: "10" + timestamp))
    }
    @objc func recTableOnDevice() {
        
       
        if let firt = valueDataToWrite.first {
            writeMessage(bytes: BCBuildMessages().loadTableLoadRec(table: firt))
            
            valueDataToWrite.removeFirst()
        } else {
            self.writeMessage(bytes: BCBuildMessages().loadTableLoadEnd())
        }
    }
    
    
    func finishLoadTable() {

       // saveTablesRegisterIndex()
        
        writeMessage(bytes: BCBuildMessages().showDisplay(msg: "Tabelas Atualizadas!"))
        
    }
    
    func getDeviceInfos(info: String) {
        let getInfo = ReadBCMessages().getInfoPinpad(msg: info)
        if getInfo.type == .general {
            let getInfoG = getInfo as! GetInfoGeneral
            print(String(describing: getInfoG))
            
        }
    }
    
    func getCardResult(){
        lastFunc = .getCard
        writeMessage(bytes: BCBuildMessages().getCard())
    }
    
    fileprivate func startGoOnChip(amount: Int) {
        
        let startGoOnChip = StartGoOnChip(amount: amount, cashback: 0, blackListResult: "0", canBeOff: "1", requiredPINOnTEF: "0", encryptionMode: "3", masterKeyIndex: "01", workingKey: "                                ", trm: "1", floorLimit: "00000FA0", targetPercentRDM: 10, thresholdValueRDM: "000003E8", maxTargetPercentageRDM: 99, entries: [], psEmvTags: "829F279F269F36959F349F379F335F289F109A5F349F0B", psEmvTagsOpt: "")
        
        writeMessage(bytes: BCBuildMessages().startGoOnChip(input: startGoOnChip.getStartGetCardInput(), tags: startGoOnChip.getPsEmvTagsInput(), tagsOpt: startGoOnChip.getPsEmvTagsOptInput()))
    }
    
    func startFinishChip() {
        
    }
}

struct ItemCollection {
    var ppfunc: String
    var color: UIColor
}
