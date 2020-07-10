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
  @IBOutlet var testButtonHorizonConstraint: NSLayoutConstraint!
  
  let outCircle = UIView()
  let inCircle = UIView()
  var firstButton: UIButton!
  
  var position: CGPoint?
  var buttonCenter: CGFloat?
  
  var button1 = UIButton()
  var button2 = UIButton()
  var button3 = UIButton()
  var button4 = UIButton()
  var button5 = UIButton()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
 
    tableView.delegate = self
    tableView.dataSource = self
    
    testButton.layer.cornerRadius = testButton.frame.height/2
    testButton.pulsate()
    buttonCenter = testButton.frame.origin.y
    
    setCircle(size: CGSize(width: 65, height: 65), circle: outCircle, color: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
    setCircle(size: CGSize(width: 65, height: 65), circle: inCircle, color: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))
    
    
    let width: CGFloat = 240.0
    let height: CGFloat = 160.0
    
    let demoView = DemoView(frame:
      CGRect(x: self.view.frame.size.width/2 - width/2 , y: view.frame.height / 1.175,
      width: width, height: height))
    self.view.addSubview(demoView)
    demoView.isHidden = true 
    
    self.view.bringSubviewToFront(self.testButton)
    
    
  }
  
  
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "dropButton" {
      let VC = segue.destination as! DropDownButton
      VC.changeDelegate = self
    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    
  }
   
  
  @IBAction func testButton(_ sender: Any) {
    
    testButton.isSelected = !(testButton.isSelected)
    let generator = UIImpactFeedbackGenerator(style: .soft)
    generator.impactOccurred()
    
    let screenSize = UIScreen.main.bounds.size.width
    
   
    if testButton.isSelected {
      
      button1.alpha = 1
      button2.alpha = 1
      button3.alpha = 1
      button4.alpha = 1
      button5.alpha = 1

      buttonAnimation(buttonName: button1, title: "줄", endPoint: 1.25, duration: 0.4, withFuncName: #selector(moveLineViewControler))
      buttonAnimation(buttonName: button2, title: "아직", endPoint: 1.375, duration: 0.5)
      buttonAnimation(buttonName: button3, title: "모", endPoint: 1.5, duration: 0.5)
      buttonAnimation(buttonName: button4, title: "름", endPoint: 1.625, duration: 0.5)
      buttonAnimation(buttonName: button5, title: "곧", endPoint: 1.75, duration: 0.5)
      
      animateCircle(duration: 0.3, circle: inCircle, width: screenSize * 1.01, height: screenSize * 1.01, alpha: 1)
      animateCircle(duration: 0.4, circle: outCircle, width: screenSize * 1.4, height: screenSize * 1.4, alpha: 1)
      
      UIView.animate(withDuration: 0.2) {
        self.testButton.frame.origin.y = self.view.frame.size.height * 0.9
        self.testButtonHorizonConstraint.constant = 60
        
        self.inCircle.center = self.testButton.center
        self.outCircle.center = self.testButton.center
      }
      
      
    } else {
     
      animateCircle(duration: 0.6, circle: inCircle, width: 85, height: 85, alpha: 1)
      animateCircle(duration: 0.4, circle: outCircle, width: 0, height: 0, alpha: 0)
      fadeOutButtonAnimation()
      
      for layer in view.layer.sublayers! {
          if layer.name == "circle" {
               layer.removeFromSuperlayer()
          }
      }
    
      UIView.animate(withDuration: 0.2) {
        self.testButton.center = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height * 0.85)
        self.testButtonHorizonConstraint.constant = 0
        self.inCircle.center = self.testButton.center
        self.outCircle.center = self.testButton.center
      }
    }
  
  }
  
  func circlePath(endPoint: Double) -> UIBezierPath {
   let circlePath = UIBezierPath(arcCenter: CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height * 0.9), radius: view.frame.size.width * 0.55, startAngle: CGFloat(Double.pi * 2), endAngle: CGFloat(Double.pi * endPoint), clockwise: false)
    
    position = circlePath.currentPoint
    
    let shapeLayer = CAShapeLayer()
    
    shapeLayer.path = circlePath.cgPath
    shapeLayer.strokeColor = UIColor.clear.cgColor
    shapeLayer.fillColor = UIColor.clear.cgColor
    shapeLayer.lineWidth = 1.0
    shapeLayer.name = "circle"
    self.view.layer.addSublayer(shapeLayer)
    
    return circlePath
  }

  
  func setButton(buttonName: UIButton, title: String, withfuncName funcName: Selector) -> UIButton {
    let aniButton = buttonName
    aniButton.frame.size = CGSize(width: 35, height: 35)
    aniButton.layer.position = position! //CGPoint(x: view.frame.size.width * 0.3, y: view.frame.size.height * 0.7)
    aniButton.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
    aniButton.setTitle(title, for: .normal )
    aniButton.layer.cornerRadius = 10
    view.addSubview(aniButton)
    
    aniButton.addTarget(self, action: funcName, for: .touchUpInside)
     
    return aniButton
  }

  func buttonAnimation(buttonName: UIButton, title: String, endPoint: Double, duration: CFTimeInterval, withFuncName funcName: Selector = #selector(aniButtonClicked) ) {
    
    let buttonAnimation = CAKeyframeAnimation(keyPath: "position")
    buttonAnimation.duration = duration
    buttonAnimation.path = circlePath(endPoint: endPoint).cgPath
    buttonAnimation.rotationMode = .none
    buttonAnimation.timingFunctions = [CAMediaTimingFunction(name: .linear)]
    setButton(buttonName: buttonName, title: title, withfuncName: funcName).layer.add(buttonAnimation, forKey: "nil")
    
    
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
  
  func fadeOutButtonForSelectedButton(_ button: UIButton) {
     UIView.animate(withDuration: 0.3) {
       button.center = CGPoint(x: self.view.frame.size.width / 2, y: self.view.frame.size.height)
       button.alpha = 0
     }
  }
  func fadeOutButtonAnimationForSelectedButton() {
    fadeOutButtonForSelectedButton(button1)
    fadeOutButtonForSelectedButton(button2)
    fadeOutButtonForSelectedButton(button3)
    fadeOutButtonForSelectedButton(button4)
    fadeOutButtonForSelectedButton(button5)
  }
  
  func fadeOutButton(_ button: UIButton) {
    UIView.animate(withDuration: 0.3) {
      button.center = CGPoint(x: self.view.frame.size.width / 2, y: self.view.frame.size.height * 0.85)
      button.alpha = 0
    }
  }
  func fadeOutButtonAnimation() {
    fadeOutButton(button1)
    fadeOutButton(button2)
    fadeOutButton(button3)
    fadeOutButton(button4)
    fadeOutButton(button5)
  }
  
  func saveButtonPosition(_ button: UIButton) {
    
    let position: CGPoint?
    position = button.layer.position
    
    view.layoutIfNeeded()
    UIView.animate(withDuration: 0.3) {
      button.center = position!
      button.alpha = 1
    }
  }
  
  
  
  @objc func aniButtonClicked() {
    let alert = UIAlertController(title: "어렵노!", message: "응 나만 어려워~", preferredStyle: .alert)
    let OK = UIAlertAction(title: "확인", style: .default, handler: nil)
    alert.addAction(OK)
    self.present(alert, animated: false)
  }
    
  @objc func moveLineViewControler() {
    let vc = self.storyboard?.instantiateViewController(identifier: "line") as! LineAnimationViewController
    
    present(vc, animated: true)
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
   
    // 헤더의 최소 높이와 최대 높이, 애니메이션이 시작될 Offset 높이 지정
    let minConstraint: CGFloat = 0
    let maxConstriant: CGFloat = 40
    let animationStarOffset: CGFloat = 130
  
    // 애니매이션 시작 길이보다 테이블 뷰의 y 값이 커질 때
    if scrollView.contentOffset.y > animationStarOffset  {
      
      
      view.layoutIfNeeded()
      headerHeightConstraint.constant = minConstraint // 헤더의 길이 = 최소높이
      
      UIView.animate(withDuration: 0.5, delay: 0, options: [.allowUserInteraction], animations: {
        
        if self.testButton.isSelected { // 하단 테스트 버튼이 선택되어 커졌을때 애니메이션
        self.animateCircle(duration: 0.5, circle: self.inCircle, width: 0, height: 0, alpha: 0) // 안쪽 검정 원
        self.animateCircle(duration: 0.3, circle: self.outCircle, width: 0, height: 0, alpha: 0) // 바깥쪽 회색 원
        }
        
        self.view.layoutIfNeeded()
    
        self.testButton.frame.origin.y = self.view.frame.height * 1.2
        
        self.inCircle.center = self.testButton.center
        self.outCircle.center = self.testButton.center
        self.fadeOutButtonAnimationForSelectedButton()
        
      }, completion: nil)
      
      UIView.animate(withDuration: 0.3) {
        self.dropButton.alpha = 0.0
      }
    } else {
      // expand the header
      view.layoutIfNeeded()
      
      headerHeightConstraint.constant = maxConstriant // 헤더의 길이 최대길이로 복귀
      
      UIView.animate(withDuration: 0.5, delay: 0, options:[.allowUserInteraction], animations: {
        self.view.layoutIfNeeded() // 버튼 높이에 맞춰 원의 뷰 위치 조정
        
        if self.testButton.isSelected {
          self.testButton.frame.origin.y = self.view.frame.size.height * 0.9
        }
        
        self.inCircle.center = self.testButton.center
        self.outCircle.center = self.testButton.center
        
        
      }, completion: { _ in
        let screenSize = UIScreen.main.bounds.size.width
        
        if self.testButton.isSelected { // 버튼 선택시 y값 조정후 원의 크기 애니매이션 복귀
          self.animateCircle(duration: 0.3, circle: self.inCircle, width: screenSize * 1.01, height: screenSize * 1.01, alpha: 1)
          self.animateCircle(duration: 0.4, circle: self.outCircle, width: screenSize * 1.4, height: screenSize * 1.4, alpha: 1)
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



