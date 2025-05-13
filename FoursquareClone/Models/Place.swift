import ParseCore
import Foundation
class Place: PFObject, PFSubclassing {
    static func parseClassName() -> String {
        return "Place"
    }
    @NSManaged var user: PFUser
    @NSManaged var placeName: String
    @NSManaged var placeType: String
    @NSManaged var comment: String?
    @NSManaged var coordinates: PFGeoPoint
    @NSManaged var image: PFFileObject?
    
    override init() {
        super.init()
    }
    
    init(user: PFUser, placeName: String, placeType: String, comment: String? = nil, coordinates: PFGeoPoint, image: UIImage? = nil) {
        super.init()
        self.user = user
        self.placeName = placeName
        self.placeType = placeType
        self.comment = comment
        self.coordinates = coordinates
        
        if let image = image, let imageData = image.jpegData(compressionQuality: 0.5){
            let id = UUID()
            let idString = id.uuidString
            self.image = PFFileObject(name: "\(idString).jpg", data: imageData)
        }else{
            if let imageData =  UIImage(resource: .imageNotFound).jpegData(compressionQuality: 0.5){
                let id = UUID()
                let idString = id.uuidString
                self.image = PFFileObject(name: "\(idString).jpg", data: imageData)
            }
        }
    }
}

