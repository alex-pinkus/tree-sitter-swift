import Foundation

protocol SomeProtocol {}
protocol SomeProtocol<T>: Encodable, Decodable where T == Element {}

public class SomeClass: Codable {

    var somesss = 0
    let another = 111
    var sieee: Int = 11
    func some(zzz: String, xxx: Int) {}
    public func some(sommm: Int, _ another: String) {

    }

    public func somess<T, V>(_ sss: T, xxx: V) -> V? {}
    public func somess<T, V>(_ sss: T, xxx: V) -> V {}
    func some(_ completion: @escaping ((String) -> Void)) {
    }
    func anotherFucn() -> (String, Int) {}
    func anotherFucn() -> [String: Int] {}
    func anotherFucxn() -> [String] {}
    func anotherFucn() -> Set<String> {}
    func anotherFucn() -> [String] {}
    func anotherFucn() async -> [String] {}
    func anotherFucn() throws -> [String] {}
    func anotherFucn() async throws -> [String] {}
}

func someExternalFunc() {}

extension SomeProtocol: Encodable, Decodable {}

actor SomeActor {
    var goodVar = 11
    func somssssse() {}
    func some(x: Int, _ y: String) -> String? {
        var wrongVar = 111
    }

    func llll() -> String { "" }
    init(_ vars: String) {}
    deinit {}
}

class SomeClass<T, V>: Codable where T: Decodable, V: Encodable {
    struct SomeAnother {
        init() {

        }
    }
    init<T, V>(_ sss: T, xxx: V) {

    }
}

// TODO: Some stuff
// FIXME: Some fix
// MARK: Some mark

struct SomeAAA {
    struct SomeBBBB {
        let ppppp: Int?
    }
    enum Some {
        case some
    }
    var xxxx: String?
}

//extension SomeAAA.SomeBBBB { // breaks breadcrumbs
//    var someVariable: String { "" }
//}
