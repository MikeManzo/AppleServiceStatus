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

enum ServiceType {
    case developer
    case standard
}

public class AppleServiceStatus: NSObject {
    var system: [SystemStatus]?
    
    override init() {
        fatalError("init() is not support.  Please check documentation.")
    }
    
    init (type: ServiceType) {
        var endpointURL: String
        super.init()
        
        switch type {
        case .developer:
            endpointURL = "https://www.apple.com/support/systemstatus/data/developer/system_status_en_US.js"
        case .standard:
            endpointURL = "https://www.apple.com/support/systemstatus/data/system_status_en_US.js"
        }
        AF.request(endpointURL, method: .get).validate().responseJSON { [unowned self] response in
            switch response.result {
            case .success(let value):
                let rootJSON = JSON(value)
                self.system = rootJSON.arrayValue.compactMap { try? SystemStatus($0.description) }
            case .failure(let error):
                print(error)
            }
        }
    }
}
