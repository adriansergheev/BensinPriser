//
//  ContentView.swift
//  BensinPriser
//
//  Created by Andrian Sergheev on 2020-01-31.
//  Copyright © 2020 Andrian Sergheev. All rights reserved.
//

import SwiftUI

struct MainView: View {

	@ObservedObject
	private(set) var viewModel: MainViewModel

	@State
	private var showingActionSheet = false

	var filterButton: some View {
		Button(action: { self.showingActionSheet = true }) {
			Image(systemName: "line.horizontal.3.decrease.circle")
				.imageScale(.large)
				.accessibility(label: Text("Filter Prices"))
				.padding()
		}
		.actionSheet(isPresented: $showingActionSheet) {
			ActionSheet(
				title: Text("Filter by"),
				buttons: BPriserSorting.allCases.map { sortChoice in
					.default(Text("\(sortChoice.description.capitalized)"),
							 action: { self.viewModel.userData.sortingBy.send(sortChoice)})
				}
			)
		}
	}

	var body: some View {
		NavigationView {
			VStack {
				List(viewModel.stations, id: \.stationID) { station in
					NavigationLink(destination: DetailView(station: station, stationImage: nil)) {

						HStack {
							RemoteImage(imageURL: station.company.logoURL)
								.frame(width: 50, height: 50, alignment: .center)

							Text("\(station.stationName)")
								.minimumScaleFactor(0.7)

							Spacer()
							Divider()

							VStack(alignment: .leading) {
								if !(self.viewModel.userData.sortingBy.value == .distance) {
									Text("Price: \(String(format: "%.2f", doubleInCell(sorting: self.viewModel.userData.sortingBy.value, station: station) ?? 0)) SEK")
								}

								if station.distanceFromInKilometers ?? 50 >= 50 {

									Text("Distance: \(station.distanceFromInKilometers ?? 0) km")
										.foregroundColor(.red)
								} else {
									Text("Distance: \(station.distanceFromInKilometers ?? 0) km")
										.foregroundColor(.green)
								}

							}
							.frame(width: screenWidth / 3, alignment: .leading)
							.minimumScaleFactor(0.7)
							.animation(.easeIn)
						}
					}
				}
			}
			.navigationBarTitle(
				Text("BensinPriser Skåne")
			)
				.navigationBarItems(trailing: filterButton)
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		MainView(viewModel: MainViewModel(userData: UserData()))
	}
}

/// probably should be cached and implemented in a faster way, though ok for the current data size.
fileprivate func doubleInCell(sorting by: BPriserSorting, station: BStation) -> Double? {
	switch by {
	case .distance:
		return nil
	case .fuel(let type):
		return station
			.prices
			.filter { $0.type == type }
			.map { $0.price }
			.first
	}
}
