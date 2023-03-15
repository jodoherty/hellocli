//
//  main.swift
//  hellocli
//
//  Created by James O'Doherty on 3/3/23.
//

import Foundation
import Darwin
import libhello

class BaseHandler {
    func convert(_ string: String) -> String {
        return string
    }

    func registerHandler() {
        let ptr = UnsafeMutablePointer<libhello.HelloHandler>.allocate(capacity: 1)
        ptr.initialize(to: libhello.HelloHandler(
            context: Unmanaged.passRetained(self).toOpaque(),
            convert: { (handler, str, sptr ) in
                if let handler, let str, let sptr {
                    let mh: BaseHandler = Unmanaged.fromOpaque(handler.pointee.context).takeUnretainedValue()
                    let str = String(validatingUTF8: str)
                    if let str {
                        let str = mh.convert(str)
                        let cstr = str.withCString { strdup($0) }
                        sptr.initialize(to: cstr)
                        return 0
                    }
                }
                return 1
            },
            close: { (handler) in
                if let handler {
                    Unmanaged<BaseHandler>.fromOpaque(handler.pointee.context).release()
                    handler.deallocate()
                }
            }))
        libhello.register_handler(ptr)
    }
}

class CountHandler : BaseHandler {
    private var i = 0
    override func convert(_ string: String) -> String {
        i += 1
        return "\(string) \(i)"
    }
}

class ReverseHandler : BaseHandler {
    override func convert(_ string: String) -> String {
        return String(string.reversed())
    }
}

CountHandler().registerHandler()
libhello.hello("Hello World")
libhello.hello("Hello again")
ReverseHandler().registerHandler()
libhello.hello("Hello World")
libhello.hello("Hello again")
libhello.clear_handler()
