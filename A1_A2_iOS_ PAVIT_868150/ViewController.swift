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
    
    
}

