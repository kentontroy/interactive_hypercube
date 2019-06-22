import UIKit

struct AssetTableModelEntity
{
    var _image : UIImage
    var _label : String
    init(image: UIImage, label: String)
    {
        self._image = image
        self._label = label
    }
}

protocol AssetTableModel
{
    var data: [AssetTableModelEntity] { get }
    func addEntity(asset e: AssetTableModelEntity)
}

class IndustrySectorTableModel : AssetTableModel
{
    private var _tableData = [AssetTableModelEntity]()
    
    var data: [AssetTableModelEntity] {
        return _tableData
    }    
    init()
    {
        addEntity(asset: AssetTableModelEntity(image: UIImage(named: "materials.png")!, label: "Basic Materials"))
        addEntity(asset: AssetTableModelEntity(image: UIImage(named: "consumer.jpg")!, label: "Consumer Goods"))
        addEntity(asset: AssetTableModelEntity(image: UIImage(named: "financial.jpg")!, label: "Financial"))
        addEntity(asset: AssetTableModelEntity(image: UIImage(named: "healthcare.jpg")!, label: "Healthcare"))
        addEntity(asset: AssetTableModelEntity(image: UIImage(named: "realestate.png")!, label: "Real Estate"))
        addEntity(asset: AssetTableModelEntity(image: UIImage(named: "technology.jpg")!, label: "Technology"))
        addEntity(asset: AssetTableModelEntity(image: UIImage(named: "utilities.png")!, label: "Utilities"))
    }
    func addEntity(asset e: AssetTableModelEntity)
    {
        self._tableData.append(e)
    }
}

class MarketTableModel : AssetTableModel
{
    private var _tableData = [AssetTableModelEntity]()
    
    var data: [AssetTableModelEntity] {
        return _tableData
    }
    init()
    {
        addEntity(asset: AssetTableModelEntity(image: UIImage(named: "market.png")!, label: "S&P 500"))
        addEntity(asset: AssetTableModelEntity(image: UIImage(named: "market.png")!, label: "FTSE"))
        addEntity(asset: AssetTableModelEntity(image: UIImage(named: "market.png")!, label: "Hang Seng"))
        addEntity(asset: AssetTableModelEntity(image: UIImage(named: "market.png")!, label: "DAX"))
    }
    func addEntity(asset e: AssetTableModelEntity)
    {
        self._tableData.append(e)
    }
}
