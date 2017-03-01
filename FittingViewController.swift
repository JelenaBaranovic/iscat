//
//  FittingViewController.swift
//  ISCAT
//
//  Created by Andrew on 24/08/2016.
//  Copyright © 2016 Andrew. All rights reserved.
//

import UIKit

protocol FitViewControllerDelegate {
    func FitVCDidFinish(controller: FittingViewController, touches:Int)
    }

class FittingViewController: UIViewController {

    var progressCounter : Float = 0
    var pointsToFit : [Int16] = []
    var delegate: FitViewControllerDelegate? = nil
    var panCount : Int = 0
    var swipeCount : Int = 0
    
    var fitData : [Int] = []
    
    // need a container to hold all data from fitData
    // input to fit algorithm
    // store fit command to reproduce
    //
    
    //seems crazy to have these outside of gesture recognition but we need to remember BeganTap
    var locationOfBeganTap: CGPoint?
    var locationOfEndTap: CGPoint?
    
    @IBOutlet weak var FitView: UIView!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var BackButton: UIButton!
    
    func fitTraceView(arr: [Int16]) {
        //draw a fixed data trace on the screen
        //assuming a window of around 1000*500
        //would be nice just to take the coordinates from the layout but couldn't work out how to do it.
        let yPlotOffset = CGFloat(200)
        let viewWidth = CGFloat(900)
        let traceHeight = CGFloat(400)
        let firstPoint = CGPoint(x:0, y:yPlotOffset)
        var drawnPoint = CGPoint(x:0, y:yPlotOffset)
        
        FitView.backgroundColor = UIColor.white
        FitView.translatesAutoresizingMaskIntoConstraints = false
            
        //drawing trace
        let thickness: CGFloat = 2.0
        let tracePath = UIBezierPath()
        tracePath.move(to: firstPoint)
        print ("traceview", pointsToFit.count)
        for (index,point) in pointsToFit.enumerated() {
        
            drawnPoint = CGPoint(x: viewWidth * CGFloat(index) / CGFloat(pointsToFit.count) , y: yPlotOffset + traceHeight * CGFloat(point) / 32536.0)
            tracePath.addLine(to: drawnPoint)
            
        }
        
        // render to layer
        let traceLayer = CAShapeLayer()
        traceLayer.path = tracePath.cgPath
        traceLayer.strokeColor = UIColor.black.cgColor
        traceLayer.fillColor = nil
        traceLayer.lineWidth = thickness
        FitView.layer.addSublayer(traceLayer)
    
    }
    
    func optimiseFit() -> [Int]{
        print ("Fitting subroutine")
        return [0]
    }
    
    func drawFitLine (startTap: CGPoint!, endTap: CGPoint!) -> Bool {
        
        print ("drawing line:", startTap!, endTap!)
        //rough conversion of y value
        let averageY = (startTap.y + endTap.y) / 2 - 50
        
        let startPoint = CGPoint(x: startTap.x, y: averageY)
        let endPoint = CGPoint(x: endTap.x, y: averageY)
        
        let thickness: CGFloat = 9.0
        let fitPath = UIBezierPath()
        fitPath.move(to: startPoint)
        fitPath.addLine(to: endPoint)
        
        let fitLayer = CAShapeLayer()
        fitLayer.path = fitPath.cgPath
        fitLayer.strokeColor = UIColor.red.cgColor
        fitLayer.fillColor = nil
        fitLayer.lineWidth = thickness
        FitView.layer.addSublayer(fitLayer)
        
        return true
    }
  

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fitTraceView(arr: pointsToFit)
        positionLabel.text = "Position in trace \(progressCounter) %"
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
    @IBAction func fitPan(_ gesture: UIPanGestureRecognizer) {
        
        // recognize pan and get coords
        
        if gesture.state == UIGestureRecognizerState.began {
            
            locationOfBeganTap = gesture.location(in: self.view)
            print ("began pan", locationOfBeganTap)
            
        } else if gesture.state == UIGestureRecognizerState.ended {
            
            locationOfEndTap = gesture.location(in: self.view)
            print ("end pan", locationOfEndTap)
            
            // draw line
            // defensive code - Tap must have begun
            if (locationOfBeganTap != nil) {
                let panDrawn : Bool = drawFitLine(startTap: locationOfBeganTap!, endTap: locationOfEndTap!)
                
                if panDrawn {
                    panCount += 1
                    print ("drawn")
                }
                
                print (panDrawn)
                // save line
            }
            
            
            //saveFitLine
            
        }

        
        //an action for a more interactive kind of fit
        //dragging out a gaussian filtered rectangle?
        //need to draw on the fly so that can adjust
        
        //extent of drag gives opposed corners
        //if halfExpanding {
        //  if currentPoint.x < originPoint.x {
            //    leftExtent.x = currentPoint.x
            //    rightExtent.x = 2 * originPoint.x - currentPoint.x
            // }
            //else {
            //     leftExtent.x = originPoint.x - currentPoint.x
            //     rightExtent.x = currentPoint.x
            // ##do it here to get the sign right
            //      let size.x = 2 * (
            //    }
            //
        //else {
        //if currentPoint.x < originPoint.x {
        //    leftExtent.x = currentPoint.x
        //    rightExtent.x = originPoint.x
        // }
        //else {
        //     leftExtent.x = originPoint.x
        //     rightExtent.x = currentPoint.x
        //}
        //}
        
        //no half-expland option for vertical component - dragging from one level to another
        //check for snapping
        
        //if snapping {
        //  originLevel = nearestLevel(originPoint.y)
        //  currentLevel = nearestLevel(currentPoint.y)
        //}
        //else
        //{
        
        //if currentPoint.y < originPoint.y {
        //    **downward
        //    currentLevel.y = currentPoint.y
        //    originLevel.y = originPoint.y
        //    let size.y = ///PIXELS!!! depends on zoom need to think about real units
        
        // }
        //else {
        //     leftExtent.x = originPoint.x
        //     rightExtent.x = currentPoint.x
        //}
    
        
        
        
        
        //need to be selectable to move
        
        //live RMSD?
        
        //snap? 
        
        //draw grid?
        
        //draw amplitude lines
        
        //
        
    
        
        
        
        
        
        
    
        
    }
    
    
    
    // run fitting command
    
    @IBAction func goBack(_ sender: AnyObject) {
        print ("button")
        delegate?.FitVCDidFinish(controller: self, touches: panCount)
        
    }
  

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
