//
//  Event.swift
//  Event
//
//  Created by Mike Manzo on 02/02/20.
//  Copyright © 2020 Mike Manzo. All rights reserved.
//
//  Usage: let event = try Event(json)

import Foundation

// MARK: - Event
class Event: Codable {
    let usersAffected: String?
    let epochStartDate, epochEndDate: Int?
    let messageID, statusType, datePosted, startDate: String?
    let endDate: String?
    let affectedServices: [String]?
    let eventStatus, message: String?

    enum CodingKeys: String, CodingKey {
        case usersAffected, epochStartDate, epochEndDate
        case messageID = "messageId"
        case statusType, datePosted, startDate, endDate, affectedServices, eventStatus, message
    }

    init(usersAffected: String?, epochStartDate: Int?, epochEndDate: Int?, messageID: String?, statusType: String?, datePosted: String?, startDate: String?, endDate: String?, affectedServices: [String]?, eventStatus: String?, message: String?) {
        self.usersAffected = usersAffected
        self.epochStartDate = epochStartDate
        self.epochEndDate = epochEndDate
        self.messageID = messageID
        self.statusType = statusType
        self.datePosted = datePosted
        self.startDate = startDate
        self.endDate = endDate
        self.affectedServices = affectedServices
        self.eventStatus = eventStatus
        self.message = message
    }
}

// MARK: Event convenience initializers and mutators

extension Event {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Event.self, from: data)
        self.init(usersAffected: me.usersAffected, epochStartDate: me.epochStartDate, epochEndDate: me.epochEndDate, messageID: me.messageID, statusType: me.statusType, datePosted: me.datePosted, startDate: me.startDate, endDate: me.endDate, affectedServices: me.affectedServices, eventStatus: me.eventStatus, message: me.message)
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
        usersAffected: String?? = nil,
        epochStartDate: Int?? = nil,
        epochEndDate: Int?? = nil,
        messageID: String?? = nil,
        statusType: String?? = nil,
        datePosted: String?? = nil,
        startDate: String?? = nil,
        endDate: String?? = nil,
        affectedServices: [String]?? = nil,
        eventStatus: String?? = nil,
        message: String?? = nil
    ) -> Event {
        return Event(
            usersAffected: usersAffected ?? self.usersAffected,
            epochStartDate: epochStartDate ?? self.epochStartDate,
            epochEndDate: epochEndDate ?? self.epochEndDate,
            messageID: messageID ?? self.messageID,
            statusType: statusType ?? self.statusType,
            datePosted: datePosted ?? self.datePosted,
            startDate: startDate ?? self.startDate,
            endDate: endDate ?? self.endDate,
            affectedServices: affectedServices ?? self.affectedServices,
            eventStatus: eventStatus ?? self.eventStatus,
            message: message ?? self.message
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
