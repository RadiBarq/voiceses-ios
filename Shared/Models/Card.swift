//
//  Card.swift
//  Voiceses
//
//  Created by Radi Barq on 07/05/2021.
//

import Foundation

struct Card: Identifiable, Codable {
    var id: String
    let subjectID: String
    var backImageURL: URL?
    var frontImageURL: URL?
    var dateCreated: String
    let timestamp: Int64
    var testScore: Int
}

extension Card: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}

var test_cards = [
    Card(id: "0", subjectID: "-MYVyy9VIQOFe04aA5qy", backImageURL: URL(string: "https://firebasestorage.googleapis.com/v0/b/voiceses-99761.appspot.com/o/users%2F7tWnL6JKhAUn4QtuwcNeSrXfiAn2%2Fsubjects%2F-MYVyy9VIQOFe04aA5qy%2Fcards%2F-M_jkjTR4zpippRqLeJd%2FbackImage.png?alt=media&token=5011a786-bffa-4a5d-af43-c010139b185e")!, frontImageURL: URL(string: "https://firebasestorage.googleapis.com/v0/b/voiceses-99761.appspot.com/o/users%2F7tWnL6JKhAUn4QtuwcNeSrXfiAn2%2Fsubjects%2F-MYVyy9VIQOFe04aA5qy%2Fcards%2F-M_jkjTR4zpippRqLeJd%2FbackImage.png?alt=media&token=5011a786-bffa-4a5d-af43-c010139b185e")!, dateCreated: "15 May 2021", timestamp: Date.currentTimeStamp, testScore: 0),
    Card(id: "1", subjectID: "-MYVyy9VIQOFe04aA5qy", backImageURL: URL(string: "https://firebasestorage.googleapis.com/v0/b/voiceses-99761.appspot.com/o/users%2F7tWnL6JKhAUn4QtuwcNeSrXfiAn2%2Fsubjects%2F-MYVyy9VIQOFe04aA5qy%2Fcards%2F-M_jkjTR4zpippRqLeJd%2FbackImage.png?alt=media&token=5011a786-bffa-4a5d-af43-c010139b185e")!, frontImageURL: URL(string: "https://firebasestorage.googleapis.com/v0/b/voiceses-99761.appspot.com/o/users%2F7tWnL6JKhAUn4QtuwcNeSrXfiAn2%2Fsubjects%2F-MYVyy9VIQOFe04aA5qy%2Fcards%2F-M_jkjTR4zpippRqLeJd%2FbackImage.png?alt=media&token=5011a786-bffa-4a5d-af43-c010139b185e")!, dateCreated: "15 May 2021", timestamp: Date.currentTimeStamp, testScore: 0),
    Card(id: "3", subjectID: "-MYVyy9VIQOFe04aA5qy", backImageURL: URL(string: "https://firebasestorage.googleapis.com/v0/b/voiceses-99761.appspot.com/o/users%2F7tWnL6JKhAUn4QtuwcNeSrXfiAn2%2Fsubjects%2F-MYVyy9VIQOFe04aA5qy%2Fcards%2F-M_jkjTR4zpippRqLeJd%2FbackImage.png?alt=media&token=5011a786-bffa-4a5d-af43-c010139b185e")!, frontImageURL: URL(string: "https://firebasestorage.googleapis.com/v0/b/voiceses-99761.appspot.com/o/users%2F7tWnL6JKhAUn4QtuwcNeSrXfiAn2%2Fsubjects%2F-MYVyy9VIQOFe04aA5qy%2Fcards%2F-M_jkjTR4zpippRqLeJd%2FbackImage.png?alt=media&token=5011a786-bffa-4a5d-af43-c010139b185e")!, dateCreated: "15 May 2021", timestamp: Date.currentTimeStamp, testScore: 0),
    Card(id: "4", subjectID: "-MYVyy9VIQOFe04aA5qy", backImageURL: URL(string: "https://firebasestorage.googleapis.com/v0/b/voiceses-99761.appspot.com/o/users%2F7tWnL6JKhAUn4QtuwcNeSrXfiAn2%2Fsubjects%2F-MYVyy9VIQOFe04aA5qy%2Fcards%2F-M_jkjTR4zpippRqLeJd%2FbackImage.png?alt=media&token=5011a786-bffa-4a5d-af43-c010139b185e")!, frontImageURL: URL(string: "https://firebasestorage.googleapis.com/v0/b/voiceses-99761.appspot.com/o/users%2F7tWnL6JKhAUn4QtuwcNeSrXfiAn2%2Fsubjects%2F-MYVyy9VIQOFe04aA5qy%2Fcards%2F-M_jkjTR4zpippRqLeJd%2FbackImage.png?alt=media&token=5011a786-bffa-4a5d-af43-c010139b185e")!, dateCreated: "15 May 2021", timestamp: Date.currentTimeStamp, testScore: 0),
    Card(id: "5", subjectID: "-MYVyy9VIQOFe04aA5qy", backImageURL: URL(string: "https://firebasestorage.googleapis.com/v0/b/voiceses-99761.appspot.com/o/users%2F7tWnL6JKhAUn4QtuwcNeSrXfiAn2%2Fsubjects%2F-MYVyy9VIQOFe04aA5qy%2Fcards%2F-M_jkjTR4zpippRqLeJd%2FbackImage.png?alt=media&token=5011a786-bffa-4a5d-af43-c010139b185e")!, frontImageURL: URL(string: "https://firebasestorage.googleapis.com/v0/b/voiceses-99761.appspot.com/o/users%2F7tWnL6JKhAUn4QtuwcNeSrXfiAn2%2Fsubjects%2F-MYVyy9VIQOFe04aA5qy%2Fcards%2F-M_jkjTR4zpippRqLeJd%2FbackImage.png?alt=media&token=5011a786-bffa-4a5d-af43-c010139b185e")!, dateCreated: "15 May 2021", timestamp: Date.currentTimeStamp, testScore: 0)
]
