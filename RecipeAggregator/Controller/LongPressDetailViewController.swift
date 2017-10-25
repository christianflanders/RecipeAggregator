//
//  LongPressDetailViewController.swift
//  RecipeAggregator
//
//  Created by Christian Flanders on 10/24/17.
//  Copyright © 2017 Christian Flanders. All rights reserved.
//

import UIKit

class LongPressDetailViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var mainCardView: UIView!
    
    
    private var divisor: CGFloat!
    private var originalPosition = CGPoint()
    
    private let gradient = CAGradientLayer()
    private let colors = [UIColor.init(red: 89/255, green: 86/255, blue: 86/255, alpha: 80/100).cgColor,UIColor.init(red: 26/255, green: 25/255, blue: 25/255, alpha: 80/100).cgColor]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        divisor = (view.frame.width / 2) / 0.61
        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.panGesture(_:)))
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture(_:)))
        pan.delegate = self
        tap.delegate = self
        mainCardView.addGestureRecognizer(pan)
        mainCardView.addGestureRecognizer(tap)
        originalPosition = mainCardView.center
        gradient.frame = self.view.frame
        gradient.colors = colors
        gradient.locations = [0.0, 0.7]
//        self.view.layer.addSublayer(gradient)
        self.view.layer.insertSublayer(gradient, at: 0)
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: IBActions
    
    @IBAction func viewRecipeButtonPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func shareRecipeButtonPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func editRecipeButtonPressed(_ sender: UIButton) {
        
        
    }
    
    
    @IBAction func dismissButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    //MARK: Gesture Recognizer
    @objc func tapGesture(_ sender: UITapGestureRecognizer){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func panGesture(_ sender: UIPanGestureRecognizer){
        let card = sender.view!
        mainCardView.center.x = sender.location(in: self.view).x
        mainCardView.center.y =  sender.location(in: self.view).y
        let xFromCenter = card.center.x - view.center.x
        let direction = sender.translation(in: view)
        card.transform = CGAffineTransform(rotationAngle: xFromCenter / divisor)
        if sender.state == UIGestureRecognizerState.ended {
            if direction.x > 80 || direction.x < -80 || direction.y > 80 || direction.y < -80 {
                dismiss(animated: true, completion: nil)
            } else {
                card.center = self.originalPosition
                card.transform = CGAffineTransform(rotationAngle: 0)
            }
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
