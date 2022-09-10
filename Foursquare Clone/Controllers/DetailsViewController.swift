//
//  DetailsViewController.swift
//  Foursquare Clone
//
//  Created by mehmet on 7.09.2022.
//

import UIKit
import MapKit
import Parse

class DetailsViewController: UIViewController {
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    var selectedId = ""
    var chosenLatitude = Double()
    var chosenLongitude = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        // Do any additional setup after loading the view.
        fetchDataFromParse()
        print(selectedId)
    }
    
}

extension DetailsViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    
    func fetchDataFromParse() {
        
        let query = PFQuery(className: "Places")
        query.whereKey("objectId", equalTo: selectedId)
        query.findObjectsInBackground { objects, error in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
            } else {
                if objects != nil {
                    if objects!.count > 0 {
                        let chosenObject = objects![0]
                        
                        if let placeName = chosenObject.object(forKey: "placename") as? String {
                            self.nameLabel.text = placeName
                        }
                        
                        if let placeType = chosenObject.object(forKey: "placetype") as? String {
                            self.typeLabel.text = placeType
                        }
                        
                        if let desc = chosenObject.object(forKey: "description") as? String {
                            self.descriptionLabel.text = desc
                        }
                        
                        if let placeLatitude = chosenObject.object(forKey: "latitude") as? String {
                            if let placeLatitudeDouble = Double(placeLatitude) {
                                self.chosenLatitude = placeLatitudeDouble
                            }
                        }
                        
                        if let placeLongitude = chosenObject.object(forKey: "longitude") as? String {
                            if let placeLongitudeDouble = Double(placeLongitude) {
                                self.chosenLongitude = placeLongitudeDouble
                            }
                        }
                        
                        if let imageData = chosenObject.object(forKey: "placeimg") as? PFFileObject {
                            imageData.getDataInBackground { data, error in
                                if error == nil {
                                    if data != nil {
                                        self.imageView.image = UIImage(data: data!)
                                    }
                                } else {
                                    print("Error")
                                }
                             
                                let location = CLLocationCoordinate2D(latitude: self.chosenLatitude, longitude: self.chosenLongitude)
                                let span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
                                let region = MKCoordinateRegion(center: location, span: span)

                                self.mapView.setRegion(region, animated: true)
                                
                                let annotation = MKPointAnnotation()
                                annotation.coordinate = location
                                annotation.title = self.nameLabel.text!
                                annotation.subtitle = self.descriptionLabel.text!
                                self.mapView.addAnnotation(annotation)
                        
                            }
                        }
                    }
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            let button = UIButton(type: .detailDisclosure)
            pinView?.rightCalloutAccessoryView = button
        } else {
            pinView?.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if self.chosenLongitude != 0.0 && self.chosenLatitude != 0.0 {
            let requestLocation = CLLocation(latitude: self.chosenLatitude, longitude: self.chosenLongitude)
            
            CLGeocoder().reverseGeocodeLocation(requestLocation) { placemarks, error in
                if let placemark = placemarks {
                    if placemark.count > 0 {
                        let mkplaceMark = MKPlacemark(placemark: placemark[0])
                        let mapItem = MKMapItem(placemark: mkplaceMark)
                        mapItem.name = self.nameLabel.text!
                        
                        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
                        
                        mapItem.openInMaps(launchOptions: launchOptions) 
                    }
                }
            }
        }
    }
    
}
