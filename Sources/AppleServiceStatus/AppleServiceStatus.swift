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
    case badSerialization

    public var description: String {
        switch self {
        case .unknown: return "Unknown error retrieving service status"
        case .badSerialization: return "Unable to serialize JSON from response"
        }
    }
}

public class AppleServiceStatus: NSObject {
        
    ///
    /// Retriieves the service status based on the type requested (See ServiceType)
    /// - Parameters:
    ///   - type: the type of status requested (See ServiceType)
    ///   - callback: the callback function takes two parameters.  A fully formed SystemStatus object if successful; or an erro describing the issue.
    ///               if the call was unsuccessful, ServiceStatus will be bil; likewise if successful, error will be nill
    ///   - status: A fully formed SystemStatus object if successful; error is nil in this case
    ///   - error: A fully formed Error object if unsuccessful; status is nil in this case
    ///
    /// - Reference Material
    ///    - [JSON Serialization Example](https://stackoverflow.com/questions/50365531/serialize-json-string-that-contains-escaped-backslash-and-double-quote-swift-r)
    ///    - [English Dev Sample](https://www.apple.com/support/systemstatus/data/developer/system_status_en_US.js)
    ///    - [English System Sample](https://www.apple.com/support/systemstatus/data/system_status_en_US.js)
    ///
    public func getStatus(type: ServiceType, _ callback: @escaping (_ status: SystemStatus?, _ error: Error?) -> Void) {
        var endpointURL: URL
        
        switch type {
        case .developer:
            endpointURL = URL(string: "https://www.apple.com/support/systemstatus/data/developer/system_status_en_US.js")!
        case .standard:
            endpointURL = URL(string: "https://www.apple.com/support/systemstatus/data/system_status_en_US.js")!
        }
        
        /// Not above that these are not JSON endpoints; however there is JSOn embedded in the javascript return
        /// Assuming success, we need to untangle the response and remove the non-JSON elements so we can take advantage
        /// of auto-populating the object.  It's not ideal since Apple does not provide an end-point.  But we can manage.
        AF.request(endpointURL, method: .get).responseData { response in
            switch response.result {
            case .success(let value):   // Alamofire has succeeded; proceed
                let str0 = String(data: value, encoding: .utf8)
                let str1 = str0?.replacingOccurrences(of: "\\", with: "")               // De-Escape the return string
                let str2 = str1?.replacingOccurrences(of: "jsonCallback(", with: "")    // Remove the leading js return info
                let str3 = str2?.replacingOccurrences(of: ");", with: "")               // Remove the trailing js return info
                
                if let jsonResponse  = try? JSONSerialization.jsonObject(with: str3!.data(using: .utf8)!, options: .mutableLeaves) {
                    do {
                        let rootJSON = JSON(jsonResponse)
                        callback(try SystemStatus(data: rootJSON.rawData()), nil)   // If we made it here ... we're likely going to be successful
                        //                        callback(try SystemStatus(String(rootJSON.description.filter { !" \n\t\r".contains($0) })), nil)   // If we made it here ... we're likely going to be successful
                    }
                    catch let DecodingError.dataCorrupted(context) {
                        print(context)
                        callback (nil, DecodingError.dataCorrupted(context))
                    } catch let DecodingError.keyNotFound(key, context) {
                        print("Key '\(key)' not found:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                        callback (nil, DecodingError.keyNotFound(key, context))
                    } catch let DecodingError.valueNotFound(value, context) {
                        print("Value '\(value)' not found:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                        callback (nil, DecodingError.valueNotFound(value, context))
                    } catch let DecodingError.typeMismatch(type, context)  {
                        print("Type '\(type)' mismatch:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                        callback (nil, DecodingError.typeMismatch(type, context))
                    } catch {
                        print("Error: ", error)
                    }
/*                   catch { // Unsuccessful in crearting our SystemStatus object; let the user know why
                        callback (nil, error)
                     }
*/
                } else { // Unsuccessful in serializing the JSON Response; let the user know why
                    callback(nil, ServiceError.badSerialization)
                }
            case .failure(let error):   // Alamofire has failed; let the user know why
                callback(nil, error)
            }
        }
    }
}
