//
//  SwipyCellEnums.swift
//  SwipyCell
//
//  Created by Moritz Sternemann on 20.01.16.
//  Copyright © 2016 Moritz Sternemann. All rights reserved.
//

import Foundation

public enum SwipyCellDirection: UInt {
  case left = 0
  case center
  case right
}

public struct SwipyCellState: OptionSet {
  public let rawValue: Int
  public init(rawValue: Int) { self.rawValue = rawValue }
  public static let None = SwipyCellState(rawValue: 0)
  public static let State1 = SwipyCellState(rawValue: (1 << 0))
  public static let State2 = SwipyCellState(rawValue: (1 << 1))
  public static let State3 = SwipyCellState(rawValue: (1 << 2))
  public static let State4 = SwipyCellState(rawValue: (1 << 3))
}

public enum SwipyCellMode: UInt {
  case none = 0
  case exit
  case `switch`
}
