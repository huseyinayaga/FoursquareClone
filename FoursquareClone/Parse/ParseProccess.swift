import Foundation
import ParseCore

protocol IParseProccess {
    func login(username: String, password: String, completion: @escaping (Bool, String?) -> Void)
    func register(username: String, password: String, email: String, completion: @escaping (Bool, String?) -> Void)
    func addPlace(place: Place, completion: @escaping (Bool, String?) -> Void)
    func fetcPlaces(for user: PFUser, completion: @escaping ([Place]?, String?) -> Void)
}

struct ParseProccess: IParseProccess {
    func login(username: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        PFUser.logInWithUsername(inBackground: username, password: password) { user, error in
            if let error = error {
                print("Giris Hatasi \(error.localizedDescription)")
                completion(false, error.localizedDescription)
            }else{
                print("Giris basarili \(user?.username ?? "")")
                print(user?.password ?? "")
                completion(true, user?.username)
            }
        }
    }
    func register(username: String, password: String, email: String, completion: @escaping (Bool, String?) -> Void) {
        let user = PFUser()
        user.username = username
        user.password = password
        user.email = email
        
        user.signUpInBackground { success, error in
            if let error = error {
                print("Kayıt hatası: \(error.localizedDescription)")
                completion(false, error.localizedDescription)
            } else {
                print("Kullanıcı başarıyla kaydedildi!")
                completion(true, nil)
            }
        }
    }
    func addPlace(place: Place, completion: @escaping (Bool, String?) -> Void) {
        place.saveInBackground { success, error in
            if let error = error {
                completion(false, error.localizedDescription)
            }else{
                completion(true, nil)
            }
        }
    }
    func fetcPlaces(for user: PFUser,completion: @escaping ([Place]?, String?) -> Void) {
        let query = Place.query()
        query?.whereKey("user", equalTo: user)
        query?.includeKey("User")
        
        query?.findObjectsInBackground(block: { objects, error in
            if let error = error {
                completion(nil, error.localizedDescription)
            }else{
                let places = objects as? [Place] ?? []
                print("Veri basariyla cekildi \(places.count)")
                completion(places, nil)
            }
        })
        
    }
    func fetchImage(for place: Place, completion: @escaping (UIImage?, Error?) -> Void) {
        // imageFile 'in varlığından emin olun
        if let imageFile = place.image {
            // Veriyi arka planda indiriyoruz
            imageFile.getDataInBackground { (data, error) in
                if let error = error {
                    print("Resim indirilirken hata oluştu: \(error.localizedDescription)")
                    completion(nil, error)
                } else if let data = data {
                    // Resmi veri üzerinden oluşturuyoruz
                    let image = UIImage(data: data)
                    completion(image, nil)
                }
            }
        } else {
            print("place object does not have an image file")
            completion(nil, NSError(domain: "ParseError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Image file is missing"]))
        }
    }
    
}
