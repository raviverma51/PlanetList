//
//  PlanetListService.swift
//  JPMCMCoE
//
//  Created by Ravi Verma on 03/01/19.
//  Copyright © 2019 Ravi. All rights reserved.
//

import Foundation

class PlanetListService {
    
    func performRequest(endPointUrl: URL, completion:@escaping (PlanetsListModel?, Error?) -> Void) {
        let dataTask  = URLSession(configuration: .default).dataTask(with: requestWithURL(url: endPointUrl), completionHandler: {(data, response, error) in
            
            if error != nil {
                completion(nil, error)
            }
            else {
                guard let data = data,  let planetsListModel = try? JSONDecoder().decode(PlanetsListModel.self, from: data) else {
                    completion(nil, error)
                    return
                }
                completion(planetsListModel, nil)
            }
        })
        
        dataTask.resume()
    }
    
    
    func requestWithURL(url: URL) -> URLRequest  {
        var request: URLRequest = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
}
