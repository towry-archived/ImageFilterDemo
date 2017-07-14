//
// ImageFilter.swift
//
// Created by Towry Wang on 2017/7/13
//

import Foundation

#if os(macOS)
  import AppKit
  public typealias Image = NSImage
  public typealias Color = NSColor
#else
  import UIKit
  public typealias Image = UIImage
  public typealias Color = UIColor
#endif

public struct ImageFilter {
  public typealias Processor = (CGSize, Image) -> Image?
  public static var globalProcessors = [String: Processor]()

  fileprivate var name: String = ""
  fileprivate var size: CGSize = .zero

  init(name: String, size: CGSize) {
    self.name = name
    self.size = size
  }
}

extension ImageFilter {
  public static func registerProcessor(_ name: String, _ processor: @escaping ImageFilter.Processor) {
    ImageFilter.globalProcessors[name] = processor
  }

  public static func getProcessor(_ name: String) -> ImageFilter.Processor? {
    return ImageFilter.globalProcessors[name]
  }

  public func process(image: Image?) -> Image? {
    guard self.name != "" else {
      return nil
    }

    guard let image = image else {
      return nil
    }

    guard self.size.width != 0 && self.size.height != 0 else {
      return nil
    }

    let processor: ImageFilter.Processor? = ImageFilter.getProcessor(self.name)
    return processor?(self.size, image) ?? nil
  }
}
