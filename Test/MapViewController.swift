//
//  MapViewController.swift
//  Test
//
//  Created by Ricardo Michel Reyes Martínez on 11/7/15.
//  Copyright © 2015 KMMX. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate
{
    @IBOutlet weak var mapView: MKMapView!
    
    let geocoder = CLGeocoder()
 
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        geocoder.geocodeAddressString("Atotonilco el grande, Hidalgo, Mexico") { (placemarks: [CLPlacemark]?, error: NSError?) -> Void in
            if let error = error
            {
                print("Geocoding error: \(error)")
            }
            else
            {
                if let placemarks = placemarks
                {
                    let annotations: [MKPointAnnotation] = placemarks.map({
                        let annotation = MKPointAnnotation()
                        annotation.title = $0.name
                        if let coordinate = $0.location?.coordinate
                        {
                            annotation.coordinate = coordinate
                        }
                        
                        return annotation
                    })
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.mapView.addAnnotations(annotations)
                    })
                }
            }
        }
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?
    {
        let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Pin")
        pin.pinTintColor = UIColor.redColor()
        
        return pin
    }
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation)
    {
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        
        let region = MKCoordinateRegion(center: userLocation.coordinate, span: span)
        
        mapView.region = region
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}
