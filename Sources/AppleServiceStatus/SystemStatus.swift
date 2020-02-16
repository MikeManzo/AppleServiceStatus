//
//  SystemStatus.swift
//  SystemStatus
//
//  Created by Mike Manzo on 02/02/20.
//  Copyright © 2020 Mike Manzo. All rights reserved.
//
//   Usage: let SystemStatus = try SystemStatus(json)

import Foundation

// MARK: - SystemStatus
public class SystemStatus: Codable {
    let drpost: Bool?
    let drMessage: JSONNull?
    let services: [Service]?

    init(drpost: Bool?, drMessage: JSONNull?, services: [Service]?) {
        self.drpost = drpost
        self.drMessage = drMessage
        self.services = services
    }
}

// MARK: SystemStatus convenience initializers and mutators

extension SystemStatus {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(SystemStatus.self, from: data)
        self.init(drpost: me.drpost, drMessage: me.drMessage, services: me.services)
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
        drpost: Bool?? = nil,
        drMessage: JSONNull?? = nil,
        services: [Service]?? = nil
    ) -> SystemStatus {
        return SystemStatus(
            drpost: drpost ?? self.drpost,
            drMessage: drMessage ?? self.drMessage,
            services: services ?? self.services
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
