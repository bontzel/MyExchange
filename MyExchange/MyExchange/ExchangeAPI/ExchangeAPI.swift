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
        
        case login = "prof/auth"
        
        private var baseURL: String {
            return "https://api.owners.kia.com/"
        }
        var url: URL {
            return URL(string: baseURL.appending(rawValue))!
        }
    }
    
    // MARK: - API errors
    enum Errors: Error {
        case requestFailed
    }
    
    //MARK: - Decoder
    static func jsonDecoder(contentIdentifier: String) -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.userInfo[.contentIdentifier] = contentIdentifier
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
    
    // MARK: - generic request to send an SLRequest
    static private func request(_ sid: String, address: Address, parameters: Parameters = [:]) -> Observable<JSONObject> {
        
        return Observable.create { observer in
            
            let request = Alamofire.request(address.url.absoluteString,
                                            method: .get,
                                            parameters: parameters,
                                            encoding: URLEncoding.httpBody,
                                            headers: [:])
            
            request.responseJSON { response in
                guard response.error == nil, let data = response.data,
                    let json = try? JSONSerialization.jsonObject(with: data, options: []) as? JSONObject else {
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
