//
//  PlacesViewController.swift
//  Foursquare Clone
//
//  Created by mehmet on 6.09.2022.
//

import UIKit
import Parse


@available(iOS 13.0, *)
class PlacesViewController: UIViewController {

    @IBOutlet var placesTableView: UITableView!
    
    var placeNameArray = [String]()
    var placeIdArray = [String]()
    var chosenId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataFromParse()

        placesTableView.delegate = self
        placesTableView.dataSource = self
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPlace))
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logOutAccount))
        
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPlace))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetails" {
            let vc = segue.destination as! DetailsViewController
            vc.selectedId = chosenId
        }
    }
    
}


@available(iOS 13.0, *)
extension PlacesViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = placeNameArray[indexPath.row]
        return cell
    }
    
    
    @objc func addNewPlace() {
        performSegue(withIdentifier: "toAddPlace", sender: nil)
    }
    
    @objc func logOutAccount(){
        
        PFUser.logOutInBackground { error in
            if error != nil {
                self.makeAlert(alertTitle: "Error", alertMessage: error?.localizedDescription ?? "Error")
                
            } else {
                self.performSegue(withIdentifier: "toLogin", sender: nil)
            }
        }
    }
    
    func getDataFromParse() {
        let query = PFQuery(className: "Places")
        query.findObjectsInBackground { objects, error in
            if error != nil {
                self.makeAlert(alertTitle: "Error", alertMessage: error?.localizedDescription ?? "Error")
            } else {
                if objects != nil {
                    self.placeNameArray.removeAll(keepingCapacity: false)
                    self.placeIdArray.removeAll(keepingCapacity: false)
                    for object in objects! {
                        if let placeName =  object.object(forKey: "placename") as? String{
                            if let placeId = object.objectId {
                                self.placeNameArray.append(placeName)
                                self.placeIdArray.append(placeId)
                            }
                        }
                    }
                    
                    self.placesTableView.reloadData()
                }
            }
        }
    }
    
    func makeAlert(alertTitle: String, alertMessage: String) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
   
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenId = placeIdArray[indexPath.row]
        performSegue(withIdentifier: "toDetails", sender: nil)
    }
    
}
