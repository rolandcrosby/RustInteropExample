//
//  ContentView.swift
//  RustInteropExample
//
//  Created by roland on 5/19/20.
//  Copyright © 2020 roland. All rights reserved.
//

import Combine
import SwiftUI

struct ContentView: View {
  @EnvironmentObject var data: ContentViewData
  var body: some View {
    VStack(alignment: .leading) {
      Text(data.intro)
      List(data.items, id: \String.self) { item in
        Text(item)
      }
      Button(action: {
        var command = Example_Protos_UICommand()
        command.shuffle = Example_Protos_CommandShuffle()
        RustInterface.shared.runCommand(command)
      }) {
        Text("Shuffle")
      }

    }
    .frame(width: 300, height: 200).padding()
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView().environmentObject(ContentViewData(items: ["example 1", "another"]))
  }
}

class ContentViewData: ObservableObject {
  @Published var intro: String = "This is the default intro text."
  @Published var items: [String]
  var subscription: AnyCancellable!
  convenience init() {
    self.init(items: [])
  }
  init(items: [String]) {
    self.items = items
    self.subscription = RustInterface.shared.publisher.receive(on: RunLoop.main).sink(
      receiveValue: { value in
        print("subscription received: \(value)")
        self.intro = value.intro
        self.items = value.lines
      })

  }
}
