import Cocoa

protocol CurrencyChangesNotifierProtocol: AnyObject {
    func notify(currency: [MarketData])
}

enum CurrencyType: Int
{
    case Euro = 0
    case Usd = 1
}

class ViewController: NSViewController, NSTextFieldDelegate, CurrencyChangesNotifierProtocol {

    private let EuroSymbol = "€"
    private let UsdSymbol = "$"
    private var statusItem: NSStatusItem? = nil
    private var lastMarketData: [MarketData]
    private var parser: CurrencyParser? = nil
    
    @IBOutlet weak var currencySymbol: NSTextField!
    @IBOutlet weak var type: NSSegmentedControl!
    @IBOutlet weak var currencyRate: NSTextField!
    @IBOutlet weak var change: NSTextField!
    @IBOutlet weak var arrow: NSTextField!
    @IBOutlet weak var updatedDate: NSTextField!
    
    required init?(coder: NSCoder) {
        lastMarketData = Array<MarketData>()
        super.init(coder: coder)
        parser = CurrencyParser(currencyType: CurrencyType.Euro, delegate: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        type.selectedSegment = 0
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        view.window?.makeKey()
    }
    
    func configurate(statusItem: NSStatusItem) {
        self.statusItem = statusItem
    }
    
    func startCurrencyTracing() {
        parser!.startParsing()
    }

    @IBAction func currencyTypeChanged(_ sender: Any) {
        switch type.selectedSegment {
        case 1:
            currencySymbol.stringValue = UsdSymbol
            parser!.currencyType = .Usd
        default:
            currencySymbol.stringValue = EuroSymbol
             parser!.currencyType = .Euro
        }
        lastMarketData = Array<MarketData>()
        updateMarketData()
    }
    
    func notify(currency: [MarketData]) {
        lastMarketData = currency
        updateMarketData()
    }
    
    func updateMarketData() {
        if(statusItem == nil) {
            fatalError("Haven't access to status bar.")
        }
        
        var currencySymbol = ""
        if(type == nil){
            currencySymbol = EuroSymbol
        }
        else {
            switch type.selectedSegment {
            case 1:
                currencySymbol = UsdSymbol
            default:
                currencySymbol = EuroSymbol
            }
        }
        
        var lastPrice = 0.0, lastChange = 0.0
        var updatedTime = ""
        for elem in lastMarketData {
            if case let MarketData.last(price) = elem {
                lastPrice = price
            }
            if case let MarketData.change(chg) = elem {
                lastChange = chg
            }
            if case let MarketData.sysTime(time) = elem {
                updatedTime = time
            }
        }
        
        let arrow = lastChange >= 0.0 ? "↑" : "↓"
        let text = "\(currencySymbol)\(lastPrice)  \(arrow)\(lastChange)"
        DispatchQueue.main.async {
            self.statusItem!.button?.attributedTitle = NSAttributedString(string: text, attributes: [ NSAttributedString.Key.foregroundColor : lastChange >= 0.0 ? NSColor.green : NSColor.red])
            if(self.currencySymbol != nil) {
                self.currencySymbol.textColor = lastChange >= 0 ? NSColor.green : NSColor.red
            }
            if(self.currencyRate != nil){
                self.currencyRate.textColor = lastChange >= 0 ? NSColor.green : NSColor.red
                self.currencyRate.stringValue = String(format: "%.02f", lastPrice)
            }
            if(self.change != nil) {
                self.change.textColor = lastChange >= 0 ? NSColor.green : NSColor.red
                let strChange = String(format: "%.02f", lastChange)
                self.change!.stringValue = lastChange >= 0 ? "+\(strChange)" : "\(strChange)"
            }
            if(self.arrow != nil) {
                self.arrow.textColor = lastChange >= 0 ? NSColor.green : NSColor.red
                self.arrow.stringValue = arrow
            }
            if(self.updatedDate != nil) {
                self.updatedDate.stringValue = "Updated: \(updatedTime)"
            }
        }
    }
}

