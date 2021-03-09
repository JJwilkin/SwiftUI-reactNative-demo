//
//  SwiftUIButton.swift
//  SimpleReactNative
//
//  Created by Joshua Wilkinson on 2021-03-09.
//

import SwiftUI

@available(iOS 13.0, *)
class ButtonProps : ObservableObject {
  @Published var count: Int = 0
  @Published var onCountChange: RCTDirectEventBlock = { _ in }
}

@available(iOS 13.0, *)
struct SwiftUIButton : View {
  @available(iOS 13.0, *)
  @ObservedObject var props = ButtonProps()
  
  @available(iOS 13.0.0, *)
  var body: some View {
    VStack {
      Text("Count \(props.count)")
        .padding()
      
      Button(action: {
        self.props.onCountChange(["count": self.props.count + 1])
      }) {
        Image(systemName: "plus.circle.fill")
          .foregroundColor(.white)
          .padding()
          .background(Color.red)
          .clipShape(Circle())
      }
    }
    .padding()
    .clipShape(Circle())
  }
}
