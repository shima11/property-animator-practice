//
//  ViewController.swift
//  property-animator-practice
//
//  Created by Jinsei Shima on 2018/09/24.
//  Copyright © 2018 Jinsei Shima. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func didTapResetButton(_ sender: Any) {
        animator.stopAnimation(false)
        animator.finishAnimation(at: .start)
    }

    @IBAction func didTapStartButton(_ sender: Any) {
        setAnimation(initialVelocity: .zero)
        animator.startAnimation()
    }

    @IBAction func didTapStopButton(_ sender: Any) {
        animator.pauseAnimation()
    }

    @IBOutlet weak var targetView: UIView!
    
    @IBOutlet weak var massValueLabel: UILabel!
    @IBOutlet weak var stiffnessValueLabel: UILabel!
    @IBOutlet weak var dampingValueLabel: UILabel!
    
    @IBOutlet weak var massSlider: UISlider!
    @IBOutlet weak var stiffnessSlider: UISlider!
    @IBOutlet weak var dampingSlider: UISlider!

    @IBAction func changeMassSlider(_ sender: Any) {
        massValueLabel.text = String(format: "%.0f", massSlider.value)
    }
    
    @IBAction func changeStiffnessSlider(_ sender: Any) {
        stiffnessValueLabel.text = String(format: "%.0f", stiffnessSlider.value)
    }

    @IBAction func changeDampingSlider(_ sender: Any) {
        dampingValueLabel.text = String(format: "%.0f", dampingSlider.value)
    }

    var animator: UIViewPropertyAnimator!

    override func viewDidLoad() {
        super.viewDidLoad()

        massSlider.minimumValue = 0
        massSlider.maximumValue = 1000

        stiffnessSlider.minimumValue = 0
        stiffnessSlider.maximumValue = 1000


        dampingSlider.minimumValue = 0
        dampingSlider.maximumValue = 1000

        massValueLabel.text = String(format: "%.0f", massSlider.value)
        stiffnessValueLabel.text = String(format: "%.0f", stiffnessSlider.value)
        dampingValueLabel.text = String(format: "%.0f", dampingSlider.value)

        let gesture = UIPanGestureRecognizer(target: self, action: #selector(dragTargetView(gesture:)))
        targetView.addGestureRecognizer(gesture)

    }

    func setAnimation(initialVelocity: CGVector) {

        if animator != nil {
            animator.stopAnimation(false)
            animator.finishAnimation(at: .start)
        }

        let springCurve = UISpringTimingParameters(
            mass: CGFloat(massSlider?.value ?? 0),
            stiffness: CGFloat(stiffnessSlider?.value ?? 0),
            damping: CGFloat(dampingSlider?.value ?? 0),
            initialVelocity: initialVelocity
        )

        animator = UIViewPropertyAnimator(
            duration: 0.1,
            timingParameters: springCurve
        )
        animator.finishAnimation(at: .start)

        animator.addAnimations {
            self.targetView.center = self.view.center
        }

        animator.addCompletion { _ in
            self.targetView.center = self.view.center
        }
    }

    var i: CGPoint = .zero

    @objc func dragTargetView(gesture: UIPanGestureRecognizer) {

        switch gesture.state {
        case .began:
            i = gesture.view?.center ?? .zero
        case .changed:
            let t = gesture.translation(in: view)
            let center = CGPoint(x: i.x + t.x, y: i.y + t.y)
            targetView.center = center
        case .ended, .cancelled, .failed:
            let v = gesture.velocity(in: view)
            setAnimation(initialVelocity: CGVector(dx: v.x/500, dy: v.y/500))
            animator.startAnimation()
        default:
            break
        }
    }

}

