//
//  ViewController.swift
//  Skullibrista
//
//  Created by Abner Lima on 29/04/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var street: UIImageView!
    @IBOutlet weak var player: UIImageView!
    @IBOutlet weak var vGameOver: UIView!
    @IBOutlet weak var lbTimePlayed: UILabel!
    @IBOutlet weak var lbInstructions: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        vGameOver.isHidden = true
    }

    @IBAction func playAgain(_ sender: UIButton) {
    }
    
}

