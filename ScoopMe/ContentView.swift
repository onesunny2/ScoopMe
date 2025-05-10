//
//  ContentView.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/10/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(.run)
                .resizable()
                .scaledToFit()
                .frame(width: 50)
                .foregroundStyle(.scmBrightForsythia)
            
            Text("JNLargeTitle1")
                .font(.JNLargeTitle1)
            Text("JNLargeTitle2")
                .font(.JNLargeTitle2)
            Text("JNTitle1")
                .font(.JNTitle1)
            Text("JNBody1")
                .font(.JNBody1)
            Text("JNCaption1")
                .font(.JNCaption1)
            
            Divider()
            
            Text("PTTitle1")
                .font(.PTTitle1)
            Text("PTTitle2")
                .font(.PTTitie2)
            Text("PTBody1")
                .font(.PTBody1)
            Text("PTBody2")
                .font(.PTBody2)
            Text("PTBody3")
                .font(.PTBody3)
            Text("PTCaption1")
                .font(.PTCaption1)
            Text("PTCaption2")
                .font(.PTCaption2)
            Text("PTCaption3")
                .font(.PTCaption3)
        }
        .padding()
        .onAppear {
            for fontFamily in UIFont.familyNames {
                for fontName in UIFont.fontNames(forFamilyName: fontFamily) {
                    print(fontName)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
