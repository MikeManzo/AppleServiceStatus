//
//  AppleServiceStatus.swift
//  AppleServiceStatus
//
//  Created by Mike Manzo on 02/02/20.
//  Copyright © 2020 Mike Manzo. All rights reserved.
//

import Alamofire
import Foundation
import SwiftyJSON

public enum ServiceType {
    case developer
    case standard
}

public enum ServiceError: Error, CustomStringConvertible {
    case unknown

    public var description: String {
        switch self {
        case .unknown: return "Unknown error retrieving service status"
        }
    }
}

public class AppleServiceStatus: NSObject {
//    var system: [SystemStatus]?
    
    override public init() {
//        fatalError("init() is not support.  Please check documentation.")
    }
    
    public func getStatus(type: ServiceType, _ callback: @escaping (_ status: SystemStatus?, _ error: Error?) -> Void) {
        var endpointURL: String
        
        switch type {
        case .developer:
            endpointURL = "https://www.apple.com/support/systemstatus/data/developer/system_status_en_US.js"
        case .standard:
            endpointURL = "https://www.apple.com/support/systemstatus/data/system_status_en_US.js"
        }
        AF.request(endpointURL, method: .get).response { response in
            switch response.result {
            case .success(let value):
                let rootJSON = JSON(value)
                let str = String(data: value!, encoding: .utf8)
//                callback(rootJSON.arrayValue.compactMap { try? SystemStatus($0.description) }, nil)
//                var parsed = rootJSON.description.replacingOccurrences(of: "jsonCallback(", with: "")
//                let parsed2 = parsed. description.removeLast(2)
                callback(try? SystemStatus(rootJSON.stringValue), nil)
            case .failure(let error):
                callback(nil, error)
            }
        }
    }
}
