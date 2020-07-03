import Foundation

class UsdCurrencyParser: CurrencyParserBase
{
    override init() {
        super.init()
        self.url = "https://iss.moex.com/iss/engines/currency/markets/selt/securities.jsonp?callback=iss_jsonp_04102e9523437737843fb4a857c3bd67dc626508&iss.meta=off&iss.only=securities%2Cmarketdata&securities=CETS%3AUSD000UTSTOM%2CCETS%3AEUR_RUB__TOM%E3%80%88=ru"
    }
}
