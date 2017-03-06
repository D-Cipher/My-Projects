//
//  Thesaurus.swift
//  Word Cloud
//
//  Created by Tingbo Chen on 5/10/16.
//  Copyright © 2016 Tingbo Chen. All rights reserved.
//

class Thesaurus {
	class func defaultThesaurus() -> Thesaurus {
		struct Static {
			static var instance: Thesaurus?
			static var token: dispatch_once_t = 0
		}
		dispatch_once(&Static.token, {
			Static.instance = Thesaurus()
		})
		return Static.instance!
	}
	
	var database: FMDatabase = {
		let path = NSBundle.mainBundle().pathForResource("words", ofType: "sqlite3")
		return FMDatabase(path: path)
	}()
	
	init() {
		database.open()
	}
	
	deinit {
		database.close()
	}
	
	func resultForQuery(query: String) -> Result? {
		let set = database.executeQuery("SELECT word, synonyms FROM words WHERE word like ?", withArgumentsInArray: [query])
		if set.next() {
			let synonyms = set.stringForColumn("synonyms").componentsSeparatedByString(",")
			return Result(word: set.stringForColumn("word"), synonyms: synonyms)
		}
		
		return nil
	}
}
