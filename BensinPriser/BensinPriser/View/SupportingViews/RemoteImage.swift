import Nuke
import SwiftUI

struct RemoteImage: View {

	var imageURL: String?
	var transition: AnyTransition = .opacity
	@State private var uiImage: UIImage?

	var body: some View {
		ZStack {
			uiImage.map { uiImage in
				Image(uiImage: uiImage)
					.resizable()
					.transition(transition)
			}
		}.onAppear {
			if let stringURL = self.imageURL, let imageURL = URL(string: stringURL) {
				ImagePipeline.shared.loadImage(with: imageURL) { result in
					switch result {
					case .success(let response):
						self.uiImage = response.image
					case .failure(let error):
						#if DEBUG
						print("Error loading image: \(error)")
						#endif
						self.uiImage = UIImage(named: "defaultLogo")
					}
				}
			} else {
				self.uiImage =  UIImage(named: "defaultLogo")
			}
		}
	}
}

struct CircleImage_Previews: PreviewProvider {
	static var previews: some View {
		RemoteImage(imageURL: nil)
	}
}
