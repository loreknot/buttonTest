//
//  dropDownButton.swift
//  HearderTest
//
//  Created by 이요한 on 2020/02/28.
//  Copyright © 2020 yo. All rights reserved.
//

import Foundation
import UIKit

class DropDownButton: UIViewController {

  @IBOutlet var menuTableView: UITableView!
  @IBOutlet var dropButton: UIButton!
  @IBOutlet var buttonHeight: NSLayoutConstraint!
  
  var fruitList = ["orange", "banana", "cherry", "grape"]
  var changeDelegate: changeColorDelegate?
  var cellBackGroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    menuTableView.isHidden = true
    
    
  }
  
  @IBAction func tapDropButton(_ sender: Any) {
    if menuTableView.isHidden {
      animate(toogle: true)
    } else {
      animate(toogle: false)
    }
   
  }
  
  
  
  func animate(toogle: Bool) {
    if toogle {
      UIView.animate(withDuration: 0.3) {
        self.menuTableView.isHidden = false
      }
    } else {
      UIView.animate(withDuration: 0.3) {
        self.menuTableView.isHidden = true
      }
    }
  }
  
  
}



  

extension DropDownButton: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
   return fruitList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
  
    let cell = tableView.dequeueReusableCell(withIdentifier: "menu", for: indexPath)
    cell.textLabel?.text = fruitList[indexPath.row]
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    var color = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
    if fruitList[indexPath.row] == "orange" {
      color = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
      cellBackGroundColor = #colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1)
    } else if fruitList[indexPath.row] == "banana"{
      color = #colorLiteral(red: 0.9820410609, green: 0.9522212148, blue: 0.4846059084, alpha: 1)
      cellBackGroundColor = #colorLiteral(red: 0.9820410609, green: 0.9522212148, blue: 0.7099376721, alpha: 1)
    } else if fruitList[indexPath.row] == "cherry" {
      color = #colorLiteral(red: 0.5836527441, green: 0.1685898032, blue: 0.09727545735, alpha: 1)
      cellBackGroundColor = #colorLiteral(red: 0.849535517, green: 0.4631393296, blue: 0.3843107927, alpha: 1)
    } else if fruitList[indexPath.row] == "grape" {
      color = #colorLiteral(red: 0.4362246476, green: 0.2691299229, blue: 0.5419508097, alpha: 1)
      cellBackGroundColor = #colorLiteral(red: 0.5951312875, green: 0.3672905451, blue: 0.7396824087, alpha: 1)
    }
    
    tableView.reloadData()
    changeDelegate?.changeColor(color: color)
    
    dropButton.setTitle(fruitList[indexPath.row], for: .normal)
    animate(toogle: false)
    
    
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    cell.backgroundColor = cellBackGroundColor
    
  }
  
  
}


protocol changeColorDelegate {
  func changeColor(color: UIColor)
}
