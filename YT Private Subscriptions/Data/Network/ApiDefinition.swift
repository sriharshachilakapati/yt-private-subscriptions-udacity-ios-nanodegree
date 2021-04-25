//
//  ApiDefinition.swift
//  YT Private Subscriptions
//
//  Created by Sri Harsha Chilakapati on 25/04/21.
//

import Foundation
import RxSwift
import RxCocoa

/// A request type to use when you don't want to send any parameters in the API call. This applies only to Query
/// parameters for `GET` and `DELETE` requests and to HTTP Payload attached to `POST` requests.
typealias NilRequest = [String: String]

/// A response type that wraps the binary data. To be used if you are downloading a file for example.
struct BinaryResponse: Codable {
    let data: Data
}

/// A definition for an API. This allows to define the API in a declarative manner and then use those declarations to
/// make the calls. Supports multiple HTTP methods and also auto-mapping of requests to either query parameters or HTTP
/// body depending on the method to be used.
struct ApiDefinition<RequestType: Encodable, ResponseType: Decodable> {
    let url: String
    let method: HttpMethod
    let getDecodableResponseRange: (Data) -> Range<Int> = { data in 0 ..< data.count }
    let headers: () -> [String: String] = { [:] }

    /// Calls the API endpoint with some `payload` and returns the response in an `Observable`
    /// - Parameters:
    ///   - payload: The payload that needs to be sent across the network.
    /// - Returns: An Observable that allows observing values
    func performCall(withPayload payload: RequestType) -> Observable<ResponseType> {
        let url = URL(string: self.url)!

        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 500)
        request.httpMethod = method.rawValue

        // Set the headers
        for header in headers() {
            request.addValue(header.value, forHTTPHeaderField: header.key)
        }

        // Handle the payload
        do {
            let encodedPayload = try JSONEncoder().encode(payload)

            switch method {
                case .get, .delete:
                    // GET and DELETE uses Query parameters
                    let queryParams = try JSONSerialization.jsonObject(with: encodedPayload, options: []) as! [String: Any]
                    request.setQueryParameters(queryParams)

                case .post:
                    // POST takes it as a body
                    request.httpBody = encodedPayload
            }
        } catch {
            return Observable.error(error)
        }

        // Define the observable to perform data request
        return URLSession.shared.rx.data(request: request)
            .flatMap { data -> Observable<ResponseType> in
                if ResponseType.self == BinaryResponse.self {
                    return Observable.just(BinaryResponse(data: data) as! ResponseType)
                }

                do {
                    let subsetRange = getDecodableResponseRange(data)
                    let newData = data.subdata(in: subsetRange)
                    return Observable.just(try JSONDecoder().decode(ResponseType.self, from: newData))
                } catch {
                    return Observable.error(error)
                }
            }
            .share()
    }
}

/// The method to be used to make a HTTP request.
enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
}
