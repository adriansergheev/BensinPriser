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

	enum Error: LocalizedError, Identifiable {

		case addressUnreachable(URL)
		case invalidResponse

		var errorDescription: String? {
			switch self {
			case .invalidResponse:
				return "The server responded with garbage."
			case .addressUnreachable(let url):
				return "\(url.absoluteString) is unreachable."
			}
		}

		var id: String { localizedDescription }
	}

	typealias Response = AnyPublisher<[BStation], Error>

	static func getItems() -> Response {

		let url = BPriserBaseURL.url.appendingPathComponent(".json/")
		let apiReqQueue = DispatchQueue(label: "BpriserAPI", qos: .default, attributes: .concurrent)

		return URLSession
			.shared
			.dataTaskPublisher(for: url)
			.subscribe(on: apiReqQueue)
			//			.handleEvents( // side effect
			//				receiveSubscription: { _ in print("Trying ...") }, receiveCompletion: {
			//					guard case .failure(let error) = $0 else { return }
			//					print("Got error: \(error)")
			//			}
			//		)
			.retry(3)
			.timeout(.seconds(10), scheduler: apiReqQueue)
			//			.print("🍎", to: TimeLogger())
			.map(\.data)
			.decode(type: [BStation].self, decoder: JSONDecoder())
			.mapError { error -> BensinPriserAPI.Error in
				switch error {
				case is URLError:
					return Error.addressUnreachable(url)
				default:
					return Error.invalidResponse
				}
		}
		.eraseToAnyPublisher()
	}

}
