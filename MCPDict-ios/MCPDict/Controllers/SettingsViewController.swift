//
//  SettingsViewController.swift
//  MCPDict
//
//  Created by zengming on 9/12/16.
//  Copyright © 2016 ioi.im. All rights reserved.
//

import Foundation
import Eureka

class SettingsViewController: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        form +++ Section("显示")
            <<< TextRow() { row in
                row.title = "text row"
            }
        +++ Section("其它")
            <<< TextRow() { row in
                row.title = "text row"
            }
            <<< TextRow() { row in
                row.title = "text row"
            }
    }
}