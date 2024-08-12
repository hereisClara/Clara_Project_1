//
//  CartItem+CoreDataProperties.swift
//  
//
//  Created by shachar on 2024/8/12.
//
//

import Foundation
import CoreData


extension CartItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CartItem> {
        return NSFetchRequest<CartItem>(entityName: "CartItem")
    }

    @NSManaged public var cartNumber: String?
    @NSManaged public var color: String?
    @NSManaged public var colorName: String?
    @NSManaged public var id: String?
    @NSManaged public var image: String?
    @NSManaged public var price: String?
    @NSManaged public var size: String?
    @NSManaged public var stock: String?
    @NSManaged public var title: String?

}
