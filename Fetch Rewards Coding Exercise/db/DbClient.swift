//
//  DbClient.swift
//  Fetch Rewards Coding Exercise
//
//  Created by Dhruval Patel on 11/11/20.
//  Copyright © 2020 Dhruval. All rights reserved.
//

import Foundation
import RealmSwift

class DbClient {
    let realm: Realm = try! Realm()

    func save(item: Item) {
        try! realm.write {
            realm.add(item, update: .modified)
        }
    }

    func getSortedItemList(sortBy: [SortDescriptor]) -> Results<Item> {
        return realm.objects(Item.self).sorted(by: sortBy)
    }

    func getAllItems() -> Results<Item> {
        return realm.objects(Item.self)
    }

    func deleteAll() {
        try! realm.write {
            realm.deleteAll()
        }
    }

    func getDistListIds(distinctBy: [String], sortedByKeyPath: String, valueForKey: String) -> [Int] {
        return realm.objects(Item.self).distinct(by: distinctBy).sorted(byKeyPath: sortedByKeyPath).value(forKey: valueForKey) as! [Int]
    }
}
