//
//  Binder.swift
//  Shows
//
//  Created by mac on 08/07/2020.
//  Copyright © 2020 home. All rights reserved.
//

import Foundation

final class Binder<T> {
  //1
  typealias Listener = (T) -> Void
  var listener: Listener?
  //2
  var value: T {
    didSet {
      listener?(value)
    }
  }
  //3
  init(_ value: T) {
    self.value = value
  }
  //4
  func bind(listener: Listener?) {
    self.listener = listener
    listener?(value)
  }
}
