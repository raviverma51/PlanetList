//
//  SecureContext.swift
//  JPMCMCoE
//
//  Created by Ravi Verma on 04/01/19.
//  Copyright © 2019 Ravi. All rights reserved.
//

import UIKit

struct UserDefaultsKey {
    static let planetList = "PlanetList"
}


class SecureContext: NSObject {
    
    static let shared = SecureContext()
    let userDefaults = UserDefaults.standard

    
    var allPagePlanetList: [PlanetModel] {
        get {
            if let planetData = userDefaults.value(forKey: UserDefaultsKey.planetList) as? Data {
                return (try? PropertyListDecoder().decode(Array<PlanetModel>.self, from: planetData)) ?? []
            }
            return []
        }
        set {
            do {
                userDefaults.set(try PropertyListEncoder().encode(newValue), forKey: UserDefaultsKey.planetList)
            } catch {
                userDefaults.set(nil, forKey: UserDefaultsKey.planetList)
            }
        }
    }
}

