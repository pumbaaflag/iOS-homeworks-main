//
//  InfoViewController.swift
//  Navigation
//
//  Created by pumbaaflag on 08.02.2023.
//

import UIKit

class InfoViewController: UIViewController {
    
    // MARK: - PROPERTIES
    
    private lazy var button: UIButton = { // Создаем Alert кнопку
        let button = UIButton()  // Кнопка
        button.backgroundColor = .red  // Цвет кнопки
        button.layer.cornerRadius = 12   // Скруглим
        button.setTitle("Показать алерт", for: .normal)  // Текст кнопки
        button.setTitleColor(.lightGray, for: .normal)  // Цвет текста
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)   // Делаем жирным
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)  // Добавляем Action
        button.translatesAutoresizingMaskIntoConstraints = false // Отключаем AutoresizingMask
        
        return button
    }()
    
    // MARK: - LIFECYCLE METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .opaqueSeparator // Задаем базовый цвет
        self.view.addSubview(self.button) // Добавляем кнопку
        setConstrains() // Добавляем констрейты к кнопке
    }
    
    // MARK: - SETUP SUBVIEWS
    
    func setConstrains() {  // Создаем констрейты к кнопке
        
        NSLayoutConstraint.activate([
            self.button.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -16), // низ
            self.button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20), // левый край
            self.button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20), // левый край
            self.button.heightAnchor.constraint(equalToConstant: 50) // высота
        ]) // Активация констрейнов
    }

    @objc private func buttonAction() { // Делаем переход на UIAlertController
        self.showAlert() // Вызываем AlertController
    }
    
    private func showAlert() {  // Создаем кнопку Alert.
        let alertController = UIAlertController(title: "ВНИМАНИЕ", message: "Ты хочешь узнать правду?", preferredStyle: .alert) // Создаем AlertController
        let yesButton = UIAlertAction(title: "Да", style: .default) { Action in
            print("Нажата кнопка Да") // Кнопка Да. При нажатии в консоль должно выводиться сообщение.
        }
        let noButton = UIAlertAction(title: "Нет", style: .cancel) { Action in
            print("Нажата кнопка Нет") // Кнопка Нет. При нажатии в консоль должно выводиться сообщение.
        }
        alertController.addAction(yesButton) // Действие кнопок
        alertController.addAction(noButton) // Действие кнопок
        present(alertController, animated: true, completion: nil) // Выводим на экран
    }
}

