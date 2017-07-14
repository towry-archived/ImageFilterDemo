import Foundation
import AppKit

let imageName = "_assets/abc.jpg"

// register
ImageFilter.registerProcessor("circle", { (size, source) -> Image? in
  return roundCornerImageWithOffset(
    with: source,
    size: size,
    offset: .zero,
    bgColor: NSColor.green
  )
})

ImageFilter.registerProcessor("scale", { (_, _) -> Image? in
  return Image()
})

let filter = ImageFilter(name: "circle", size: CGSize(width: 180, height: 180))
let image = filter.process(image: Image(byReferencingFile: imageName))

let result = saveAsJepgWithName(name: "./output/0-circle.jpeg", source: image)
if result {
  print("saved")
} else {
  print("fail")
}
