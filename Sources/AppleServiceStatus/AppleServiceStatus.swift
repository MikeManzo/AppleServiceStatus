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
        var endpointURL: URL
        
        switch type {
        case .developer:
            endpointURL = URL(string: "https://www.apple.com/support/systemstatus/data/developer/system_status_en_US.js")!
        case .standard:
            endpointURL = URL(string: "https://www.apple.com/support/systemstatus/data/system_status_en_US.js")!
        }
        
        AF.request(endpointURL, method: .get).responseData { response in
            switch response.result {
            case .success(let value):
                let str0 = String(data: value, encoding: .utf8)
                let str1 = str0?.replacingOccurrences(of: "\"", with: "")
                let str2 = str1?.replacingOccurrences(of: "jsonCallback(", with: "")
                let str3 = str2?.dropLast(2)
                let rootJSON = JSON(String(str3!))
                guard let status = try? SystemStatus(rootJSON.stringValue) else {
                    callback(nil, ServiceError.unknown)
                    return
                }
                callback(status, nil)
            case .failure(let error):
                callback(nil, error)
            }
        }
    }

}
