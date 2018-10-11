//
//  ViewController.swift
//  MapTesting
//
//  Created by Camilo Rivas on 13-02-18.
//  Copyright © 2018 Camilo Rivas. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class StationsMapViewController: UIViewController, MKMapViewDelegate {

    // MARK: Properties
    @IBOutlet var mapView: MKMapView!
    let manager = CLLocationManager()
    var stations : Stations? {
        didSet {
            addMarks()
        }
    }
    var userLocation : CLLocation? {
        didSet {
            setUpMap()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mapView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        for ann in mapView.selectedAnnotations {
            mapView.deselectAnnotation(ann, animated: false)
        }
        
    }
    
    // MARK: Map delegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseIdentifier = "pin"
        
        let stationAnnotation = annotation as! StationAnnotation
        
        var v = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        if v == nil {
            v = MKAnnotationView(annotation: stationAnnotation, reuseIdentifier: reuseIdentifier)
            v!.canShowCallout = false
        } else {
            v!.annotation = stationAnnotation
        }
        
        if(stationAnnotation.title != nil) {
            v!.image = UIImage(named: "MarkerMe")
        } else {
            v!.image = UIImage(named: "MarkerCopec")
        }
        
        return v
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("touched pin")
        let annotation = view.annotation as! StationAnnotation
        print(annotation.coordinate)
        if let station = annotation.station {
            performSegue(withIdentifier: "StationDetailsSegue", sender: station)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
        case "StationDetailsSegue":
            guard let stationDetailsViewController = segue.destination as? StationDetailsViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            let station = sender as? Station
            stationDetailsViewController.station = station
            stationDetailsViewController.userLocation = self.userLocation
        default:
            print("default case")
        }
    }
    
    // MARK: Private
    private func addMarks(){
        for station in (self.stations?.stations)! {
            let coords = CLLocationCoordinate2D(latitude: (station.latitude as NSString).doubleValue, longitude: (station.longitude as NSString).doubleValue)
            let annotation = StationAnnotation(coordinate: coords)
            annotation.station = station
            mapView.addAnnotation(annotation)
        }
    }
    
    private func getStations(location : CLLocation){
        let session = URLSession(configuration: .ephemeral, delegate: nil, delegateQueue: OperationQueue.main)
        let url = URL(string: "http://copec.modyo.be/copec/stations/get_stations.json?company=copec&pagoclick=pagoclick&limit=100&latitude=\(location.coordinate.latitude)&longitude=\(location.coordinate.longitude)&gasoline_93=gasoline_93")!
        let task = session.dataTask(with: url, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            guard let responseData = data else {
                return
            }

            do {
                self.stations = try JSONDecoder().decode(Stations.self, from: responseData)
                self.addMarks()
            } catch {
                print(error)
            }
            
        })
        task.resume()

    }
    
    private func setUpMap(){
        let coords = CLLocationCoordinate2D(latitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude)
        let annotation = StationAnnotation(coordinate: coords)
        annotation.title = "Tu ubicación"
        mapView.addAnnotation(annotation)
        let camera = MKMapCamera()
        camera.centerCoordinate = coords
        camera.altitude = 10000
        mapView.setCamera(camera, animated: true)
    }
}

