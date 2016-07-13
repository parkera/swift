//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2016 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See http://swift.org/LICENSE.txt for license information
// See http://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

/// A value that has a custom representation in `AnyHashable`.
///
/// `Self` should also conform to `Hashable`.
public protocol _HasCustomAnyHashableRepresentation {
  /// Returns a custom representation of `self` as `AnyHashable`.
  /// If returns nil, the default representation is used.
  ///
  /// If your custom representation is a class instance, it
  /// needs to be boxed into `AnyHashable` using the static
  /// type that introduces the `Hashable` conformance.
  ///
  ///     class Base : Hashable {}
  ///     class Derived1 : Base {}
  ///     class Derived2 : Base, _HasCustomAnyHashableRepresentation {
  ///       func _toCustomAnyHashable() -> AnyHashable? {
  ///         // `Derived2` is canonicalized to `Devired1`.
  ///         let customRepresentation = Derived1()
  ///
  ///         // Wrong:
  ///         // return AnyHashable(customRepresentation)
  ///
  ///         // Correct:
  ///         return AnyHashable(customRepresentation as Base)
  ///       }
  func _toCustomAnyHashable() -> AnyHashable?
}

internal protocol _AnyHashableBox {
  var _typeID: ObjectIdentifier { get }
  func _unbox<T : Hashable>() -> T?

  func _isEqual(to: _AnyHashableBox) -> Bool
  var _hashValue: Int { get }
}

internal struct _ConcreteHashableBox<Base : Hashable> : _AnyHashableBox {
  internal var _base: Base
  internal init(_ base: Base) {
    self._base = base
  }

  internal var _typeID: ObjectIdentifier {
    return ObjectIdentifier(self.dynamicType)
  }

  internal func _unbox<T : Hashable>() -> T? {
    return (self as _AnyHashableBox as? _ConcreteHashableBox<T>)?._base
  }

  internal func _isEqual(to rhs: _AnyHashableBox) -> Bool {
    if let rhs: Base = rhs._unbox() {
      return _base == rhs
    }
    return false
  }

  internal var _hashValue: Int {
    return _base.hashValue
  }
}

public struct AnyHashable : Equatable, Hashable {
  internal var _box: _AnyHashableBox

  public init<H : Hashable>(_ base: H) {
    if let customRepresentation =
      (base as? _HasCustomAnyHashableRepresentation)?._toCustomAnyHashable() {
      self = customRepresentation
      return
    }

    self._box = _ConcreteHashableBox(0 as Int)
    _stdlib_makeAnyHashableUpcastingToHashableBaseType(
      base,
      storingResultInto: &self)
  }

  internal init<H : Hashable>(_usingDefaultRepresentationOf base: H) {
    self._box = _ConcreteHashableBox(base)
  }

  public var hashValue: Int {
    return _box._hashValue
  }

  public func unbox<H : Hashable>(as: H.Type) -> H? {
    return _box._unbox()
  }
}

public func == (lhs: AnyHashable, rhs: AnyHashable) -> Bool {
  return lhs._box._isEqual(to: rhs._box)
}

/// Returns a default (non-custom) representation of `self`
/// as `AnyHashable`.
///
/// Completely ignores the
/// `_HasCustomAnyHashableRepresentation` conformance, if
/// any.
@_silgen_name("swift_stdlib_makeAnyHashableUsingDefaultRepresentation")
public // COMPILER_INTRINSIC (actually, called from the runtime)
func _stdlib_makeAnyHashableUsingDefaultRepresentation<H : Hashable>(
  of value: H,
  storingResultInto result: UnsafeMutablePointer<AnyHashable>
) {
  result.pointee = AnyHashable(_usingDefaultRepresentationOf: value)
}

@_silgen_name("swift_stdlib_makeAnyHashableUpcastingToHashableBaseType")
func _stdlib_makeAnyHashableUpcastingToHashableBaseType<H : Hashable>(
  _ value: H,
  storingResultInto result: UnsafeMutablePointer<AnyHashable>
)

