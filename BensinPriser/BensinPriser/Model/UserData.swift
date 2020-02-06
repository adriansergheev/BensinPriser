//
//  UserData.swift
//  BensinPriser
//
//  Created by Andrian Sergheev on 2020-02-06.
//  Copyright © 2020 Andrian Sergheev. All rights reserved.
//

import Foundation

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

final class UserData: ObservableObject {
	@Published
	var sortingBy: BPriserSorting = .fuel(.bensin95)
}
