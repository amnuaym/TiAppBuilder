//
//  ShoppingItem.swift
//  MyShoppingList
//
//  Created by Amnuay M on 9/4/17.
//  Copyright © 2017 Amnuay M. All rights reserved.
//

import UIKit

class ShoppingItem: NSObject {
    var shoppingProductName : String
    var shoppingProductNumber : Int
    var shoppingProductUnitPrice : Double
    
    override init() {
        self.shoppingProductName = ""
        self.shoppingProductNumber = 0
        self.shoppingProductUnitPrice = 0.0
    }
        
    init(shoppingProductName : String, shoppingProductNumber : Int, shoppingProductUnitPrice : Double) {
        self.shoppingProductName = shoppingProductName
        self.shoppingProductNumber = shoppingProductNumber
        self.shoppingProductUnitPrice = shoppingProductUnitPrice
    }
}
