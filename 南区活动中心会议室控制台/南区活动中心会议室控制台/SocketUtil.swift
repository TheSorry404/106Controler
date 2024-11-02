////
////  SocketUtil.swift
////  南区活动中心会议室控制台
////
////  Created by 牢大 on 2024/10/12.
////
//
//import Foundation
//
//class SocketUtil {
//    static let shared = SocketUtil()
//    private let host = "10.10.100.254"
//    private let port = 8899
//    private var outputStream: OutputStream?
//    
//    init() {
//        setupNetworkCommunication()
//    }
//    
//    private func setupNetworkCommunication() {
//        var readStream: Unmanaged<CFReadStream>?
//        var writeStream: Unmanaged<CFWriteStream>?
//        
//        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault,
//                                           host as CFString,
//                                           UInt32(port),
//                                           &readStream,
//                                           &writeStream)
//        
//        outputStream = writeStream?.takeRetainedValue()
//        outputStream?.open()
//    }
//    
//    func send(_ msg: String) {
//        guard let data = convert(msg) else {
//            print("Invalid data")
//            return
//        }
//        
//        _ = data.withUnsafeBytes { outputStream?.write(\$0.bindMemory(to: UInt8.self).baseAddress!, maxLength: data.count) }
//    }
//    
//    private func convert(_ data: String) -> Data? {
//        let bytes = data.split(separator: " ").compactMap { UInt8(String(\$0), radix: 16) }
//        return Data(bytes)
//    }
//
//}
