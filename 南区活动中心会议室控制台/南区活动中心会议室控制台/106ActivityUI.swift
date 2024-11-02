////
////  106ActivityUI.swift
////  南区活动中心会议室控制台
////
////  Created by 牢大 on 2024/10/12.
////
//
//import SwiftUI
//
//struct _06ActivityUI: View {
//        var body: some View {
//            VStack(spacing: 20) {
//                Button("MAC2 On") {
//                    SocketUtil.send("3A 00 00 03 00 03 05 0D 23 00 4D 81 81")
//                }
//                Button("MAC2 Off") {
//                    SocketUtil.send("3A 00 00 03 00 03 05 0D 23 00 4D 80 80")
//                }
//                Button("Screen On") {
//                    SocketUtil.send("3A 00 00 04 00 03 09 0D 6B 61 20 30 30 20 30 31 0D")
//                }
//                Button("Screen Off") {
//                    SocketUtil.send("3A 00 00 04 00 03 09 0D 6B 61 20 30 30 20 30 30 0D")
//                }
//                Button("Face Light On") {
//                    SocketUtil.send("3A 00 00 03 00 03 05 0D 23 00 4D 82 82")
//                }
//                Button("Face Light Off") {
//                    SocketUtil.send("3A 00 00 03 00 03 05 0D 23 00 4D 83 83")
//                }
//            }
//            .padding()
//        }
//    }
//
//    struct _06ActivityUI_Previews: PreviewProvider {
//        static var previews: some View {
//            _06ActivityUI()
//        }
//    }
//
//    class SocketUtil {
//        static var host: String = "10.10.100.254"
//        static var port: Int = 8899
//        
//        static func send(_ msg: String, host: String = SocketUtil.host, port: Int = SocketUtil.port) {
//            DispatchQueue.global().async {
//                var connection: OutputStream?
//                defer {
//                    connection?.close()
//                }
//                
//                Stream.getStreamsToHost(withName: host, port: port, inputStream: nil, outputStream: &connection)
//                connection?.open()
//                
//                let data = convert(msg)
//                connection?.write(data, maxLength: data.count)
//            }
//        }
//        
//        static func convert(_ data: String) -> [UInt8] {
//            return data.split(separator: " ").compactMap { UInt8(String(\$0), radix: 16) }
//        }
//
//
//
//
//
//
//    }
//
//
//#Preview {
//    _06ActivityUI()
//}
