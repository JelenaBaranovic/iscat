//
//  TraceDraw.swift
//  ISCAT
//
//  Created by Andrew on 22/08/2016.
//  Copyright © 2016 Andrew. All rights reserved.
//

import Foundation
import UIKit

class TraceDraw {
    
    func setpoint (array) {
        var xp : CGFloat = 10                   //the xposn of the trace
        var firstPoint = CGPoint(x:xp, y:200)
        var drawnPoint = CGPoint(x:xp, y:200)

        var chunk = Int (basicChunk / v.tDrawScale )
        var chunkN = (traceLength - header) / chunk
        var step = ceil(2 / Double(v.tDrawScale))

        print (step, chunkN, chunkN * chunk, traceLength)
    }
        
    sv.backgroundColor = UIColor.whiteColor()
    sv.translatesAutoresizingMaskIntoConstraints = false
    sv.minimumZoomScale = 0.5
    sv.maximumZoomScale = 2

    if sv != nil {
        sv.delegate = self
    }
    //sv.scrollEnabled = true

    sv.addSubview(v)        //UIView



    for i in 0..<chunkN {
        
        //chunk label
        let lab = UILabel()
        lab.text = "This chunk is #\(i+1)"
        lab.sizeToFit()
        lab.frame.origin = CGPointMake(xp, 100)
        v.addSubview(lab)
        
        //drawing trace
        let thickness: CGFloat = 2.0
        let tracePath = UIBezierPath()
        tracePath.moveToPoint(firstPoint)
        
        for index in 0.stride(to: chunk, by: Int(step))  {
            
            pointIndex = index + header + tStart + i * chunk
            
            //xp is separately scaled by tDrawScale
            drawnPoint = CGPoint(x: xp + v.tDrawScale * CGFloat(index), y: CGFloat(200) * (1.0 + CGFloat(arr![pointIndex]) / 32536.0))
            
            tracePath.addLineToPoint(drawnPoint)
            
        }
        
        //grab the last plotted point for next iteration
        firstPoint = drawnPoint
        print (i, firstPoint)
        
        // render to layer
        let traceLayer = CAShapeLayer()
        traceLayer.path = tracePath.CGPath
        traceLayer.strokeColor = UIColor.blackColor().CGColor
        traceLayer.fillColor = nil
        traceLayer.lineWidth = thickness
        v.layer.addSublayer(traceLayer)             //basically accumulate a bunch of anonymous layers.
        
        xp += CGFloat(chunk) * v.tDrawScale