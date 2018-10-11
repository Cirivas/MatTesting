//
//  Station.swift
//  MapTesting
//
//  Created by Camilo Rivas on 15-02-18.
//  Copyright © 2018 Camilo Rivas. All rights reserved.
//

import MapKit

class StationAnnotation: NSObject, MKAnnotation {
    
    var station : Station?
    var title : String??
    var image: UIImage!
    var coordinate: CLLocationCoordinate2D
    
    init(coordinate: CLLocationCoordinate2D){
        self.coordinate = coordinate
    }
}

class Stations : Codable {
    let stations: [Station]
}

struct Station : Codable {
    let id: Int
    let company: String
    let title: String
    let description: String
    let email: String?
    let commune: String
    let region: String
    let phone: String?
    let uuid: String
    let latitude: String
    let longitude: String
    let distance: String
    let decimal_distance: Float
    let copec_id: Int
    let diesel: Int?
    let kerosene: Int?
    let gasoline_93: Int?
    let gasoline_95: Int?
    let gasoline_97: Int?
    let gnc: Int?
    let glp: Int?
    let pronto: Bool
    let punto: Bool
    let dpaso: Bool
    let cajero: Bool
    let bano: Bool
    let lavamax: Bool
    let zervo: Bool
    let voltex: Bool
    let cupon: Bool
    let tct: Bool
    let lanpass: Bool
    let taxiamigo: Bool
    let mobil: Bool
    let tae: Bool
    let renova: Bool
    let lavamax_autoservicio: Bool
    let lavamax_automatico: Bool
    let glp_service: Bool
    let gnc_service: Bool
    let tct_premium: Bool
    let bluemax_surtidor: Bool
    let bluemax_bidon: Bool
    let agenda_online: Bool
    let chiletur: Bool
    let pronto_ruta: Bool
    let lub: Bool
    let cyclist: Bool
}
