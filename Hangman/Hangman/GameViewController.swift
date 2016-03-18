//
//  GameViewController.swift
//  Hangman
//
//  Created by Shawn D'Souza on 3/3/16.
//  Copyright © 2016 Shawn D'Souza. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var hangmanImageView: UIImageView!
    @IBOutlet weak var phraseToGuessLabel: UILabel!
    @IBOutlet weak var incorrectButton: UIButton!
    @IBOutlet weak var correctButton: UIButton!
    @IBOutlet weak var incorrectGuessesLabel: UILabel!
    @IBOutlet weak var letterTextField: UITextField!
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var guessButton: UIButton!
    
    
    let underscore = "_" as Character!
    let space = " " as Character!
    var phrase : String!
    var phraseAsUnderscores: String!
    /* Each index of array has the letter corresponding to the its place in the phrase */
    var lettersArray : [Character]!
    var incorrectGuesses : [Character]!
    var numOfUniqueLettersInPhrase : Int!
    var numCorrectGuesses : Int!
    var gameOver: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.navigationBarHidden = true
        setupGame()
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*** SETTING UP GAME ***/
    
    func setupGame() {
        // Do any additional setup after loading the view.
        let hangmanPhrases = HangmanPhrases()
        phrase = hangmanPhrases.getRandomPhrase()
        phraseToGuessLabel.text = convertPhraseToUnderscores(phrase)
        lettersArray = putLettersOfPhraseInArray(phrase)
        incorrectGuesses = [Character]()
        hangmanImageView.image = UIImage(named: "hangman1.gif")
        incorrectGuessesLabel.text = "Incorrect Guesses:"
        numOfUniqueLettersInPhrase = findNumOfUniqueLettersInPhrase()
        print(numOfUniqueLettersInPhrase)
        numCorrectGuesses = 0
        gameOver = false
        print(phrase)
    }
    
    func findNumOfUniqueLettersInPhrase() -> Int {
        var num = 0
        var str = ""
        for letter in lettersArray {
            if (!str.containsString(String(letter))) {
                num++
                str.append(letter)
            }
        }
        return num
    }
    
    func convertPhraseToUnderscores(phrase: String) -> String
    {
        phraseAsUnderscores = ""
        for chr in phrase.characters {
            if (!(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z") ) {
                phraseAsUnderscores.append(space)
                phraseAsUnderscores.append(space)
                phraseAsUnderscores.append(space)
            }
            else {
                phraseAsUnderscores.append(underscore)
                phraseAsUnderscores.append(space)
            }
        }
        return phraseAsUnderscores
    }
    
    func putLettersOfPhraseInArray(phrase: String) -> [Character]{
        var arrayOfChars = [Character]()
        for chr in phrase.characters {
            if ((chr >= "a" && chr <= "z") || (chr >= "A" && chr <= "Z")) {
                arrayOfChars.append(chr)
            }
        }
        return arrayOfChars
    }

    @IBAction func newGameAction(sender: AnyObject) {
        setupGame()
    }
    
    
    func alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func guessAction(sender: AnyObject) {
        let guessedLetter = letterTextField.text?.uppercaseString
        let letters = NSCharacterSet.letterCharacterSet()
        if gameOver! {
            alert("Error", message: "Game is Over. Please press new game.")
        }
        else if (guessedLetter == ""){
            alert("Error", message: "Enter a Letter")
        }
        else if (guessedLetter?.characters.count > 1) {
            alert("Error", message: "More than 1 letter")
        }
        else if (!letters.longCharacterIsMember((guessedLetter?.unicodeScalars.first?.value)!))
        {
            alert("Error", message: "No special characters")
        }
        else if (phrase.containsString(guessedLetter!))
        {
            revealLetter((guessedLetter?.characters.first)!)
        }
        else
        {
            addLetterToIncorrectGuesses((guessedLetter?.characters.first)!)
        }
    }
    

    func revealLetter(letter: Character) {
        var updatedPhraseAsUnderscores = ""
        var indexToChange = 0
        
        var letterAlreadyGuessed = false
        for chr in phraseAsUnderscores.characters {
            if ((chr >= "a" && chr <= "z") || (chr >= "A" && chr <= "Z")) {
                indexToChange++
                updatedPhraseAsUnderscores.append(chr)
                if (chr == letter) {
                    letterAlreadyGuessed = true
                }
            }
            else if (chr == "_") {
                let missingLetter = lettersArray[indexToChange]
                indexToChange++
                if (letter == missingLetter) {
                    updatedPhraseAsUnderscores.append(missingLetter)
                }
                else {
                    updatedPhraseAsUnderscores.append(chr)
                }
            }
            else {
                updatedPhraseAsUnderscores.append(chr)
            }
        }
        phraseAsUnderscores = updatedPhraseAsUnderscores
        phraseToGuessLabel.text = phraseAsUnderscores
        if letterAlreadyGuessed {
            alert("Error", message: "Oops, you already guessed this letter")
        }
        else {
            numCorrectGuesses?++
            if (numCorrectGuesses == numOfUniqueLettersInPhrase) {
                gameOver = true
                alert("Winner!!!", message: "You win! The correct phrase was \(phrase)!")
            }
        }
    }
    
    
    func addLetterToIncorrectGuesses(letter: Character) {
        var addedLetterToIncorrectGuesses = false
        if (!phrase.characters.contains(letter)) {
            var letterAlreadyGuessed = false
            for guess in incorrectGuesses {
                if letter == guess {
                    letterAlreadyGuessed = true
                    alert("Error", message: "Letter was already guessed")
                }
            }
            if !letterAlreadyGuessed {
                incorrectGuesses.append(letter)
                addedLetterToIncorrectGuesses = true
            }
        }
        updateIncorrectGuessesText()
        updateHangmanImage()
    }
    
    func updateHangmanImage() {
        let numberOfIncorrectGuesses = incorrectGuesses.count
        if numberOfIncorrectGuesses >= 6 {
            hangmanImageView.image = UIImage(named: "hangman7.gif")
            if numberOfIncorrectGuesses == 6 {
                alert("Sorry", message: "You have lost :( The correct phrase was \(phrase)")
                gameOver = true
            }
        }
        else {
            hangmanImageView.image = UIImage(named: "hangman\(numberOfIncorrectGuesses + 1).gif")
        }
    }
    
    func updateIncorrectGuessesText() -> [Character] {
        var incorrectGuessesText = "Incorrect Guesses:"
        let commaChar = "," as Character
        var index = 0
        for letterGuessed in incorrectGuesses {
            if index != 0 {
                incorrectGuessesText.append(commaChar)
            }
            incorrectGuessesText.append(space)
            incorrectGuessesText.append(letterGuessed)
            index++
        }
        incorrectGuessesLabel.text = incorrectGuessesText
        
        return incorrectGuesses
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
