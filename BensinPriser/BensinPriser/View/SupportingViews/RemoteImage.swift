/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view that clips an image to a circle and adds a stroke and shadow.
*/

import Nuke
import SwiftUI

struct RemoteImage: View {

	var imageURL: String?
	var transition: AnyTransition = .opacity
	@State private var uiImage: UIImage?

	var body: some View {
		ZStack {
			//TODO: Add mock logo in case of no internet connection
			uiImage.map { uiImage in
				Image(uiImage: uiImage)
					.resizable()
					.transition(transition)
			}
		}.onAppear {
			if let stringURL = self.imageURL, let imageURL = URL(string: stringURL) {
				ImagePipeline.shared.loadImage(with: imageURL) { result in
					switch result {
					case .success(let response): self.uiImage = response.image
					case .failure(let error): print(error)
					}
				}
			} else {
				self.uiImage = UIImage(systemName: "car.fill")
			}
		}
	}
}

struct CircleImage_Previews: PreviewProvider {
	static var previews: some View {
		RemoteImage(imageURL: nil)
	}
}
