//
//  MovieCollectionCell.swift
//  FilmsApp
//
//  Created by Владимир Царь on 13.12.2025.
//


import UIKit

class MovieCollectionViewFavoriteCell: UICollectionViewCell {
    
    private var currentMovieId: String = "some id"
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
            
            imdbIDLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12), // Уменьшил отступ
            imdbIDLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            imdbIDLabel.leadingAnchor.constraint(greaterThanOrEqualTo: posterImageView.trailingAnchor, constant: 12),
        ])
        
        // Устанавливаем приоритеты для предотвращения конфликтов
        imdbIDLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        imdbIDLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    func configure(with movie: Film) {
        titleLabel.text = movie.title
        yearLabel.text = "Год: \(movie.year ?? "")"
        typeLabel.text = movie.type?.uppercased()
        imdbIDLabel.text = "ID: \(movie.id ?? "")"
        
        // Сохраняем ID фильма и состояние
        
        // Обновляем кнопку на основе переданного состояния
        
        // Загрузка изображения...
        if movie.image != "N/A", let imageURL = URL(string: movie.image ?? "") {
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.backgroundColor = .lightGray
        titleLabel.text = nil
        yearLabel.text = nil
        typeLabel.text = nil
        imdbIDLabel.text = nil
    }
}
