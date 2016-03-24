//
//  Configuration.swift
//  Beiwe
//
//  Created by Keary Griffin on 3/24/16.
//  Copyright © 2016 Rocketfarm Studios. All rights reserved.
//

import Foundation

class Configuration {
    static let sharedInstance = Configuration();
    var settings: Dictionary<String, AnyObject> = [:];

    init() {
        if let path = NSBundle.mainBundle().pathForResource("Config-Default", ofType: "plist"), dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
            for (key,value) in dict {
                settings[key] = value;
            }
        }
        if let path = NSBundle.mainBundle().pathForResource("Config", ofType: "plist"), dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
            for (key,value) in dict {
                settings[key] = value;
            }
        }

    }
}