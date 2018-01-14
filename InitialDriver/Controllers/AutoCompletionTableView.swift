//
//  AutoCompletionTableView.swift
//  InitialDriver
//
//  Created by Mohamed Ali on 13/01/2018.
//  Copyright © 2018 Mohamed Ali. All rights reserved.
//

import UIKit
import RxCocoa

class AutoCompletionTableView: UITableView {
    
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bindData(to address: [Address]) {
        
    }
}
