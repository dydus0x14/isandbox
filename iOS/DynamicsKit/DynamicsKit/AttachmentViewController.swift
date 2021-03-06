//
//  AttachmentViewController.swift
//  DynamicsKit
//
//  Created by Anton Davydov on 2/17/15.
//  Copyright (c) 2015 EPAM Systems. All rights reserved.
//

import UIKit

class AttachmentViewController: UIViewController {

    @IBOutlet weak var platform: UIView!
    @IBOutlet weak var spring: UIView!
    @IBOutlet weak var cube: UIView!

    var animator: UIDynamicAnimator!
    var pushBehavior: UIPushBehavior!
    var dynamicSpring: UIDynamicItemBehavior!
    var attachmentSpring: UIAttachmentBehavior!

    @IBOutlet weak var magnitude: UISlider!
    @IBOutlet weak var density: UISlider!

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        animator = UIDynamicAnimator()
        startAnimation()
    }

    @IBAction func panGestureAction(sender: UIPanGestureRecognizer) {

        let translatedPoint = sender.translationInView(cube)
        let velocity = sender.velocityInView(cube)

        switch(sender.state) {
        case .Changed:
            sender.setTranslation(CGPoint(x: 0, y: 0), inView: cube)
            break
        case .Ended:
            if pushBehavior != nil {
                animator.removeBehavior(pushBehavior)
            }
            pushBehavior = UIPushBehavior(items: [cube], mode: .Instantaneous)
            pushBehavior.pushDirection = CGVectorMake(velocity.x, velocity.y)
            pushBehavior.magnitude = CGFloat(magnitude.value)
            animator.addBehavior(pushBehavior)
            break
        default:
            break
        }
    }
    
    @IBAction func sliderValueChanged(sender: UISlider) {
        dynamicSpring.density = CGFloat(density.value)
    }

    func startAnimation() {

        dynamicSpring = UIDynamicItemBehavior(items: [spring])
        density.value = Float(dynamicSpring.density)
        animator.addBehavior(dynamicSpring)


        attachmentSpring = UIAttachmentBehavior(item: spring, attachedToAnchor: platform.center)
        animator.addBehavior(attachmentSpring)

        let dynamicCube = UIDynamicItemBehavior(items: [cube])
        animator.addBehavior(dynamicCube)
        let attachmentCube = UIAttachmentBehavior(item: cube, attachedToItem: spring)
        attachmentCube.frequency = 4.0
        attachmentCube.damping = 0.0
        animator.addBehavior(attachmentCube)

        let collision = UICollisionBehavior(items: [cube])
        collision.addBoundaryWithIdentifier("edges", forPath: UIBezierPath(rect: view.frame))
        animator.addBehavior(collision)

        let gravity = UIGravityBehavior(items: [cube, spring])
        animator.addBehavior(gravity)

    }
}
