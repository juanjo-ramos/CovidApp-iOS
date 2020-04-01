//
//  ViewController.swift
//  CovidApp-iOS
//
//  Created by Juanjo Ramos Rodriguez on 29/03/2020.
//  Copyright © 2020 Las Juntas. All rights reserved.
//

import CoreBluetooth
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet private weak var userLabel: UILabel!
    private let serviceId = CBUUID(string: "a57c806a-71ae-11ea-bc55-0242ac130003")
    private let userId = UIDevice.current.identifierForVendor?.uuidString ?? "Unknown"
    private var bluetoothManager: BluetoothManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userIdLabel.text = "Your userId is \(userId)"
        updateUserLabel(totalNumber: 0)
        bluetoothManager = BluetoothManager(serviceId: serviceId, userId: userId, delegate: self)
        bluetoothManager.start()
    }
    
    private func updateUserLabel(totalNumber: Int) {
        userLabel.text = "You have interacted with \(totalNumber) people"
    }
}

extension ViewController: BluetoothManagerDelegate {
    func updateUsersFound(totalNumber: Int) {
        updateUserLabel(totalNumber: totalNumber)
    }
}

