import UIKit
import ParseCore
class ListTableViewController: UITableViewController {
    private let parseProccess = ParseProccess()
    private var places: [Place] = []
    private var logOutButton: UIBarButtonItem?
    
    init(){
        super.init(style: .insetGrouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getPlaces()
        navigationItem.hidesBackButton = true
        let addItemButton = UIBarButtonItem(title: "Add Place", style: .plain, target: self, action: #selector(addItemClicked))
        navigationItem.rightBarButtonItem = addItemButton
        logOutButton = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logOutClicked))
        logOutButton?.tintColor = .red
        navigationItem.leftBarButtonItem = logOutButton
        tableView.register(TravleViewCell.self, forCellReuseIdentifier: "TravleViewCell")
    }
    
    @objc private func addItemClicked(){
        let placeViewController = PlaceViewController()
        navigationController?.pushViewController(placeViewController, animated: true)
    }
    @objc private func logOutClicked(){
//        cikis islemleri
        logOutButton?.isEnabled = false
        let overlay = UIView(frame: view.bounds)
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        overlay.tag = 999
        view.addSubview(overlay)
        
        PFUser.logOutInBackground { error in
            DispatchQueue.main.async {
                overlay.removeFromSuperview()
                self.logOutButton?.isEnabled = true
                if let error = error {
                    Helper.makeAlert(title: "Hata!", message: error.localizedDescription, controller: self)
                }else{
                    print("Cikis yapildi")
                    let loginViewController = LoginViewController()
                    self.navigationController?.pushViewController(loginViewController, animated: true)
                }
            }
        }
        
    }
}

extension ListTableViewController {
    override func viewWillAppear(_ animated: Bool) {
//        getPlaces()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TravleViewCell", for: indexPath) as? TravleViewCell else { return UITableViewCell()}
        // Configure the cell...
        parseProccess.fetchImage(for: places[indexPath.row]) { image, error in
            DispatchQueue.main.async {
                if let error = error {
                    print(error.localizedDescription)
                }else{
                    cell.cellImageView.image = image
                }
            }
        }
        cell.titleLabel.text = places[indexPath.row].placeName
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsViewController = DetailsViewController()
        detailsViewController.place = places[indexPath.row]
        if let navigationController = self.navigationController{
            navigationController.pushViewController(detailsViewController, animated: true)
            print("Gecis saglandi")
        }else{
            print("Gecis saglanamadi")
        }
    }
    private func getPlaces(){
        guard let currentUser = PFUser.current() else {
            Helper.makeAlert(title: "Hata!", message: "Kullanici bulunamadi", controller: self)
            return
        }
        parseProccess.fetcPlaces(for: currentUser) { places, error in
            DispatchQueue.main.async {
                self.places.removeAll(keepingCapacity: false)
                if let places = places {
                    self.places = places
                    print("veri atamasi yapildi")
                }else{
                    Helper.makeAlert(title: "Hata", message: error ?? "", controller: self)
                }
                self.tableView.reloadData()
            }
                   
        }
    }
    
}
