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
        case history = "history"
        
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
        case parseFailed
    }
    
    //MARK: - Decoder
    static func jsonDecoder(contentIdentifier: String) -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.userInfo[.contentIdentifier] = contentIdentifier
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
    
    //MARK: - endpoints
    
    static func lastFiveDaysHistory(for base: String) -> Observable<HistoryQuote> {
        
        var params = Parameters()
        
        params["start_at"] = Date().addingTimeInterval(-432000.0).paramString()
        params["end_at"] = Date().paramString()
        
        let request: Observable<HistoryQuote> = ExchangeAPI.request(address: .history, parameters: params)
        
        return request
        
    }
    
    static func latest(for base: String) -> Observable<Quote> {
        
        var params = Parameters()
        
        params["base"] = base
        
        let request: Observable<Quote> = ExchangeAPI.request(address: .latest, parameters: params)

        return request
        
    }
    
    static var symbols: Observable<[String]> = {
        
        if let path = Bundle.main.path(forResource: "symbols", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)

                let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! JSONObject
                
                let symbols = json["symbols"] as? [String]

                return Observable.just(symbols ?? [])
            } catch {
                print("file read error -> \(error)")
            }
        }
        
        return Observable.just([])
        
    }()

    
    
    // MARK: - generic request to send an SLRequest
    static private func request<T: Decodable>(address: Address, parameters: Parameters = [:]) -> Observable<T> {
        
        return Observable.create { observer in
            
            var comps = URLComponents(string: address.url.absoluteString)!
            comps.queryItems = parameters.sorted{ $0.0 < $1.0 }.map({ (arg0) -> URLQueryItem in
                
                let (key, value) = arg0
                return URLQueryItem.init(name: key, value: (value as! String))
            })
            let url = try! comps.asURL()
            
            let request = Alamofire.request(url,
                                            method: .get,
                                            parameters: Parameters(),
                                            encoding: URLEncoding.httpBody,
                                            headers: [:])
            
            request.responseJSON { response in
                guard response.error == nil, let data = response.data,
                    let json = try? JSONDecoder.init().decode(T.self, from: data) else {
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
