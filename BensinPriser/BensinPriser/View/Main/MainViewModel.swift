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
	var userData: UserData

	private var subscriptions = Set<AnyCancellable>()

	init(userData: UserData) {

		self.userData = userData

		let throttledLocation = userData.location2d
			.throttle(for: .seconds(10), scheduler: DispatchQueue.main, latest: true)
			.prepend(nil)

		let sortingBy = userData
			.sortingBy
			.prepend(.fuel(.bensin95))

		BensinPriserAPI
			.getItems()
			.receive(on: DispatchQueue.main)
			.retry(3)
			.replaceError(with: [])
			.combineLatest(throttledLocation)
			.map(calculateDistance)
			.replaceNil(with: [])
			.combineLatest(sortingBy)
			.map(sortStations)
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

fileprivate func sortStations(stations: [BStation], sorting by: BPriserSorting) -> [BStation] {
	switch by {
	case .fuel(let type):
		return stations.sorted { st1, st2 in

			if let price1 = st1.prices.first(where: {$0.type == type})?.price,
				let price2 = st2.prices.first(where: {$0.type == type})?.price {
				return price1 < price2
			} else {
				#if DEBUG
				fatalError()
				#endif
				return false
			}

		}
	case .distance:
		return stations.sorted {
			$0.distanceFromInMeters ?? 0 < $1.distanceFromInMeters ?? 0
		}
	}
}
