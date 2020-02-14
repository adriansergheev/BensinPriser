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
					NavigationLink(destination: DetailView(station: station)) {

						HStack {
							RemoteImage(imageURL: station.company.logoURL)
								.frame(width: 50, height: 50, alignment: .center)

							Text("\(station.stationName)")
								.minimumScaleFactor(0.7)

							Spacer()
							Divider()

							VStack(alignment: .leading) {
								//should be prettier ;(
								if !(self.viewModel.userData.sortingBy.value == .distance) {
									if doubleInCell(sorting: self.viewModel.userData.sortingBy.value, station: station) != nil {
										Text("Price: \(String(format: "%.2f", doubleInCell(sorting: self.viewModel.userData.sortingBy.value, station: station)!)) SEK")
									}
								}

								Text("Distance: \(station.distanceFromInKilometers ?? 0) km")
									.foregroundColor(
										((station.distanceFromInKilometers ?? 50) >= 50) ? .red : .green
								)
									.minimumScaleFactor(0.7)

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
		.alert(item: self.$viewModel.error) { error in
			Alert(
				title: Text("Network error, using generated data"),
				message: Text(error.localizedDescription),
				dismissButton: .cancel()
			)
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		MainView(viewModel: MainViewModel(userData: UserData()))
	}
}

/// should be cached and implemented in a faster way, though ok for the current data size.
fileprivate func doubleInCell(sorting by: BPriserSorting, station: BStation) -> Double? {
	switch by {
	case .distance:
		return nil
	case .fuel(let type):
		return station
			.prices
			.filter { $0.type == type }
			.map { $0.price }
			.first ?? nil
	}
}
