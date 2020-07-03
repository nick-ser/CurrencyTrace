enum MarketData
{
    case highBid(Double?)
    case bidDepth(Double?)
    case lowOffer(Double?)
    case offerDepth(Double?)
    case spread(Double)
    case high(Double)
    case low(Double)
    case open(Double)
    case last(Double)
    case lastCngToLastWaPrice(Double)
    case valToday(Int)
    case volToday(Int)
    case valTodayUsd(Int)
    case waPrice(Double)
    case wapToPrevWaPrice(Double)
    case closePrice(Double?)
    case numTrades(Int)
    case tradingStatus(String)
    case updateTime(String)
    case boardId(String)
    case secId(String)
    case wapToPrevWaPricePrcnt(Double)
    case bid(Double?)
    case bidDepthT(Double?)
    case numBids(Double?)
    case offer(Double?)
    case offerDepthT(Double?)
    case numOffers(Double?)
    case change(Double)
    case lastChangePrcnt(Double)
    case value(Int)
    case valueUsd(Double)
    case seqNum(Int)
    case qty(Int)
    case time(String)
    case priceMinusPrevWaPrice(Double)
    case lastChange(Double)
    case lastToPrevPrice(Double)
    case valTodayRur(Int)
    case sysTime(String)
    case marketPrice(Double)
    case marketPriceToday(Double?)
    case marketPrice2(Double?)
    case admitTedQuote(Double?)
    
    func get() -> Any
    {
        switch self
        {
            case .tradingStatus(let str), .updateTime(let str), .boardId(let str), .secId(let str), .time(let str), .sysTime(let str):
                return str
            case .valToday(let int), .volToday(let int), .valTodayUsd(let int), .numTrades(let int), .value(let int), .qty(let int), .valTodayRur(let int),
                 .seqNum(let int):
                return int
            case .spread(let dbl), .high(let dbl), .low(let dbl), .open(let dbl), .last(let dbl), .lastCngToLastWaPrice(let dbl), .waPrice(let dbl),
                 .wapToPrevWaPrice(let dbl), .wapToPrevWaPricePrcnt(let dbl), .change(let dbl), .lastChangePrcnt(let dbl), .valueUsd(let dbl),
                 .priceMinusPrevWaPrice(let dbl), .lastChange(let dbl), .lastToPrevPrice(let dbl), .marketPrice(let dbl):
                return dbl
            case .highBid(let nilDbl), .bidDepth(let nilDbl), .lowOffer(let nilDbl), .offerDepth(let nilDbl), .closePrice(let nilDbl), .bid(let nilDbl), .marketPrice2(let nilDbl),
                 .bidDepthT(let nilDbl), .numBids(let nilDbl), .offer(let nilDbl), .offerDepthT(let nilDbl), .numOffers(let nilDbl), .marketPriceToday(let nilDbl),
                 .admitTedQuote(let nilDbl):
                return nilDbl as Any;
        }
    }
}
