import Foundation

import Combine

public enum SampleError: Error {
    case sampleError
}

public func check<P: Publisher>(
    _ title: String,
    publisher: () -> P
) -> AnyCancellable {
    print("----- \(title) -----")
    defer {
        print("")
    }
    return publisher()
        .print()
        .sink(
            receiveCompletion: {_ in},
            receiveValue: {_ in}
        )
}


extension Sequence {
    public func scan<ResultElement>(
        _ initial: ResultElement,
        _ nextPartialResult: (ResultElement, Element) -> ResultElement
    ) -> [ResultElement] {
        var result: [ResultElement] = []
        for x in self {
            result.append(nextPartialResult(result.last ?? initial, x))
        }
        return result
    }
    
//    public func map<T>(_ transform: (Elements.Element) -> T) -> Publishers.Sequence<[T], Failure> {
//        return Publishers.Sequence(sequence: sequence.map(transform))
//    }
}

public func loadPage(
    url: URL,
    handler: @escaping(Data?, URLResponse?, Error?) -> Void
) {
    URLSession.shared.dataTask(with: url) { (data, response, error) in
        handler(data, response, error)
    }.resume()
}


public func delay(_ second: Int, action: @escaping ()->Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + DispatchTimeInterval.seconds(second), execute: action)
}

extension String {
     
    //将原始的url编码为合法的url
    public func urlEncoded() -> String? {
        let encodeUrlString = self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        return encodeUrlString
    }
     
    //将编码后的url转换回原始的url
    public func urlDecoded() -> String? {
        return self.removingPercentEncoding
    }
    
    // 去除首尾空格
    public func removeWhitespaces() -> String {
        return self.trimmingCharacters(in: .whitespaces)
    }
}
