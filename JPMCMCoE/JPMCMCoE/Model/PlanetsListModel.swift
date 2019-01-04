//
//  PlanetsListModel.swift
//  JPMCMCoE
//
//  Created by Ravi Verma on 03/01/19.
//  Copyright © 2019 Ravi. All rights reserved.
//

import Foundation

struct PlanetsListModel: Codable {
    var count = 0
    var results: [PlanetModel] = []
}

 struct PlanetModel: Codable {
    var name = ""
    var rotationPeriod = ""
    var orbitalPeriod = ""
    var diameter = ""
    var climate = ""
    var gravity = ""
    var terrain = ""
    var surfaceWater = ""
    var population = ""
    var residents: [String] = []
    var films: [String] = []
    var created = ""
    var edited = ""
    var url = ""
    var renderPage: Int?
    
    enum CodingKeys: String, CodingKey {
        case rotationPeriod = "rotation_period"
        case orbitalPeriod = "orbital_period"
        case surfaceWater = "surface_water"
        case name = "name"
        case diameter = "diameter"
        case climate = "climate"
        case gravity = "gravity"
        case terrain = "terrain"
        case population = "population"
        case residents = "residents"
        case films = "films"
        case created = "created"
        case edited = "edited"
        case url = "url"
        case renderPage = "renderPage"
    }
}


