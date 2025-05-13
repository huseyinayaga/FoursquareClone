import Foundation
import UIKit
struct Labels {
    static var titleLabel: UILabel {
        let label = UILabel()
        label.text = "Giriş Yap"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        return label
    }
    static func detailsLabel() -> UILabel {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }
}
