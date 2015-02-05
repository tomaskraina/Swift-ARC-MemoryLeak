//
//  Model.swift
//  Swift-ARC-MemoryLeak
//
//  Created by Tomas Kraina on 05/02/2015.
//  Copyright (c) 2015 Tom Kraina. All rights reserved.
//

import Foundation

@objc protocol ModelDelegate {
    optional func modelDidSomething(data: AnyObject)
}

class Model {
    
    weak var delegate: ModelDelegate?
    
    init(delegate: ModelDelegate) {
        self.delegate = delegate
    }
    
    func doSomething () {
        // Do something
        print("Model: doing something")
        
        // Check if delegate implements the method
        // If not do an early return
        if self.delegate?.modelDidSomething? == nil { return }
        
        // Prepare data for delegate - fetch data from CoreData, etc..
        
        // Let the delegate know
        self.delegate!.modelDidSomething!("Processed data")
    }
}
