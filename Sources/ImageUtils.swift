
import CoreGraphics
import AppKit

public func roundCornerImageWithOffset(
	with image: Image,
	// target image's size.
	size: CGSize,
	offset: CGPoint,
	bgColor: NSColor? = nil) -> Image? {
	// original image size.
	let oldSize = CGSize(width: image.size.width, height: image.size.height)
	// target image.
	let drawImage: Image = Image(size: size)

	// set graphic context to image.
	drawImage.lockFocus()

	let imageFrame = CGRect(x: 0,
		y: 0,
		width: size.width,
		height: size.height)
	let context = NSGraphicsContext.current()
	context?.imageInterpolation = .high

	let cgContext = context?.cgContext
	// Add background color.
	if bgColor != nil {
		cgContext?.setFillColor(bgColor!.cgColor)
		cgContext?.fill(imageFrame)
	}

	let scale = NSScreen.main()!.backingScaleFactor

	// Create a clip path and add it to the graphic context.
	// the clip's size must be small than the target image's size,
	// otherwise the clip will has no effect.
	// create a rounded clip path.
	let clipPath = NSBezierPath(roundedRect: imageFrame, xRadius: size.width / 2, yRadius: size.height / 2)
	clipPath.windingRule = .evenOddWindingRule
	// add the path to clip region.
	clipPath.addClip()

	// set scale factor to `scale`,
	// so anything draw will be scaled by this factor.
	cgContext?.scaleBy(x: scale, y: scale)

	// draw origin image portion content to current context.
	// image.draw(at: .zero,
	// 	// from the center of original image.
	// 	from: CGRect(x: oldSize.width / 2 - size.width / 2,
	// 		y: oldSize.height / 2 - size.height / 2,
	// 		width: size.width / 2,
	// 		height: size.height / 2),
	// 	operation: .sourceOver,
	// 	fraction: 1)

	image.draw(in: CGRect(
		x: 0,
		y: 0,
		width: oldSize.width / scale,
		height: oldSize.height / scale
	))

	drawImage.unlockFocus()

	return drawImage
}


public func saveAsJepgWithName(name: String, source: Image?) -> Bool {
	guard let source = source else {
		return false
	}

	if let bitmapRepresentation = representation(forType: NSJPEGFileType, with: source) {
		do {
			try bitmapRepresentation.write(to: URL(fileURLWithPath: name), options: .atomicWrite)
		} catch let error as NSError {
			print(error)
			return false
		}
	} else {
		return false
	}

	return true
}

func representation(forType type: NSBitmapImageFileType, with image: Image) -> Data? {
	if let tiff = image.tiffRepresentation, let tiffData = NSBitmapImageRep(data: tiff) {
		return tiffData.representation(using: type, properties: [:])
	}

	return nil
}
