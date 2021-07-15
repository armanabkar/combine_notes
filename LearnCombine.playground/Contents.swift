import Combine
import Foundation
import UIKit
import XCTest

let _ = Just("Hello World")
    .sink { (value) in
        print("value is \(value)")
    }

// Subscriber
let notification = Notification(name: .NSSystemClockDidChange, object: nil, userInfo: nil)
// Publisher
let notificationClockPublisher = NotificationCenter.default.publisher(for: .NSSystemClockDidChange)
    .sink { (value) in
        print("value is \(value)")
    }
NotificationCenter.default.post(notification)

// Operators
[1, 5, 9, 10]
    .publisher
    .map { $0 * $0}
    .sink { print($0) }
let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
struct Task: Decodable {
    let id: Int
    let title: String
    let userId: Int
    let body: String
}
let dataPublisher = URLSession.shared.dataTaskPublisher(for: url)
    .map { $0.data }
    .decode(type: [Task].self, decoder: JSONDecoder())
let cancellableSink = dataPublisher
    .sink { (completion) in
        print(completion)
    } receiveValue: { items in
        print("Result \(items[0].title)")
    }

// Subscribers
[1, 5, 9]
    .publisher
    .sink { print($0) }
let label = UILabel()
Just("Arman")
    .map { "My name is \($0)" }
    .assign(to: \.text, on: label)

// Subjects
let subject = PassthroughSubject<Int, Never>()
let subscription = subject
    .sink { print($0) }
subject.send(94)
Just(29)
    .subscribe(subject)
let anotherSubject = CurrentValueSubject<String, Never>("I am a...")
let anotherSubscription = anotherSubject
    .sink {print($0)}
anotherSubject.send("Subject")

// Just $ Future
enum FutureError: Error {
    case notMultiple
}
let future = Future<String, FutureError> { promise in
    let calendar = Calendar.current
    let second = calendar.component(.second, from: Date())
    print("second is \(second)")
    if second.isMultiple(of: 3) {
        promise(.success("We are successful: \(second)"))
    } else {
        promise(.failure(.notMultiple))
    }
}
.catch({ error in
    Just("Caught the error")
})
.delay(for: .init(integerLiteral: 1), scheduler: RunLoop.main)
.eraseToAnyPublisher()
future.sink(receiveCompletion: {print($0)}, receiveValue: {print($0)})

// Call REST API with Error Handling
struct Post: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}
let samplePost = Post(userId: 1, id: 1, title: "Post Title", body: "This is and post body")
let publisher = URLSession.shared.dataTaskPublisher(for: url)
    .map {$0.data}
    .decode(type: Array<Post>.self, decoder: JSONDecoder())
let cancellableSink2 = publisher
    .retry(2)
    .mapError({ (error) -> Error in
        switch error {
            case URLError.cannotFindHost:
                fatalError(error.localizedDescription)
            default:
                fatalError(error.localizedDescription)
        }
    })
    .sink { (completion) in
        print(String(describing: completion))
    } receiveValue: { (value) in
        print("returned value \(value[0])")
    }

// Scheduler
let queue = DispatchQueue(label: "a queue")

// Backpressure
let cityPublisher = (["San Jose", "San Francisco", "Palo Alto", "Menlo Park"])
    .publisher
final class CitySubscriber: Subscriber {
    func receive(subscription: Subscription) {
        subscription.request(.max(3))
    }
    func receive(_ input: String) -> Subscribers.Demand {
        print("City: \(input)")
        return .none
    }
    func receive(completion: Subscribers.Completion<Never>) {
        print("Subscription \(completion)")
    }
    typealias Input = String
    typealias Failure = Never
}
let citySubscription = CitySubscriber()
cityPublisher.subscribe(citySubscription)

// Advanced Operators
let numbers = (1...20)
let numbersTwo = (21...40)
let words = (21...40)
    .compactMap {String($0)}
    .publisher
let cancellableSink3 = numbers
    //.filter {$0 % 2 == 0}
    //.compactMap {value in Float(value)}
    //.first()
    //.last(where: {$0 < 20})
    //.dropFirst()
    //.drop(while: {$0 % 3 == 0})
    //.prefix(4)
    //.prefix(while: {$0 < 5})
    //.append(21, 22, 23)
    //.prepend(21, 22, 23)
    //.merge(with: numbersTwo)
    //.combineLatest(words)
    //.zip(numbersTwo)
    //.collect()
    //.sink {print($0)}
