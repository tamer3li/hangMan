//
//  ViewController.swift
//  hangMan
//
//  Created by tamerali on 31/03/2022.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var wordToGuessLabel: UILabel!
    @IBOutlet weak var remainingGuessesLabel: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var letterBankLabel: UILabel!
    
    let LIST_OF_WORDS :[String] = ["hello","goodbye","hangman","tea","esraa"]
    let LIST_OF_HINTS :[String] = ["greeting","farewell","guess the word","drink solve my problems","resource of happiness"]
    var wordToGuess : String!
    var wordAsUnderscores : String = ""
    let MAX_NUMBER_OF_GUESSES :Int = 5
    var guessesRemaining : Int!
    var oldRandomNumber : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inputTextField.delegate = self
        inputTextField.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard let letterGuessed = textField.text else { return }
        inputTextField.text?.removeAll()
        var currentLetterBank: String = letterBankLabel.text ?? ""
        if currentLetterBank.contains(letterGuessed){
           return
        }else {
            if wordToGuess.contains(letterGuessed){
                processCorrectGuess(letterGuessed: letterGuessed)
            }else {
                processIncorrectGuess()
            }
            letterBankLabel.text?.append("\(letterGuessed),")
        }
    }
    
    
    func processCorrectGuess(letterGuessed: String){
    
        let characterGuessed = Character(letterGuessed)
        for index in wordToGuess.indices {
            if wordToGuess[index] == characterGuessed{
                let endIndex = wordToGuess.index(after: index)
                let charRange = index..<endIndex
                wordAsUnderscores = wordAsUnderscores.replacingCharacters(in: charRange, with: letterGuessed)
                wordToGuessLabel.text = wordAsUnderscores
            }
        }
        if !(wordAsUnderscores.contains("_")){
            remainingGuessesLabel.text = "you win!"
            inputTextField.isEnabled = false
        }
    }
    
    func processIncorrectGuess(){
         guessesRemaining! -= 1
        if guessesRemaining == 0 {
            remainingGuessesLabel.text = "you lose!"
            inputTextField.isEnabled = false
        } else{
            remainingGuessesLabel.text = "\(guessesRemaining!) guesses left"
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
  
    @IBAction func chooseNewWordAction(_ sender: UIButton) {
        
        reset()
        
        let index = chooseRandomNumber()
        wordToGuess = LIST_OF_WORDS[index]
        
        let hint = LIST_OF_HINTS[index]
        hintLabel.text = "hint:\(hint) \(wordToGuess.count) letters"
        
        for _ in 1...wordToGuess.count {
            wordAsUnderscores.append("_")
        }
        wordToGuessLabel.text = wordAsUnderscores
    }
    
    func chooseRandomNumber ()-> Int{
        var newRandomNumber : Int = Int(arc4random_uniform(UInt32(LIST_OF_WORDS.count)))
        if (newRandomNumber == oldRandomNumber){
            newRandomNumber = chooseRandomNumber()
        }else {
            oldRandomNumber = newRandomNumber
        }
        return newRandomNumber
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = NSCharacterSet.lowercaseLetters
        let startingLength = textField.text?.count ?? 0
        let lengthToAdd = string.count
        let lengthToReplace = range.length
        let newLength = startingLength + lengthToAdd - lengthToReplace
        
        if string.isEmpty {
            return true
        } else if newLength == 1 {
            if let _ = string.rangeOfCharacter(from: allowedCharacters, options: .caseInsensitive){
                return true
            }
        }
        return false
    }
    
    func reset(){
        guessesRemaining = MAX_NUMBER_OF_GUESSES
        remainingGuessesLabel.text = "\(guessesRemaining!) guesses left"
        wordAsUnderscores = ""
        inputTextField.text?.removeAll()
        letterBankLabel.text?.removeAll()
        inputTextField.isEnabled = true
        
    }
   
    
}

