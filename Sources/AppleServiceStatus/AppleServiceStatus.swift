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
        URLSession.shared.dataTask(with: endpointURL) { data, response, error in
            print(data as Any)
        }.resume()
        
/*        AF.request(endpointURL, method: .get).responseString { response in
            switch response.result {
            case .success(let value):
                let rootJSON = JSON(value)
//                callback(rootJSON.arrayValue.compactMap { try? SystemStatus($0.description) }, nil)
                let parsed = rootJSON.stringValue.replacingOccurrences(of: "jsonCallback(", with: "")
                let parsed2 = parsed.dropLast(2)
                callback(try? SystemStatus(String(parsed2)), nil)
            case .failure(let error):
                callback(nil, error)
            }
        }
*/
    }

}
