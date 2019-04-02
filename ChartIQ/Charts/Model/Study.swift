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
    open var priority: Int = 0
    
    public init(shortName: String, name: String, inputs: [String: Any]?, outputs: [String: Any]?, parameters: [String: Any]?, priority: Int) {
        super.init()
        self.shortName = shortName
        self.name = name.replacingOccurrences(of: "|", with: "")
        self.inputs = inputs
        self.outputs = outputs
        self.parameters = parameters
        self.priority = priority
    }
    
    required public init(coder aDecoder: NSCoder) {
        self.shortName = aDecoder.decodeObject(forKey: "shortName") as! String
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.inputs = aDecoder.decodeObject(forKey: "inputs") as? [String: Any]
        self.outputs = aDecoder.decodeObject(forKey: "outputs") as? [String: Any]
        self.parameters = aDecoder.decodeObject(forKey: "parameters") as? [String: Any]
        self.priority = aDecoder.decodeObject(forKey: "priority") as? Int ?? 0
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(shortName, forKey: "shortName")
        aCoder.encode(inputs, forKey: "inputs")
        aCoder.encode(outputs, forKey: "outputs")
        aCoder.encode(parameters, forKey: "parameters")
        aCoder.encode(priority, forKey: "priority")
    }
}

extension Study {
    convenience init?(json: [String: Any]) {
        guard let shortName = json["shortName"] as? String,
            let name = json["name"] as? String,
            let priority = json["priority"] as? Int else { return nil }
        
        let inputs = json["inputs"] as? [String : Any] ?? [String : Any]()
        let outputs = json["outputs"] as? [String : Any] ?? [String : Any]()
        let parameters = json["parameters"] as? [String : Any] ?? [String : Any]()
        
        self.init(shortName: shortName, name: name, inputs: inputs, outputs: outputs, parameters: parameters, priority: priority)
    }
}
