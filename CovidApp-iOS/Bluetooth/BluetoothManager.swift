//
//  BluetoothManager.swift
//  CovidApp-iOS
//
//  Created by Juanjo Ramos Rodriguez on 29/03/2020.
//  Copyright © 2020 Las Juntas. All rights reserved.
//

import CoreBluetooth
import Foundation

protocol BluetoothManagerProtocol {
    func start()
    func stop()
}

protocol BluetoothManagerDelegate: class {
    func updateUsersFound(totalNumber: Int)
}

class BluetoothManager: NSObject {
    private weak var delegate: BluetoothManagerDelegate?
    private var centralManager: CBCentralManager?
    private var peripheralManager: CBPeripheralManager?
    private let serviceId: CBUUID
    private let userId: String
    private var usersRecord = [String: [Date]]()
    private let thresholdTime: TimeInterval = -60*15 // 15 minutes ago
    
    init(serviceId: CBUUID, userId: String, delegate: BluetoothManagerDelegate) {
        self.serviceId = serviceId
        self.userId = userId
        self.delegate = delegate
    }
}

extension BluetoothManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("New Central State=\(central.state.rawValue)")
        
        if central.state == .poweredOn {
            startScanning()
        }
    }
    
    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any],
                        rssi RSSI: NSNumber) {
        guard let userId = advertisementData[CBAdvertisementDataLocalNameKey] as? String else {
            print("User id not found for peripheral=\(peripheral.name ?? "")")
            return
        }
        print("New device discovered: \(userId)")
        guard let totalNumber = updateUsersRecords(newUserId: userId) else { return }
        delegate?.updateUsersFound(totalNumber: totalNumber)
    }
    
    private func startScanning() {
        centralManager?.scanForPeripherals(withServices: [serviceId], options: [CBCentralManagerScanOptionAllowDuplicatesKey: false])
    }
    
    // MARK: Private functions
    
    private func updateUsersRecords(newUserId: String) -> Int? {
        guard var existingDates = usersRecord[newUserId] else {
            usersRecord[newUserId] = [Date()]
            return usersRecord.count
        }
        // If we've just seeing it in the last 15m, ignore
        let thresholdDate = Date(timeIntervalSinceNow: thresholdTime)
        guard let lastTime = existingDates.last, lastTime < thresholdDate else {
            return nil
        }
//        guard let lastTime = let lastTime = existingDates.last, Date.
        existingDates.append(Date())
        print(usersRecord[newUserId])
        usersRecord[newUserId] = existingDates
        print(usersRecord[newUserId])
        return usersRecord.count
    }
}

extension BluetoothManager: CBPeripheralManagerDelegate {
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        print("New Peripheral State=\(peripheral.state.rawValue)")
        if peripheral.state == .poweredOn {
            startAdvertising()
        }
    }
    
    private func startAdvertising() {
        let peripheralService = CBMutableService(type: serviceId, primary: true)
        peripheralManager?.add(peripheralService)
        peripheralManager?.startAdvertising([CBAdvertisementDataServiceUUIDsKey: [serviceId],
                                             CBAdvertisementDataLocalNameKey: userId])
    }
}

extension BluetoothManager: BluetoothManagerProtocol {
    func start() {
        let centralManager = self.centralManager ?? CBCentralManager(delegate: self, queue: nil)
        let peripheralManager = self.peripheralManager ?? CBPeripheralManager(delegate: self, queue: nil, options: [CBPeripheralManagerOptionShowPowerAlertKey: true])
        
        self.centralManager = centralManager
        self.peripheralManager = peripheralManager
    }
    
    func stop() {
        centralManager?.stopScan()
        peripheralManager?.stopAdvertising()
    }
}
