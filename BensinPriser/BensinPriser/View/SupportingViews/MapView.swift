/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view that hosts an `MKMapView`.
*/

import SwiftUI
import MapKit

final class MapViewUIKit: MKMapView {

	private var coordinate: CLLocationCoordinate2D

	init(frame: CGRect, coordinate: CLLocationCoordinate2D) {
		self.coordinate = coordinate
		super.init(frame: frame)
		delegate = self
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

extension MapViewUIKit: MKMapViewDelegate {

	func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {

		let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate,
													   addressDictionary: nil))

		//TODO: Inject place's name
		//mapItem.name = ""
		mapItem.openInMaps(launchOptions:
			[MKLaunchOptionsDirectionsModeKey:
				MKLaunchOptionsDirectionsModeDriving])
	}

}

struct MapView: UIViewRepresentable {
	var coordinate: CLLocationCoordinate2D

	func makeUIView(context: Context) -> MKMapView {
		MapViewUIKit(frame: .zero, coordinate: coordinate)
	}

	func updateUIView(_ view: MKMapView, context: Context) {
		let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
		let region = MKCoordinateRegion(center: coordinate, span: span)

		let annotation = MKPointAnnotation()
		annotation.coordinate = coordinate
		annotation.title = "Tap to open in Maps"

		view.setRegion(region, animated: true)
		view.addAnnotation(annotation)
	}
}

struct MapView_Previews: PreviewProvider {
	static var previews: some View {
		MapView(coordinate: BData.mockStations[0].locationCoordinate)
	}
}
