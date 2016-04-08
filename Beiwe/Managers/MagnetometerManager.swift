//
//  MagnetometerManager.swift
//  Beiwe
//
//  Created by Keary Griffin on 4/3/16.
//  Copyright © 2016 Rocketfarm Studios. All rights reserved.
//

import Foundation
import CoreMotion

class MagnetometerManager : DataServiceProtocol {
    let motionManager = AppDelegate.sharedInstance().motionManager;

    let headers = ["timestamp", "accuracy", "x", "y", "z"]
    let storeType = "magnetometer";
    var store: DataStorage?;
    var offset: Double = 0;

    func initCollecting() -> Bool {
        guard  motionManager.magnetometerAvailable else {
            print("Magnetometer not available.  Not initializing collection");
            return false;
        }

        store = DataStorageManager.sharedInstance.createStore(storeType, headers: headers);
        // Get NSTimeInterval of uptime i.e. the delta: now - bootTime
        let uptime: NSTimeInterval = NSProcessInfo.processInfo().systemUptime;
        // Now since 1970
        let nowTimeIntervalSince1970: NSTimeInterval  = NSDate().timeIntervalSince1970;
        // Voila our offset
        self.offset = nowTimeIntervalSince1970 - uptime;
        motionManager.magnetometerUpdateInterval = 0.1;

        return true;
    }

    func startCollecting() {
        print("Turning \(storeType) collection on");
        let queue = NSOperationQueue.mainQueue();


        motionManager.startMagnetometerUpdatesToQueue(queue) {
            (magData, error) in

            if let magData = magData {
                var data: [String] = [ ];
                let timestamp: Double = magData.timestamp + self.offset;
                data.append(String(Int64(timestamp * 1000)));
                data.append(AppDelegate.sharedInstance().modelVersionId);
                data.append(String(magData.magneticField.x))
                data.append(String(magData.magneticField.y))
                data.append(String(magData.magneticField.z))

                self.store?.store(data);
            }
        }
    }
    func pauseCollecting() {
        print("Pausing \(storeType) collection");
        motionManager.stopGyroUpdates();
        store?.flush();
    }
    func finishCollecting() {
        print ("Finishing \(storeType) collecting");
        pauseCollecting();
        DataStorageManager.sharedInstance.closeStore(storeType);
        store = nil;
    }
}