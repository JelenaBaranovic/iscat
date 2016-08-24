//
//  ViewController.swift
//  ISCAT
//
//  Created by Andrew on 30/07/2016.
//  Copyright © 2016 Andrew. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var sv: UIScrollView!
    @IBOutlet weak var zoomButton: UIButton!
    @IBOutlet weak var zoomLabel: UILabel!
    

    let v = TraceDisplay() //content view
    let ld = TraceIO()     //file retrieval
  
    let header = 3000       //axograph
    let tStart = 0
    
    let basicChunk : CGFloat = 1000     // points in a base chunk of data
    
    var pointIndex : Int = 0
    var tScale = 1          //this is terrible mixing up t and x
    var offset = CGPoint()
    var xp : CGFloat = 0    //the xposn of the trace
    
    var arr = [Int16]() //  this array will hold the trace data
    
    func getTrace() -> [Int16] {
        arr = ld.loadData()
        return arr
        
    }
    
    func traceView(arr: [Int16]) {
        let traceLength = arr.count
        
        
        var firstPoint = CGPoint(x:xp, y:200)
        var drawnPoint = CGPoint(x:xp, y:200)
        
        let chunk = Int (basicChunk / v.tDrawScale )
        let chunkN = (traceLength - header) / chunk         // the number of chunks to display
        let step = ceil(2 / Double(v.tDrawScale))
        
        print (step, chunkN, chunkN * chunk, traceLength)
        
        sv.backgroundColor = UIColor.whiteColor()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.minimumZoomScale = 0.1
        sv.maximumZoomScale = 10
        
        if sv != nil {
            sv.delegate = self
        }
        
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
                drawnPoint = CGPoint(x: xp + v.tDrawScale * CGFloat(index), y: CGFloat(200) * (1.0 + CGFloat(arr[pointIndex]) / 32536.0))
                
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
        }
        
        var sz = sv.bounds.size     //Not sure what these three lines do any more.
        sz.width = xp
        sv.contentSize = sz

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        //Load the trace
        let trace = getTrace()
        print (trace[0])
        traceView(trace)
        sv.bouncesZoom = false

        // Do any additional setup after loading the view, typically from a nib.
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func viewForZoomingInScrollView(sv: UIScrollView) -> UIView? {
        return v
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
    
        sv.userInteractionEnabled = true
        
    }
    
    func scrollViewWillBeginZooming(scrollView: UIScrollView, withView view: UIView?) {
   
        self.offset = scrollView.contentOffset
        print (scrollView.contentOffset.x)
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        //print("scrollViewDidZoom")
        
        
        
        let zoomValue = scrollView.zoomScale
        //v.tDrawScale *= zoomValue             #meltdown - not defensive.
        
        var sz = sv.bounds.size
        sz.width = xp * zoomValue
        sv.contentSize = sz
        sv.contentOffset = self.offset
        //sv.contentOffset = CGPoint(x:self.offset.x * zoomValue, y:self.offset.y * zoomValue)
        zoomLabel.text = String(zoomValue)
        sv.userInteractionEnabled = true
        //think about passing new scale onto the hard zoom? at the moment, it locks up. 
        //separate threads? How to release?
    }
    
    //mark actions

    
    //add vertical zoom?

    
    @IBAction func zoomIn(sender: UIButton) {
        //need to put a defensive limit in here to avoid overshoot
        
        v.tDrawScale *= 2       //increase the horizontal zoom factor
        v.layer.sublayers = nil //kill all the existing layes (ALL!!!)
        
         //add display of zoom factor
        
        //redraw the view
        self.traceView(arr)
    }

    @IBAction func zoomOut(sender: UIButton) {
        //need to put a defensive limit in here to avoid undershoot (data disappears!)
        
        v.tDrawScale /= 2           //reduce the horizontal zoom factor
        v.layer.sublayers = nil     //kill all the existing layes (ALL!!!)
        
        //add display of zoom factor
        
        //redraw the view
        self.traceView(arr)
    }
  


}

