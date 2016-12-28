//
//  ChecklistItem.swift
//  TODOLister
//
//  Created by Volodymyr Lavryk on 12.12.16.
//  Copyright © 2016 Volodymyr Lavryk. All rights reserved.
//

import Foundation

class ChecklistItem: NSObject, NSCoding {
    var text = ""
    var checked = false
    
    required init?(coder aDecoder: NSCoder) {
        text = aDecoder.decodeObject(forKey: "Text") as! String
        checked = aDecoder.decodeBool(forKey: "Checked")
        super.init()
    }
    override init() {
        super.init()
    }
    
    func toggleChecked() {
        checked = !checked
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(text, forKey: "Text")
        aCoder.encode(checked, forKey: "Checked")
    }
   }
