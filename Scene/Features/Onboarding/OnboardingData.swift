//
//  OnboardingData.swift
//  Scene
//
import Foundation

enum OnboardingData {

    static let all: [OnboardingModel] = [

        .init(
            title: "Upload your script.",
            subtitle: "إرفاق النص",
            image: "sceneLogo"
        ),

        .init(
            title: "Automatic script breakdown.",
            subtitle: "تفصيل النص بشكل تلقائي",
            image: "sceneLogo"
        ),

        .init(
            title: "Understand production costs.",
            subtitle: "إفهم تكلفة الصناعة",
            image: "sceneLogo"
        )
    ]
}
