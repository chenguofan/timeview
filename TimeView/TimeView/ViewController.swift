//
//  ViewController.swift
//  TimeView
//
//  Created by suhengxian on 2022/1/10.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let timeView = TimeView()
        timeView.titel = "选择日期"
        timeView.show()
        timeView.selectDate { date in
            print("date:\(date)")
        }
    }
    
}

