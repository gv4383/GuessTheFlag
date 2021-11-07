//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Goyo Vargas on 10/13/21.
//

import SwiftUI

struct FlagImage: View {
    let fileName: String
    
    var body: some View {
        Image(fileName)
            .renderingMode(.original)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.black, lineWidth:  1))
            .shadow(color: .black, radius: 2)
    }
}

struct ContentView: View {
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var scoreDescription = ""
    
    @State private var countries = [
        "Estonia",
        "France",
        "Germany",
        "Ireland",
        "Italy",
        "Nigeria",
        "Poland",
        "Russia",
        "Spain",
        "UK",
        "US"
    ].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var playerSelection = 0
    
    @State private var playerScore = 0
    
    @State private var rotationAmount = 0.0
    @State private var flagOpacity = 1.0
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                VStack {
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                    
                    Text(countries[correctAnswer])
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                
                ForEach(0..<3) { number in
                    Button(action: {
                        flagTapped(number)
                        playerSelection = number
                        flagOpacity = 0.25
                        
                        withAnimation {
                            rotationAmount += 360
                        }
                    }) {
                        FlagImage(fileName: countries[number])
                    }
                    .rotation3DEffect(
                        .degrees(number == playerSelection ? rotationAmount : 0.0),
                        axis: (x: 0, y: 1, z: 0)
                    )
                    .opacity(number != playerSelection ? flagOpacity : 1.0)
                    .animation(.default, value: flagOpacity)
                }
                
                Text("Score: \(playerScore)")
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .fontWeight(.black)
                
                Spacer()
            }
        }
        .alert(isPresented: $showingScore) {
            Alert(title: Text(scoreTitle), message: Text(scoreDescription), dismissButton: .default(Text("Continue")) {
                askQuestion()
            })
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            playerScore += 1
            scoreTitle = "Correct"
            scoreDescription = "Your score is \(playerScore)"
        } else {
            playerScore -= 1
            scoreTitle = "Wrong"
            scoreDescription = "Wrong! That’s the flag of \(countries[number])."
        }
        
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        flagOpacity = 1.0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
