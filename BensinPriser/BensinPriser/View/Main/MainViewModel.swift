//
//  MainViewModel.swift
//  BensinPriser
//
//  Created by Andrian Sergheev on 2020-02-04.
//  Copyright © 2020 Andrian Sergheev. All rights reserved.
//

import Combine
import Foundation

final class MainViewModel: ObservableObject {

	@Published var stations: [BStation] = []

	@Published private var cancellable: Cancellable?

	init() {
		let assign = Subscribers.Assign(object: self, keyPath: \.stations)
		cancellable = assign

		BensinPriserAPI
			.getItems()
			.receive(on: DispatchQueue.main)
			.replaceError(with: [])
			.receive(subscriber: assign)
	}

}
