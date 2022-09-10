//
//  MapViewController.swift
//  Foursquare Clone
//
//  Created by mehmet on 7.09.2022.
//

import UIKit
import MapKit
import Parse

@available(iOS 13.0, *)
class MapViewController: UIViewController {

    @IBOutlet var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    var annotation = MKPointAnnotation()
    var chosenLatitude = ""
    var chosenLongitude = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(selectPlace))
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "< Back", style: .plain, target: self, action: #selector(backToAddPlace))
        
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let pinGesture = UILongPressGestureRecognizer(target: self, action: #selector(markPlace(gestureRecognizer:)))
        pinGesture.minimumPressDuration = 3
        mapView.addGestureRecognizer(pinGesture)
    }
    
    @objc func selectPlace() {
        //TODO: add selecting action
        
        let place = Places.sharedInstance
        let obj = PFObject(className: "Places")
        
        obj["placename"] = place.placeName
        obj["placetype"] = place.placeType
        obj["description"] = place.placeDesc
        obj["latitude"] = place.placeLatitude
        obj["longitude"] = place.placeLongitude
        
        if let imageData = place.placeImg.jpegData(compressionQuality: 0.5) {
            obj["placeimg"] = PFFileObject(name: "\(UUID().uuidString).jpg", data: imageData)
        }
        
        obj.saveInBackground { isSaved, error in
            if error == nil {
                self.performSegue(withIdentifier: "toPlacesTable", sender: nil)
            } else {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
            }
        }
        
    }

    @objc func backToAddPlace() {
        //go back to previous page
        self.dismiss(animated: true)
    }
    
    @objc func markPlace(gestureRecognizer: UIGestureRecognizer) {
        let pinnedPlace = Places.sharedInstance
        
        if gestureRecognizer.state == UIGestureRecognizer.State.began {
            //take location of tapped point
            let touches = gestureRecognizer.location(in: self.mapView)
            
            //turn points into coordinate
            let coordinate = self.mapView.convert(touches, toCoordinateFrom: self.mapView)
            annotation.coordinate = coordinate
            annotation.title = pinnedPlace.placeName
            annotation.subtitle = pinnedPlace.placeDesc + "\n" + pinnedPlace.placeType
            
            self.mapView.addAnnotation(annotation)
            
            pinnedPlace.placeLatitude = String(coordinate.latitude)
            pinnedPlace.placeLongitude = String(coordinate.longitude)
            
        }
        
        
    }
}


@available(iOS 13.0, *)
extension MapViewController : MKMapViewDelegate, CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
        let region = MKCoordinateRegion(center: location, span: span)
        
        mapView.setRegion(region, animated: true)
    }
    
    
    
}
