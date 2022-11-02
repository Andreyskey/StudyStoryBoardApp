//
//  Data.swift
//  StudyStoryBoardApp
//
//  Created by Андрей Волков on 29.10.2022.
//

import UIKit

var user: User = User(login: "", password: "")

var postOne = [
    Post(name: "Ateo Breaking",
         imageProfile: UIImage(named: "Ateologo")!,
         timePost: "5 минут назад",
         textPost: "Хакер. Связался с РИА Новости.",
         ImagePost: UIImage(named: "ateopost")!,
         countLikes: 560,
         countComment: 22,
         countShare: 36,
         seesCount: "9,6k"),
    Post(name: "высеры марка",
         imageProfile: UIImage(named: "marklogo")!,
         timePost: "час назад",
         textPost: "я выбросил землю из горшков с растениями и потом щупал и жамкал их корни я прочитал что это полезно для растений",
         countLikes: 9,
         countComment: 0,
         countShare: 1,
         seesCount:  "400"),
    Post(name: "iamdead",
         imageProfile: UIImage(named: "logoiamdead.jpeg")!,
         timePost: "сегодня в 13:15",
         textPost: "мне больше незачем жить.",
         ImagePost: UIImage(named: "postiamdead"),
         countLikes: 89,
         countComment: 9,
         countShare: 4,
         seesCount: "2,4k"),
    Post(name: "Пездуза",
        imageProfile: UIImage(named: "Pezdusa")!,
        timePost: "вчера в 23:56",
        textPost: "⚡️Словарь русского языка назвал словом 2022 года термин «полный пиздец»",
        ImagePost: UIImage(named: "imagePost")!,
        countLikes: 125,
        countComment: 4,
        countShare: 1,
        seesCount: "1,3k"),
    Post(name: "высеры марка",
        imageProfile: UIImage(named: "marklogo")!,
        timePost: "вчера в 19:07",
        textPost: "я не представляю чтобы в тебя влезло двенадцать баксиков",
        countLikes: 6,
        countComment: 1,
        countShare: 2,
        seesCount:  "469"),
    Post(name: "sanzespoir",
        imageProfile: UIImage(named: "sanzlogo")!,
        timePost: "вчера в 18:10",
        textPost: nil,
         ImagePost: UIImage(named: "sanzpost")!,
         countLikes: 47,
         countComment: 4,
         countShare: 5,
         seesCount: "1,5k"),
    Post(name: "Пездуза",
         imageProfile: UIImage(named: "Pezdusa")!,
         timePost: "вчера в 11:36",
         textPost: "«Наш народ должен показать Западу, что у него есть деньги». Кремль объяснил постоянный рост цен",
         ImagePost: nil,
         countLikes: 233,
         countComment: 10,
         countShare: 14,
         seesCount: "3,6k")
]
