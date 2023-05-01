//
//  QuoteTableViewCell.swift
//  Technical-test
//
//  Created by Adriana Epure on 01.05.2023.
//


import UIKit

/**
 Displays a Quote cell and its corresponding information
 */
class QuoteTableViewCell: UITableViewCell{
	
	let customTextFontSize: CGFloat = 14.0 /// font size for the labels

		//MARK: UI Properties
	
	//Name Label
	private lazy var nameLabel: UILabel = {
		let label = UILabel(frame: .zero)
		label.font = UIFont.boldSystemFont(ofSize: customTextFontSize)
		label.textColor = .black
		label.numberOfLines = 0
		label.lineBreakMode = .byWordWrapping
		label.setContentCompressionResistancePriority(UILayoutPriority(1000), for: .horizontal) /// make the label resist being made smaller on the horizontal axis
		return label
	}()
	
	//Last Price Label
	private lazy var lastPriceLbl: UILabel = {
		let label = UILabel(frame: .zero)
		label.textColor = .black
		label.font = UIFont.systemFont(ofSize: customTextFontSize)
		return label
	}()
	
	//Last Change Percentage Label
	private lazy var lastChangeLabel: UILabel = {
		let label = UILabel(frame: .zero)
		label.font = UIFont.systemFont(ofSize: customTextFontSize)
		return label
	}()
	
	//Vertical Stack View with the name and price labels
	private lazy var stackView: UIStackView = {
		let stack = UIStackView(arrangedSubviews: [nameLabel, lastPriceLbl])
		stack.distribution = .fill
		stack.axis = .vertical
		return stack
	}()
	
	//Favorite Image View
	private lazy var favoriteImageView: UIImageView = {
		return UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
	}()
	
	//Horizontal Stack View with the name, price, change & favorite image
	private lazy var  contentStackView : UIStackView = {
		let stack = UIStackView(arrangedSubviews: [stackView, lastChangeLabel, favoriteImageView])
		stack.distribution = .fill
		stack.alignment = .center
		stack.axis = .horizontal
		stack.spacing = 10.0
		return stack
	}()
	
	
	//MARK: View LifeCycle
	override class func awakeFromNib() {
		super.awakeFromNib()
	}
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		addSubviews()
		setupAutolayout()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	/**
	 Reset attributes that are related to the appearance of the cell and not content
	 */
	override func prepareForReuse() {
		super.prepareForReuse()
		nameLabel.text = nil
		lastPriceLbl.text = nil
		lastChangeLabel.text = nil
	}
}

//MARK: Methods for UI Setup & Update
extension QuoteTableViewCell{
	func addSubviews(){
		contentView.backgroundColor = .white
		contentView.addSubview(contentStackView)
	}
	func setupAutolayout(){
		let layoutMarginsGuide = contentView.layoutMarginsGuide
		nameLabel.translatesAutoresizingMaskIntoConstraints = false
		favoriteImageView.translatesAutoresizingMaskIntoConstraints = false
		contentStackView.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			
			nameLabel.widthAnchor.constraint(equalToConstant: contentView.frame.width * 0.6),
			favoriteImageView.widthAnchor.constraint(equalToConstant: 30),
			favoriteImageView.heightAnchor.constraint(equalToConstant: 30),
			contentStackView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
			contentStackView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
			contentStackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
			contentStackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor)
		])
		
	}
	
	func updateUI(with quote: Quote){
		
		nameLabel.text = quote.name
		if let last = quote.last,
		   let currency = quote.currency{
			lastPriceLbl.text = last + currency
		}
		lastChangeLabel.text = quote.readableLastChangePercent ?? ""
		lastChangeLabel.textColor = UIColor.colorWith(name: quote.variationColor)
		favoriteImageView.image = UIImage(named: quote.isFavorite ? QuoteImageName.favorite.rawValue : QuoteImageName.notFavorite.rawValue)
		
		
	}
	
}
