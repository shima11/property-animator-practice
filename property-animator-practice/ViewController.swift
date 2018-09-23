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
        setAnimation()
        animator.startAnimation()
    }

    @IBAction func didTapStopButton(_ sender: Any) {
        animator.pauseAnimation()
    }

    func setAnimation() {

        if animator != nil {
            animator.stopAnimation(false)
            animator.finishAnimation(at: .start)
        }

        let springCurve = UISpringTimingParameters(
            mass: CGFloat(massSlider?.value ?? 0),
            stiffness: CGFloat(stiffnessSlider?.value ?? 0),
            damping: CGFloat(dampingSlider?.value ?? 0),
            initialVelocity: CGVector.zero
        )

        animator = UIViewPropertyAnimator(
            duration: 1,
            timingParameters: springCurve
        )
        animator.finishAnimation(at: .start)

        animator.addAnimations {
            self.targetView.center = CGPoint(x: UIScreen.main.bounds.width/2, y: 100)
        }

        animator.addCompletion { _ in
            self.targetView.center = self.view.center
        }
    }

    @IBOutlet weak var targetView: UIView!
    
    @IBOutlet weak var massValueLabel: UILabel!
    @IBOutlet weak var stiffnessValueLabel: UILabel!
    @IBOutlet weak var dampingValueLabel: UILabel!
    
    @IBOutlet weak var massSlider: UISlider!
    @IBOutlet weak var stiffnessSlider: UISlider!
    @IBOutlet weak var dampingSlider: UISlider!

    @IBAction func changeMassSlider(_ sender: Any) {
        massValueLabel.text = String(format: "%.2f", massSlider.value)
    }
    
    @IBAction func changeStiffnessSlider(_ sender: Any) {
        stiffnessValueLabel.text = String(format: "%.2f", stiffnessSlider.value)
    }

    @IBAction func changeDampingSlider(_ sender: Any) {
        dampingValueLabel.text = String(format: "%.2f", dampingSlider.value)
    }

    var animator: UIViewPropertyAnimator!

    override func viewDidLoad() {
        super.viewDidLoad()

        massSlider.minimumValue = 0
        massSlider.maximumValue = 1

        stiffnessSlider.minimumValue = 0
        stiffnessSlider.maximumValue = 1

        dampingSlider.minimumValue = 0
        dampingSlider.maximumValue = 1

        massValueLabel.text = String(format: "%.2f", massSlider.value)
        stiffnessValueLabel.text = String(format: "%.2f", stiffnessSlider.value)
        dampingValueLabel.text = String(format: "%.2f", dampingSlider.value)

    }


}

