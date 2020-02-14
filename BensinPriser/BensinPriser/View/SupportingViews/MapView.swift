import SwiftUI
import MapKit

final class MapViewUIKit: MKMapView {

	var placemarkName: String
	private var coordinate: CLLocationCoordinate2D

	init(frame: CGRect, coordinate: CLLocationCoordinate2D, placemarkName: String) {
		self.coordinate = coordinate
		self.placemarkName = placemarkName
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

		mapItem.name = placemarkName
		mapItem.openInMaps(launchOptions:
			[MKLaunchOptionsDirectionsModeKey:
				MKLaunchOptionsDirectionsModeDriving])
	}

}

struct MapView: UIViewRepresentable {

	var placemarkName: String
	var coordinate: CLLocationCoordinate2D

	func makeUIView(context: Context) -> MKMapView {
		MapViewUIKit(frame: .zero, coordinate: coordinate, placemarkName: placemarkName)
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
		MapView(placemarkName: "Test", coordinate: BData.mockStations[0].locationCoordinate)
	}
}
