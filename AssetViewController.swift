import UIKit

class AssetViewController: UIViewController, Storyboarded, UITableViewDelegate
{
    weak var _coordinator: DecideCoordinator?
    
    var _tableIndustrySectorView : AssetTableView!
    var _tableIndustrySectorModel : AssetTableModel!
    var _tableMarketView : AssetTableView!
    var _tableMarketModel : AssetTableModel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
//Add the table for Industry Sector
        self._tableIndustrySectorModel = IndustrySectorTableModel()
        self._tableIndustrySectorView = AssetTableView(x: 50, width: 300, height: self.view.frame.height,
                                                       dataModel: self._tableIndustrySectorModel)
        self._tableIndustrySectorView.delegate = self
        populateTable(table: self._tableIndustrySectorView)
        self.view.addSubview(self._tableIndustrySectorView)
//Add the table for Market
        self._tableMarketModel = MarketTableModel()
        self._tableMarketView = AssetTableView(x: 360, width: 300, height: self.view.frame.height,
                                                       dataModel: self._tableMarketModel)
        self._tableMarketView.delegate = self
        populateTable(table: self._tableMarketView)
        self.view.addSubview(self._tableMarketView)
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if let tableView = tableView as? AssetTableView
        {
            if let _ = tableView.model as? IndustrySectorTableModel
            {
                print("Industry Sector")
                print("Num: \(indexPath.row)")
                print("Value: \(self._tableIndustrySectorModel.data[indexPath.row])")
            }
            else if let _ = tableView.model as? MarketTableModel
            {
                print("Market Sector")
                print("Num: \(indexPath.row)")
                print("Value: \(self._tableMarketModel.data[indexPath.row])")
            }
        }
    }
    func populateTable(table tableView: UITableView)
    {
        for section in 0..<tableView.numberOfSections
        {
            for row in 0..<tableView.numberOfRows(inSection: section)
            {
                let indexPath = IndexPath(row: row, section: section)
                 _ = tableView.delegate?.tableView?(tableView, willSelectRowAt: indexPath)
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                tableView.delegate?.tableView?(tableView, didSelectRowAt: indexPath)
            }
        }
    }
}
