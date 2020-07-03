import Foundation

class CurrencyParser
{
    private var parser: CurrencyParserBaseProtocol = EuroCurrencyParser()
    private let timerInterval = 300.0
    var currencyType: CurrencyType
    {
        willSet {
            if(self.currencyType != newValue) {
                if(timer != nil){
                    timer!.invalidate()
                }
                
                switch newValue {
                case .Usd:
                    parser = UsdCurrencyParser()
                default:
                    parser = EuroCurrencyParser()
                }
                startParsing()
            }
        }
    }
    weak var delegate: CurrencyChangesNotifierProtocol?
    var timer: Timer?
    
    init(currencyType: CurrencyType, delegate: CurrencyChangesNotifierProtocol) {
        self.delegate = delegate
        self.currencyType = currencyType
    }
    
    @objc func fireTimer() {
        parser.startLoading(delegate: self.delegate)
    }
    
    func startParsing() {
        parser.startLoading(delegate: self.delegate)
        
        if(timer != nil){
            timer!.invalidate()
        }
        timer = Timer.scheduledTimer(timeInterval: timerInterval, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
    }
}
