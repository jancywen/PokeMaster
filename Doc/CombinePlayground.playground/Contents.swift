import Cocoa
import Combine
import Foundation
//[1, 23,4].scan(0, +)
/*
["A", "B", "C"]
    .publisher
    .flatMap { letter in
        
        [1, 2, 3].publisher.map{"\(letter)\($0)"}
    }
    .print()
    .sink(
        receiveCompletion: {_ in},
        receiveValue: {_ in}
    )


[[1, 2, 3], [4, 5, 6]]
    .publisher
    .flatMap {
        $0.publisher
    }
    .print()
    .sink(
        receiveCompletion: {_ in},
        receiveValue: {_ in}
    )

check("Catch and Continue") {
    ["1", "2", "some", "4"]
        .publisher
        .flatMap { s in
            return Just<String>(s)
                .tryMap {s -> Int in
                    guard let value = Int(s) else {
                        throw SampleError.sampleError
                    }
                    return value
                }
                .catch{_ in Just(-1)}
        }
}
 */

/*
let subject_example1 = PassthroughSubject<Int, Never>()
let subject_example2 = PassthroughSubject<Int, Never>()

check("Subject Order") {
    subject_example1.merge(with: subject_example2)
}

subject_example1.send(10)
subject_example2.send(20)
subject_example2.send(21)
subject_example1.send(14)
subject_example1.send(16)
subject_example2.send(25)
*/

/*
let future = check("Future") {
    Future<(Data, URLResponse), Error>{promise in
        loadPage(url: URL(string: "https://example.com")!) { (data, response, error) in
            if let data = data, let response = response {
                promise(.success((data, response)))
            }else {
                promise(.failure(error!))
            }
        }
    }
}
*/

/*
struct SampleModel {
    var id: Int?
}

func sampleRequestAction(handler: @escaping(SampleModel?, Error?) -> Void) {
    print("模拟延时")
    DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
        print("延时结束返回")
        handler(SampleModel(id: 5), nil)
    }
}

Future<SampleModel, Error> { promise in
    sampleRequestAction { (model, err) in
        print("promise")
        if let model = model {
            promise(.success(model))
        }else {
            promise(.failure(err!))
        }
    }
}
.subscribe(on: RunLoop.main)
.sink { (complete) in
    print("complete")
    if case .failure(let msg) = complete {
        print(msg)
    }
} receiveValue: { (model) in
    print("receiveValue")
    print(model.id)
}


check("Sample") {
    Future<SampleModel, Error> { promise in
        sampleRequestAction { (model, err) in
            if let model = model {
                promise(.success(model))
            }else {
                promise(.failure(err!))
            }
        }
    }.subscribe(on: RunLoop.main)
}
*/

/*
let subject = PassthroughSubject<(), Never>()
Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
    subject.send()
}

*/

/*
struct Response: Decodable {
    struct Args: Decodable {
        let foo: String
    }
    
    let args: Args?
}

URLSession.shared
    .dataTaskPublisher(for: URL(string: "https://httpbin.org/get?foo=bar")!)
    .map{ data, _ in data }
    .decode(type: Response.self, decoder: JSONDecoder())
    .compactMap{$0.args?.foo}
    .subscribe(on: RunLoop.main)
    .print()
    .sink(receiveCompletion: {_ in}) { (foo) in
        print(foo)
    }
*/

/*
let timer = Timer.publish(every: 1, on: .main, in: .default)
timer
    .print()
    .sink { (date) in
        print(date)
    }

*/

/*
class Wrapper {
    @Published var text: String = "hhoo"
}
var wrapper = Wrapper()
wrapper.$text.print().sink { _ in }
wrapper.text = "1222"

*/

/*
class Clock {
    var timeString: String = "" {
        didSet {print("\(timeString)")}
    }
}

let clock = Clock()

let formatter = DateFormatter()
formatter.timeStyle = .medium

let timer = Timer.publish(every: 1, on: .main, in: .default)
var token = timer.map{formatter.string(from:$0)}.assign(to: \.timeString, on: clock)
timer.connect()

var anycancel = AnyCancellable(token)

DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//    token.cancel()
    anycancel.cancel()
}
*/

/*
struct Response: Decodable {
    struct Args: Decodable {
        let foo: String
    }
    let args: Args?
}

let searchText = PassthroughSubject<String, Never>()
searchText
    .scan("", { "\($0) \($1)"})
    .debounce(for: .seconds(3), scheduler: RunLoop.main)
    .compactMap{$0.removeWhitespaces().urlEncoded()}
    .flatMap { text in
        return URLSession.shared
            .dataTaskPublisher(for: URL(string: "https://httpbin.org/get?foo=\(text)")!)
            .subscribe(on: RunLoop.main)
            .map{data, _ in data}
            .decode(type: Response.self, decoder: JSONDecoder())
            .compactMap{$0.args?.foo.urlDecoded()}
            .replaceError(with: text)
    }.eraseToAnyPublisher()
    .subscribe(on: RunLoop.main)
    .print()
    .sink(receiveValue: {_ in})

delay(0) { searchText.send("I") }
delay(1) { searchText.send("Love") }
delay(2) { searchText.send("SwifUI") }
delay(6) { searchText.send("And") }
delay(8) { searchText.send("Combine") }
*/


let searchText = PassthroughSubject<String, Never>()
//searchText
//    .scan("", { "\($0) \($1)"})
//    .debounce(for: .seconds(3), scheduler: RunLoop.main)
//    .compactMap{$0.removeWhitespaces()}
//    .subscribe(on: RunLoop.main)
//    .print()
//    .sink(receiveValue: {_ in})

searchText
//    .scan("", { "\($0) \($1)"})
    .debounce(for: .seconds(3), scheduler: RunLoop.main)
    .throttle(for: .seconds(3), scheduler: RunLoop.main, latest: false)
    .compactMap{$0.removeWhitespaces()}
    .subscribe(on: RunLoop.main)
    .print()
    .sink(receiveValue: {_ in})

//searchText.send("start")
delay(0) { searchText.send("0") }
delay(1) { searchText.send("1") }
delay(2) { searchText.send("2") }
delay(3) { searchText.send("3") }
delay(4) { searchText.send("4") }
delay(5) { searchText.send("5") }
delay(6) { searchText.send("6") }
delay(7) { searchText.send("7") }
delay(8) { searchText.send("8") }
delay(9) { searchText.send("9") }

delay(10) { searchText.send("10") }
delay(11) { searchText.send("11") }
delay(12) { searchText.send("12") }
delay(13) { searchText.send("13") }
