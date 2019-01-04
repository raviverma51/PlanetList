//
//  PlanetViewModel.swift
//  JPMCMCoE
//
//  Created by Ravi Verma on 03/01/19.
//  Copyright © 2019 Ravi. All rights reserved.
//

import Foundation

class PlanetViewModel: Codable {
    var results: [PlanetModel]?
    var planetModel: PlanetModel?
    var maxResultCount: Int?
    
    init(results: [PlanetModel]!, maxResultCount: Int) {
        self.results = results
        self.maxResultCount = maxResultCount
    }
    
    func viewModelForIndex(index: Int) {
        planetModel = self.results?[index]
    }
    
    var planetName: String? {
        get {
            return planetModel?.name
        }
    }
    
    var resultCount: Int? {
        get {
            return results?.count
        }
    }
}
