//
//  AppDelegate.swift
//  Runner
//
//  Created by Reuven Levitsky on 13/12/2023.
//

import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application,
                                 didFinishLaunchingWithOptions: launchOptions)
    }
}
