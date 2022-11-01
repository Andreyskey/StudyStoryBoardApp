//
//  CustomButton.swift
//  StudyStoryBoardApp
//
//  Created by Андрей Волков on 29.10.2022.
//

import UIKit

class CustomButton: UIButton {

    // Два цвета для изменения
    let color: UIColor = UIColor(cgColor: CGColor(red: 0.988, green: 0.239, blue: 0.282, alpha: 1))
    let colorTwo: UIColor = UIColor(cgColor: CGColor(red: 0.879, green: 0.114, blue: 0.158, alpha: 1))
    
    // Интервалы для анимации нажатия(1) и интервал нажатия
    let timeAnimate: TimeInterval = 0.2
    let timerStep: TimeInterval = 0.1
    
    // Создается только при вызове в коде
    weak var timer: Timer?

    // Удаляет таймер
    private func stopTimer() {
        timer?.invalidate()
    }
    
    // При нажатии сменится цвет
    private func touchDown() {
        stopTimer()
        layer.backgroundColor = colorTwo.cgColor
    }
    
    // Как только пользователь уберет палец с кнопки запустится анимация возвращения цвета в исходный
    private func touchUp() {
        // Timer.scheduledTimer создает таймер при нажатии и каждую секунду
        // вызывает animation() до тех пор пока пользователь не уберет палец
        timer = Timer.scheduledTimer(timeInterval: timerStep,
                                     target: self,
                                     selector: #selector(animation),
                                     userInfo: nil,
                                     repeats: true)

    }

    // Анимация возвращения цвета
    @objc func animation() {
        UIView.animate(withDuration: timeAnimate) { [weak self] in
            self?.layer.backgroundColor = self?.color.cgColor
        }
        stopTimer()
    }
    
    func isTouched(_ action: Bool) {
        isUserInteractionEnabled = action
    }
    
    // Отслеживание нажатия
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                touchDown()
            } else {
                cancelTracking(with: nil)
                touchUp()
            }
        }
    }
    
    // Удаляет таймер (если он есть) при деиницилизации UI-компонента
    deinit{
        print("Delete Controller")
        stopTimer()
    }
}
