// DO NOT EDIT.
// swift-format-ignore-file
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: src/example.proto
//
// For information on using the generated types, please see the documentation:
//   https://github.com/apple/swift-protobuf/

import Foundation
import SwiftProtobuf

// If the compiler emits an error on this type, it is because this file
// was generated by a version of the `protoc` Swift plug-in that is
// incompatible with the version of SwiftProtobuf to which you are linking.
// Please ensure that you are building against the same version of the API
// that was used to generate this file.
fileprivate struct _GeneratedWithProtocGenSwiftVersion: SwiftProtobuf.ProtobufAPIVersionCheck {
  struct _2: SwiftProtobuf.ProtobufAPIVersion_2 {}
  typealias Version = _2
}

struct Example_Protos_UpdateUI {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var intro: String = String()

  var lines: [String] = []

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct Example_Protos_UICommand {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var command: Example_Protos_UICommand.OneOf_Command? = nil

  var shuffle: Example_Protos_CommandShuffle {
    get {
      if case .shuffle(let v)? = command {return v}
      return Example_Protos_CommandShuffle()
    }
    set {command = .shuffle(newValue)}
  }

  var unknownFields = SwiftProtobuf.UnknownStorage()

  enum OneOf_Command: Equatable {
    case shuffle(Example_Protos_CommandShuffle)

  #if !swift(>=4.1)
    static func ==(lhs: Example_Protos_UICommand.OneOf_Command, rhs: Example_Protos_UICommand.OneOf_Command) -> Bool {
      switch (lhs, rhs) {
      case (.shuffle(let l), .shuffle(let r)): return l == r
      }
    }
  #endif
  }

  init() {}
}

struct Example_Protos_CommandShuffle {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

// MARK: - Code below here is support for the SwiftProtobuf runtime.

fileprivate let _protobuf_package = "example.protos"

extension Example_Protos_UpdateUI: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".UpdateUI"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "intro"),
    2: .same(proto: "lines"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1: try decoder.decodeSingularStringField(value: &self.intro)
      case 2: try decoder.decodeRepeatedStringField(value: &self.lines)
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.intro.isEmpty {
      try visitor.visitSingularStringField(value: self.intro, fieldNumber: 1)
    }
    if !self.lines.isEmpty {
      try visitor.visitRepeatedStringField(value: self.lines, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Example_Protos_UpdateUI, rhs: Example_Protos_UpdateUI) -> Bool {
    if lhs.intro != rhs.intro {return false}
    if lhs.lines != rhs.lines {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Example_Protos_UICommand: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".UICommand"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "shuffle"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1:
        var v: Example_Protos_CommandShuffle?
        if let current = self.command {
          try decoder.handleConflictingOneOf()
          if case .shuffle(let m) = current {v = m}
        }
        try decoder.decodeSingularMessageField(value: &v)
        if let v = v {self.command = .shuffle(v)}
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if case .shuffle(let v)? = self.command {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Example_Protos_UICommand, rhs: Example_Protos_UICommand) -> Bool {
    if lhs.command != rhs.command {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Example_Protos_CommandShuffle: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".CommandShuffle"
  static let _protobuf_nameMap = SwiftProtobuf._NameMap()

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let _ = try decoder.nextFieldNumber() {
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Example_Protos_CommandShuffle, rhs: Example_Protos_CommandShuffle) -> Bool {
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}
