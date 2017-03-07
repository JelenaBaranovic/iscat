//
//  Gaussian.swift
//  ISCAT
//
//  Created by Andrew on 03/03/2017.
//  Copyright © 2017 Andrew. All rights reserved.
//

import Foundation
import UIKit

class GaussianFit {

    let x = Array(0...100)
    var xf = [Float]()
    var gaussArray = [Float]()
    
    init() {
        (xf, gaussArray) = createGaussianArray()
        //probably need to start saying what sigma should be here
    }
    
    func gaussian (x: Float, a: Float, b: Float, c: Float) -> Float32 {
        return (a * exp (-(pow(x-b , 2) / 2 * pow(c, 2))))
    }

    func createGaussianArray (mu: Float = 0.5) -> ([Float], [Float]) {
        //makes two arrays: x points and Gaussian function
        xf = x.map {x in Float(x) / 100}
        gaussArray = xf.map { xf in gaussian (x: xf, a: 1,b: mu,c: 10) }

        return (xf, gaussArray)
    }

    /*
    typical values, now received from view controller
    and gesture:
    let firstTouch = CGPoint(x: 150, y:000)
    let currentTouch = CGPoint(x: 50, y:300)
    let window = CGPoint (x: 400.0, y: 400.0)
    */
    
    func buildGaussPath (firstTouch: CGPoint, currentTouch: CGPoint, window:CGPoint) -> CGPath {

        //float them for maths later
        let leftExtreme = Float(min(firstTouch.x, currentTouch.x))
        let gWidth = Float(max(firstTouch.x, currentTouch.x)) - leftExtreme
        let base = Float(firstTouch.y)
        let amp = Float(firstTouch.y - currentTouch.y)

        //let cv = UIView(frame: CGRect(x: 0.0, y: 0.0, width: window.x, height: window.y))
        //cv.backgroundColor = UIColor.white

        let gaussPath = UIBezierPath()

        let firstPoint = CGPoint (x: CGFloat(leftExtreme), y: CGFloat(base)) //draw left to right, from
        gaussPath.move(to: firstPoint)

        for (xp, yp) in zip(xf, gaussArray) {
            
            let gaussPoint = CGPoint (x:Double(leftExtreme + xp * gWidth), y:Double( base - amp * yp))
            //print (xp,yp)
            //print (gaussPoint.x, gaussPoint.y)
            
            gaussPath.addLine(to: gaussPoint)
        }
        return gaussPath.cgPath
    }
    
    func buildGaussLayer (gPath: CGPath) -> CAShapeLayer {
        
        
        let gLayer = CAShapeLayer()
        gLayer.path = gPath
        gLayer.strokeColor = UIColor.green.cgColor
        gLayer.fillColor = nil
        gLayer.lineWidth =  3

        return gLayer
    }
}
//cv.layer.addSublayer(gLayer)  is what is done with that...
