//
//  ViewController.swift
//  SWSlideVerifyView
//
//  Created by nguyenkhiem7789@gmail.com on 05/13/2020.
//  Copyright (c) 2020 nguyenkhiem7789@gmail.com. All rights reserved.
//

import UIKit
import SWSlideVerifyView

class ViewController: UIViewController {

    @IBOutlet weak var slideVerifyView: SlideVerifyView!

    override func viewDidLoad() {
        super.viewDidLoad()
        slideVerifyView.delete = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: SlideVerifyDelegate {

    func finish() {
        slideVerifyView.text = "Verify success!"
        slideVerifyView.textColor = UIColor.red
    }

}
