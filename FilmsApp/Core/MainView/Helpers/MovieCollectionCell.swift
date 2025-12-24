import UIKit

class MovieCollectionCell: UICollectionViewCell {
    
    private var currentMovieId: String = ""
    private var isCurrentlyFavorite: Bool = false
    var onFavoriteTapped: (() -> Void)? // Замыкание без параметров
    
    lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 2
        return label
    }()
    
    lazy var yearLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .lightGray
        return label
    }()
    
    lazy var typeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .systemBlue
        label.textAlignment = .center
        label.layer.cornerRadius = 4
        label.layer.masksToBounds = true
        label.backgroundColor = .systemBlue.withAlphaComponent(0.2)
        return label
    }()
    
    lazy var imdbIDLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 10, weight: .regular)
        label.textColor = .lightGray
        return label
    }()
    
    lazy var addButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Добавить в избранное", for: .normal)
        button.backgroundColor = .systemBlue.withAlphaComponent(0.2)
        button.titleLabel?.font = .systemFont(ofSize: 9, weight: .bold)
        button.layer.cornerRadius = 4
        button.setTitleColor(.white, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        
        let action: UIAction = UIAction { _ in
            self.onFavoriteTapped?() // Просто вызываем замыкание
        }
        button.addAction(action, for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(yearLabel)
        contentView.addSubview(typeLabel)
        contentView.addSubview(imdbIDLabel)
        contentView.addSubview(addButton)
        
        // Добавляем скругление и тень для ячейки
        contentView.backgroundColor = .black.withAlphaComponent(0.3)
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            // Постер слева
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            posterImageView.widthAnchor.constraint(equalTo: posterImageView.heightAnchor, multiplier: 0.7),
            
            // Заголовок
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            // Год
            yearLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            yearLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 12),
            yearLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            // Тип
            typeLabel.topAnchor.constraint(equalTo: yearLabel.bottomAnchor, constant: 8),
            typeLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 12),
            typeLabel.widthAnchor.constraint(equalToConstant: 60),
            typeLabel.heightAnchor.constraint(equalToConstant: 20),
            
            // Кнопка "Добавить в избранное" - прижимаем к низу
            addButton.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 12),
            addButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            //addButton.heightAnchor.constraint(equalToConstant: 36), // Уменьшил высоту для лучшего вида
            addButton.trailingAnchor.constraint(lessThanOrEqualTo: imdbIDLabel.leadingAnchor, constant: -8), // Приоритет меньше
            
            // IMDb ID - прижимаем к правому краю
            imdbIDLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            imdbIDLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            imdbIDLabel.leadingAnchor.constraint(greaterThanOrEqualTo: addButton.trailingAnchor, constant: 8), // Приоритет больше
        ])
        
        // Устанавливаем приоритеты для предотвращения конфликтов
        addButton.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        imdbIDLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        imdbIDLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    func configure(with movie: Movie, isFavorite: Bool) {
        titleLabel.text = movie.title
        yearLabel.text = "Год: \(movie.year)"
        typeLabel.text = movie.type.uppercased()
        imdbIDLabel.text = "ID: \(movie.imdbID)"
        
        // Сохраняем ID фильма и состояние
        self.currentMovieId = movie.imdbID
        self.isCurrentlyFavorite = isFavorite
        
        // Обновляем кнопку на основе переданного состояния
        updateButtonAppearance(isFavorite: isFavorite)
        
        // Загрузка изображения...
        if movie.poster != "N/A", let imageURL = URL(string: movie.poster) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: imageURL) {
                    DispatchQueue.main.async {
                        self.posterImageView.image = UIImage(data: data)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.setPlaceholderImage()
                    }
                }
            }
        } else {
            setPlaceholderImage()
        }
    }
    
    private func setPlaceholderImage() {
        posterImageView.image = UIImage(systemName: "film")
        posterImageView.tintColor = .white
        posterImageView.contentMode = .center
        posterImageView.backgroundColor = .darkGray
    }
    
    private func updateButtonAppearance(isFavorite: Bool) {
        if isFavorite {
            // Состояние "Добавлено" - можно отменить
            addButton.setTitle("★ Добавлено", for: .normal)
            addButton.setTitleColor(.systemYellow, for: .normal)
            addButton.backgroundColor = .systemYellow.withAlphaComponent(0.1)
            addButton.layer.borderWidth = 1
            addButton.layer.borderColor = UIColor.systemYellow.cgColor
            
            let config = UIImage.SymbolConfiguration(pointSize: 10, weight: .bold)
            if let originalImage = UIImage(systemName: "star.fill", withConfiguration: config) {
                let yellowImage = originalImage.withTintColor(.systemYellow, renderingMode: .alwaysOriginal)
                addButton.setImage(yellowImage, for: .normal)
            }
            
            addButton.isEnabled = true // Теперь кнопка активна!
            addButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 4)
        } else {
            // Состояние "Добавить в избранное"
            addButton.setTitle("☆ Добавить в избранное", for: .normal)
            addButton.setTitleColor(.white, for: .normal)
            addButton.backgroundColor = .systemBlue.withAlphaComponent(0.2)
            addButton.layer.borderWidth = 0
            addButton.setImage(nil, for: .normal)
            addButton.isEnabled = true
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.backgroundColor = .lightGray
        titleLabel.text = nil
        yearLabel.text = nil
        typeLabel.text = nil
        imdbIDLabel.text = nil
        
        // Сбрасываем только UI кнопки
        addButton.setTitle("☆ Добавить в избранное", for: .normal)
        addButton.setTitleColor(.white, for: .normal)
        addButton.backgroundColor = .systemBlue.withAlphaComponent(0.2)
        addButton.setImage(nil, for: .normal)
        addButton.isEnabled = true
        addButton.layer.borderWidth = 0
    }
}
