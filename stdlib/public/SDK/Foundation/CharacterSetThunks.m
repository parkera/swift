//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2016 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

#import <Foundation/Foundation.h>

// SPI from CoreFoundation
CF_EXPORT CFCharacterSetRef _CFURLComponentsGetURLUserAllowedCharacterSet();
CF_EXPORT CFCharacterSetRef _CFURLComponentsGetURLPasswordAllowedCharacterSet();
CF_EXPORT CFCharacterSetRef _CFURLComponentsGetURLHostAllowedCharacterSet();
CF_EXPORT CFCharacterSetRef _CFURLComponentsGetURLPathAllowedCharacterSet();
CF_EXPORT CFCharacterSetRef _CFURLComponentsGetURLQueryAllowedCharacterSet();
CF_EXPORT CFCharacterSetRef _CFURLComponentsGetURLFragmentAllowedCharacterSet();

extern /*"C"*/ CF_RETURNS_RETAINED CFCharacterSetRef
__Swift_CFURLComponentsCopyURLUserAllowedCharacterSet() {
    return CFRetain(_CFURLComponentsGetURLUserAllowedCharacterSet());
}

extern /*"C"*/ CF_RETURNS_RETAINED CFCharacterSetRef
__Swift_CFURLComponentsGetURLPasswordAllowedCharacterSet() {
    return CFRetain(_CFURLComponentsGetURLPasswordAllowedCharacterSet());
}

extern /*"C"*/ CF_RETURNS_RETAINED CFCharacterSetRef
__Swift_CFURLComponentsGetURLHostAllowedCharacterSet() {
    return CFRetain(_CFURLComponentsGetURLHostAllowedCharacterSet());
}

extern /*"C"*/ CF_RETURNS_RETAINED CFCharacterSetRef
__Swift_CFURLComponentsGetURLPathAllowedCharacterSet() {
    return CFRetain(_CFURLComponentsGetURLPathAllowedCharacterSet());
}

extern /*"C"*/ CF_RETURNS_RETAINED CFCharacterSetRef
__Swift_CFURLComponentsGetURLQueryAllowedCharacterSet() {
    return CFRetain(_CFURLComponentsGetURLQueryAllowedCharacterSet());
}

extern /*"C"*/ CF_RETURNS_RETAINED CFCharacterSetRef
__Swift_CFURLComponentsGetURLFragmentAllowedCharacterSet() {
    return CFRetain(_CFURLComponentsGetURLFragmentAllowedCharacterSet());
}


