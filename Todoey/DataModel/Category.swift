import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = "" // monitor when data change
    @objc dynamic var color: String = "" 
    let items = List<Item>()
}
