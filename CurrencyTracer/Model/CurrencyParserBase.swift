import Foundation

class CurrencyParserBase: CurrencyParserBaseProtocol
{
    var url: String = ""
    
    func startLoading(delegate: CurrencyChangesNotifierProtocol?) {
        
        guard let url = URL(string: url) else {
            fatalError("Can't create url.")
        }
        let task = URLSession.shared.dataTask(with: url)
        {
            data, response, error in
            if let error = error
            {
                print(error)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else
            {
                fatalError("HTTPS status is invalid.")
            }
            if let mimeType = httpResponse.mimeType, mimeType == "application/javascript",
                let jsonString = String(data: data!, encoding: .utf8)
            {
                do
                {
                    let result = try self.parseJson(jsonString: jsonString)
                    if(delegate != nil) {
                        DispatchQueue.main.async {
                            delegate!.notify(currency: result.1[0])
                        }
                    }
                }
                catch JsonParsingErrors.jsonObjectNil {
                    print("JSON object can't be created.")
                }
                catch JsonParsingErrors.parsingError(let e) {
                    print(e)
                }
                catch JsonParsingErrors.securitiesColumnsNotFound {
                    print("Securities columns couldn't be found.")
                }
                catch JsonParsingErrors.securitiesDataNotFound {
                    print("Securities data couldn't be found.")
                }
                catch JsonParsingErrors.securitiesNotFound {
                    print("Securities couldn't be found.")
                }
                catch {
                    print("Unexpected exception occurred.")
                }
            }
        }
        task.resume()
    }
    
    func parseJson(jsonString: String) throws -> (Array<[SecurityData]>, Array<[MarketData]>) {
        let firstIndex = jsonString.firstIndex(of: "{")!
        let lastIndex = jsonString.lastIndex(of: "}")!
        let prefixRange = firstIndex...lastIndex
        let prefix = jsonString[prefixRange]
        let jsonData = prefix.data(using: .utf8)!
        let json = try JSONSerialization.jsonObject(with: jsonData, options: [])
        let securities = try parseSecurities(json: json)
        let marketData = try parseMarketData(json: json)
        return (securities, marketData)
    }
    
    func parseMarketData(json: Any?) throws -> Array<Array<MarketData>> {
        if(json == nil) {
            throw JsonParsingErrors.jsonObjectNil
        }
        guard let dictionary = json as? [String: Any] else {
            throw JsonParsingErrors.parsingError("Not a dictionary structure.")
        }
        guard let marketData = dictionary["marketdata"] as? [String: Any] else {
            throw JsonParsingErrors.marketDataNotFound
        }
        guard let datas = marketData["data"] as? Array<Array<Any>> else {
            throw JsonParsingErrors.marketDataDataNotFound
        }
        var marketDataEntities = Array(repeating: Array<MarketData>(), count: datas.count)
        guard let columns = marketData["columns"] as? [String] else {
            throw JsonParsingErrors.marketDataColumnsNotFound
        }
        for i in 0..<datas.count
        {
            let data = datas[i]
            for j in 0..<columns.count
            {
                let columnId = MarketDataColumns(rawValue: columns[j])!
                switch columnId
                {
                    case .highBid:
                        marketDataEntities[i].append((.highBid(data[j] as? Double)))
                    case .bidDepth:
                        marketDataEntities[i].append((.bidDepth(data[j] as? Double)))
                    case .lowOffer:
                        marketDataEntities[i].append((.lowOffer(data[j] as? Double)))
                    case .offerDepth:
                        marketDataEntities[i].append((.offerDepth(data[j] as? Double)))
                    case .spread:
                        marketDataEntities[i].append((.spread(data[j] as! Double)))
                    case .high:
                        marketDataEntities[i].append((.high(data[j] as! Double)))
                    case .low:
                        marketDataEntities[i].append((.low(data[j] as! Double)))
                    case .open:
                        marketDataEntities[i].append((.open(data[j] as! Double)))
                    case .last:
                        marketDataEntities[i].append((.last(data[j] as! Double)))
                    case .lastCngToLastWaPrice:
                        marketDataEntities[i].append((.lastCngToLastWaPrice(data[j] as! Double)))
                    case .valToday:
                        marketDataEntities[i].append((.valToday(data[j] as! Int)))
                    case .volToday:
                        marketDataEntities[i].append((.volToday(data[j] as! Int)))
                    case .valTodayUsd:
                        marketDataEntities[i].append((.valTodayUsd(data[j] as! Int)))
                    case .waPrice:
                        marketDataEntities[i].append((.waPrice(data[j] as! Double)))
                    case .wapToPrevWaPrice:
                        marketDataEntities[i].append((.wapToPrevWaPrice(data[j] as! Double)))
                    case .closePrice:
                        marketDataEntities[i].append((.closePrice(data[j] as? Double)))
                    case .numTrades:
                        marketDataEntities[i].append((.numTrades(data[j] as! Int)))
                    case .tradingStatus:
                        marketDataEntities[i].append((.tradingStatus(data[j] as! String)))
                    case .updateTime:
                        marketDataEntities[i].append((.updateTime(data[j] as! String)))
                    case .boardId:
                        marketDataEntities[i].append((.boardId(data[j] as! String)))
                    case .secId:
                        marketDataEntities[i].append((.secId(data[j] as! String)))
                    case .wapToPrevWaPricePrcnt:
                        marketDataEntities[i].append((.wapToPrevWaPricePrcnt(data[j] as! Double)))
                    case .bid:
                        marketDataEntities[i].append((.bid(data[j] as? Double)))
                    case .bidDepthT:
                        marketDataEntities[i].append((.bidDepthT(data[j] as? Double)))
                    case .numBids:
                        marketDataEntities[i].append((.numBids(data[j] as? Double)))
                    case .offer:
                        marketDataEntities[i].append((.offer(data[j] as? Double)))
                    case .offerDepthT:
                        marketDataEntities[i].append((.offerDepthT(data[j] as? Double)))
                    case .numOffers:
                        marketDataEntities[i].append((.numOffers(data[j] as? Double)))
                    case .change:
                        marketDataEntities[i].append((.change(data[j] as! Double)))
                    case .lastChangePrcnt:
                        marketDataEntities[i].append((.lastChangePrcnt(data[j] as! Double)))
                    case .value:
                        marketDataEntities[i].append((.value(data[j] as! Int)))
                    case .valueUsd:
                        marketDataEntities[i].append((.valueUsd(data[j] as! Double)))
                    case .seqNum:
                        marketDataEntities[i].append((.seqNum(data[j] as! Int)))
                    case .qty:
                        marketDataEntities[i].append((.qty(data[j] as! Int)))
                    case .time:
                        marketDataEntities[i].append((.time(data[j] as! String)))
                    case .priceMinusPrevWaPrice:
                        marketDataEntities[i].append((.priceMinusPrevWaPrice(data[j] as! Double)))
                    case .lastChange:
                        marketDataEntities[i].append((.lastChange(data[j] as! Double)))
                    case .lastToPrevPrice:
                        marketDataEntities[i].append((.lastToPrevPrice(data[j] as! Double)))
                    case .valTodayRur:
                        marketDataEntities[i].append((.valTodayRur(data[j] as! Int)))
                    case .sysTime:
                        marketDataEntities[i].append((.sysTime(data[j] as! String)))
                    case .marketPrice:
                        marketDataEntities[i].append((.marketPrice(data[j] as! Double)))
                    case .marketPriceToday:
                        marketDataEntities[i].append((.marketPriceToday(data[j] as? Double)))
                    case .marketPrice2:
                        marketDataEntities[i].append((.marketPrice2(data[j] as? Double)))
                    case .admitTedQuote:
                        marketDataEntities[i].append((.admitTedQuote(data[j] as? Double)))
                }
            }
        }
        return marketDataEntities;
    }
    
    func parseSecurities(json: Any?) throws -> Array<Array<SecurityData>> {
        if(json == nil) {
            throw JsonParsingErrors.jsonObjectNil
        }
        
        guard let dictionary = json as? [String: Any] else {
            throw JsonParsingErrors.parsingError("Not a dictionary structure.")
        }
        
        guard let securities = dictionary["securities"] as? [String: Any] else {
            throw JsonParsingErrors.securitiesNotFound
        }
        
        guard let datas = securities["data"] as? Array<Array<Any>> else {
            throw JsonParsingErrors.securitiesDataNotFound
        }
        var securitiesEntities = Array(repeating: Array<SecurityData>(), count: datas.count)
        guard let columns = securities["columns"] as? [String] else {
            throw JsonParsingErrors.securitiesColumnsNotFound
        }
        for i in 0..<datas.count
        {
            let data = datas[i]
            for j in 0..<columns.count
            {
                let columnId = SecurityColumns(rawValue: columns[j])!
                switch columnId
                {
                    case .secid:
                        securitiesEntities[i].append(.secid(data[j] as! String))
                    case .boardId:
                        securitiesEntities[i].append(.boardId(data[j] as! String))
                    case .shortName:
                        securitiesEntities[i].append(.shortName(data[j] as! String))
                    case .setleDate:
                        securitiesEntities[i].append(.setleDate(data[j] as! String))
                    case .lotSize:
                        securitiesEntities[i].append(.lotSize(data[j] as! Int))
                    case .decimals:
                        securitiesEntities[i].append(.decimals(data[j] as! Int))
                    case .faceValue:
                        securitiesEntities[i].append(.faceValue(data[j] as! Int))
                    case .marketCode:
                        securitiesEntities[i].append(.marketCode(data[j] as! String))
                    case .minStep:
                        securitiesEntities[i].append(.minStep(data[j] as! Double))
                    case .prevDate:
                        securitiesEntities[i].append(.prevDate(data[j] as! String))
                    case .secName:
                        securitiesEntities[i].append(.secName(data[j] as! String))
                    case .remarks:
                        securitiesEntities[i].append(.remarks(data[j] as? String))
                    case .satus:
                        securitiesEntities[i].append(.satus(data[j] as! String))
                    case .faceUnit:
                        securitiesEntities[i].append(.faceUnit(data[j] as! String))
                    case .prevPrice:
                        securitiesEntities[i].append(.prevPrice(data[j] as! Double))
                    case .prevWaPrice:
                        securitiesEntities[i].append(.prevWaPrice(data[j] as! Double))
                    case .currencyId:
                        securitiesEntities[i].append(.currencyId(data[j] as! String))
                    case .latName:
                        securitiesEntities[i].append(.latName(data[j] as! String))
                }
            }
        }
        return securitiesEntities
    }
}
