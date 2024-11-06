//
//  ContentView.swift
//  南区活动中心会议室控制台
//
//  Created by Syan && OpenAI on 2024/10/12.
//

import SwiftUI
import Socket

struct ContentView: View {
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    @State private var showBaseOpAlert = false
    @State private var showBaseClAlert = false
    @State private var showScrnOpAlert = false
    @State private var showScrnClAlert = false
    @State private var showLghtOpAlert = false
    @State private var showLghtClAlert = false
    @State var showError = false
    
    var body: some View {
                LazyVGrid(columns: columns, spacing: 30) {
                    Button(action: {
                        SocketUtil.send("3A 00 00 03 00 03 05 0D 23 00 4D 81 81")
                        showBaseOpAlert = true
                    }) {
                        Text("机柜开")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(height: 60)
                            .background(Color.blue)
                            .cornerRadius(15)
                            .shadow(radius: 5)
                    }
                    .alert(isPresented: $showBaseOpAlert){
                        Alert(title: Text("完成"), message: Text("已发送开机柜指令"))
                    }
                    
                    Button(action: {
                        SocketUtil.send("3A 00 00 03 00 03 05 0D 23 00 4D 80 80")
                        showBaseClAlert = true
                    }) {
                        Text("机柜关")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(height: 60)
                            .background(Color.red)
                            .cornerRadius(15)
                            .shadow(radius: 5)
                    }
                    .alert(isPresented: $showBaseClAlert){
                        Alert(title: Text("完成"), message: Text("已发送关机柜指令"))
                    }
                    
                    Button(action: {
                        SocketUtil.send("3A 00 00 04 00 03 09 0D 6B 61 20 30 30 20 30 31 0D")
                        showScrnOpAlert = true
                    }) {
                        Text("外接屏开")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(height: 60)
                            .background(Color.blue)
                            .cornerRadius(15)
                            .shadow(radius: 5)
                    }
                    .alert(isPresented: $showScrnOpAlert){
                        Alert(title: Text("完成"), message: Text("已发送开大屏指令"))
                    }
                    
                    Button(action: {
                        SocketUtil.send("3A 00 00 04 00 03 09 0D 6B 61 20 30 30 20 30 30 0D")
                        showScrnClAlert = true
                    }) {
                        Text("外接屏关")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(height: 60)
                            .background(Color.red)
                            .cornerRadius(15)
                            .shadow(radius: 5)
                    }
                    .alert(isPresented: $showScrnClAlert){
                        Alert(title: Text("完成"), message: Text("已发送关大屏指令"))
                    }
                    
                    Button(action: {
                        SocketUtil.send("3A 00 00 03 00 03 05 0D 23 00 4D 82 82")
                        showLghtOpAlert = true
                    }) {
                        Text("面光灯开")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(height: 60)
                            .background(Color.blue)
                            .cornerRadius(15)
                            .shadow(radius: 5)
                    }
                    .alert(isPresented: $showLghtOpAlert){
                        Alert(title: Text("完成"), message: Text("已发送开面灯指令"))
                    }
                    
                    Button(action: {
                        SocketUtil.send("3A 00 00 03 00 03 05 0D 23 00 4D 83 83")
                        showLghtClAlert = true
                    }) {
                        Text("面光灯关")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(height: 60)
                            .background(Color.red)
                            .cornerRadius(15)
                            .shadow(radius: 5)
                    }
                    .alert(isPresented: $showLghtClAlert){
                        Alert(title: Text("完成"), message: Text("已发送关面灯指令"))
                    }
                    .alert(isPresented: $showError){
                        Alert(title: Text("错误"), message: Text("本次发送发生错误，未成功发送"))
                    }
                }
                .padding()
            }
        }

    struct SocketUtil {
        static let HOST = "10.10.100.254"
        static let PORT = 8899
        

        static func send(_ msg: String, host: String = HOST, port: Int = PORT) {
            let queue = DispatchQueue.global(qos: .background)
            queue.async {
                do {
                    let socket = try Socket.create()
                    try socket.connect(to: host, port: Int32(port))
                    let data = convert(data: msg)
                    try socket.write(from: data)
                    socket.close()
                } catch {
                    print("Unexpected error: \(error).")
                    showError = true
                }
            }
        }
        
        static func convert(data: String) -> Data {
            let scanner = Scanner(string: data)
            var bytes: [UInt8] = []
            
            while !scanner.isAtEnd {
                var byte: UInt32 = 0
                if scanner.scanHexInt32(&byte) {
                    bytes.append(UInt8(byte))
                }
            }
            
            return Data(bytes)
        }



    }
