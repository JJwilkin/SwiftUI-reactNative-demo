//
//  SwiftUIButtonProxy.swift
//  SimpleReactNative
//
//  Created by Joshua Wilkinson on 2021-03-09.
//

import SwiftUI


@available(iOS 13.0, *)
//@objcMembers class SwiftUIButtonProxy: UIView {
//  private var vc = UIHostingController(rootView: SwiftUIButton())
//
//  static let storage = NSMutableDictionary()
//
//  var count: Int {
//    set { vc.rootView.props.count = newValue }
//    get { return vc.rootView.props.count }
//  }
//
//  var onCountChange: RCTBubblingEventBlock {
//    set { vc.rootView.props.onCountChange = newValue }
//    get { return vc.rootView.props.onCountChange }
//  }
//
//  var view: UIView {
//    return vc.view
//  }
//}
@objcMembers class SwiftUIButtonProxy: UIView {
  private var vc = UIHostingController(rootView: CameraView())
  
//  static let storage = NSMutableDictionary()
  
//  var count: Int {
//    set { vc.rootView.props.count = newValue }
//    get { return vc.rootView.props.count }
//  }
//
//  var onCountChange: RCTBubblingEventBlock {
//    set { vc.rootView.props.onCountChange = newValue }
//    get { return vc.rootView.props.onCountChange }
//  }
  
  var view: UIView {
    return vc.view
  }
}
