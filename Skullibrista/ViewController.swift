//
//  ViewController.swift
//  Skullibrista
//
//  Created by Abner Lima on 29/04/23.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    @IBOutlet weak var street: UIImageView!
    @IBOutlet weak var player: UIImageView!
    @IBOutlet weak var vGameOver: UIView!
    @IBOutlet weak var lbTimePlayed: UILabel!
    @IBOutlet weak var lbInstructions: UILabel!
    
    var isMoving: Bool = false
    lazy var motionManager = CMMotionManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        vGameOver.isHidden = true
        prepareStreet()
        preparePlayer()
        animatePlayer()
        
        Timer.scheduledTimer(withTimeInterval: 6.0, repeats: false) { timer in
            self.start()
        }
    }
    
    func prepareStreet() {
        street.frame.size.width = view.frame.size.width * 2
        street.frame.size.height = view.frame.size.height * 2
        street.center = view.center
    }
    
    func preparePlayer() {
        player.center = view.center
    }
    
    func animatePlayer() {
        player.animationImages = []
        
        for i in 0...7 {
            let image = UIImage(named: "player\(i)")!
            player.animationImages?.append(image)
        }
        
        player.animationDuration = 0.5
        player.startAnimating()
    }
    
    func start() {
        lbInstructions.isHidden = true
        vGameOver.isHidden = true
        isMoving = false
        useMotionManager()
    }
    
    func useMotionManager() {
        if motionManager.isDeviceMotionAvailable {
            motionManager.startDeviceMotionUpdates(to: OperationQueue.main) { data, error in
                if error == nil {
                    if let data = data {
                        self.rotatePlayer(x: data.gravity.x, y: data.gravity.y)
                    }
                }
            }
        }
    }
    
    func rotatePlayer(x: Double, y: Double) {
        let angle = atan2(x, y) - .pi
        player.transform = CGAffineTransform(rotationAngle: CGFloat(angle))
    }

    @IBAction func playAgain(_ sender: UIButton) {
    }
    
}

