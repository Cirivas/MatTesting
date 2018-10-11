//
//  StationDetailsViewController.swift
//  MapTesting
//
//  Created by Camilo Rivas on 19-02-18.
//  Copyright © 2018 Camilo Rivas. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class StationDetailsViewController : UIViewController, MKMapViewDelegate {
    
    //MARK: Properties
    @IBOutlet weak var mapView: MKMapView!
    var station : Station?
    var userLocation : CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        // Do any additional setup after loading the view, typically from a nib.
        if let station = station, let userLocation = userLocation {
            //Set initial camera
            let camera = MKMapCamera()
            camera.centerCoordinate = userLocation.coordinate
            camera.altitude = 10000
            mapView.setCamera(camera, animated: false)
            
            //Set up for direction
            let source = MKPlacemark(coordinate: userLocation.coordinate, addressDictionary: nil)
            let coords = CLLocationCoordinate2D(latitude: (station.latitude as NSString).doubleValue, longitude: (station.longitude as NSString).doubleValue)
            let destination = MKPlacemark(coordinate: coords, addressDictionary: nil)
            
            let sourceAnnotation = MKPointAnnotation()
            sourceAnnotation.coordinate = userLocation.coordinate
            sourceAnnotation.title = "MeLocation"
            let destinationAnnotation = MKPointAnnotation()
            destinationAnnotation.coordinate = coords
            
            mapView.addAnnotation(sourceAnnotation)
            mapView.addAnnotation(destinationAnnotation)

            
            let sourceItem = MKMapItem(placemark: source)
            let destinationItem = MKMapItem(placemark: destination)
            
            let directionRequest = MKDirectionsRequest()
            directionRequest.source = sourceItem
            directionRequest.destination = destinationItem
            directionRequest.transportType = .automobile
            
            let directions = MKDirections(request: directionRequest)
            
            directions.calculate(completionHandler: { (response, error) -> Void in
                guard let response = response else {
                    if let error = error {
                        print("Error: \(error)")
                    }
                    return
                }
                
                let route = response.routes[0]
                self.mapView.add((route.polyline), level: MKOverlayLevel.aboveRoads)
                
                let rect = route.polyline.boundingMapRect
                self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
            })
        }
    }
    
    //MARK: Map delegate
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 4.0
        
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseIdentifier = "pin"
        
        let stationAnnotation = annotation as! MKPointAnnotation
        
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
    
    
}
