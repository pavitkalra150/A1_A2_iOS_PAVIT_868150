//
//  ViewController.swift
//  A1_A2_iOS_ PAVIT_868150
//
//  Created by PAVIT KALRA on 2023-01-20.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var directionBtn: UIButton!
    
    
    var locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        map.delegate = self
        map.isZoomEnabled = false
        
    }

    @IBAction func zoomIn(_ sender: UIButton) {
        let currentRegion = map.region
            let newRegion = MKCoordinateRegion(center: currentRegion.center, span: MKCoordinateSpan(latitudeDelta: currentRegion.span.latitudeDelta/2, longitudeDelta: currentRegion.span.longitudeDelta/2))
           map.setRegion(newRegion, animated: true)
    }
    
    @IBAction func zoomOut(_ sender: UIButton) {
        let currentRegion = map.region
            let newRegion = MKCoordinateRegion(center: currentRegion.center, span: MKCoordinateSpan(latitudeDelta: currentRegion.span.latitudeDelta*2, longitudeDelta: currentRegion.span.longitudeDelta*2))
            map.setRegion(newRegion, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation = locations[0]
        
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        
        
        displayLocation(latitude: latitude, longitude: longitude, title: "my Location", subtitle: "you are here")
    }
    
    func displayLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees, title: String, subtitle: String){
        
        //DEFINE SPAN
        let latdelta: CLLocationDegrees = 0.05
        let lngdelta: CLLocationDegrees = 0.05
        
        let span = MKCoordinateSpan(latitudeDelta: latdelta, longitudeDelta: lngdelta)
        
        
        //DEFINE LOCATION
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        
        //DEFINE REGION
        let region = MKCoordinateRegion(center: location, span: span)
        
        
        //SET REGION ON MAP
        map.setRegion(region, animated: true)
        
    }
    
}

