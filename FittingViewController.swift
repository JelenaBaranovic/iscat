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
    var touchCount : Int = 0
    var swipeCount : Int = 0
    @IBOutlet weak var FitView: UIView!
    @IBOutlet weak var positionLabel: UILabel!
    
    @IBOutlet weak var BackButton: UIButton!
    
    func traceView(arr: [Int16]) {
        //let traceLength = arr.count
        
        //assuming a window of around 1000*500
        //would be nice just to take these from the layout but couldn't work out how to do it.
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
        

  

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let touchCount:Int = 0
        traceView(arr: pointsToFit)
        
        positionLabel.text = "Position in trace \(progressCounter) %"
        //print (pointsToFit [10])
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // recognize touches
    
    // recognize swipes and get coords
    
    // run fitting command
    
 
    @IBAction func fitPan(_ gesture: UIPanGestureRecognizer) {

        var locationOfBeganTap: CGPoint?
        
        var locationOfEndTap: CGPoint?
        
        if gesture.state == UIGestureRecognizerState.began {
            
            locationOfBeganTap = gesture.location(in: self.view)
            
        } else if gesture.state == UIGestureRecognizerState.ended {
            
            locationOfEndTap = gesture.location(in: self.view)
        }

    
        print ("pan", locationOfBeganTap, locationOfEndTap)
        swipeCount += 1
    }
    
    @IBAction func goBack(_ sender: AnyObject) {
        print ("button")
        delegate?.FitVCDidFinish(controller: self, touches: swipeCount)
        
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
