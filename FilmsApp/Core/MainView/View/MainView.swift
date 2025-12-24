//  ViewController.swift
//  FilmsApp
//
//  Created by Владимир Царь on 12.11.2025.
//

import UIKit
import Combine

class MainView: UIViewController {
    
    var authService = AuthService()
    
    var viewModel: MainViewModel
    
    private var cancellables: Set<AnyCancellable> = []
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Приветствую \(UserDefaults.standard.string(forKey: "name") ?? "Vova")"
        label.textColor = .white
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Введите название фильма на английском"
        textField.backgroundColor = .white
        textField.textColor = .black
        textField.delegate = self
        textField.layer.cornerRadius = 8
        textField.layer.masksToBounds = true
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return textField
    }()
    
    lazy var exitButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Выйти", for: .normal)
        btn.backgroundColor = .purple
        btn.layer.cornerRadius = 25
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        btn.setTitleColor(.white, for: .normal)
        let action = UIAction { [weak self]_ in
            self?.authService.singOut()
            NotificationCenter.default.post(name: .windowManager, object: nil, userInfo: [String.windowManager: AppRoute.registView])
        }
        btn.addAction(action, for: .touchUpInside)
        return btn
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(MovieCollectionCell.self, forCellWithReuseIdentifier: "MovieCollectionCell")
        collectionView.isHidden = true
        return collectionView
    }()
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        setupUI()
        setupConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addPermission()
        //collectionView.backgroundColor = .red.withAlphaComponent(0.3)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Обновляем градиент основного вью
        if let gradientLayer = view.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = view.bounds
        }
        
        // Добавляем градиент на кнопку, когда она уже имеет размеры
        setupButtonGradient()
    }

    private func setupButtonGradient() {
        // Удаляем старые градиентные слои
        exitButton.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = exitButton.bounds // Важно: используем bounds кнопки, не view!
        gradientLayer.colors = [
            UIColor.systemPurple.cgColor,
            UIColor.systemBlue.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.cornerRadius = 25
        
        // Вставляем градиент под контент кнопки
        exitButton.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setupUI() {
        view.addSubviews(nameLabel, textField, exitButton, collectionView)
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor.systemPurple.cgColor,
            UIColor.systemBlue.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            // Лейбл по центру сверху
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Текстовое поле под лейблом
            textField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            textField.heightAnchor.constraint(equalToConstant: 44),
            
            // Коллекция под текстовым полем - ЗАНИМАЕТ ВСЕ ОСТАВШЕЕСЯ ПРОСТРАНСТВО
            collectionView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: exitButton.topAnchor, constant: -20),
            
            // Кнопка выхода
            exitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            exitButton.widthAnchor.constraint(equalToConstant: 120),
            exitButton.heightAnchor.constraint(equalToConstant: 50),
            exitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    func addPermission() {
        textField
            .textPublisher
            .sink { [weak self] text in
                self?.viewModel.textField = text
            }
            .store(in: &cancellables)
        
        viewModel.$result
            .receive(on: DispatchQueue.main)
            .sink { [weak self] movies in
                print("Обновление коллекции. Фильмов: \(movies.count)")
                self?.collectionView.reloadData()
                self?.collectionView.isHidden = movies.isEmpty
            }
            .store(in: &cancellables)
        
    }

    @objc private func textFieldDidChange() {
        viewModel.textField = textField.text ?? ""
    }
}

extension MainView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.result.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionCell", for: indexPath) as? MovieCollectionCell else {
            return UICollectionViewCell()
        }
        
        let movie = viewModel.result[indexPath.item]
        let isFavorite = viewModel.isFavorite(movieId: movie.imdbID)
        
        cell.configure(with: movie, isFavorite: isFavorite)
        
        // Устанавливаем замыкание для обработки нажатий
        cell.onFavoriteTapped = { [weak self] in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                DataBaseManager.shared.createFilm(year: movie.year, title: movie.title, type: movie.type, image: movie.poster)
            }
            
            // Обновляем состояние в ViewModel
            self.viewModel.toggleFavorite(movieId: movie.imdbID)
            
            // Обновляем только эту ячейку
            collectionView.reloadItems(at: [indexPath])
        }
        
        return cell
    }
}

extension MainView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - 32 // Отступы слева и справа
        return CGSize(width: width, height: 160) // ШИРОКАЯ ЯЧЕЙКА ДЛЯ ВЕРТИКАЛЬНОГО СКРОЛЛА
    }
}
