//
//  Result.swift
//  Word Cloud
//
//  Created by Tingbo Chen on 5/10/16.
//  Copyright © 2016 Tingbo Chen. All rights reserved.
//

struct Result {
	var word: String
	var synonyms: [String]
	
	init(word: String, synonyms: [String]) {
		self.word = word
		self.synonyms = synonyms
	}
	
	init(line: String) {
		var words = line.componentsSeparatedByString(",")
		self.word = words.removeAtIndex(0)
		self.synonyms = words
	}
}
