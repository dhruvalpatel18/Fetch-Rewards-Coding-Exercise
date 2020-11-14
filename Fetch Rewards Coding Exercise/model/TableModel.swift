import Foundation

enum TableItem: String {
    case name
    case id
    case listId
}

struct ListModel {
    var id = 0
    var name = ""
}

class TableModel {
    var listId = 0
    var nameModel = [ListModel]()
}
