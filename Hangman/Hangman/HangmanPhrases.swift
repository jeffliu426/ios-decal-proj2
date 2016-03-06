//
//  HangmanPhrases.swift
//  Hangman
//
//  Created by Shawn D'Souza on 3/3/16.
//  Copyright © 2016 Shawn D'Souza. All rights reserved.
//

import Foundation

class HangmanPhrases {
    var phrases : NSArray!
    
    // Initialize HangmanPhrase with an array of all possible phrases of the Hangman game
    init() {
        let path = NSBundle.mainBundle().pathForResource("phrases", ofType: "plist")
        phrases = NSArray.init(contentsOfFile: path!)
    }
    
    // Get random phrase from all available phrases
    func getRandomPhrase() -> String! {
        let index = Int(arc4random_uniform(UInt32(phrases.count)))
        return phrases.objectAtIndex(index) as! String
    }
    
    static func saveData(word : String) {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        defaults.setObject(word, forKey: "word")
    }
    
    static func getData() -> String? {
        var word : String?
        let defaults = NSUserDefaults.standardUserDefaults()
        word = defaults.objectForKey("word") as? String
        return word
 
    }
    
}