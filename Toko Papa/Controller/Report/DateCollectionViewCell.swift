//
//  DateCollectionViewCell.swift
//  Toko Papa
//
//  Created by Leonnardo Benjamin Hutama on 05/11/19.
//  Copyright © 2019 Louis  Valen. All rights reserved.
//

import UIKit

class DateCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var Circle: UIView!
    
    
    func DrawCircle() {
        
        let circleCenter = Circle.center
        
        let circlePath = UIBezierPath(arcCenter: circleCenter, radius: (Circle.bounds.width/2 - 5), startAngle: -CGFloat.pi/2, endAngle: (2 * CGFloat.pi), clockwise: true)
        
        let CircleLayer = CAShapeLayer()
        CircleLayer.path = circlePath.cgPath
        CircleLayer.strokeColor = #colorLiteral(red: 0, green: 0.5690457821, blue: 0.5746168494, alpha: 1)
        CircleLayer.lineWidth = 2
        CircleLayer.strokeEnd = 0
        CircleLayer.fillColor = #colorLiteral(red: 0, green: 0.5690457821, blue: 0.5746168494, alpha: 1)
        CircleLayer.lineCap = CAShapeLayerLineCap.round
        
//        let Animation = CABasicAnimation(keyPath: "strokeEnd")
//        Animation.duration = 1.5
//        Animation.toValue = 1
//        Animation.fillMode = CAMediaTimingFillMode.forwards
//        Animation.isRemovedOnCompletion = false
//
//        CircleLayer.add(Animation, forKey: nil)
        Circle.layer.addSublayer(CircleLayer)
        Circle.layer.backgroundColor = UIColor.clear.cgColor
        
    }
    
    func DrawGreyCircle() {
            
        let circleCenter = Circle.center
        
        let circlePath = UIBezierPath(arcCenter: circleCenter, radius: (Circle.bounds.width/2 - 5), startAngle: -CGFloat.pi/2, endAngle: (2 * CGFloat.pi), clockwise: true)
        
        let CircleLayer = CAShapeLayer()
        CircleLayer.path = circlePath.cgPath
        CircleLayer.strokeColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        CircleLayer.lineWidth = 2
        CircleLayer.strokeEnd = 0
        CircleLayer.fillColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        CircleLayer.lineCap = CAShapeLayerLineCap.round
        
//        let Animation = CABasicAnimation(keyPath: "strokeEnd")
//        Animation.duration = 1.5
//        Animation.toValue = 1
//        Animation.fillMode = CAMediaTimingFillMode.forwards
//        Animation.isRemovedOnCompletion = false
//
//        CircleLayer.add(Animation, forKey: nil)
        Circle.layer.addSublayer(CircleLayer)
        Circle.layer.backgroundColor = UIColor.clear.cgColor
        
    }
    
}
