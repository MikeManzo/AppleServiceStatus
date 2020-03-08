//
//  Service.swift
//  Service
//
//  Created by Mike Manzo on 02/02/20.
//  Copyright © 2020 Mike Manzo. All rights reserved.
//
//   Usage: let service = try Service(json)

import Foundation

// MARK: - Service
public class Service: Codable {
    public let serviceName: String?
    public let redirectURL: String?
    public let events: [Event]?

    enum CodingKeys: String, CodingKey {
        case serviceName
        case redirectURL = "redirectUrl"
        case events
    }

    init(serviceName: String?, redirectURL: String?, events: [Event]?) {
        self.serviceName = serviceName
        self.redirectURL = redirectURL
        self.events = events
    }
}

// MARK: Service convenience initializers and mutators

extension Service {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Service.self, from: data)
        self.init(serviceName: me.serviceName, redirectURL: me.redirectURL, events: me.events)
    }

    convenience init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    convenience init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        serviceName: String?? = nil,
        redirectURL: String?? = nil,
        events: [Event]?? = nil
    ) -> Service {
        return Service(
            serviceName: serviceName ?? self.serviceName,
            redirectURL: redirectURL ?? self.redirectURL,
            events: events ?? self.events
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
