//
//  ListViewController.swift
//  JPMCMCoE
//
//  Created by Ravi Verma on 03/01/19.
//  Copyright © 2019 Ravi. All rights reserved.
//

let endPoint: String = "https://swapi.co/api/planets/"
let endPointNewPage: String = "https://swapi.co/api/planets/?page=%d"
let scaleFactorToShowPage: Int = 10

import UIKit

class ListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    var viewModel: PlanetViewModel?
    var allPagePlanetList: [PlanetModel] = []
    var maxPageToRender: Int = 0
    var currentPage: Int = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nextButton: UIButton = UIButton(type: .roundedRect)
        nextButton.setTitle("Next", for: .normal)
        nextButton.addTarget(self, action: #selector(ListViewController.nextPage), for: .touchUpInside)
        
        let prevButton: UIButton = UIButton(type: .roundedRect)
        prevButton.setTitle("Prev", for: .normal)
        prevButton.addTarget(self, action: #selector(ListViewController.previousPage), for: .touchUpInside)

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: nextButton)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: prevButton)
        self.navigationItem.leftBarButtonItem?.customView?.isHidden = true
        callPlanetService()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @objc func nextPage() {
        self.navigationItem.rightBarButtonItem?.customView?.isHidden = false
        self.navigationItem.leftBarButtonItem?.customView?.isHidden = false
        if (currentPage + 1) == maxPageToRender {
            self.navigationItem.leftBarButtonItem?.customView?.isHidden = false
            self.navigationItem.rightBarButtonItem?.customView?.isHidden = true
        }
        currentPage += 1
        callPlanetService()
    }

    @objc func previousPage() {
        self.navigationItem.rightBarButtonItem?.customView?.isHidden = false
        self.navigationItem.leftBarButtonItem?.customView?.isHidden = false
        
        if (currentPage - 1) == 1 {
            self.navigationItem.leftBarButtonItem?.customView?.isHidden = true
            self.navigationItem.rightBarButtonItem?.customView?.isHidden = false
        }
        currentPage -= 1
        callPlanetService()
        
    }
    

    func callPlanetService() {

        let storedDataModelList = SecureContext.shared.allPagePlanetList.filter({ $0.renderPage == currentPage })
        if storedDataModelList.count > 0 {
            viewModel = PlanetViewModel(results: storedDataModelList, maxResultCount: 61)
        }
        
        else {
            if let url = URL(string: (currentPage == 1) ? endPoint : String(format:endPointNewPage, currentPage) ) {
                weak var weakSelf = self
                activityIndicatorView.startAnimating()
                let service = PlanetListService()
                service.performRequest(endPointUrl: url, completion: {
                    (responseModel, error) in
                    
                    DispatchQueue.main.async {
                        weakSelf?.activityIndicatorView.stopAnimating()
                    }
                    
                    if error != nil {
                        weakSelf?.showServerErrorAlert()
                    }
                    else {
                        weakSelf?.viewModel = PlanetViewModel(results: responseModel?.results, maxResultCount: responseModel?.count ?? 0)
                        weakSelf?.getMaxPageRender(resultCount: weakSelf?.viewModel?.maxResultCount)
                        
                        if let results = responseModel?.results {
                            for planetModel in results {
                                var updatedPlanetModel = planetModel
                                updatedPlanetModel.renderPage = weakSelf?.currentPage ?? 1
                                SecureContext.shared.allPagePlanetList.append(updatedPlanetModel)
                            }
                        }
                        
                        DispatchQueue.main.async {
                            weakSelf?.tableView.reloadData()
                        }
                    }
                })
            }
            else {
                showAlertWithMessage(message: "Url end point is not correct !!")
            }
            
        }
        tableView.reloadData()
    }

    
    func getMaxPageRender(resultCount: Int?) {
        if let resultCount = resultCount {
            if resultCount % 2 == 0 {
                maxPageToRender = resultCount/scaleFactorToShowPage
            }
            else {
                maxPageToRender = (resultCount/scaleFactorToShowPage) + 1
            }
        }
    }
}


extension ListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PlanetTableViewCell.planetTableViewCell) as? PlanetTableViewCell else {
            return UITableViewCell()
        }
        viewModel?.viewModelForIndex(index: indexPath.row)
        cell.textLabel?.text = viewModel?.planetName
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.resultCount ?? 0
    }
}

extension ListViewController: UtilityProtocols {}
