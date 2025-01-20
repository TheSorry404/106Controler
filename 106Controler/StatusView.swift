//
//  StatusView.swift
//  106Controller
//
//  Created by Sorry404 Wang on 2025/3/4.
//

import SwiftUI

struct StatusView: View {
    @Binding var buttonStates: [String: Bool]
    
    var body: some View {
        VStack {
            ForEach(buttonStates.keys.sorted(), id: \.self) { key in
                HStack {
                    Text(key)
                    Spacer()
                    Text(buttonStates[key]! ? "已打开" : "已关闭")
                }
                .padding()
            }
        }
        .navigationTitle("状态页")
    }
}

