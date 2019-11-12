//
//  GameViewController.swift
//  Judgement
//
//  Created by Ruchi Maheshwari on 11/12/19.
//  Copyright © 2019 Ruchi Maheshwari. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    @IBOutlet weak var numCards: UISlider!
    @IBOutlet weak var displayCards: UILabel!
    @IBOutlet weak var numPlayers: UISlider!
    @IBOutlet weak var displayPlayers: UILabel!
    static var players = Array<Array<Int>>()
    static var turn = -1
    static var roundTurns = -1
    static var trump = "H"
    static var roundTrump = "D"
    static var cardSuits = ["H", "D", "S", "C"]
    static var roundBets = [Int]()
    static var card = Array<Int>()
    static var numZero = 0
    
    @IBAction func onClick(_ sender: Any) {
        performSegue(withIdentifier: "Changer", sender: self)
    }
    
    @IBAction func changePlayers(_ sender: Any) {
        displayPlayers.text = String(Int(numPlayers.value))
        cardInfo.numPlayers = Int(numPlayers.value)
    }
    
    @IBAction func changeSlider(_ sender: Any) {
        displayCards.text = String(Int(numCards.value))
        cardInfo.numCards = Int(numCards.value)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numCards.minimumValue = 2
        numCards.maximumValue = 8
        numPlayers.minimumValue = 2
        numPlayers.maximumValue = 4
        displayCards.text = String(Int(numCards.value))
        displayPlayers.text = String(Int(numPlayers.value))
        for _ in 0..<cardInfo.numPlayers {
            cardInfo.overallScore.append(0)
        }
    }
    
    static func createCards(){
        var i = 1
        while i <= 52 {
            card.append(i)
            i += 1
        }
    }
    
    static func nextTurn() -> Int{
        turn = turn + 1
        roundTurns += 1
        if roundTurns == cardInfo.numPlayers{
            roundTurns = 0
            determineRoundWinner()
            cardInfo.cardsPlayed = Array<Int>()
            cardInfo.result = ""
            print(turn % cardInfo.numPlayers)
            if players[turn % cardInfo.numPlayers].count == 0 {
                findOverallScores()
                resetRound()
            }
        }
        return turn % cardInfo.numPlayers
    }
    
    static func resetRound() {
        roundBets = Array<Int>()
        card = Array<Int>()
        players = Array<Array<Int>>()
        createPlayers(num: cardInfo.numCards)
        cardInfo.gameScore = Array<Int>()
    }
    
    static func createPlayers(num: Int){
        for _ in 0..<cardInfo.numPlayers {
            var i = num
            if card.count == 0 {
                createCards()
        }
            var playerCards = Array<Int>()
            for _ in 0..<num {
                let randomElementIndex = Int.random(in: 0..<card.count)
                playerCards.append(card[randomElementIndex])
                card.remove(at: randomElementIndex)
                i = i - 1
            }
            players.append(playerCards)
        }
    }
    
    static func determineRoundWinner(){
        var pointValues = [Int]()
        for i in 0...cardInfo.cardsPlayed.count - 1{
            let cardNumber = cardInfo.cardsPlayed[i] % 13 + 1
            let cardSuit = cardSuits[cardInfo.cardsPlayed[i] % 4]
            if cardSuit == trump {
                pointValues.append(100 + cardNumber)
            }
            else if cardSuit == roundTrump {
                pointValues.append(20 + cardNumber)
            }
            else {
                pointValues.append(cardNumber)
            }
        }
        var maxPlayer = pointValues.max()
        for i in 0..<pointValues.count{
            if pointValues[i] == maxPlayer{
                maxPlayer = i
            }
        }
        cardInfo.gameScore[maxPlayer!] += 1
        turn = maxPlayer!
    }

    static func findOverallScores() {
        for i in 0..<roundBets.count{
            if roundBets[i] == cardInfo.gameScore[i]{
                cardInfo.overallScore[i] += (roundBets[i] + 10*(roundBets[i]+1))
            }
        }
        declareWinner()
        print(cardInfo.overallScore)
    }
    
    static func declareWinner() {
        for i in 0..<cardInfo.numPlayers {
            if cardInfo.overallScore[i] >= 50 {
                print("Player " + String(i + 1) + " Won")
                win(i: i)
            }
        }
    }
    
    static func win(i: Int){
        cardInfo.gameEnd = true
        turn = i
        players = Array<Array<Int>>()
    }
}

struct cardInfo {
    static var numCards = 4
    static var numPlayers = 4
    static var cardsPlayed = Array<Int>()
    static var result = ""
    static var gameScore = Array<Int>()
    static var overallScore = Array<Int>()
    static var gameEnd = false
}
