//
//  MyExchangeTests.swift
//  MyExchangeTests
//
//  Created by Cosmin Bonta on 8/9/19.
//  Copyright © 2019 Cosmin Bonta. All rights reserved.
//

import XCTest
import RxSwift
import RxBlocking
import Nimble
import RxNimble
import OHHTTPStubs


@testable import MyExchange

class MyExchangeTests: XCTestCase {

    override func setUp() {
        super.setUp()

        if let path = Bundle.main.path(forResource: "latest", ofType: "json") {
            stub(condition: isHost("exchangeratesapi.io")) { _ in
                return OHHTTPStubsResponse(fileAtPath: path, statusCode: 200, headers: nil)
            }
        }

    }
    
    override func tearDown() {
        super.tearDown()
        OHHTTPStubs.removeAllStubs()
    }
    
    func testQuote() {
        
        let obs = ExchangeAPI.latest(for: "EUR")
        
        guard let quote = obs.toBlocking().firstOrNil() else {
            XCTFail()
            return
        }
        
        expect(quote.base == "EUR").to(beTrue())
        expect(quote.rates).toNot(beNil())
        expect(quote.rates.count > 0).to(beTrue())
        expect(quote.rates.first?.0).toNot(beNil())
        expect(quote.rates.first?.1).toNot(beNil())
    
        
    }

}

extension BlockingObservable {
    func firstOrNil() -> E? {
        do {
            return try first()
        } catch {
            return nil
        }
    }
}
