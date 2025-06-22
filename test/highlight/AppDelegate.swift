import Cocoa
// ^ keyword.import
import GRDB

@NSApplicationMain
// ^ attribute
class AppDelegate: NSObject, NSApplicationDelegate {
// ^ keyword.type
//    ^ type
//               ^ punctuation.delimiter
//                 ^ type
//                         ^ punctuation.delimiter
//                                                 ^ punctuation.bracket
    func applicationDidFinishLaunching(_ aNotification: Notification) {
//  ^ keyword.function
//       ^ function.method
//                                     ^ variable.parameter
//                                       ^ variable.parameter
        _ = try! DatabaseQueue()
//        ^ operator
//          ^ keyword.exception
        _ = FTS5()
        _ = sqlite3_preupdate_new(nil, 0, nil)
//                                ^ constant.builtin
//                                     ^ number
    }
//  ^ punctuation.bracket
}
