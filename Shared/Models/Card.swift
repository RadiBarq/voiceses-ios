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
    let backImageURL: URL
    let frontImageURL: URL
    let dateCreated: String
    let timestamp: Int64
}

var testCards = [
    Card(id: UUID().uuidString, subjectID: "-MYVyy9VIQOFe04aA5qy", backImageURL: URL(string: "https://firebasestorage.googleapis.com/v0/b/voiceses-99761.appspot.com/o/users%2F7tWnL6JKhAUn4QtuwcNeSrXfiAn2%2Fsubjects%2F-MYVyy9VIQOFe04aA5qy%2Fcards%2F-M_jkjTR4zpippRqLeJd%2FbackImage.png?alt=media&token=5011a786-bffa-4a5d-af43-c010139b185e")!, frontImageURL: URL(string: "https://firebasestorage.googleapis.com/v0/b/voiceses-99761.appspot.com/o/users%2F7tWnL6JKhAUn4QtuwcNeSrXfiAn2%2Fsubjects%2F-MYVyy9VIQOFe04aA5qy%2Fcards%2F-M_jkjTR4zpippRqLeJd%2FbackImage.png?alt=media&token=5011a786-bffa-4a5d-af43-c010139b185e")!, dateCreated: "15 May 2021", timestamp: Date.currentTimeStamp),
    Card(id: UUID().uuidString, subjectID: "-MYVyy9VIQOFe04aA5qy", backImageURL: URL(string: "https://firebasestorage.googleapis.com/v0/b/voiceses-99761.appspot.com/o/users%2F7tWnL6JKhAUn4QtuwcNeSrXfiAn2%2Fsubjects%2F-MYVyy9VIQOFe04aA5qy%2Fcards%2F-M_jkjTR4zpippRqLeJd%2FbackImage.png?alt=media&token=5011a786-bffa-4a5d-af43-c010139b185e")!, frontImageURL: URL(string: "https://firebasestorage.googleapis.com/v0/b/voiceses-99761.appspot.com/o/users%2F7tWnL6JKhAUn4QtuwcNeSrXfiAn2%2Fsubjects%2F-MYVyy9VIQOFe04aA5qy%2Fcards%2F-M_jkjTR4zpippRqLeJd%2FbackImage.png?alt=media&token=5011a786-bffa-4a5d-af43-c010139b185e")!, dateCreated: "15 May 2021", timestamp: Date.currentTimeStamp),
    Card(id: UUID().uuidString, subjectID: "-MYVyy9VIQOFe04aA5qy", backImageURL: URL(string: "https://firebasestorage.googleapis.com/v0/b/voiceses-99761.appspot.com/o/users%2F7tWnL6JKhAUn4QtuwcNeSrXfiAn2%2Fsubjects%2F-MYVyy9VIQOFe04aA5qy%2Fcards%2F-M_jkjTR4zpippRqLeJd%2FbackImage.png?alt=media&token=5011a786-bffa-4a5d-af43-c010139b185e")!, frontImageURL: URL(string: "https://firebasestorage.googleapis.com/v0/b/voiceses-99761.appspot.com/o/users%2F7tWnL6JKhAUn4QtuwcNeSrXfiAn2%2Fsubjects%2F-MYVyy9VIQOFe04aA5qy%2Fcards%2F-M_jkjTR4zpippRqLeJd%2FbackImage.png?alt=media&token=5011a786-bffa-4a5d-af43-c010139b185e")!, dateCreated: "15 May 2021", timestamp: Date.currentTimeStamp),
    Card(id: UUID().uuidString, subjectID: "-MYVyy9VIQOFe04aA5qy", backImageURL: URL(string: "https://firebasestorage.googleapis.com/v0/b/voiceses-99761.appspot.com/o/users%2F7tWnL6JKhAUn4QtuwcNeSrXfiAn2%2Fsubjects%2F-MYVyy9VIQOFe04aA5qy%2Fcards%2F-M_jkjTR4zpippRqLeJd%2FbackImage.png?alt=media&token=5011a786-bffa-4a5d-af43-c010139b185e")!, frontImageURL: URL(string: "https://firebasestorage.googleapis.com/v0/b/voiceses-99761.appspot.com/o/users%2F7tWnL6JKhAUn4QtuwcNeSrXfiAn2%2Fsubjects%2F-MYVyy9VIQOFe04aA5qy%2Fcards%2F-M_jkjTR4zpippRqLeJd%2FbackImage.png?alt=media&token=5011a786-bffa-4a5d-af43-c010139b185e")!, dateCreated: "15 May 2021", timestamp: Date.currentTimeStamp),
    Card(id: UUID().uuidString, subjectID: "-MYVyy9VIQOFe04aA5qy", backImageURL: URL(string: "https://firebasestorage.googleapis.com/v0/b/voiceses-99761.appspot.com/o/users%2F7tWnL6JKhAUn4QtuwcNeSrXfiAn2%2Fsubjects%2F-MYVyy9VIQOFe04aA5qy%2Fcards%2F-M_jkjTR4zpippRqLeJd%2FbackImage.png?alt=media&token=5011a786-bffa-4a5d-af43-c010139b185e")!, frontImageURL: URL(string: "https://firebasestorage.googleapis.com/v0/b/voiceses-99761.appspot.com/o/users%2F7tWnL6JKhAUn4QtuwcNeSrXfiAn2%2Fsubjects%2F-MYVyy9VIQOFe04aA5qy%2Fcards%2F-M_jkjTR4zpippRqLeJd%2FbackImage.png?alt=media&token=5011a786-bffa-4a5d-af43-c010139b185e")!, dateCreated: "15 May 2021", timestamp: Date.currentTimeStamp)
]
