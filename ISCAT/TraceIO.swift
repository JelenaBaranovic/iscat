//
//  TraceIO.swift
//  ISCAT
//
//  Created by Andrew on 30/07/2016.
//  Copyright © 2016 Andrew. All rights reserved.
//

import Foundation

class TraceIO {
    
    func loadData() -> [Int16] {
        //*read binary data from disk
        let bundle = NSBundle.mainBundle()
        let dataPath :String = bundle.pathForResource("sim1600", ofType: "bin")!
        let readData = NSData (contentsOfFile: dataPath)
        print("read the data")
        
        let count = readData!.length / sizeof(Int16) //assume data format
        
        var arrayTrace = [Int16](count: count, repeatedValue: 0)
        
        readData!.getBytes(&arrayTrace, length:count * sizeof(Int16))
        
        return arrayTrace

    }
    
}
