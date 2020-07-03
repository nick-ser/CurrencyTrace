import Foundation

class EuroCurrencyParser: CurrencyParserBase
{
    override init() {
        super.init()
        self.url = "https://iss.moex.com/iss/engines/currency/markets/selt/boards/CETS/securities/EUR_RUB__TOM.jsonp?callback=iss_jsonp_82f90a84d69b82afd6e3ab0d0e646fb787b807ce&iss.meta=off&iss.only=securities%2Cmarketdata&lang=ru&_=1419352445028"
    }
}
