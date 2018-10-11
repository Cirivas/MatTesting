//
//  StationsListViewController.swift
//  MapTesting
//
//  Created by Camilo Rivas on 20-02-18.
//  Copyright © 2018 Camilo Rivas. All rights reserved.
//

import UIKit
import CoreLocation

class StationsListViewController: UIViewController, UITableViewDataSource {
    //MARK: Properties
    @IBOutlet weak var stationsTable: UITableView!
    var stations : Stations?
    var userLocation : CLLocation!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        stationsTable.dataSource = self
        self.automaticallyAdjustsScrollViewInsets = false
        //stationsTable.bounces = false
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        let offset = CGPoint.init(x: 0, y:0)
//        self.stationsTable.setContentOffset(offset, animated: false)
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Table source delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stations!.stations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier") as? StationTableViewCell else {
            fatalError("Not instance")
        }
        
        let station = stations!.stations[indexPath.row]
        
        cell.station = station
        cell.communeLabel.text = station.commune
        cell.distanceLabel.text = String(describing: station.decimal_distance)
        cell.titleLabel.text = station.title
        
        if let gas93 = station.gasoline_93 {
            cell.gas93PriceLabel.text = String(describing: gas93)
        }
        
        if let gas95 = station.gasoline_95 {
            cell.gas95PriceLabel.text = String(describing: gas95)
        }
        
        if let gas97 = station.gasoline_97 {
            cell.gas97PriceLabel.text = String(describing: gas97)
        }
        
        
        
        return cell
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "StationDetailsFromListSegue" {
            guard let stationDetailsViewController = segue.destination as? StationDetailsViewController else {
                fatalError("Unexpected destination")
            }
            
            guard let selectedCell = sender as? StationTableViewCell else {
                fatalError("Unexpected sender")
            }
            
            guard let indexPath = stationsTable.indexPath(for: selectedCell) else {
                fatalError("cell not in table")
            }
            
            let selectedStation = stations!.stations[indexPath.row]
            stationDetailsViewController.station = selectedStation
            stationDetailsViewController.userLocation = userLocation
        }
        
    }
    

}
