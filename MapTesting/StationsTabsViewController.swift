//
//  StationsTabs.swift
//  MapTesting
//
//  Created by Camilo Rivas on 20-02-18.
//  Copyright © 2018 Camilo Rivas. All rights reserved.
//

import UIKit
import CoreLocation

class StationsTabsViewController : UIViewController, CLLocationManagerDelegate {
    
    //MARK: Properties

    @IBOutlet weak var contentView: UIView!
    @IBOutlet var buttons : [UIButton]!
    let manager = CLLocationManager()
    var stations : Stations?
    var called : Bool = false
    var userLocation : CLLocation!
    
    var stationsMapViewController : UIViewController!
    var stationsListViewController : UIViewController!
    var viewControllers: [UIViewController]!
    
    var selectedIndex : Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Prepare custom tabs
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        stationsMapViewController = storyboard.instantiateViewController(withIdentifier: "StationsMap")
        stationsListViewController = storyboard.instantiateViewController(withIdentifier: "StationsList")
        viewControllers = [stationsMapViewController, stationsListViewController]
        
        buttons[selectedIndex].isSelected = true
        didPressTab(buttons[selectedIndex])
        
        //Get user location and stations
        enableLocationServices()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Location delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("Found user's location: \(location)")
            if !self.called {
                self.called = true
                userLocation = location
                (stationsMapViewController as! StationsMapViewController).userLocation = userLocation
                (stationsListViewController as! StationsListViewController).userLocation = userLocation
                getStations(location: location)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    // MARK: Actions
    @IBAction func didPressTab(_ sender: UIButton) {
        if sender.tag == 0 {
            changeView(sender: sender)
        } else if sender.tag == 1 && stations != nil {
            changeView(sender: sender)
        } else {
            print("button pressed")
        }
    }
    
    // MARK: Private
    private func changeView(sender: UIButton){
        let previousIndex = selectedIndex
        selectedIndex = sender.tag
        buttons[previousIndex].isSelected = false
        let previousVC = viewControllers[previousIndex]
    
        previousVC.willMove(toParentViewController: nil)
        previousVC.view.removeFromSuperview()
        previousVC.removeFromParentViewController()
    
        sender.isSelected = true
        let vc = viewControllers[selectedIndex]

        addChildViewController(vc)
    
        vc.view.frame = contentView.bounds
        vc.automaticallyAdjustsScrollViewInsets = false
        contentView.addSubview(vc.view)
        vc.didMove(toParentViewController: self)
    }
    
    private func getStations(location : CLLocation){
        let url = URL(string: "http://copec.modyo.be/copec/stations/get_stations.json?company=copec&pagoclick=pagoclick&limit=100&latitude=\(location.coordinate.latitude)&longitude=\(location.coordinate.longitude)&gasoline_93=gasoline_93")!
        let stationsRequest = StationsRequest(url: url)
        stationsRequest.load(withCompletion: { [weak self] (stations: Stations?) in
            guard let stations = stations else {
                print("error tabs view")
                return
            }
            self?.stations = stations
            
            (self?.stationsMapViewController as! StationsMapViewController).stations = self?.stations
            (self?.stationsListViewController as! StationsListViewController).stations = self?.stations
        })
        
    }
    
    func enableLocationServices(){
        manager.delegate = self
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            // Request when-in-use authorization initially
            print("not determined")
            manager.requestWhenInUseAuthorization()
            
        case .restricted, .denied:
            // Disable location features
            //disableMyLocationBasedFeatures()
            print("restricted or denied")
            break
            
        case .authorizedWhenInUse:
            // Enable basic location features
            print("authorized when in use")
            manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            manager.requestLocation()
            
        case .authorizedAlways:
            // Enable any of your app's location features
            print("authorized always")
            manager.startUpdatingLocation()
        }
    }
    
}
