import Foundation

protocol CurrencyParserBaseProtocol {
    func parseJson(jsonString: String) throws -> (Array<[SecurityData]>, Array<[MarketData]>)
    func parseMarketData(json: Any?) throws -> Array<Array<MarketData>>
    func parseSecurities(json: Any?) throws -> Array<Array<SecurityData>>
    func startLoading(delegate: CurrencyChangesNotifierProtocol?)
}
