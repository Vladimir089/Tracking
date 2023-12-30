//
//  API.swift
//  TrackingCode
//
//  Created by Владимир on 18.12.2023.
//

import Foundation


protocol StringOrInt: Codable {}

extension String: StringOrInt {}
extension Int: StringOrInt {}

struct StringOrIntWrapper: Codable {
    let value: StringOrInt

    init(_ value: StringOrInt) {
        self.value = value
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        do {
            self.value = try container.decode(String.self)
        } catch DecodingError.typeMismatch {
            // If decoding as String fails, attempt decoding as Int
            self.value = try container.decode(Int.self)
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch value {
        case let stringValue as String:
            try container.encode(stringValue)
        case let intValue as Int:
            try container.encode(intValue)
        default:
            throw EncodingError.invalidValue(
                value,
                EncodingError.Context(
                    codingPath: encoder.codingPath,
                    debugDescription: "Invalid type for StringOrInt"
                )
            )
        }
    }
}



var mainArray = [[String]]()

struct Tracker: Codable {
    let status: String?
    let data: DataClass
    let services: [String]?
    let deliveredStat: JSONNull?
    let id: StringOrIntWrapper?
    let rpm: Int?
    let limits: Limits?
    let totalTime: Double?
    
    
}

// MARK: - DataClass
struct DataClass: Codable {
    let trackCode, trackCreationDateTime, trackUpdateDateTime: String
    let trackUpdateDiffMinutes: Int
    let trackAwaitingDateTime, trackDeliveredDateTime, fromCountryCode, fromCountry: String
    let destinationCountryCode, destinationCountry, fromName, destinationName: String
    let fromCity, destinationCity, fromAddress, destinationAddress: String
    let destinationPostalCode, collectOnDeliveryPrice, declaredValue, trackCodeModified: String
    let deliveredStatus, awaitingStatus: String
    let awaiting: Bool
    let events: [Event]
    let shippers: [String]
    let itemWeight: StringOrIntWrapper
    
    
    let trackFirstOperationDateTime: String
    let daysInTransit, daysTracking: Int
    let groupedCompanyNames: [String]
    
    let lastPoint: LastPoint
    let allWayTracking, upu: Bool
}

// MARK: - Event
struct Event: Codable {
    let id, operationDateTime: StringOrIntWrapper
    let eventDateTime: String?
    let operationAttribute: String?
    let operationType: String
    let operationPlacePostalCode, operationPlaceName, itemWeight: StringOrIntWrapper?
    let source, serviceName: String
    let serviceAllWayTracking: Bool?
    let operationAttributeInformation: String?
    let operationAttributeOriginal, operationTypeOriginal, operationPlaceNameOriginal: String?
    let operationAttributeTranslated, operationTypeTranslated: String
    let operationPlaceNameTranslated, icon: String?
}

// MARK: - LastPoint

struct LastPoint: Codable {
    let id, eventDateTime, operationDateTime: StringOrIntWrapper?
    let operationAttribute: StringOrIntWrapper
    let operationAttributeTranslated, operationType, operationTypeTranslated, source: String?
    let serviceName: String?
}




// MARK: - Limits
struct Limits: Codable {
    let full: Bool
    let updatesPeriod, minute, day, month: Int
}



class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
