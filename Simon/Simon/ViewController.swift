//
//  ViewController.swift
//  Simon
//
//  Created by IOS on 22/06/22.
//

import Foundation

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var label: UILabel!
    let GestureLabel = ["SIMON MEMORY","Ready to play?","Tap the play button"]
    var count = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        label.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture))
        label.addGestureRecognizer(tapGesture)
    }
    
    @objc func tapGesture(){
        if(self.count >= 3){
            self.count = 0
        }
        let randomItem = GestureLabel[self.count]
        print(randomItem)
        
        label.text = randomItem
        count+=1
    }

}
