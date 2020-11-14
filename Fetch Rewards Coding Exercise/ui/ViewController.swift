import RealmSwift
import SwiftyJSON
import UIKit

class ViewController: UIViewController {
    let cellReuseIdentifier = "ItemViewCell"
    @IBOutlet var tableView: UITableView!
    @IBOutlet var toastView: UIView!
    @IBOutlet var toastMessage: UILabel!

    var itemList: Results<Item>?
    var distinctListIds = [Int]()
    var tableModelList = [TableModel]()

    private let networkingClient = NetworkingClient()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        if Connectivity.isConnectedToInternet {
            callAPI()
        } else {
            DispatchQueue.global().async {
                self.updateTableModelList()
            }
            toast(message: "No Internet")
        }
    }

    func callAPI() {
        showSVProgressHUD(message: "Loading...")

        guard let url = URL(string: "https://fetch-hiring.s3.amazonaws.com/hiring.json") else {
            return
        }

        networkingClient.execute(url: url) { jsonResponse, error in

            if let error = error {
                DispatchQueue.main.async {
                    self.hideSVProgressHUD()
                    self.toast(message: "Error in fetching api data.")
                    print("Error: \(error)")
                }

            } else if let jsonResponse = jsonResponse {
                self.parseAndSaveToDB(jsonResponse.arrayValue)
            }
        }
    }

    func parseAndSaveToDB(_ jsonarray: [JSON]) {
        for itemNum in 0 ..< jsonarray.count where jsonarray[itemNum][TableItem.name.rawValue].stringValue != "" {
            let item = Item()
            item.id = jsonarray[itemNum][TableItem.id.rawValue].intValue
            item.listId = jsonarray[itemNum][TableItem.listId.rawValue].intValue
            item.name = jsonarray[itemNum][TableItem.name.rawValue].stringValue

            DbClient().save(item: item)
        }
        updateTableModelList()
    }

    func updateTableModelList() {
        itemList = DbClient().getAllItems()

        if itemList?.count == 0 { // database is empty
            return
        }

        distinctListIds = itemList?.distinct(by: [TableItem.listId.rawValue]).sorted(byKeyPath: TableItem.listId.rawValue).value(forKey: TableItem.listId.rawValue) as! [Int]

        for listId in distinctListIds {
            let nameModelList = itemList?.filter { $0.listId == listId }
            let sortedList = nameModelList?.sorted(by: { $0.name.localizedStandardCompare($1.name) == .orderedAscending })

            let tableModel = TableModel()
            tableModel.listId = listId
            for item in sortedList! {
                var listModel = ListModel()
                listModel.id = item.id
                listModel.name = item.name
                tableModel.nameModel.append(listModel)
            }
            tableModelList.append(tableModel)
        }
        updateTable()
    }

    func updateTable() {
        if tableModelList.count != 0 {
            DispatchQueue.main.async {
                self.hideSVProgressHUD()
                self.tableView.reloadData()
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModelList[section].nameModel.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! ItemViewCell

        cell.itemId.text = String(tableModelList[indexPath.section].nameModel[indexPath.row].id)
        cell.itemName.text = tableModelList[indexPath.section].nameModel[indexPath.row].name

        return cell
    }

    func numberOfSections(in _: UITableView) -> Int {
        return tableModelList.count
    }

    func tableView(_: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "List Id \(tableModelList[section].listId)"
    }

    func tableView(_: UITableView, willDisplayHeaderView view: UIView, forSection _: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.contentView.backgroundColor = .darkGray
        header.textLabel?.textColor = .white
        header.textLabel?.font = UIFont(name: "Helvetica-Bold", size: 14)
    }
}
