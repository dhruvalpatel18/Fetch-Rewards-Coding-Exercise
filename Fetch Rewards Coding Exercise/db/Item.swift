import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var id = 0
    @objc dynamic var listId = 0
    @objc dynamic var name = ""

    override static func primaryKey() -> String? {
        return "id"
    }
}
