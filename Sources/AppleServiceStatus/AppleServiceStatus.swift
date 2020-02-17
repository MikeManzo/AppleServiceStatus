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
/*                guard let status = try? SystemStatus(rootJSON.stringValue) else {
                    callback(nil, ServiceError.unknown)
                    return
                }
                callback(status, nil)
                 */
                let test = #"{"drpost":false,"drMessage":null,"services":[{"serviceName":"Account","redirectUrl":"https://developer.apple.com/account/","events":[]},{"serviceName":"APNS","redirectUrl":"https://developer.apple.com/notifications/","events":[]},{"serviceName":"APNS Sandbox","redirectUrl":"https://developer.apple.com/notifications/","events":[]},{"serviceName":"App Store Connect","redirectUrl":"https://appstoreconnect.apple.com/","events":[]},{"serviceName":"App Store Connect API","redirectUrl":"https://developer.apple.com/app-store-connect/api/","events":[]},{"serviceName":"Apple Developer Forums","redirectUrl":"https://forums.developer.apple.com","events":[]},{"serviceName":"Apple Music API","redirectUrl":"https://developer.apple.com/musickit/","events":[]},{"serviceName":"Apple News API","redirectUrl":null,"events":[]},{"serviceName":"Apple Pay","redirectUrl":"https://developer.apple.com/apple-pay/","events":[]},{"serviceName":"Feedback Assistant","redirectUrl":"https://bugreport.apple.com/","events":[]},{"serviceName":"Certificates, Identifiers & Profiles","redirectUrl":"https://developer.apple.com/account/","events":[]},{"serviceName":"CloudKit Dashboard","redirectUrl":"https://icloud.developer.apple.com/dashboard","events":[]},{"serviceName":"Code-level Support","redirectUrl":"https://developer.apple.com/account/?view=support","events":[]},{"serviceName":"Contact Us","redirectUrl":"https://developer.apple.com/contact/","events":[]},{"serviceName":"Developer Documentation","redirectUrl":"https://developer.apple.com/reference","events":[]},{"serviceName":"Developer ID Notary Service","redirectUrl":null,"events":[]},{"serviceName":"Device Check","redirectUrl":"https://developer.apple.com/documentation/devicecheck","events":[]},{"serviceName":"Enterprise App Verification","redirectUrl":"https://support.apple.com/en-us/HT204460","events":[]},{"serviceName":"In-App Purchases","redirectUrl":null,"events":[]},{"serviceName":"iTunes Sandbox","redirectUrl":null,"events":[]},{"serviceName":"MapKit JS Dashboard","redirectUrl":"https://maps.developer.apple.com","events":[]},{"serviceName":"News Publisher","redirectUrl":"https://developer.apple.com/news-publisher/","events":[]},{"serviceName":"Program Enrollment and Renewals","redirectUrl":"https://developer.apple.com/enroll/","events":[]},{"serviceName":"Software Downloads","redirectUrl":"https://developer.apple.com/download/","events":[]},{"serviceName":"TestFlight","redirectUrl":"https://developer.apple.com/testflight/","events":[{"startDate":"02/10/2020 11:45 PST","endDate":"02/12/2020 03:00 PST","affectedServices":null,"eventStatus":"resolved","usersAffected":"Some users were affected","epochStartDate":1581363900000,"epochEndDate":1581505200000,"messageId":"1003214","statusType":"Issue","datePosted":"02/15/2020 01:00 PST","message":"Users experienced a problem with this service."}]},{"serviceName":"Videos","redirectUrl":"https://developer.apple.com/videos/","events":[]},{"serviceName":"Xcode Automatic Configuration","redirectUrl":"https://developer.apple.com/xcode/","events":[]}]}"#
                
                do {
                    let status = try SystemStatus(test)
                    callback(status, nil)
                } catch {
                    callback (nil, error)
                }
            case .failure(let error):
                callback(nil, error)
            }
        }
    }

}
