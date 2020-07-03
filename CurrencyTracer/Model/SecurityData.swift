enum SecurityData
{
    case secid(String)
    case boardId(String)
    case shortName(String)
    case lotSize(Int)
    case setleDate(String)
    case decimals(Int)
    case faceValue(Int)
    case marketCode(String)
    case minStep(Double)
    case prevDate(String)
    case secName(String)
    case remarks(String?)
    case satus(String)
    case faceUnit(String)
    case prevPrice(Double)
    case prevWaPrice(Double)
    case currencyId(String)
    case latName(String)
    
    func get() -> Any
    {
        switch self
        {
            case .secid(let str), .boardId(let str), .shortName(let str), .setleDate(let str), .marketCode(let str), .prevDate(let str),
                 .secName(let str), .satus(let str), .faceUnit(let str), .currencyId(let str), .latName(let str):
                return str
            case .lotSize(let int), .decimals(let int), .faceValue(let int):
                return int
            case .minStep(let dbl), .prevPrice(let dbl), .prevWaPrice(let dbl):
                return dbl
            case .remarks(let nilStr):
                return nilStr ?? ""
        }
    }
}
