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
    
    let underscore = "_" as Character!
    let space = " " as Character!
    var phrase : String!
    var phraseAsUnderscores: String!
    /* Each index of array has the letter corresponding to the its place in the phrase */
    var lettersArray : [Character]!
    var incorrectGuesses : [Character]!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let hangmanPhrases = HangmanPhrases()
        phrase = hangmanPhrases.getRandomPhrase()
        phraseToGuessLabel.text = convertPhraseToUnderscores(phrase)
        lettersArray = putLettersOfPhraseInArray(phrase)
        incorrectGuesses = [Character]()
        hangmanImageView.image = UIImage(named: "hangman1.gif")
        print(phrase)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    

    @IBAction func revealLetter(sender: AnyObject) {
        var updatedPhraseAsUnderscores = ""
        var indexToChange = 0
        var letterRevealed = false
        for chr in phraseAsUnderscores.characters {
            if ((chr >= "a" && chr <= "z") || (chr >= "A" && chr <= "Z")) {
                indexToChange++
                updatedPhraseAsUnderscores.append(chr)
            }
            else if (chr == "_" && letterRevealed == false) {
                let missingLetter = lettersArray[indexToChange]
                updatedPhraseAsUnderscores.append(missingLetter)
                letterRevealed = true
            }
            else {
                updatedPhraseAsUnderscores.append(chr)
            }
        }
        print(updatedPhraseAsUnderscores)
        phraseAsUnderscores = updatedPhraseAsUnderscores
        phraseToGuessLabel.text = phraseAsUnderscores
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
    
    func updateHangmanImage() {
        let numberOfIncorrectGuesses = incorrectGuesses.count
        if numberOfIncorrectGuesses >= 7 {
            hangmanImageView.image = UIImage(named: "hangman7.gif")
        }
        else {
            hangmanImageView.image = UIImage(named: "hangman\(numberOfIncorrectGuesses + 1).gif")
        }
    }
    
    @IBAction func addLetterToIncorrectGuesses(sender: AnyObject) {
        
        var addedLetterToIncorrectGuesses = false

        
        for char in "ABCDEFGHIJKLMNOPQRSTUVWXYZ".characters {
            var letterAlreadyGuessed = false
            if (!phrase.characters.contains(char) && addedLetterToIncorrectGuesses == false) {
                for guess in incorrectGuesses {
                    print(guess)
                    if char == guess {
                        letterAlreadyGuessed = true
                    }
                }
                if !letterAlreadyGuessed {
                    incorrectGuesses.append(char)
                    addedLetterToIncorrectGuesses = true
                }
            }
        }
        
        updateIncorrectGuessesText()
        updateHangmanImage()
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
