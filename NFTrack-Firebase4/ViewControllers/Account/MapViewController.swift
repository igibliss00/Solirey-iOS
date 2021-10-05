//
//  MapViewController.swift
//  NFTrack-Firebase4
//
//  Created by J C on 2021-08-29.
//

import UIKit
import MapKit

class MapViewController: AddressViewController, MKMapViewDelegate, SharableDelegate, HandleMapSearch, ParseAddressDelegate {
    var mapView: MKMapView!
    var placemark: MKPlacemark? = nil
    var shareButtonItem: UIBarButtonItem!
    let alert = Alerts()
    private var customNavView: BackgroundView5!

    init() {
        super.init(nibName: nil, bundle: nil)
        mapView = MKMapView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
    }
    
    override func configureUI() {
        super.configureUI()
        hideKeyboardWhenTappedAround()
        
        configureMapView()
    }
    
    func configureNavigationBar() {
        shareButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(mapButtonPressed))
        shareButtonItem.tag = 2
        self.navigationItem.rightBarButtonItem = shareButtonItem
        
        customNavView = BackgroundView5()
        customNavView.translatesAutoresizingMaskIntoConstraints = false
        mapView.addSubview(customNavView)
    }
    
    func configureMapView() {
        mapView.userTrackingMode = .follow
        view.addSubview(mapView)
        mapView.fill()
        mapView.delegate = self
    }
    
    override func configureSearchVC() {
        locationSearchVC = LocationSearchViewController(regionRadius: regionRadius, location: location)
        
        resultSearchController = UISearchController(searchResultsController: locationSearchVC)
        resultSearchController.searchResultsUpdater = locationSearchVC
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.obscuresBackgroundDuringPresentation = true
        
        configureSearchBar(resultSearchController)
        
        // When the search result is tapped, the pin is dropped onto the map
        // MapVC designates itself as the delegate to do the pin dropping
        locationSearchVC.handleMapSearchDelegate = self
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        //        guard let annotation = annotation as? MyAnnotation else { return nil }
        let identifier = "marker"
        var annotationView: MKMarkerAnnotationView
        if let deqeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            deqeuedView.annotation = annotation
            annotationView = deqeuedView
        } else {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView.isEnabled = true
            annotationView.canShowCallout = true
            annotationView.calloutOffset = CGPoint(x: -5, y: 5)
            
            let mapButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 30, height: 30)))
            mapButton.setBackgroundImage(UIImage(systemName: "checkmark.circle"), for: UIControl.State())
            mapButton.addTarget(self, action: #selector(mapButtonPressed), for: .touchUpInside)
            mapButton.tag = 1
            annotationView.rightCalloutAccessoryView = mapButton
        }
        
        return annotationView
    }
    
    @objc func mapButtonPressed(_ sender: UIButton) {
        switch sender.tag {
            case 1:
                if let placemark = placemark {
                    didSelectPin(placemark)
                }
                break
            case 2:
                guard let placemark = placemark else { return }
                let address = parseAddress(selectedItem: placemark)
                share([address as AnyObject])

//                let clLocation = CLLocation(latitude: placemark.coordinate.latitude, longitude: placemark.coordinate.longitude)
//                let geocoder = CLGeocoder()
//                geocoder.reverseGeocodeLocation(clLocation) { [weak self] (placemarks, error) in
//                    if let error = error {
//                        self?.alert.showDetail("Error", with: error.localizedDescription, for: self)
//                    }
//
//                    guard let pm = placemarks?.first else { return }
//                    let placemark = MKPlacemark(placemark: pm)
//                    let buyersAddress = self?.parseAddress(selectedItem: placemark)
//                }
                break
            default:
                break
        }
    }
    
    func didSelectPin(_ placemark: MKPlacemark) {
        fetchPlacemarkDelegate?.dropPinZoomIn(placemark: placemark, addressString: nil, scope: nil)
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func centerMapOnLocation() {
        guard let location = location else { return }
        self.placemark = MKPlacemark(coordinate: location)
        if let pm = self.placemark {
            mapView.removeAnnotations(mapView.annotations)
            mapView.addAnnotation(pm)
        }

        let coorindateRegion = MKCoordinateRegion.init(center: location, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coorindateRegion, animated: true)
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    func dropPinZoomIn(placemark: MKPlacemark, addressString: String?, scope: ShippingRestriction?) {
        // cache the pin
        self.placemark = placemark
        
        // clear the existing pins
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(placemark)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    func resetSearchResults() {}
    
    override func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        super.locationManagerDidChangeAuthorization(manager)
        
        print("locationManagerDidChangeAuthorization old mapview")
        guard let coordinate = manager.location?.coordinate else { return }
        
        
        let placemark = MKPlacemark(coordinate: coordinate)
        self.placemark = placemark
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    override func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        super.locationManager(manager, didChangeAuthorization: status)
        
        print("didChangeAuthorization new mapview")
        guard let coordinate = manager.location?.coordinate else { return }
        
        let placemark = MKPlacemark(coordinate: coordinate)
        self.placemark = placemark
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
}
