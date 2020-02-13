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
	
	var body: some View {
		VStack(alignment: .leading) {

			MapView(placemarkName: station.stationName,
					coordinate: station.locationCoordinate)
				.edgesIgnoringSafeArea(.top)
				.frame(height: screenHeight / 3)

			RemoteImage(imageURL: station.company.logoURL)
				.frame(width: 100, height: 100, alignment: .center)
				.clipShape(Circle())
				.overlay(Circle().stroke(Color.white, lineWidth: 4))
				.shadow(radius: 10)
				.offset(x: 10, y: -70)
				.padding(.bottom, -130)

			VStack(alignment: .leading) {
				HStack {
					Text(station.stationName)
						.font(.title)
						.lineLimit(1)
				}
				HStack(alignment: .top) {
					Text(station.company.companyName)
						.font(.subheadline)
						.lineLimit(1)
				}
				List(station.prices, id: \.price) { stationPrice in
					HStack(alignment: .firstTextBaseline) {
						if stationPrice.price != nil {
							Text("\(stationPrice.type.rawValue.capitalized)")
							Spacer()
							Text("\(String(format: "%.2f", stationPrice.price!)) SEK")
						}
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
		DetailView(station: BData.mockStations[0])
	}
}
