//
//  FittingViewController.swift
//  ISCAT
//
//  Created by Andrew on 24/08/2016.
//  Copyright © 2016 Andrew. All rights reserved.
//

import UIKit

class FittingViewController: UIViewController {

    var progressCounter : Float = 0
    var pointsToFit : [Int16] = []
    
    
    @IBOutlet weak var FitView: UIView!
    @IBOutlet weak var positionLabel: UILabel!
    
    @IBOutlet weak var BackButton: UIButton!
    
    func traceView(arr: [Int16]) {
        //let traceLength = arr.count
        
        
        let firstPoint = CGPoint(x:0, y:300)
        var drawnPoint = CGPoint(x:0, y:200)
        
        
        FitView.backgroundColor = UIColor.whiteColor()
        FitView.translatesAutoresizingMaskIntoConstraints = false
            
        //drawing trace
        let thickness: CGFloat = 2.0
        let tracePath = UIBezierPath()
        tracePath.moveToPoint(firstPoint)
        
        for (index,point) in pointsToFit.enumerate() {
        
            //xp is separately scaled by tDrawScale
            drawnPoint = CGPoint(x: FitView.bounds.width * CGFloat(index) / CGFloat(pointsToFit.count) , y: CGFloat(300) * (1.0 + CGFloat(point)) / 32536.0)
            tracePath.addLineToPoint(drawnPoint)
            
        }
        
       
        // render to layer
        let traceLayer = CAShapeLayer()
        traceLayer.path = tracePath.CGPath
        traceLayer.strokeColor = UIColor.blackColor().CGColor
        traceLayer.fillColor = nil
        traceLayer.lineWidth = thickness
        FitView.layer.addSublayer(traceLayer)
    
    }
        

  

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print ("after segue", pointsToFit.count)
        
        traceView(pointsToFit)
        
        positionLabel.text = "Position in trace \(progressCounter) %"
        //print (pointsToFit [10])
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goBack(sender: AnyObject) {
        print ("button")
        
        //zoom gets reset and so on
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
