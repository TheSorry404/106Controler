//
//  ContentView.swift
//  南区活动中心会议室控制台
//
//  Created by Syan && OpenAI on 2024/10/12.
//

// TODO
// - 按键适配百分比，因为发现了居然没关横屏，为了让横屏和iPad也能用决定改一下。
// - 在上面下面可以写几行字。

import SwiftUI
import Socket
import UIKit



struct ContentView: View {
    
    @State private var refresher = 0
    
    class ViewController: UIViewController {
        
        class TriggerViewModel: ObservableObject {
            func updateView(){
                self.objectWillChange.send()
            }
            @Published var refreshing = 0
        }
        
        @ObservedObject var refreshTrigger = TriggerViewModel()
        
        override func viewDidLoad(){
            super.viewDidLoad()
            updateViewForOrientation(UIDevice.current.orientation)
            NotificationCenter.default.addObserver(self, selector: #selector(orientationDidChange), name: UIDevice.orientationDidChangeNotification, object: nil)
        }
        
        @objc func orientationDidChange(){
            updateViewForOrientation(UIDevice.current.orientation)
        }
        
        func updateViewForOrientation(_ orientation: UIDeviceOrientation){
            if orientation.isPortrait || orientation.isLandscape {
                refreshTrigger.updateView()
                refreshTrigger.refreshing += 1
                DispatchQueue.main.async {
                    self.view.setNeedsLayout()
                    self.view.layoutIfNeeded()
                }
            }
        }
        
        deinit{
            NotificationCenter.default.removeObserver(self)
        }
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            self.updateViewForOrientation(UIDevice.current.orientation)
        })
    }

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
    @State private var showError = false
    @State private var errorMessage: String?
    
    
    var body: some View {        
        GeometryReader { geometry in
            VStack {
                Text("106控制")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .center)
                LazyVGrid(columns: columns, spacing: 15) {
                    Button(action: {
                        SocketUtil.send("3A 00 00 03 00 03 05 0D 23 00 4D 81 81"){ error in
                            Task { @MainActor in
                                if let error = error {
                                    self.errorMessage = "发送指令时出现问题：\n\(error)\n\(error.localizedDescription)"
                                    self.showError = true
                                }
                            }
                        }
                        showBaseOpAlert = true
                    }) {
                        Text("机柜开")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .aspectRatio(contentMode: .fit)
                            .frame(
                                width: geometry.size.width * 0.3,
                                height: geometry.size.height * 0.15
                            )
                            .background(Color.blue)
                            .cornerRadius(15)
                            .shadow(radius: 5)
                    }
                    .alert("完成", isPresented: $showBaseOpAlert) {
                        Button("OK", role: .cancel) { }
                    } message: {
                        Text("已发送开机柜指令")
                    }
                    
                    Button(action: {
                        SocketUtil.send("3A 00 00 03 00 03 05 0D 23 00 4D 80 80"){ error in
                            Task { @MainActor in
                                if let error = error {
                                    self.errorMessage = "发送指令时出现问题：\n\(error)\n\(error.localizedDescription)"
                                    self.showError = true
                                }
                            }
                        }
                        showBaseClAlert = true
                    }) {
                        Text("机柜关")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .aspectRatio(contentMode: .fit)
                            .frame(
                                width: geometry.size.width * 0.3,
                                height: geometry.size.height * 0.15
                            )
                            .background(Color.red)
                            .cornerRadius(15)
                            .shadow(radius: 5)
                    }
                    .alert("完成", isPresented: $showBaseClAlert) {
                        Button("OK", role: .cancel) { }
                    } message: {
                        Text("已发送关机柜指令")
                    }
                    
                    Button(action: {
                        SocketUtil.send("3A 00 00 04 00 03 09 0D 6B 61 20 30 30 20 30 31 0D"){ error in
                            Task { @MainActor in
                                if let error = error {
                                    self.errorMessage = "发送指令时出现问题：\n\(error)\n\(error.localizedDescription)"
                                    self.showError = true
                                }
                            }
                        }
                        showScrnOpAlert = true
                    }) {
                        Text("外接屏开")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .aspectRatio(contentMode: .fit)
                            .frame(
                                width: geometry.size.width * 0.3,
                                height: geometry.size.height * 0.15
                            )
                            .background(Color.blue)
                            .cornerRadius(15)
                            .shadow(radius: 5)
                    }
                    .alert("完成", isPresented: $showScrnOpAlert) {
                        Button("OK", role: .cancel) { }
                    } message: {
                        Text("已发送开大屏指令")
                    }
                    
                    Button(action: {
                        SocketUtil.send("3A 00 00 04 00 03 09 0D 6B 61 20 30 30 20 30 30 0D"){ error in
                            Task { @MainActor in
                                if let error = error {
                                    self.errorMessage = "发送指令时出现问题：\n\(error)\n\(error.localizedDescription)"
                                    self.showError = true
                                }
                            }
                        }
                        showScrnClAlert = true
                    }) {
                        Text("外接屏关")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .aspectRatio(contentMode: .fit)
                            .frame(
                                width: geometry.size.width * 0.3,
                                height: geometry.size.height * 0.15
                            )
                            .background(Color.red)
                            .cornerRadius(15)
                            .shadow(radius: 5)
                    }
                    .alert("完成", isPresented: $showScrnClAlert) {
                        Button("OK", role: .cancel) { }
                    } message: {
                        Text("已发送关大屏指令")
                    }
                    
                    Button(action: {
                        SocketUtil.send("3A 00 00 03 00 03 05 0D 23 00 4D 82 82"){ error in
                            Task { @MainActor in
                                if let error = error {
                                    self.errorMessage = "发送指令时出现问题：\n\(error)\n\(error.localizedDescription)"
                                    self.showError = true
                                }
                            }
                        }
                        showLghtOpAlert = true
                    }) {
                        Text("面光灯开")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .aspectRatio(contentMode: .fit)
                            .frame(
                                width: geometry.size.width * 0.3,
                                height: geometry.size.height * 0.15
                            )
                            .background(Color.blue)
                            .cornerRadius(15)
                            .shadow(radius: 5)
                    }
                    .alert("完成", isPresented: $showLghtOpAlert) {
                        Button("OK", role: .cancel) { }
                    } message: {
                        Text("已发送开面灯指令")
                    }
                    
                    Button(action: {
                        SocketUtil.send("3A 00 00 03 00 03 05 0D 23 00 4D 83 83"){ error in
                            Task { @MainActor in
                                if let error = error {
                                    self.errorMessage = "发送指令时出现问题：\n\(error)\n\(error.localizedDescription)"
                                    self.showError = true
                                }
                            }
                        }
                        showLghtClAlert = true
                    }) {
                        Text("面光灯关")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .aspectRatio(contentMode: .fit)
                            .frame(
                                width: geometry.size.width * 0.3,
                                height: geometry.size.height * 0.15
                            )
                            .background(Color.red)
                            .cornerRadius(15)
                            .shadow(radius: 5)
                    }
                    .alert("完成", isPresented: $showLghtClAlert) {
                        Button("OK", role: .cancel) { }
                    } message: {
                        Text("已发送关面灯指令")
                    }
                    
                    .alert("发生错误", isPresented: $showError) {
                        Button("OK", role: .cancel) { }
                    } message: {
                        if let errorMessage = errorMessage {
                            Text(errorMessage)
                        }
                    }
                }
                .padding()
            }
        }
        // Text("106控制")
        //     .font(.largeTitle)
        //     .fontWeight(.bold)
        //     .padding()
        //     .frame(maxWidth: .infinity, alignment: .center)
        // LazyVGrid(columns: columns, spacing: 15) {
            
        //     Button(action: {
        //         SocketUtil.send("3A 00 00 03 00 03 05 0D 23 00 4D 81 81"){  error in
        //             Task { @MainActor in
        //                 if let error = error {
        //                     self.errorMessage = "发送指令时出现问题：\n\(error)\n\(error.localizedDescription)"
        //                     self.showError = true
        //                 }
        //             }
        //         }
        //         showBaseOpAlert = true
        //     }) {
        //         Text("机柜开")
        //             .font(.headline)
        //             .foregroundColor(.white)
        //             .padding()
        //             .frame(maxWidth: .infinity, maxHeight: .infinity)
        //             .aspectRatio(contentMode: .fit)
        //             .frame(
        //                 width: UIScreen.main.bounds.width * 0.3,
        //                 height: UIScreen.main.bounds.height * 0.15
        //             )
        //             .background(Color.blue)
        //             .cornerRadius(15)
        //             .shadow(radius: 5)
        //     }
        //     .alert("完成", isPresented: $showBaseOpAlert) {
        //         Button("OK", role: .cancel) { }
        //     } message: {
        //         Text("已发送开机柜指令")
        //     }
            
        //     Button(action: {
        //         SocketUtil.send("3A 00 00 03 00 03 05 0D 23 00 4D 80 80"){  error in
        //             Task { @MainActor in
        //                 if let error = error {
        //                     self.errorMessage = "发送指令时出现问题：\n\(error)\n\(error.localizedDescription)"
        //                     self.showError = true
        //                 }
        //             }
        //         }
        //         showBaseClAlert = true
        //     }) {
        //         Text("机柜关")
        //             .font(.headline)
        //             .foregroundColor(.white)
        //             .padding()
        //             .frame(maxWidth: .infinity, maxHeight: .infinity)
        //             .aspectRatio(contentMode: .fit)
        //             .frame(
        //                 width: UIScreen.main.bounds.width * 0.3,
        //                 height: UIScreen.main.bounds.height * 0.15
        //             )
        //             .background(Color.red)
        //             .cornerRadius(15)
        //             .shadow(radius: 5)
        //     }
        //     .alert("完成", isPresented: $showBaseClAlert) {
        //         Button("OK", role: .cancel) { }
        //     } message: {
        //         Text("已发送关机柜指令")
        //     }
            
        //     Button(action: {
        //         SocketUtil.send("3A 00 00 04 00 03 09 0D 6B 61 20 30 30 20 30 31 0D"){  error in
        //             Task { @MainActor in
        //                 if let error = error {
        //                     self.errorMessage = "发送指令时出现问题：\n\(error)\n\(error.localizedDescription)"
        //                     self.showError = true
        //                 }
        //             }
        //         }
        //         showScrnOpAlert = true
        //     }) {
        //         Text("外接屏开")
        //             .font(.headline)
        //             .foregroundColor(.white)
        //             .padding()
        //             .frame(maxWidth: .infinity, maxHeight: .infinity)
        //             .aspectRatio(contentMode: .fit)
        //             .frame(
        //                 width: UIScreen.main.bounds.width * 0.3,
        //                 height: UIScreen.main.bounds.height * 0.15
        //             )
        //             .background(Color.blue)
        //             .cornerRadius(15)
        //             .shadow(radius: 5)
        //     }
        //     .alert("完成", isPresented: $showScrnOpAlert) {
        //         Button("OK", role: .cancel) { }
        //     } message: {
        //         Text("已发送开大屏指令")
        //     }
            
        //     Button(action: {
        //         SocketUtil.send("3A 00 00 04 00 03 09 0D 6B 61 20 30 30 20 30 30 0D"){  error in
        //             Task { @MainActor in
        //                 if let error = error {
        //                     self.errorMessage = "发送指令时出现问题：\n\(error)\n\(error.localizedDescription)"
        //                     self.showError = true
        //                 }
        //             }
        //         }
        //         showScrnClAlert = true
        //     }) {
        //         Text("外接屏关")
        //             .font(.headline)
        //             .foregroundColor(.white)
        //             .padding()
        //             .frame(maxWidth: .infinity, maxHeight: .infinity)
        //             .aspectRatio(contentMode: .fit)
        //             .frame(
        //                 width: UIScreen.main.bounds.width * 0.3,
        //                 height: UIScreen.main.bounds.height * 0.15
        //             )
        //             .background(Color.red)
        //             .cornerRadius(15)
        //             .shadow(radius: 5)
        //     }
        //     .alert("完成", isPresented: $showScrnClAlert) {
        //         Button("OK", role: .cancel) { }
        //     } message: {
        //         Text("已发送关大屏指令")
        //     }
            
        //     Button(action: {
        //         SocketUtil.send("3A 00 00 03 00 03 05 0D 23 00 4D 82 82"){  error in
        //             Task { @MainActor in
        //                 if let error = error {
        //                     self.errorMessage = "发送指令时出现问题：\n\(error)\n\(error.localizedDescription)"
        //                     self.showError = true
        //                 }
        //             }
        //         }
        //         showLghtOpAlert = true
        //     }) {
        //         Text("面光灯开")
        //             .font(.headline)
        //             .foregroundColor(.white)
        //             .padding()
        //             .frame(maxWidth: .infinity, maxHeight: .infinity)
        //             .aspectRatio(contentMode: .fit)
        //             .frame(
        //                 width: UIScreen.main.bounds.width * 0.3,
        //                 height: UIScreen.main.bounds.height * 0.15
        //             )
        //             .background(Color.blue)
        //             .cornerRadius(15)
        //             .shadow(radius: 5)
        //     }
        //     .alert("完成", isPresented: $showLghtOpAlert) {
        //         Button("OK", role: .cancel) { }
        //     } message: {
        //         Text("已发送开面灯指令")
        //     }
            
        //     Button(action: {
        //         SocketUtil.send("3A 00 00 03 00 03 05 0D 23 00 4D 83 83"){  error in
        //             Task { @MainActor in
        //                 if let error = error {
        //                     self.errorMessage = "发送指令时出现问题：\n\(error)\n\(error.localizedDescription)"
        //                     self.showError = true
        //                 }
        //             }
        //         }
        //         showLghtClAlert = true
        //     }) {
        //         Text("面光灯关")
        //             .font(.headline)
        //             .foregroundColor(.white)
        //             .padding()
        //             .frame(maxWidth: .infinity, maxHeight: .infinity)
        //             .aspectRatio(contentMode: .fit)
        //             .frame(
        //                 width: UIScreen.main.bounds.width * 0.3,
        //                 height: UIScreen.main.bounds.height * 0.15
        //             )
        //             .background(Color.red)
        //             .cornerRadius(15)
        //             .shadow(radius: 5)
        //     }
        //     .alert("完成", isPresented: $showLghtClAlert) {
        //         Button("OK", role: .cancel) { }
        //     } message: {
        //         Text("已发送关面灯指令")
        //     }
            
        //     .alert("发生错误", isPresented: $showError) {
        //         Button("OK", role: .cancel) { }
        //     } message: {
        //         if let errorMessage = errorMessage {
        //             Text(errorMessage)
        //         }
        //     }
        // }
        // .padding()
        
    }
}

struct SocketUtil {
    static let HOST = "10.10.100.254"
    static let PORT = 8899

    static func send(_ msg: String, host: String = HOST, port: Int = PORT, completion: @escaping @Sendable (Error?) -> Void) {
        let queue = DispatchQueue.global(qos: .background)
        queue.async {
            do {
                let socket = try Socket.create()
//                try socket.setReadTimeout(value: 5000)
//                try socket.setWriteTimeout(value: 5000)
                try socket.connect(to: host, port: Int32(port), timeout: 5000)
                let data = convert(data: msg)
                try socket.write(from: data)
                socket.close()
                completion(nil)
            } catch {
                print("Unexpected error: \(error).")
                completion(error)
                // var ErrorMsg: String?
                // ErrorMsg = "发送指令时出现问题：\n\(error)"
                // // showError = true
                // struct ErrorAlert : View {
                //     @State private var showError = false
                //     var body: some View {
                //         showError = true
                //         .alert("发生错误", isPresented: $showError) {
                //             Button("OK", role: .cancel) { }
                //         } message: {
                //             Text(ErrorMsg)
                //         }
                //     }
                // }
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
