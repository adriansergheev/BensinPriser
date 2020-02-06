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

	@EnvironmentObject
	private var userData: UserData

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
							 action: { self.userData.sortingBy = sortChoice})
				}
			)
		}
	}

	var body: some View {
		NavigationView {
			VStack {
				List(sortStations(sorting: userData.sortingBy,
								  stations: viewModel.stations), id: \.stationID) { station in
									NavigationLink(destination: DetailView(station: station,
																		   stationImage: nil)) {
																			StationCell(station: station)
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
		MainView(viewModel: MainViewModel())
	}
}

struct StationCell: View {
	@EnvironmentObject
	private var userData: UserData

	var station: BStation

	var body: some View {
		HStack {
			RemoteImage(imageURL: station.company.logoURL)
				.frame(width: 50, height: 50, alignment: .center)
			
			Text("\(station.stationName)")
				.minimumScaleFactor(0.7)

			Spacer()
			Divider()
			
			VStack(alignment: .leading) {

				if !(userData.sortingBy == .distance) {
					Text("Price: \(String(format: "%.2f", doubleInCell(sorting: userData.sortingBy, station: station) ?? 0)) SEK")
				}

				//TODO: Compute distance
				Text("Distance: 3km")
			}
			.minimumScaleFactor(0.7)
			.animation(.easeIn)
		}
	}
}

///probably should be cached and implemented in a faster way, though ok for the current data size.
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

fileprivate func sortStations(sorting by: BPriserSorting, stations: [BStation]) -> [BStation] {
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
		//TODO: Compute distance function, should be a lazy var for current station
		return stations
	}
}
