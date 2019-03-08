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
    var dataToWrite = [Data]()
    var sizeWrite = 0
    var conta = 0

    var callbackMessage: [String] = [String]()
    var callbackStatus = StatusDeviceMessage.beginning
    
    
    var items: [ItemCollection] = [ItemCollection(ppfunc: "OPN", color: UIColor(named: "open")! ), ItemCollection(ppfunc: "READ", color: UIColor(named: "read")!), ItemCollection(ppfunc: "CLO", color: UIColor(named: "close")!), ItemCollection(ppfunc: "GIN", color: UIColor(named: "open")!), ItemCollection(ppfunc: "SGC", color: UIColor(named: "tableEnd")!), ItemCollection(ppfunc: "GCR", color: UIColor(named: "tableEnd")!), ItemCollection(ppfunc: "GCRR", color: UIColor(named: "tableEnd")!), ItemCollection(ppfunc: "TLI", color: UIColor(named: "tableIniti")!), ItemCollection(ppfunc: "TLR", color: UIColor(named: "tableRec")!), ItemCollection(ppfunc: "TLE", color: UIColor(named: "tableEnd")!), ItemCollection(ppfunc: "GTS", color: UIColor(named: "open")!), ItemCollection(ppfunc: "GOCS", color: UIColor(named: "read")!), ItemCollection(ppfunc: "GOC", color: UIColor(named: "read")!)]

    

    @IBOutlet weak var tableCharac: UITableView!
    @IBOutlet weak var tableServices: UITableView!
    @IBOutlet weak var readBtn: UIButton!
    @IBOutlet weak var ppFuncTextFiled: UITextField!
    @IBOutlet weak var text: UITextView!
    

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
            scale.writeValue(Data(bytes: BCBuildMessages().showDisplay(msg: "     muxiPAY")), for: characteristic!, type: .withResponse)
        } else {
            scale.writeValue(Data(bytes: BCBuildMessages().showDisplay(msg: ppFuncTextFiled.text ?? "muxiPAY")), for: characteristic!, type: .withResponse)
        }
        
    }
    
    func sendMore(_ data: Data ){
        print("data total")
        print(String(data: data, encoding: .ascii))
        var dataMSG = data
            while dataMSG.count > 40 {
                var d: Data = Data()
                print(dataMSG.count)
                if dataMSG.first! == 0x16 {
                    print("primeiro dado")
                } else {
                    print("add byte 15")
                    print(dataMSG)
                    d.append(0x15)
                    //d.append(Data("GOC".utf8))
                    d.append(contentsOf: dataMSG)
                    
                    dataMSG = d
                    //dataMSG.insert(0x15, at: 0)
                    print(dataMSG)
                }
                var partData = self.extract(from: &dataMSG)
                
                partData?.append(0x15)
                dataToWrite.append(partData!)
                
                print(partData)
            
                //self.scale.writeValue(partData!, for: self.characteristic!, type: .withResponse)
            
        }
        
        if dataMSG.count > 0 {
            dataToWrite.append(dataMSG)
        }
        
        
    }

    func sendMessage(message : Data){
             scale.writeValue(message, for: characteristic!, type: .withResponse)
        
    }

    func extract(from data: inout Data) -> Data? {
        guard data.count > 0 else {
            return nil
        }
        
        // Define the length of data to return
        let length = Int.init(data[10])
        
        // Create a range based on the length of data to return
        
        let range = Range(0..<40)
        
        // Get a new copy of data
        let subData = data.subdata(in: range)
        
        // Mutate data
        data.removeSubrange(range)
        
        // Return the new copy of data
        return subData
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

        if peripheral.identifier.uuidString == /*"BC09EFF0-F1F6-418C-62CA-E3EEEA425610" */ "F4A4339D-AF47-55D0-FE6F-B75ADCDD3C07" {
            centralManager.stopScan()
            scale = peripheral
            centralManager.connect(peripheral, options: nil)
        }
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }


    //Peripheral delegate
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {

        print("print services ====>>")

        servicesList = peripheral.services
        tableServices.reloadData()

        peripheral.services?.forEach {
            print($0)
        }
        print("-------------------")

    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        charList = service.characteristics
        tableCharac.reloadData()
        print("characteristics ==> > ")
        service.characteristics?.forEach{
            print($0)
        }
        print("-------------------")

    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print("didUpdateValueFor")
        
        canWrite = true
        if let error = error {
            print(error)
        }
        
        
        if let data = characteristic.value {

            BCBuildMessages().readMessage(data: data) { (response)  in

                switch response.statusMessage {
                case .beginning: print("beginning")
                case .middle:
                    print("middle")
                    print(response.message)
                case .end:
                    print("end")
                    print(response.message)
                }
                
                switch response.function {
                case .getInfo: do {
                    let getInfo = ReadBCMessages().getInfoPinpad(msg: response.message)
                }
                default: print("Default")
                    
                }
                

                self.text.text = " Func:  \(response.function.rawValue), \n msg: \(response.message)"
            }

        }
    }
    

    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        print("didUpdateNotificationStateFor")
        
        if let error = error {
            print(error)
        }
        
    
        if let data = characteristic.value {
            
            let dataSTR = String(data: data, encoding: String.Encoding.utf8)
            print("data STR: ")
            print(dataSTR)
            print("------")
            print(String(data: data, encoding: String.Encoding.ascii))
            print("bytes in str: ")
            
            let weigth: UInt8 = data.withUnsafeBytes{ $0.pointee}
            
            
            text.text = " utf8:  \(dataSTR), \n ascii: \(String(data: data, encoding: String.Encoding.ascii)) \n charc: \(characteristic) "
        }



        if let er = error {
            text.text = String(describing: er)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor descriptor: CBDescriptor, error: Error?) {
        print("didUpdateValueFor descriptor")

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

            writeMessage(bytes: BCBuildMessages().startGetCard())
            
        } else if ppFunc.contains("GCR") {
            print("func: \(ppFunc)")
            writeMessage(bytes: BCBuildMessages().getCard())
        } else if ppFunc.contains("GCRR") {
            
        } else if ppFunc.contains("TLI") {
            print("func: \(ppFunc)")
            writeMessage(bytes: BCBuildMessages().loadTableLoadInit(input: "103112201427"))
            
        } else if ppFunc.contains("TLR") {
            print("func: \(ppFunc)")

            writeMessage(bytes: BCBuildMessages().loadTableLoadRec(table: "0328410107A00000000410100000000000000000000201MASTERCARD ••••••030082008200820769862MERCH00000000011234TERM0001E0F0C06000B0F 00021C8000000000000000000C800000000•••••••••••••••••••••••••••••••• ••••••••••••••••••••••••••••••••••••••••••••••••9F02069F03069F1A029 5055F2A029A039C010000Y1Z1Y3Z306210202101000000000000000000000000000 000302VISA•ELECTRON•••041091030652005060708000000000000000000000030 3VISA•CASH•••••••010000050000000000000000000015210198607612,.R$••1"))

            
        } else if ppFunc.contains("TLE") {
            print("func: \(ppFunc)")

            writeMessage(bytes: BCBuildMessages().loadTableLoadEnd())
            
        }  else if ppFunc.contains("GTS") {
            print("func: \(ppFunc)")
            
            let mMsg = String(format: "%03d", ppFuncTextFiled.text!)
           writeMessage(bytes: BCBuildMessages().getTimeStampt(input:"00"))
            
        } else if ppFunc.contains("GOCS") {
            print("func: \(ppFunc)")
            
            let input = "000000000500000000000000010301                                100000FA010000003E899000"
            let tags = "023829F279F269F36959F349F379F335F289F109A5F349F0B"
            let tagsOpt = "000"

            writeMessage(bytes: BCBuildMessages().startGoOnChip(input: input, tags: tags, tagsOpt: tagsOpt))

            
        } else if ppFunc.contains("GOC") {
            print("func: \(ppFunc)")

            writeMessage(bytes: BCBuildMessages().goOnChip(input: "086000000000500000000000000010301                                100000FA010000003E899000049023829F279F269F36959F349F379F335F289F109A5F349F0B003000"))

        }

    }

    func writeMessage(bytes: [UInt8]) {

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

            scale.writeValue(chunk, for: characteristic!, type: .withResponse)

            let stringFromData = String(data: chunk, encoding: .utf8)
            print("Sent: \(stringFromData ?? "")")

            sendDataIndex += amountToSend
        }
    }
}

struct ItemCollection {
    var ppfunc: String
    var color: UIColor
}
