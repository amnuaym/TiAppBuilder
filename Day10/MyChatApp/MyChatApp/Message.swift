//
//  Message.swift
//  MyChatApp
//
//  Created by Amnuay M on 10/16/17.
//  Copyright © 2017 ANT. All rights reserved.
//

import UIKit

class Message: NSObject {

    var sender : String
    var messageBody : String
    
    override init(){
        self.sender = ""
        self.messageBody = ""
    }
}
