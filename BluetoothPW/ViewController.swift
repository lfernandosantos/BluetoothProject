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


    @IBOutlet weak var tableCharac: UITableView!
    @IBOutlet weak var tableServices: UITableView!
    @IBOutlet weak var readBtn: UIButton!
    @IBOutlet weak var ppFuncTextFiled: UITextField!
    @IBOutlet weak var text: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        centralManager = CBCentralManager()
        centralManager.delegate = self

        readBtn.frame.size.height = readBtn.frame.width
        readBtn.layer.cornerRadius = readBtn.frame.width/2

        tableServices.delegate = self
        tableCharac.delegate = self

        tableServices.dataSource = self
        tableCharac.dataSource = self

        self.hideKeyboardWhenTappedAround()

    }


    @IBAction func write(_ sender: Any) {
        scale.writeValue(ppFuncTextFiled.text!.data(using: String.Encoding.utf8)!, for: characteristic!, type: .withResponse)
    }

    @IBAction func readPinpad(_ sender: Any) {
        if let char = characteristic {
            scale.readValue(for: char)
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

        if peripheral.identifier.uuidString == "5D82CA3B-9795-01F5-D95E-0324890BE23E" {
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

//        if let service = peripheral.services?.first {
//            peripheral.discoverCharacteristics(nil, for: service)
//        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        charList = service.characteristics
        tableCharac.reloadData()
        print("characteristics ==> > ")
        service.characteristics?.forEach{
            print($0)
        }
        print("-------------------")

//        if let caracteristic = service.characteristics?[1] {
//            print(caracteristic)
//
//            peripheral.readValue(for: caracteristic)
//            peripheral.readValue(for: service.characteristics!.first!)
//        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {

        print("didUpdateValueFor")
        if let data = characteristic.value {
            let weigth: Int = data.withUnsafeBytes{ $0.pointee}
            print("\(String(weigth)) g")

            text.text = " int data:  \(weigth), \n data str: \(String(data: data, encoding: .utf8)) \n charc: \(characteristic) descriptions: \(characteristic.description) \n properties: \(characteristic.properties)"

            print(text.text)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        print("didUpdateNotificationStateFor")
        if let data = characteristic.value {
            let weigth: Int = data.withUnsafeBytes{ $0.pointee}
            print("\(String(weigth)) g")

            text.text = " int data:  \(weigth), \n data str: \(String(data: data, encoding: .utf8)) \n charc: \(characteristic) \n nsdata: \(NSString(data: data, encoding: String.Encoding.utf8.rawValue))"
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
                //scale.setNotifyValue(true, for: charSelected)

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
