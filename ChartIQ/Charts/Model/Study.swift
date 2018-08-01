//
//  Study.swift
//  ChartIQ
//
//  Created by Tao Man Kit on 4/2/2017.
//  Copyright © 2017 ROKO. All rights reserved.
//

import UIKit

open class Study: NSObject, NSCoding {
    
    open var shortName = ""
    open var name = ""
    open var inputs: [String: Any]?
    open var outputs: [String: Any]?
    open var parameters: [String: Any]?
    open var type = ""
    
    public init(shortName: String, name: String, inputs: [String: Any]?, outputs: [String: Any]?, type: String, parameters: [String: Any]?) {
        super.init()
        self.shortName = shortName.replacingOccurrences(of: "|", with: "")
        self.name = name.replacingOccurrences(of: "|", with: "")
        self.inputs = inputs
        self.outputs = outputs
        self.type = type
        self.parameters = parameters
    }
    
    required public init(coder aDecoder: NSCoder) {
        self.shortName = aDecoder.decodeObject(forKey: "shortName") as! String
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.type = aDecoder.decodeObject(forKey: "type") as! String
        self.inputs = aDecoder.decodeObject(forKey: "inputs") as? [String: Any]
        self.outputs = aDecoder.decodeObject(forKey: "outputs") as? [String: Any]
        self.parameters = aDecoder.decodeObject(forKey: "parameters") as? [String: Any]
        
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(shortName, forKey: "shortName")
        aCoder.encode(type, forKey: "type")
        aCoder.encode(inputs, forKey: "inputs")
        aCoder.encode(outputs, forKey: "outputs")
        aCoder.encode(parameters, forKey: "parameters")
    }
}
