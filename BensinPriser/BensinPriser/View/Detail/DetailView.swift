//
//  DetailView.swift
//  BensinPriser
//
//  Created by Andrian Sergheev on 2020-02-05.
//  Copyright © 2020 Andrian Sergheev. All rights reserved.
//

import SwiftUI

struct DetailView: View {
	
	var station: BStation
	var stationImage: Image?
	
	var body: some View {
		VStack {
			MapView(coordinate: station.locationCoordinate)
				.edgesIgnoringSafeArea(.top)
				.frame(height: 300)
//
//			CircleImage(image: stationImage ?? Image(systemName: "car.fill"))
//				.offset(x: 0, y: -130)
//				.padding(.bottom, -130)

			VStack(alignment: .leading) {
				HStack {
					Text(station.stationName)
						.font(.title)
				}
				HStack(alignment: .top) {
					Text(station.company.companyName)
						.font(.subheadline)
				}
				List(station.prices, id: \.price) { price in
					HStack(alignment: .firstTextBaseline) {
						Text("\(price.type.rawValue)")
						Spacer()
						Text("\(String(format: "%.2f", price.price)) SEK")
					}
				}
			}
			.padding()

			Spacer()
		}
	}
}

struct DetailView_Previews: PreviewProvider {
	static var previews: some View {
		DetailView(station: BData.mockStations[0], stationImage: nil)
	}
}
