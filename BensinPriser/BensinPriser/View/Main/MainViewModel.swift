//
//  MainViewModel.swift
//  BensinPriser
//
//  Created by Andrian Sergheev on 2020-02-04.
//  Copyright © 2020 Andrian Sergheev. All rights reserved.
//

import Combine
import Foundation
import CoreLocation

final class MainViewModel: ObservableObject {

	@Published
	var stations: [BStation] = []

	@Published
	var error: BensinPriserAPI.Error?

	@Published
	var userData: UserData

	private var subscriptions = Set<AnyCancellable>()

	init(userData: UserData) {

		self.userData = userData

		let throttledLocation = userData.location2d
			.throttle(for: .seconds(10), scheduler: DispatchQueue.global(qos: .default), latest: true)
			.prepend(nil)

		let sortingBy = userData
			.sortingBy
			.prepend(.fuel(.bensin95))

		BensinPriserAPI
			.getItems()
			.handleEvents( // side effect
				receiveCompletion: { event in
					switch event {
					case .failure(let error):
						DispatchQueue.main.async {
							self.error = error
						}
					default: break
					}
			}
		)
			.replaceError(with: BData.mockStations) // fall to generated data
			.combineLatest(throttledLocation)
			.map(calculateDistance)
			.combineLatest(sortingBy)
			.map(sortFilter)
			//			.print("🎈", to: TimeLogger())
			.receive(on: DispatchQueue.main)
			.assign(to: \.stations, on: self)
			.store(in: &subscriptions)
	}

}

fileprivate func calculateDistance(stations: [BStation], location: CLLocationCoordinate2D?) -> [BStation] {
	guard let location = location else { return stations }

	var localStations: [BStation] = stations

	localStations.mutateEach {
		$0.distanceFromInMeters = CLLocation
			.distance(from: location, to: $0.locationCoordinate)
	}
	return localStations
}

fileprivate func sortFilter(stations: [BStation], sorting by: BPriserSorting) -> [BStation] {

	switch by {
	case .fuel(let type):

		var stationsCopy = stations

		//n^2, but ok for current data size

		stationsCopy.removeAll { stations in
			stations.prices.contains { price in
				price.price == nil && price.type == type
			}
		}

		return stationsCopy.sorted { st1, st2 in
			if let price1 = st1.prices.first(where: {$0.type == type})?.price,
				let price2 = st2.prices.first(where: {$0.type == type})?.price {
				return price1 < price2
			} else {
				return false
			}
		}
	case .distance:
		return stations.sorted {
			$0.distanceFromInMeters ?? 0 < $1.distanceFromInMeters ?? 0
		}
	}
}
