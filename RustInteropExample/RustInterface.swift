//
//  RustInterface.swift
//  RustInteropExample
//
//  Created by roland on 5/19/20.
//  Copyright © 2020 roland. All rights reserved.
//

import Combine
import Foundation

typealias UpdateUI = Example_Protos_UpdateUI
typealias UICommand = Example_Protos_UICommand
typealias CommandShuffle = Example_Protos_CommandShuffle

class RustInterface {
  static let shared = RustInterface()
  let publisher: AnyPublisher<UpdateUI, Never>

  func runCommand(_ command: UICommand) {
    let protoData = try! command.serializedData()
    protoData.withUnsafeBytes({ ptr in
      rs_run_command(ptr, protoData.count)
    })
  }

  private let internalPublisher: PassthroughSubject<UpdateUI, Never>

  private init() {
    self.internalPublisher = PassthroughSubject()
    self.publisher = self.internalPublisher.share().eraseToAnyPublisher()
    let selfPtr = UnsafeRawPointer(Unmanaged.passUnretained(self).toOpaque())
    rs_register_callback(
      selfPtr,
      { (selfPtr, protoData, protoLength) -> Void in
        print("callback called")
        let reconstitutedSelf = Unmanaged<RustInterface>.fromOpaque(selfPtr!).takeUnretainedValue()
        reconstitutedSelf.receiveProto(protoData, protoLength: protoLength)
      })
  }

  private func receiveProto(_ protoData: UnsafePointer<CChar>?, protoLength: size_t) {
    let protoBuf = Data(bytes: UnsafeRawPointer(protoData!), count: protoLength)
    let proto = try! Example_Protos_UpdateUI(serializedData: protoBuf)
    print("receiveProto received: \(proto)")
    self.internalPublisher.send(proto)
  }

}
