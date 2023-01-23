import Foundation


class Session {
    private init() {}
    
    static let share = Session()
    
    var token = ""
    var userId = ""
}
