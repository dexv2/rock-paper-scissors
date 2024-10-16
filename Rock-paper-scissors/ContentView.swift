//
//  ContentView.swift
//  Rock-paper-scissors
//
//  Created by Vermont Phil Paguiligan on 10/16/24.
//

import SwiftUI

struct Info: View {
    var label: String
    var value: String
    var valueBg: Color?
    
    var body: some View {
        HStack {
            Text("\(label):")
            Text(value)
                .bold()
                .foregroundStyle(valueBg ?? Color.white)
        }
    }
}

struct TitleStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundStyle(.white)
            .font(.largeTitle.bold())
    }
}

struct TextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundStyle(.white)
            .font(.system(size: 20))
    }
}

extension View {
    func textStyle() -> some View {
        modifier(TextStyle())
    }
    
    func titleStyle() -> some View {
        modifier(TitleStyle())
    }
}

struct ContentView: View {
    let moves = ["Rock", "Paper", "Scissors"]
    let totalItems = 10
    
    @State private var computerPick = Int.random(in: 0..<3)
    @State private var shouldWin = Bool.random()
    @State private var score = 0
    @State private var item = 0
    @State private var resultTitle = ""
    @State private var showResult = false
    @State private var showTotal = false
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.blue, .black], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack(spacing: 70) {
                VStack {
                    Info(label: "Score", value: "\(score)")
                        .titleStyle()
                }
                
                VStack {
//                    Info(label: "Item #", value: "\(item + 1)")
//                        .textStyle()
                    Info(label: "Computer", value: moves[computerPick])
                        .textStyle()
                    Info(label: "Player should", value: shouldWin ? "Win" : "Lose", valueBg: shouldWin ? .green : .red)
                        .textStyle()
                }
                
                VStack {
                    HStack {
                        ForEach(0..<3) { index in
                            Button {
                                chooseMove(index)
                            } label: {
                                Text(moves[index])
                            }
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(width: 100, height: 30)
                            .background(Color(red: 0.1, green: 0.3, blue: 0.6))
                            .clipShape(.capsule)
                            .padding(3)
                        }
                    }
                }
            }
        }
        .alert(resultTitle, isPresented: $showResult) {
            Button("Continue", action: toggle)
        } message: {
            Text("Your score is \(score)")
        }
        .alert(resultTitle, isPresented: $showTotal) {
            Button("Reset", action: reset)
        } message: {
            Text("Total score: \(score)/\(totalItems)")
        }
    }
    
    func chooseMove(_ playerPick: Int) {
        item += 1
        if (playerPick != computerPick && playerWins(playerPick) == shouldWin) {
            score += 1
            resultTitle = "Correct!"
        } else {
            resultTitle = "Wrong!"
        }
        
        if item == totalItems {
            showTotal = true
        } else {
            showResult = true
        }
    }
    
    func toggle() {
        computerPick = Int.random(in: 0..<3)
        shouldWin = Bool.random()
    }
    
    func reset() {
        score = 0
        item = 0
        
        toggle()
    }
    
    func playerWins(_ playerPick: Int) -> Bool {
        let diff = abs(playerPick - computerPick)
        if (diff == 1) {
            return playerPick > computerPick
        } else {
            return computerPick > playerPick
        }
    }
}

#Preview {
    ContentView()
}
