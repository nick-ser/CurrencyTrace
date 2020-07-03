enum JsonParsingErrors: Error
{
    case jsonObjectNil
    case parsingError(String)
    case securitiesNotFound
    case securitiesDataNotFound
    case securitiesColumnsNotFound
    case marketDataNotFound
    case marketDataColumnsNotFound
    case marketDataDataNotFound
}
