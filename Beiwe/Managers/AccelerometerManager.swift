//
//  AccelerometerManager.swift
//  Beiwe
//
//  Created by Keary Griffin on 3/31/16.
//  Copyright © 2016 Rocketfarm Studios. All rights reserved.
//

import Foundation
import CoreMotion
import PromiseKit

class AccelerometerManager : DataServiceProtocol {
    let motionManager = AppDelegate.sharedInstance().motionManager;

    let headers = ["timestamp", "accuracy", "x", "y", "z"]
    let storeType = "accel";
    var store: DataStorage?;
    var offset: Double = 0;

    func initCollecting() -> Bool {
        guard  motionManager.accelerometerAvailable else {
            log.info("Accel not available.  Not initializing collection");
            return false;
        }

        store = DataStorageManager.sharedInstance.createStore(storeType, headers: headers);
        // Get NSTimeInterval of uptime i.e. the delta: now - bootTime
        let uptime: NSTimeInterval = NSProcessInfo.processInfo().systemUptime;

        // Now since 1970
        let nowTimeIntervalSince1970: NSTimeInterval  = NSDate().timeIntervalSince1970;

        // Voila our offset
        self.offset = nowTimeIntervalSince1970 - uptime;

        motionManager.accelerometerUpdateInterval = 0.1;

        return true;
    }

    func startCollecting() {
        log.info("Turning \(storeType) collection on");
        let queue = NSOperationQueue()


        motionManager.startAccelerometerUpdatesToQueue(queue) {
            (accelData, error) in

            if let accelData = accelData {
                var data: [String] = [ ];
                let timestamp: Double = accelData.timestamp + self.offset;
                data.append(String(Int64(timestamp * 1000)));
                data.append("unknown");
                data.append(String(accelData.acceleration.x))
                data.append(String(accelData.acceleration.y))
                data.append(String(accelData.acceleration.z))

                self.store?.store(data);
            }
        }
    }
    func pauseCollecting() {
        log.info("Pausing \(storeType) collection");
        motionManager.stopAccelerometerUpdates();
        store?.flush();
    }
    func finishCollecting() -> Promise<Void> {
        print ("Finishing \(storeType) collecting");
        pauseCollecting();
        store = nil;
        return DataStorageManager.sharedInstance.closeStore(storeType);
    }
}