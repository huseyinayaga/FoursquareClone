import UIKit
import MapKit
import SnapKit
class DetailsViewController: UIViewController {
    private let imageView = ImageViews.placeImageView
    private let placeLabel = Labels.detailsLabel()
    private let typeLabel = Labels.detailsLabel()
    private let commentLabel = Labels.detailsLabel()
    private let parseProccess = ParseProccess()
    var place: Place?
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [placeLabel,typeLabel,commentLabel])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    private let mapView = MKMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        mapView.delegate = self
        setupDetails()
        setupLayout()
        
    }
        
}

extension DetailsViewController: CLLocationManagerDelegate, MKMapViewDelegate {
    private func setupLayout(){
        
        view.addSubview(imageView)
        view.addSubview(stackView)
        view.addSubview(mapView)
        
        imageView.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.3)
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(5)
            
        }
        stackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(imageView.snp.bottom).offset(10)
        }
        mapView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.top.equalTo(stackView.snp.bottom).offset(10)
            make.bottom.equalToSuperview()
        }
    }
    private func setupDetails(){
        if let place = place {
            placeLabel.text = "Adı: \(place.placeName)"
            typeLabel.text = "Türü :\(place.placeType)"
            commentLabel.text = "Yorum : \(place.comment ?? "Yorum yapilmamis")"
            parseProccess.fetchImage(for: place, completion: { image, error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    if let imageView = self.imageView.subviews.first(where: { $0 is UIImageView }) as? UIImageView {
                        imageView.image = image
                    }
                }
            })
        } else {
            Helper.makeAlert(title: "Hata!", message: "Place nesnesi mevcut degil", controller: self)
        }
        addPinsToMap()
    }
    private func addPinsToMap(){
        if let coordinates = place?.coordinates {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)
            annotation.title = place?.placeName
            annotation.subtitle = place?.placeType
            mapView.addAnnotation(annotation)
            
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center:annotation.coordinate , span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        let identifier = "placePin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            
            let infoButton = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = infoButton
        }else{
            annotationView?.annotation = annotation
        }
        return annotationView
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation else { return }
        
        let destination = MKMapItem(placemark: MKPlacemark(coordinate: annotation.coordinate))
        destination.name = annotation.title ?? "Hedef"
        
        let launchOptions =  [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        destination.openInMaps(launchOptions: launchOptions)
    }
}
