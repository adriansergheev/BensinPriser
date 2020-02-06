//
//  Bapi.swift
//  BensinPriser
//
//  Created by Andrian Sergheev on 2020-02-04.
//  Copyright © 2020 Andrian Sergheev. All rights reserved.
//

import Foundation
import Combine

enum BensinPriserAPI {

	typealias Response = AnyPublisher<[BStation], Error>

	static func getItems() -> Response {

		let url = BPriserBaseURL.url.appendingPathComponent(".json/")

		return URLSession
			.shared
			.dataTaskPublisher(for: url)
			.print()
			.map(\.data)
			.decode(type: [BStation].self, decoder: JSONDecoder())
			.eraseToAnyPublisher()
	}

}
