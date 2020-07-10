//
//  LineAnimationViewController.swift
//  HearderTest
//
//  Created by 이요한 on 2020/06/23.
//  Copyright © 2020 yo. All rights reserved.
//

import UIKit

class LineAnimationViewController: UIViewController, CAAnimationDelegate, UIGestureRecognizerDelegate {
    
    var verticalLine: CAShapeLayer?

    override func viewDidLoad() {
        super.viewDidLoad()
      createLine()
      addPanGesture()
      
    

    }
    
  func addPanGesture() {
    let sgr = UIPanGestureRecognizer(target: self, action: #selector(handleSlide))
    sgr.delegate = self
    view.addGestureRecognizer(sgr)
  }
  
  @objc func handleSlide(gesture: UIPanGestureRecognizer) {
    let amountX = gesture.translation(in: view.self).x
    let amountY = gesture.translation(in: view.self).y
    self.verticalLine?.path = self.getLinePathWithAmount(amountX: amountX, amountY: amountY)
    
    if gesture.state == UIGestureRecognizer.State.ended {
      self.view.removeGestureRecognizer(gesture)
      self.animateLineReturnFrom(positionX: amountX, positionY: amountY)
    }
  }
  
  func animateLineReturnFrom(positionX: CGFloat, positionY: CGFloat) {
    let bounce = CAKeyframeAnimation(keyPath: "path")
    bounce.timingFunctions = [CAMediaTimingFunction(name: .easeIn)]
    let values = [
      self.getLinePathWithAmount(amountX: positionX, amountY: positionY),
      self.getLinePathWithAmount(amountX: -(positionY * 0.7), amountY: -(positionY * 0.7)),
      self.getLinePathWithAmount(amountX: positionX * 0.4, amountY: positionY * 0.4),
      self.getLinePathWithAmount(amountX: -(positionX * 0.3), amountY: -(positionY * 0.3)),
      self.getLinePathWithAmount(amountX: positionX * 0.15, amountY: positionY * 0.15),
      self.getLinePathWithAmount(amountX: 0.0, amountY: 0.0)
    ]
    
    bounce.values = values
    bounce.duration = 0.9
    bounce.isRemovedOnCompletion = false
    bounce.fillMode = .forwards
    bounce.delegate = self
    self.verticalLine?.add(bounce, forKey: "return")
    
  }

  func getLinePathWithAmount(amountX: CGFloat, amountY: CGFloat) -> CGPath {
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.width
    
    let centerY = height
    
    let path = UIBezierPath()
    let topLeftPoint = CGPoint(x: 0, y: centerY)
    let topMidPoint = CGPoint(x: width / 2, y: centerY + amountY)
    let topRightPoint = CGPoint(x: width, y: centerY)
    
    path.move(to: topLeftPoint)
    path.addQuadCurve(to: topRightPoint, controlPoint: topMidPoint)
    
    return path.cgPath
  }
  
  func createLine() {
    verticalLine = CAShapeLayer(layer: self.view.layer)
    verticalLine?.lineWidth = 3.0
    verticalLine?.path = getLinePathWithAmount(amountX: 0.0, amountY: 0.0)
    verticalLine?.strokeColor = UIColor.white.cgColor
    verticalLine?.fillColor = UIColor.clear.cgColor
    
    view.layer.addSublayer(verticalLine!)
  }



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
