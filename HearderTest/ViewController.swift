//
//  ViewController.swift
//  HearderTest
//
//  Created by 이요한 on 2020/02/27.
//  Copyright © 2020 yo. All rights reserved.
//

import UIKit
import AudioToolbox

class ViewController: UIViewController {

  @IBOutlet var tableView: UITableView!
  @IBOutlet var headerHeightConstraint: NSLayoutConstraint!

  @IBOutlet var topBarView: UIView!
  @IBOutlet var dropButton: UIView!
  
  @IBOutlet var testButton: UIButton!
  let outCircle = UIView()
  let inCircle = UIView()
  let circleLayer = UIButton()
  
  
  
 
  override func viewDidLoad() {
    super.viewDidLoad()
 
    tableView.delegate = self
    tableView.dataSource = self
    
    testButton.layer.cornerRadius = testButton.frame.height/2
    testButton.pulsate()
    
    setCircle(size: CGSize(width: 65, height: 65), circle: outCircle, color: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
    setCircle(size: CGSize(width: 65, height: 65), circle: inCircle, color: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))
    self.view.bringSubviewToFront(self.testButton)
    
    let width: CGFloat = 240.0
    let height: CGFloat = 160.0
    let demoView = DemoView(frame: CGRect(x: self.view.frame.size.width/2 - width/2 , y: self.view.frame.size.height/2 - height/2
      , width: width, height: height))
    
    self.view.addSubview(demoView)
    
    
    
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "dropButton" {
      let VC = segue.destination as! DropDownButton
      VC.changeDelegate = self
    }
  }
  
  @IBAction func testButton(_ sender: Any) {
    
    testButton.isSelected = !(testButton.isSelected)
    let generator = UIImpactFeedbackGenerator(style: .soft)
    generator.impactOccurred()
    
    let screenSize = UIScreen.main.bounds.size.width
    
    if testButton.isSelected {
      animateCircle(duration: 0.3, circle: inCircle, width: screenSize * 1.01, height: screenSize * 1.01, alpha: 1)
      animateCircle(duration: 0.4, circle: outCircle, width: screenSize * 1.4, height: screenSize * 1.4, alpha: 1)
      
    
      
      UIView.animate(withDuration: 0.2) {
        self.view.layoutIfNeeded()
        
        self.testButton.frame.origin.y = self.view.frame.size.height * 0.9
        self.inCircle.center = self.testButton.center
        self.outCircle.center = self.testButton.center
        
      }
      self.view.bringSubviewToFront(self.testButton)
      
      
    } else {
     
      animateCircle(duration: 0.6, circle: inCircle, width: 85, height: 85, alpha: 1)
      animateCircle(duration: 0.4, circle: outCircle, width: 0, height: 0, alpha: 0)
      
      UIView.animate(withDuration: 0.2) {
        self.view.layoutIfNeeded()
        self.inCircle.center = self.testButton.center
        self.outCircle.center = self.testButton.center
        
      }
    }
    

    
    
  }
  

  
  func setCircle(size cirlSize: CGSize, circle kindOfCircle: UIView, color cirlcColor: UIColor) {
    kindOfCircle.frame.size = cirlSize
    kindOfCircle.alpha = 1
    kindOfCircle.backgroundColor = cirlcColor
    kindOfCircle.layer.cornerRadius = kindOfCircle.frame.height / 2
    kindOfCircle.center = CGPoint(x: view.frame.width / 2, y: view.frame.height / 1.175)
    
    self.view.addSubview(kindOfCircle)
   
  }

  func animateCircle(duration durationTime: TimeInterval, circle circleView: UIView, width circleWidth: CGFloat, height circleHeight: CGFloat, alpha circleAlpha: CGFloat){
    
    UIView.animate(withDuration: durationTime) {
      
      circleView.frame.size.height = circleWidth
      circleView.frame.size.width = circleHeight
      circleView.center = self.testButton.center
      circleView.alpha = circleAlpha
      circleView.layer.cornerRadius = circleView.frame.height / 2

    }
  }
  

    
  
}




extension ViewController: UITableViewDataSource, UITableViewDelegate {
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 40
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    
    cell.textLabel?.text = "\(indexPath.row)"
    cell.textLabel?.textAlignment = .center
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
  }
  
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let minConstraint: CGFloat = 0
    let maxConstriant: CGFloat = 40
    let animationStarOffset: CGFloat = 130
    
    if scrollView.contentOffset.y > animationStarOffset  {
      
      view.layoutIfNeeded()
      headerHeightConstraint.constant = minConstraint
      
      UIView.animate(withDuration: 0.5, delay: 0, options: [.allowUserInteraction], animations: {
        
        if self.testButton.isSelected {
        self.animateCircle(duration: 0.5, circle: self.inCircle, width: 0, height: 0, alpha: 0)
        self.animateCircle(duration: 0.3, circle: self.outCircle, width: 0, height: 0, alpha: 0)
        }
        
        self.view.layoutIfNeeded()
        self.testButton.frame.origin.y = 850
        self.inCircle.center = self.testButton.center
        self.outCircle.center = self.testButton.center
        
        
      }, completion: nil)
      
      UIView.animate(withDuration: 0.3) {
        self.dropButton.alpha = 0.0
      }
    } else {
      // expand the header
      view.layoutIfNeeded()
      
      headerHeightConstraint.constant = maxConstriant
      
      UIView.animate(withDuration: 0.5, delay: 0, options:[.allowUserInteraction], animations: {
        self.view.layoutIfNeeded()
        self.inCircle.center = self.testButton.center
        self.outCircle.center = self.testButton.center
        
      }, completion: { _ in
        if self.testButton.isSelected {
          self.animateCircle(duration: 0.4, circle: self.inCircle, width: 300, height: 300, alpha: 1)
          self.animateCircle(duration: 0.6, circle: self.outCircle, width: 500, height: 500, alpha: 1)
        }
      })
      
      UIView.animate(withDuration: 0.3) {
        self.dropButton.alpha = 1.0
        
      }
    }
  }
    
//    if scrollView.contentOffset.y < animationStarOffset && headerHeightConstraint.constant < maxConstriant {
//      self.headerHeightConstraint.constant += 1
//
//    }
  }








extension ViewController: changeColorDelegate {
  func changeColor(color: UIColor) {
    
    UIView.animate(withDuration: 0.5) {
      self.topBarView.backgroundColor = color
    }
  }
}
  
extension UIButton {

  func pulsate() {
    let pulse = CASpringAnimation(keyPath: "transform.scale")
    pulse.duration = 0.4
    pulse.fromValue = 0.98
    pulse.toValue = 1.0
    pulse.autoreverses = true
    pulse.repeatCount = .infinity
    pulse.initialVelocity = 0.5
    pulse.damping = 1.0
    layer.add(pulse, forKey: nil)
  }
  
  func flash() {
    let flash = CABasicAnimation(keyPath: "opacity")
    flash.duration = 0.3
    flash.fromValue = 1
    flash.toValue = 0.1
    flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
    flash.autoreverses = true
    flash.repeatCount = .infinity
    layer.add(flash, forKey: nil)
  }
  
}



