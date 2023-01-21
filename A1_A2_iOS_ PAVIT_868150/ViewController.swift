//
//  ViewController.swift
//  A1_A2_iOS_ PAVIT_868150
//
//  Created by PAVIT KALRA on 2023-01-20.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var directionBtn: UIButton!
    
    @IBOutlet weak var addressTextField: UITextField!
    var numbersOfAnnotations: Int = 0
    
    var locationManager = CLLocationManager()
    var distanceLabels: [UILabel] = []
    let geocoder = CLGeocoder()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        map.delegate = self
        map.isZoomEnabled = false
        doubleTap()
        
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
        
        
        displayLocation(latitude: latitude, longitude: longitude)
    }
    
    func displayLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        
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
    
    func doubleTap(){
        let double = UITapGestureRecognizer(target: self, action: #selector(dropPin))
        double.numberOfTapsRequired = 2
        map.addGestureRecognizer(double)
    }
    
    @objc func dropPin(sender: UITapGestureRecognizer){
        //print(map.annotations.count)
        if sender.state == .ended {
                let touchPoint = sender.location(in: map)
                let coordinate = map.convert(touchPoint, toCoordinateFrom: map)
            if map.annotations.count == 4 && sender.numberOfTapsRequired == 2 {
                        map.removeAnnotations(map.annotations)
                        map.removeOverlays(map.overlays)
                        remoteDistanceLabel()
                        let annotationCity = City(coordinate: coordinate, title: "A")
                        map.addAnnotation(annotationCity)
                    }
            else if sender.numberOfTapsRequired == 2 {
                    var title: String = ""
                    switch map.annotations.count {
                    case 1:
                        title = "A"
                    case 2:
                        title = "B"
                    case 3:
                        title = "C"
                    default:
                        break
                    }

                    let annotationCity = City(coordinate: coordinate, title: title)
                    map.addAnnotation(annotationCity)
                }
            }
        addPolygon()
        //addPolyline()
    }
    
    
    func addPolygon() {

        var myAnnotations: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()

        for point in map.annotations{
            if point.title == "My Location" {
                continue
            }
            myAnnotations.append(point.coordinate)
        }

        let polygon = MKPolygon(coordinates: myAnnotations, count: myAnnotations.count)

        map.addOverlay(polygon)
        
    }
    
    
    func addPolyline() {
        directionBtn.isHidden = false
        var myAnnotations: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
        for mapAnnotation in map.annotations {
    
            myAnnotations.append(mapAnnotation.coordinate)
        }
        
        myAnnotations.append(myAnnotations[0])
        
        let polyline = MKPolyline(coordinates: myAnnotations, count: myAnnotations.count)
        map.addOverlay(polyline, level: .aboveRoads)
        //showDistanceBetweenTwoPoint()
        
    }
    
    @IBAction func searchAddress(_ sender: UIButton) {
        //searchAddress()
        let address = addressTextField.text!
            let searchRequest = MKLocalSearch.Request()
            searchRequest.naturalLanguageQuery = address
            let activeSearch = MKLocalSearch(request: searchRequest)
        activeSearch.start { [self] (response, error) in
                if error == nil {
                    let coordinates = response?.boundingRegion.center
                    let lat = coordinates?.latitude
                    let lon = coordinates?.longitude
                    let location = CLLocationCoordinate2D(latitude: lat!, longitude: lon!)
                    self.displayLocation(latitude: lat!, longitude: lon!)
                    let annotationCity = City(coordinate: location, title: "")
                    if map.annotations.count == 4 {
                                map.removeAnnotations(map.annotations)
                                map.removeOverlays(map.overlays)
                        annotationCity.title = "A"
                                map.addAnnotation(annotationCity)
                            }
                    switch self.map.annotations.count {
                                    case 1:
                                        annotationCity.title = "A"
                                    case 2:
                                        annotationCity.title = "B"
                                    case 3:
                                        annotationCity.title = "C"
                                    default:
                                        break
                                    }
                    self.map.addAnnotation(annotationCity)
                    addPolygon()
                }
                else {
                    print(error?.localizedDescription ?? "Error")
                }
            }
        
    }

    @IBAction func drawRoute(_ sender: UIButton) {
        
        //print(map.annotations.count)
        map.removeOverlays(map.overlays)
        remoteDistanceLabel()
        var nextIndex = 0
        for index in 0 ... 2 {
            if index == 2 {
                nextIndex = 0
            } else {
                nextIndex = index + 1
            }
            
            
            let source = MKPlacemark(coordinate: map.annotations[index].coordinate)
            
            let destination = MKPlacemark(coordinate: map.annotations[nextIndex].coordinate)
            
            let directionRequest = MKDirections.Request()
            
            directionRequest.source = MKMapItem(placemark: source)
            directionRequest.destination = MKMapItem(placemark: destination)
            
            directionRequest.transportType = .automobile
            
            let directions = MKDirections(request: directionRequest)
            
            directions.calculate(completionHandler: { (response, error) in
                guard let directionResponse = response else {
                    return
                }
                
                let route = directionResponse.routes[0]
                self.map.addOverlay(route.polyline, level: .aboveRoads)
                
                let rect = route.polyline.boundingMapRect
                self.map.setVisibleMapRect(rect, edgePadding: UIEdgeInsets(top: 100, left: 100, bottom: 100, right: 100), animated: true)
            })
            }
        showDistanceBetweenTwoPoint()
    }
    
    func removeOverlays() {
        directionBtn.isHidden = true
        remoteDistanceLabel()
        
        for polygon in map.overlays {
            map.removeOverlay(polygon)
        }
    }
    
    private func remoteDistanceLabel() {
        for label in distanceLabels {
            label.removeFromSuperview()
        }
        
        distanceLabels = []
    }
    private func showDistanceBetweenTwoPoint() {
        var nextIndex = 0
        
        for index in 0...2{
            if index == 2 {
                nextIndex = 0
            } else {
                nextIndex = index + 1
            }

            let distance: Double = getDistance(from: map.annotations[index].coordinate, to:  map.annotations[nextIndex].coordinate)
            
            let pointA: CGPoint = map.convert(map.annotations[index].coordinate, toPointTo: map)
            let pointB: CGPoint = map.convert(map.annotations[nextIndex].coordinate, toPointTo: map)
        
            let labelDistance = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 18))

            labelDistance.textAlignment = NSTextAlignment.center
            labelDistance.text = "\(String.init(format: "%2.f",  round(distance * 0.001))) km"
            labelDistance.center = CGPoint(x: (pointA.x + pointB.x) / 2, y: (pointA.y + pointB.y) / 2)
            labelDistance.textColor = UIColor.blue
            distanceLabels.append(labelDistance)
        }
        for label in distanceLabels {
            map.addSubview(label)
        }
    }
    
    func getDistance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> CLLocationDistance {
        let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let to = CLLocation(latitude: to.latitude, longitude: to.longitude)
        
        return from.distance(from: to)
    }
    
}

extension ViewController: MKMapViewDelegate{
    
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
                    renderer.strokeColor = UIColor.red
                    renderer.lineWidth = 2.0
            return renderer
        } else if overlay is MKPolygon {
            let renderer = MKPolygonRenderer(overlay: overlay)
            renderer.fillColor = .red.withAlphaComponent(0.5)
            renderer.strokeColor = .green
            renderer.lineWidth = 2
            return renderer
        }
        return MKOverlayRenderer()
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? City else { return nil }

        let identifier = "marker"
        var view: MKMarkerAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
          as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        //print(locationManager.location)
        if let currentLocation = locationManager.location {
            let distance = currentLocation.distance(from: CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude))
            let distanceinkms = round(distance * 0.001)
            view.detailCalloutAccessoryView = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
            (view.detailCalloutAccessoryView as! UILabel).text = "\(distanceinkms) kms away from your location"
        }
        return view
    }
}
