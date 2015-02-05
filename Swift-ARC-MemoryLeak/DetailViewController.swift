//
//  DetailViewController.swift
//  Swift-ARC-MemoryLeak
//
//  Created by Tomas Kraina on 05/02/2015.
//  Copyright (c) 2015 Tom Kraina. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, ModelDelegate {
    
    lazy var model: Model = Model(delegate: self)
    
    // MARK: UIViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("\(self) - \(__FUNCTION__)")
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        println("\(self) - \(__FUNCTION__)")
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        println("\(self) - \(__FUNCTION__)")
    }
    
    deinit {
        println("\(self) - \(__FUNCTION__)")
    }
    
    // MARK: - IBAction
    
    @IBAction func performModelAction(sender: AnyObject) {
        println("\(self) - \(__FUNCTION__)")
        self.model.doSomething()
    }
    
    // MARK: - ModelDelegate
    
    func modelDidSomething(data: AnyObject) {
        println("\(self) - \(__FUNCTION__)")
        
        let alert = UIAlertController(title: "Done!", message: nil, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
