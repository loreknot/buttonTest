//
//  DemoView.swift
//  HearderTest
//
//  Created by 이요한 on 2020/03/23.
//  Copyright © 2020 yo. All rights reserved.
//

import UIKit

var path: UIBezierPath!

class DemoView: UIView {

  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.backgroundColor = UIColor.clear
  }
  
 required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
  }

  
  override func draw(_ rect: CGRect) {
    //self.createRectangle()
    
//    path = UIBezierPath(ovalIn: CGRect(x: self.frame.size.width/2  - self.frame.size.height/2, y: 0.0, width: self.frame.size.height, height: self.frame.size.height))
    createArc()

    UIColor.purple.setStroke()
    path.lineWidth = 3.0
    path.stroke()
    
  }
  
  func createRectangle() {
    path = UIBezierPath()
    path.move(to: CGPoint(x: 0.0, y: 0.0))
    path.addLine(to: CGPoint(x: 0.0, y: self.frame.size.height))
    path.addLine(to: CGPoint(x: self.frame.size.width, y: self.frame.size.height))
    path.addLine(to: CGPoint(x: self.frame.size.width, y: 0.0))
    path.close()
  }
  
  func createArc() {
    path = UIBezierPath(arcCenter: CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2), radius: self.frame.height/2, startAngle: CGFloat(180).toRadians(), endAngle: CGFloat(0).toRadians(), clockwise: true)
  }
  
  
  

}


extension CGFloat {
    func toRadians() -> CGFloat {
      return self * .pi / 180.0
  }
}
