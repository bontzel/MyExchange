//
//  ExchangeAPI.swift
//  MyExchange
//
//  Created by Cosmin Bonta on 8/9/19.
//  Copyright © 2019 Cosmin Bonta. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

typealias JSONObject = [String: Any]

extension CodingUserInfoKey {
    static let contentIdentifier = CodingUserInfoKey(rawValue: "contentIdentifier")!
}

struct ExchangeAPI {
    
    // MARK: - API Addresses
    fileprivate enum Address: String {
        
        case latest = "latest"
        
        private var baseURL: String {
            return "https://api.exchangeratesapi.io/"
        }
        
        var url: URL {
            return URL(string: baseURL.appending(rawValue))!
        }
    }
    
    // MARK: - API errors
    enum Errors: Error {
        case requestFailed
        case invalidDecoder
    }
    
    //MARK: - Decoder
    static func jsonDecoder(contentIdentifier: String) -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.userInfo[.contentIdentifier] = contentIdentifier
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
    
    //MARK: - endpoints
    
    static var latest: Observable<Quote> = {
        
        let request: Observable<Quote> = ExchangeAPI.request(address: .latest)
    
        return request
        
    }()
    
    
    // MARK: - generic request to send an SLRequest
    static private func request<T: Decodable>(address: Address, parameters: Parameters = [:]) -> Observable<T> {
        
        return Observable.create { observer in
            
            let request = Alamofire.request(address.url.absoluteString,
                                            method: .get,
                                            parameters: parameters,
                                            encoding: URLEncoding.httpBody,
                                            headers: [:])
            
            request.responseJSON { response in
                guard response.error == nil, let data = response.data,
                    let json = try? JSONDecoder.init().decode(Quote.self, from: data) as? T else {
                        observer.onError(Errors.requestFailed)
                        return
                }
                
                observer.onNext(json)
                observer.onCompleted()
            }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
}
