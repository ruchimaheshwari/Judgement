//
//  Player.swift
//  Judgement
//
//  Created by Ruchi Maheshwari on 11/12/19.
//  Copyright © 2019 Ruchi Maheshwari. All rights reserved.
//

import UIKit

class Player: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    var buttonNum = 0
    var buttonValues = Array<UIButton>()
    var firstTurn = true
    var playedButtons = Array<UIButton>()
    var cardSuits = ["H", "D", "S", "C"]
    var playerCards = Array<Int>()
    var turn = 0
    var firstfirst = true
    var beforeFirst = true
    var textInput: String = ""
    var j = false
    let picker = UIPickerView()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        GameViewController.createPlayers(num: cardInfo.numCards)
        createView(num: GameViewController.nextTurn())
    }
    
    func createTextField() {
        let textField =  UITextField(frame: CGRect(x: 125, y: 100, width: 200, height: 80))
        textField.font = UIFont.systemFont(ofSize: 30)
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.keyboardType = UIKeyboardType.numberPad
        textField.attributedPlaceholder = NSAttributedString(string: "Enter Bet")
        textField.returnKeyType = UIReturnKeyType.done
        self.view.addSubview(textField)
        textField.delegate = self
    }
    
    @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        GameViewController.roundBets.append(Int(textField.text!) ?? 0)
        textField.removeFromSuperview()
        if GameViewController.roundBets.count == cardInfo.numPlayers {
            cardInfo.gameScore.append(0)
            beforeFirst = false
            removeAllCards()
            let maxBet = GameViewController.roundBets.max()
            for i in 0..<cardInfo.numPlayers {
                if GameViewController.roundBets[i] == maxBet {
                    GameViewController.turn = i
                    createPicker()
                    return true
                }
            }
        }
        else {
            cardInfo.gameScore.append(0)
            removeAllCards()
            createView(num: GameViewController.roundBets.count)
        }
        return true
    }
    
    func createPicker() {
        picker.frame = CGRect(x: 110, y: 100, width: 200, height: 80)
        picker.delegate = self
        picker.dataSource = self
        self.view.addSubview(picker)
        let pickerButton = UIButton(type: UIButton.ButtonType.system) as UIButton
        pickerButton.frame = CGRect(x: 110, y: 180, width: 200, height: 80)
        pickerButton.setTitle("Choose", for: UIControl.State.normal)
        pickerButton.addTarget(self, action: #selector(pickerButtonAction(me: )), for: .touchUpInside)
        self.view.addSubview(pickerButton)
    }
    
    @objc func pickerButtonAction(me: UIButton!) {
        picker.removeFromSuperview()
        me.removeFromSuperview()
        createView(num: GameViewController.turn)
    }
    
    func getCardNumber(thisButton: UIButton) -> Int{
        var count = 0
        while count < buttonValues.count {
            if buttonValues[count] == thisButton {
                return count
            }
            count += 1
        }
        return 0
    }
    
    func getPlayedNumber(thisButton: UIButton) -> Int{
        var count = 0
        while count < playedButtons.count {
            if playedButtons[count] == thisButton {
                return count
            }
            count += 1
        }
        return 0
    }
    
    @objc func buttonAction(me: UIButton!)
    {
        printCards()
        if firstTurn && !beforeFirst{
            firstTurn = false
        }
        else if !beforeFirst{
            firstTurn = true
            removeCard(thisButton: me)
            removeAllCards()
            createView(num: GameViewController.nextTurn())
        }
    }
    
    func removeAllCards(){
        var count = buttonValues.count - 1
        while count >= 0 {
            buttonValues.remove(at: count).removeFromSuperview()
            count = count - 1
        }
    }
    
    func removeCard(thisButton: UIButton) {
        let cardNumber = getCardNumber(thisButton: thisButton)
        cardInfo.cardsPlayed.append(playerCards[cardNumber])
        buttonValues.remove(at: cardNumber).removeFromSuperview()
        GameViewController.players[turn].remove(at: cardNumber)
        }
    
    func printCards() {
        var count = 0
        while count < buttonValues.count {
            let cardNumber = playerCards[getCardNumber(thisButton: buttonValues[count])]
            buttonValues[count].setBackgroundImage(UIImage(named: (String(cardNumber % 13 + 1) + cardSuits[cardNumber % 4])), for: .normal)
            buttonValues[count].setTitle("", for: UIControl.State.normal)
            count += 1
        }
        count = playedButtons.count - 1
        while count >= 0 {
            playedButtons.remove(at: count).removeFromSuperview()
            count = count - 1
        }
        printPlayed()
    }
    
    func printPlayed() {
        var i = Double(cardInfo.cardsPlayed.count - 1)
        while Int(i) >= 0 {
            let button = UIButton(type: UIButton.ButtonType.system) as UIButton
            let width = Int(i.truncatingRemainder(dividingBy: 2))
            let height = Int(i / 2)
            let xPostion:CGFloat = 50 + CGFloat(width) * 225
            let yPostion:CGFloat = 50 + CGFloat(height) * 200
            let buttonWidth:CGFloat = 75
            let buttonHeight:CGFloat = 150
            button.frame = CGRect(x:xPostion, y:yPostion, width:buttonWidth, height:buttonHeight)
            let cardNumber = cardInfo.cardsPlayed[Int(i)]
            button.setBackgroundImage(UIImage(named: (String(cardNumber % 13 + 1) + cardSuits[cardNumber % 4])), for: .normal)
            self.view.addSubview(button)
            playedButtons.append(button)
            i = i - 1.0
    }
    }

    
    func createView(num: Int) {
        if GameViewController.roundBets.count == 0 {
            beforeFirst = true
            firstfirst = true
            print(num)
        }
        if firstfirst {
            printCards()
        }
        else if !beforeFirst{
            firstfirst = false
        }
        if beforeFirst {
            createTextField()
        }
        turn = num
        var i = 0.0
        playerCards = GameViewController.players[num]
        while i < Double(playerCards.count) {
            let button = UIButton(type: UIButton.ButtonType.system) as UIButton
            let width = Int(i.truncatingRemainder(dividingBy: 2))
            let height = Int(i / 2)
            let xPostion:CGFloat = 50 + CGFloat(width) * 225
            let yPostion:CGFloat = 400 + CGFloat(height) * 200
            let buttonWidth:CGFloat = 75
            let buttonHeight:CGFloat = 150
            button.frame = CGRect(x:xPostion, y:yPostion, width:buttonWidth, height:buttonHeight)
            button.setTitle("Click me", for: UIControl.State.normal)
            button.addTarget(self, action: #selector(buttonAction(me: )), for: .touchUpInside)
            self.view.addSubview(button)
            buttonValues.append(button)
            i = i + 1.0
        }
        if cardInfo.gameEnd {
            let button = UIButton(type: UIButton.ButtonType.system) as UIButton
            let xPostion:CGFloat = 75
            let yPostion:CGFloat = 300
            let buttonWidth:CGFloat = 400
            let buttonHeight:CGFloat = 150
            button.frame = CGRect(x:xPostion, y:yPostion, width:buttonWidth, height:buttonHeight)
            button.setTitle("Player " + String(num + 1) + " Won!!!", for: UIControl.State.normal)
            self.view.addSubview(button)
            removeAllCards()
            picker.removeFromSuperview()
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 4
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
                return cardSuits[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        cardInfo.result = cardSuits[row]
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


