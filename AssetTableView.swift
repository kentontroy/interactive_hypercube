import UIKit

protocol AssetTableDataSource : UITableViewDataSource
{
    var model : AssetTableModel? { get }
}

class AssetTableView : UITableView, AssetTableDataSource
{
    private var _model : AssetTableModel?
    
    var model:  AssetTableModel? {
        get {
            return self._model
        }
    }
    
    override init(frame: CGRect, style: UITableView.Style)
    {
        super.init(frame: frame, style: style)
    }
    convenience init(x xPos: CGFloat, y yPos: CGFloat = UIApplication.shared.statusBarFrame.size.height,
                     width w: CGFloat, height h: CGFloat, dataModel: AssetTableModel)
    {
        let displayRect = CGRect(x: xPos, y: yPos * 2, width: w, height: h - yPos)
        self.init(frame: displayRect, style: UITableView.Style.grouped)
        self.separatorColor = UIColor.clear
        self.backgroundColor = UIColor.white
        self.register(AssetTableViewCell.self, forCellReuseIdentifier: "tableCell")
        self.dataSource = self
        self._model = dataModel
    }
    required init(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if let m = self._model {
            return m.data.count
        }
        fatalError("no model instance created")
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard let m = self._model else {
            fatalError("no model instance created")
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath as IndexPath) as? AssetTableViewCell
            else {
                fatalError("unable to create table view cell")
        }
        cell._sourceImage.image = m.data[indexPath.row]._image
        cell._sourceLabel.text = m.data[indexPath.row]._label
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return AssetTableViewCell.height
    }
}

class AssetTableViewCell: UITableViewCell
{
    lazy var _backView: UIView = {
        let view = UIView(frame: CGRect(x: 10, y: 0, width: AssetTableViewCell.width, height: AssetTableViewCell.height))
        view.backgroundColor = UIColor.white
        return view
    }()
    
    lazy var _sourceImage: UIImageView = {
        let image = UIImageView(frame: CGRect(x: 4, y: 4, width: 50, height: 50))
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    lazy var _sourceLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 60, y: 4, width: 250, height: 50))
        label.textAlignment = .left
        return label
    }()
    
    static let height : CGFloat = 50
    static let width : CGFloat = 300
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
    override func layoutSubviews()
    {
        self.contentView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        self._backView.layer.cornerRadius = 5
        self._backView.clipsToBounds = true
        self._sourceImage.layer.cornerRadius = 25
        self._sourceImage.clipsToBounds = true
        
        super.addSubview(self._backView)
        self._backView.addSubview(self._sourceImage)
        self._backView.addSubview(self._sourceLabel)
    }
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
}

