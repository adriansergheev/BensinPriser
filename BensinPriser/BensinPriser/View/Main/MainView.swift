//
//  ContentView.swift
//  BensinPriser
//
//  Created by Andrian Sergheev on 2020-01-31.
//  Copyright © 2020 Andrian Sergheev. All rights reserved.
//

import SwiftUI

fileprivate var colors: [Color] = [.red, .blue, .yellow]

struct MainView: View {

	@ObservedObject
	private(set) var viewModel: MainViewModel

	var filterButton: some View {
		Button(action: { print("Tapped") }) {
			Image(systemName: "line.horizontal.3.decrease.circle")
				.imageScale(.large)
				.accessibility(label: Text("Filter Prices"))
				.padding()
		}
	}

	var body: some View {
		NavigationView {
			VStack {
				List(viewModel.stations, id: \.stationID) { station in
					NavigationLink(destination: DetailView(station: station,
														   stationImage: nil)) {
															StationCell(station: station)
					}
				}
			}
			.navigationBarTitle(
				Text("BensinPriser")
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
	var station: BStation
	var body: some View {
		HStack {
			Image(systemName: "car.fill")
				.resizable()
				.frame(width: 50, height: 50, alignment: .center)
				.foregroundColor(colors.randomElement())
				.cornerRadius(5)
			
			Text("\(station.stationName)")
				.minimumScaleFactor(0.7)
			Spacer()
			Divider()
			
			VStack(alignment: .leading) {
				Text("Price: \(String(format: "%.2f", station.prices.first?.price ?? 0)) SEK")
				Text("Distance: 3km")
			}
			.minimumScaleFactor(0.7)
			//						.frame(width: 130)
		}
	}
}
