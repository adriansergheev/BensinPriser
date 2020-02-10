//
//  UserData.swift
//  BensinPriser
//
//  Created by Andrian Sergheev on 2020-02-06.
//  Copyright © 2020 Andrian Sergheev. All rights reserved.
//

import Foundation
import Combine
import CoreLocation

final class UserData: NSObject, ObservableObject {

	// settings
	var sortingBy: CurrentValueSubject<BPriserSorting, Never> = CurrentValueSubject(.fuel(.bensin95))

	// location
	var location2d = PassthroughSubject<CLLocationCoordinate2D?, Never>()

	private let locationManager = CLLocationManager()

	override init() {
		super.init()
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
		locationManager.requestWhenInUseAuthorization()
		locationManager.startUpdatingLocation()
	}
}

extension UserData: CLLocationManagerDelegate {

	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		location2d.send(locations.first?.coordinate)

		#if DEBUG
//		print("🎁 Location: \(locations)")
		#endif
	}

	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		#if DEBUG
		print("Error while updating location " + error.localizedDescription)
		#endif
	}

}
