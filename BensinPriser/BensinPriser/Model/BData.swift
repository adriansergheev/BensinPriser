//
//  BData.swift
//  BensinPriser
//
//  Created by Andrian Sergheev on 2020-01-31.
//  Copyright © 2020 Andrian Sergheev. All rights reserved.
//

import Foundation
import CoreLocation

struct BCompany: Codable {
	let companyID: Int
	let companyName: String
	let logoURL: String?
	let companyURL: String?
}

struct BStation: Codable {
	let stationID: Int
	let company: BCompany
	let stationName: String

	let latitude: Double?
	let longitude: Double?

	let prices: [BFuel]

	var distanceFromInMeters: Double?
	var distanceFromInKilometers: Int? {
		return Int(distanceFromInMeters ?? 0) / 1000
	}
}

extension BStation {
	var locationCoordinate: CLLocationCoordinate2D {
		CLLocationCoordinate2D(
			latitude: latitude ?? 0,
			longitude: longitude ?? 0)
	}
}

enum BFuelType: String, Codable, CaseIterable {
	case diesel
	case bensin98
	case bensin95
	case ethanol85
	case gas
}

struct BFuel: Codable {
	let type: BFuelType
	let price: Double
}

enum BPriserSorting {
	case fuel(BFuelType)
	case distance
}

extension BPriserSorting: Equatable { }

extension BPriserSorting: CaseIterable {
	static var allCases: [BPriserSorting] {
		return [
			.distance,
			.fuel(.bensin95),
			.fuel(.bensin98),
			.fuel(.diesel),
			.fuel(.ethanol85),
			.fuel(.gas)
		]
	}
}

extension BPriserSorting: CustomStringConvertible {
	var description: String {
		switch self {
		case .fuel(let type):
			return type.rawValue
		case .distance:
			return "Distance"
		}
	}
}

public struct BData: Codable {

	var stations: [BStation] = []

	static var mockStations: [BStation] {
		let bCompany = BCompany(companyID: 0,
								companyName: names.randomElement() ?? "BensinCompany",
								logoURL: "",
								companyURL: "")

		let bData = (0...15)
			.map { BStation(stationID: $0,
							company: bCompany,
							stationName: names.randomElement() ?? "\($0)",
				latitude: 30.3 + Double($0),
				longitude: 88.5 + Double($0),
				prices:
				[
					BFuel(type: .bensin98, price: 20.1),
					BFuel(type: .bensin95, price: 18.2),
					BFuel(type: .diesel, price: 14.2),
					BFuel(type: .gas, price: 13),
					BFuel(type: .ethanol85, price: 15.3)
				]
				)}
		defer {
			let jsonEncoder = JSONEncoder()
			let jsonData = try! jsonEncoder.encode(bData)
			let json = String(data: jsonData, encoding: String.Encoding.utf8)

			print(json!)
		}
		return bData
	}
}

fileprivate var names: [String] = [
	"American Express",
	"Ascena Retail Group",
	"Icahn Enterprises",
	"Xcel Energy",
	"Northrop Grumman",
	"Cognizant Technology Solutions"
]
