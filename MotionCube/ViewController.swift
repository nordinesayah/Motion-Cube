//
//  ViewController.swift
//  MotionCube
//
//  Created by Nordine Sayah on 01/10/2018.
//  Copyright © 2018 Nordine Sayah. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    var allObj = [Object]()
    var animator: UIDynamicAnimator!
    var gravity = UIGravityBehavior()
    var collision = UICollisionBehavior()
    var itemElasticity = UIDynamicItemBehavior()
    let motionManager = CMMotionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animator = UIDynamicAnimator(referenceView: self.view)
        animator.addBehavior(gravity)
        collision.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(collision)
        
        self.view.clipsToBounds = true
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(touchSelector)))
        
        if motionManager.isGyroAvailable{
            motionManager.startAccelerometerUpdates(to: OperationQueue.main){(data, error) in
                if let myData = data as CMAccelerometerData? {
                    self.gravity.gravityDirection = CGVector(dx: myData.acceleration.x * -1, dy: myData.acceleration.y * -1)
                }
            }
        }
    }
    
    func createView(x: CGFloat, y: CGFloat) {
        let obj = Object(x: x, y: y)
        
        obj.addGestureRecognizer(UIPanGestureRecognizer(target: self, action:#selector(panGesture)))
        obj.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(pinchGesture)))
        obj.addGestureRecognizer(UIRotationGestureRecognizer(target: self, action: #selector(rotationGesture)))
        
        self.view.addSubview(obj)
        allObj.append(obj)
        
        gravity.addItem(obj)
        collision.addItem(obj)
        
        itemElasticity = UIDynamicItemBehavior(items: allObj)
        itemElasticity.elasticity = 0.6
        self.animator.addBehavior(itemElasticity)
    }
    
    @objc func touchSelector(touch: UITapGestureRecognizer){
        let location = touch.location(in: self.view)
        self.createView(x: location.x, y: location.y)
    }
    
    @objc func rotationGesture(gesture: UIRotationGestureRecognizer){
        if let currObj = gesture.view as? Object{
            switch gesture.state {
            case .began:
                print("Began")
                gravity.removeItem(currObj)
            case .changed:
                print("Changed")
                currObj.transform = currObj.transform.rotated(by: gesture.rotation)
                animator.updateItem(usingCurrentState: currObj)
                gesture.rotation = 0
            case .ended:
                print("ended")
                gravity.addItem(currObj)
            case .failed, .cancelled:
                print("failed, cancelled")
            case .possible:
                print("possible")
            }
        }
    }
    
    @objc func pinchGesture(gesture: UIPinchGestureRecognizer){
        if let currObj = gesture.view as? Object{
            switch gesture.state {
            case .began:
                print("Began")
                gravity.removeItem(currObj)
                collision.removeItem(currObj)
                itemElasticity.removeItem(currObj)
            case .changed:
                print("Changed")
                currObj.layer.bounds.size.height *= gesture.scale
                currObj.layer.bounds.size.width *= gesture.scale
                if currObj.isCircle! {
                    currObj.layer.cornerRadius = currObj.layer.bounds.size.height / 2
                }
                gesture.scale = 1
            case .ended:
                print("ended")
                gravity.addItem(currObj)
                collision.addItem(currObj)
                itemElasticity.addItem(currObj)
            case .failed, .cancelled:
                print("failed, cancelled")
            case .possible:
                print("possible")
            }
        }
        
    }
    
    @objc func panGesture(gesture: UIPanGestureRecognizer){
        if let currObj = gesture.view as? Object{
            switch gesture.state {
            case .began:
                print("Began")
                gravity.removeItem(currObj)
            case .changed:
                print("Changed")
                gesture.view?.center = gesture.location(in: self.view)
                animator.updateItem(usingCurrentState: currObj)
            case .ended:
                print("ended")
                gravity.addItem(currObj)
            case .failed, .cancelled:
                print("failed or cancelled")
            case .possible:
                print("possible")
            }
        }
    }
}

