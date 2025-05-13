import SnapKit
import MapKit
import UIKit
import CoreLocation
import ParseCore
class MapViewController: UIViewController {
    private let mapView = MapViews.mapView
    private let locationManager = CLLocationManager()
    private var chooseCoordinate: CLLocationCoordinate2D?
    private let parseProccess = ParseProccess()
    var saveButton: UIBarButtonItem?
    var placeName: String?
    var placeTypeName: String?
    var commentText: String?
    var image: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonClicked))
        navigationItem.rightBarButtonItem = saveButton
        setupLayout()
        setupLocation()
        setupGestureRecognizer()
        
        
        
        
    }
}
extension MapViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    private func setupLayout(){
        view.backgroundColor = .systemBackground
        view.addSubview(mapView)
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        
        mapView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalToSuperview()
        }
    }
    private func setupLocation(){
        mapView.delegate = self
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    private func setupGestureRecognizer(){
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        longPress.minimumPressDuration = 1
        mapView.addGestureRecognizer(longPress)
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(mapDragged))
        mapView.addGestureRecognizer(panGestureRecognizer)
    }
    @objc private func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer){
        if gestureRecognizer.state == .began {
            let touchPoint = gestureRecognizer.location(in: mapView)
            let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            chooseCoordinate = coordinate
            
            let annotaion = MKPointAnnotation()
            annotaion.coordinate = coordinate
            annotaion.title = self.placeName
            annotaion.subtitle = self.placeTypeName
            mapView.addAnnotation(annotaion)
        }
    }
    @objc private func mapDragged(){
        locationManager.stopUpdatingLocation()
    }
    @objc private func saveButtonClicked(){
        guard let user = PFUser.current() else {
            Helper.makeAlert(title: "Hata!", message: "Giris yapmis kullanici bulunamadi", controller: self)
            return
        }
        guard let coordinate = chooseCoordinate else{ return }
        let PFGcoordinate = PFGeoPoint(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        let overlay = UIView(frame: view.bounds)
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.5) // Yarı saydam siyah arka plan
        overlay.tag = 999 // Overlay'i tanımlamak için bir etiket ekliyoruz
        view.addSubview(overlay)
        saveButton?.isEnabled = false
        
        let place = Place(user: user, placeName: placeName ?? "null", placeType: placeTypeName ?? "null",comment: commentText ?? "null", coordinates: PFGcoordinate, image: image)
        parseProccess.addPlace(place: place) { success, message in
            DispatchQueue.main.async {
                overlay.removeFromSuperview()
                self.saveButton?.isEnabled = true
                if success {
                    if let navigationController = self.navigationController {
                        let listTableViewController = ListTableViewController()
                        listTableViewController.tableView.reloadData()
                        navigationController.pushViewController(listTableViewController, animated: true)
                        print("Gecis saglandi")
                    }else{
                        print("NavigationController bulunamadi")
                    }
                }else{
                    Helper.makeAlert(title: "Hata!", message: message ?? "", controller: self)
                }
            }
            
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude,
                                              longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
}
