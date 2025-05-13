import UIKit
import PhotosUI
class PlaceViewController: UIViewController {
    private let placeNameTextField = TextFields.createTextField(placeholder: "Place Name")
    private let typeNameTextField = TextFields.createTextField(placeholder: "Place Type")
    private let commentTextField = TextFields.createTextField(placeholder: "Comment")
    private let imageView = ImageViews.placeImageView
    private let nextButton = Buttons.placenextButton
    private var isImageSelected = false
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [placeNameTextField,typeNameTextField,commentTextField,imageView,nextButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        imageView.isUserInteractionEnabled = true
        let imageGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        imageView.addGestureRecognizer(imageGestureRecognizer)
        nextButton.addTarget(self, action: #selector(goToMapView), for: .touchUpInside)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    
}
extension PlaceViewController: PHPickerViewControllerDelegate {
    @objc private func hideKeyboard(){
        view.endEditing(true)
    }
   
    private func setupLayout(){
        view.backgroundColor = .systemBackground
        if let actualImageView = imageView.subviews.first(where: { $0 is UIImageView }) as? UIImageView {
            actualImageView.image = UIImage(named: "select_image")
        }
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        imageView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(view.snp.height).multipliedBy(0.4)
        }
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalToSuperview().multipliedBy(0.3)
        }
        placeNameTextField.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        commentTextField.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        typeNameTextField.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
    }
    
    @objc private func selectImage(){
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    @objc private func goToMapView(){
        if Helper.textFieldIsEmpty(textField: placeNameTextField) ||
            Helper.textFieldIsEmpty(textField: typeNameTextField){
            Helper.makeAlert(title: "Bos alanlar var", message: "mekan adi ve tipi zorunlu", controller: self)
            return
        }
        let mapViewController = MapViewController()
        mapViewController.placeName = placeNameTextField.text
        mapViewController.placeTypeName = typeNameTextField.text
        mapViewController.commentText = commentTextField.text
        if isImageSelected,
           let actualImageView = imageView.subviews.first(where: { $0 is UIImageView }) as? UIImageView {
            mapViewController.image = actualImageView.image
        }
        navigationController?.pushViewController(mapViewController, animated: true)
    }
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        if let firstResult = results.first {
            firstResult.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                guard let self = self else { return }
                if let selectedImage = image as? UIImage {
                    DispatchQueue.main.async {
                        if let actualImageView = self.imageView.subviews.first(where: { $0 is UIImageView }) as? UIImageView {
                            actualImageView.image = selectedImage
                        }
                        self.isImageSelected = true
                    }
                }
            }
        }
    }
}
