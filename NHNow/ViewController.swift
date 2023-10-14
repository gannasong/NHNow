//
//  ViewController.swift
//  NHNow
//
//  Created by miguel on 2023/9/28.
//

import UIKit

class ViewController: UIViewController {
    // 請輸入起點座標
    let lat1 = 24.765597
    let lon1 = 121.739684
    // 請輸入終點座標
    let lat2 = 25.035905
    let lon2 = 121.563426

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green.withAlphaComponent(0.8)
        calculateGPXPoints()
    }

    func calculateGPXPoints() {
        let distance = calculateDistance(lat1: lat1,
                                         lon1: lon1,
                                         lat2: lat2,
                                         lon2: lon2)
        print("兩點之間的距離為 \(distance) 公尺")
        let desiredDistance: Int = 210
        let points = Int(distance) / desiredDistance
        print("每秒走 1 公尺， \(Int(distance)) 公尺共需要 \(points) 個點")
        var currentTime = Date()

        for i in 0..<points {
            let ratio = Double(i) / Double(points)
            let lat = lat1 + (lat2 - lat1) * ratio
            let lon = lon1 + (lon2 - lon1) * ratio
            currentTime = Calendar.current.date(byAdding: .second, value: 60, to: currentTime)!

            let intermediatePoint = """
            <wpt lat="\(lat)" lon="\(lon)">
                <name>no.\(i + 1) Point</name>
                <time>\(getCurrentGPXDateTime(timeZone: TimeZone(abbreviation: "GMT+8")!, date: currentTime))</time>
            </wpt>
            """

            print(intermediatePoint)
        }
    }

    func calculateDistance(lat1: Double, lon1: Double, lat2: Double, lon2: Double) -> Double {
        let earthRadius: Double = 6371 // 地球半径，单位千米

        // 将经纬度从度数转换为弧度
        let lat1InRadians = lat1 * .pi / 180.0
        let lon1InRadians = lon1 * .pi / 180.0
        let lat2InRadians = lat2 * .pi / 180.0
        let lon2InRadians = lon2 * .pi / 180.0

        // 使用 Haversine 公式计算距离
        let dlon = lon2InRadians - lon1InRadians
        let dlat = lat2InRadians - lat1InRadians
        let a = sin(dlat / 2) * sin(dlat / 2) + cos(lat1InRadians) * cos(lat2InRadians) * sin(dlon / 2) * sin(dlon / 2)
        let c = 2 * atan2(sqrt(a), sqrt(1 - a))

        // 计算距离
        let distance = earthRadius * c * 1000
        return distance
    }

    // 获取当前日期时间并格式化为GPX所需的格式
    func getCurrentGPXDateTime(timeZone: TimeZone) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        dateFormatter.timeZone = timeZone // 使用指定时区
        let currentDateTime = Date()
        return dateFormatter.string(from: currentDateTime)
    }

    // 格式化日期时间为GPX所需的格式
    func getCurrentGPXDateTime(timeZone: TimeZone, date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        dateFormatter.timeZone = timeZone // 使用指定时区
        return dateFormatter.string(from: date)
    }
}
