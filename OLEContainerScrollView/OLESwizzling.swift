//
//  OLESwizzling.swift
//  OLEContainerScrollView
//
//  Created by Chanon Purananunak on 20/10/2563 BE.
//  Copyright © 2563 Chanon Purananunak. All rights reserved.
//
/*
OLEContainerScrollView

Copyright (c) 2014 Ole Begemann.
https://github.com/ole/OLEContainerScrollView
*/

import Foundation
import ObjectiveC

// Adapted from Peter Steinberger's PSPDFReplaceMethodWithBlock
// See http://petersteinberger.com/blog/2014/a-story-about-swizzling-the-right-way-and-touch-forwarding/
class OLESwizzling {
    func OLEReplaceMethodWithBlock(_ c: AnyClass, _ origSEL: Selector, _ block: Any?) -> IMP {
        assert(block != nil, "Invalid parameter not satisfying: block != nil")

        // get original method
        let origMethod = class_getInstanceMethod(c, origSEL)
        assert(origMethod != nil, "Invalid parameter not satisfying: origMethod != nil")

        // convert block to IMP trampoline and replace method implementation
        var newIMP: IMP = imp_implementationWithBlock(block)
        if let block = block {
            newIMP = imp_implementationWithBlock(block)
        }

        // Try adding the method if not yet in the current class
    //    if let origMethod = origMethod, let newIMP = newIMP {
    //        if !class_addMethod(c, origSEL, newIMP, method_getTypeEncoding(origMethod)) {
    //            return method_setImplementation(origMethod, newIMP)
    //        } else {
    //            return method_getImplementation(origMethod)
    //        }
    //    }
        
        //Without null safety
        if !class_addMethod(c, origSEL, newIMP, method_getTypeEncoding(origMethod!)) {
            return method_setImplementation(origMethod!, newIMP)
        } else {
            return method_getImplementation(origMethod!)
        }
    }
}
