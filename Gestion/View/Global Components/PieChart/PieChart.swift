//
//  PieChart.swift
//  Gestion
//
//  Created by Kevin Bertrand on 30/08/2022.
//

import SwiftUI

struct PieChartView: View {
    // MARK: States
    @State private var activeIndex: Int = -1
    
    // MARK: Properties
    private let values: [Double]
    private let names: [String]
    private let formatter: (Double) -> String
    private let backgroundColor: Color
    private let maxWidth: CGFloat
    private var colors: [Color]
    private var foregroundColor: Color
    private var widthFraction: CGFloat
    private var innerRadiusFraction: CGFloat
    private var size: (CGSize)->Void
    
    var slices: [PieSliceData] {
        let sum = values.reduce(0, +)
        var endDeg: Double = 0
        var tempSlices: [PieSliceData] = []
        
        for (i, value) in values.enumerated() {
            let degrees: Double = value * 360 / sum
            tempSlices.append(PieSliceData(startAngle: Angle(degrees: endDeg), endAngle: Angle(degrees: endDeg + degrees), text: String(format: "%.0f%%", value * 100 / sum), color: self.colors[i]))
            endDeg += degrees
        }
        return tempSlices
    }
    
    // MARK: Initialization
    init(values:[Double],
         names: [String],
         formatter: @escaping (Double) -> String,
         colors: [Color] = [Color.accentColor,
                            Color.gray,
                            Color.orange],
         colorScheme: ColorScheme,
         backgroundColor: Color = .black,
         widthFraction: CGFloat = 0.75,
         innerRadiusFraction: CGFloat = 0.60,
         maxWidth: CGFloat = 500,
         size: @escaping (CGSize) -> Void){
        self.values = values
        self.names = names
        self.formatter = formatter
        self.size = size
        self.colors = colors
        self.foregroundColor = (colorScheme == .dark) ? .white : .black
        self.widthFraction = widthFraction
        self.innerRadiusFraction = innerRadiusFraction
        self.backgroundColor = backgroundColor
        self.maxWidth = maxWidth
    }
    
    // MARK: Body
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack {
                    ForEach(0..<slices.count) { i in
                        withAnimation(.spring()) {
                            PieSlice(pieSliceData: self.slices[i])
                                .scaleEffect(self.activeIndex == i ? 1.03 : 1)
                        }
                    }
                    .frame(width: widthFraction * geometry.size.width, height: widthFraction * geometry.size.width)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                let radius = 0.5 * widthFraction * geometry.size.width
                                let diff = CGPoint(x: value.location.x - radius, y: radius - value.location.y)
                                let dist = pow(pow(diff.x, 2.0) + pow(diff.y, 2.0), 0.5)
                                if (dist > radius || dist < radius * innerRadiusFraction) {
                                    self.activeIndex = -1
                                    return
                                }
                                var radians = Double(atan2(diff.x, diff.y))
                                if (radians < 0) {
                                    radians = 2 * Double.pi + radians
                                }
                                
                                for (i, slice) in slices.enumerated() {
                                    if (radians < slice.endAngle.radians) {
                                        self.activeIndex = i
                                        break
                                    }
                                }
                            }
                            .onEnded { value in
                                self.activeIndex = -1
                            }
                    )
                    Circle()
                        .fill(ColorManager.tileBackground.color)
                        .frame(width: widthFraction * geometry.size.width * innerRadiusFraction,
                               height: widthFraction * geometry.size.width * innerRadiusFraction)
                    VStack {
                        Text(self.activeIndex == -1 ? "Total" : names[self.activeIndex])
                            .font(.title)
                            .foregroundColor(Color.gray)
                        Text(self.formatter(self.activeIndex == -1 ? values.reduce(0, +) : values[self.activeIndex]))
                            .font(.title)
                    }.foregroundColor(foregroundColor)
                    
                }
                PieChartRows(colors: self.colors, 
                             names: self.names,
                             values: self.values.map { self.formatter($0) }, 
                             percents: self.values.map { String(format: "%.0f%%", $0 * 100 / self.values.reduce(0, +)) },
                             foregroundColor: foregroundColor)
            }
            .background(backgroundColor)
            .foregroundColor(Color.white)
            .preference(key: SizePreferenceKey.self, value: geometry.size)
        }
        .frame(maxWidth: maxWidth)
        .onPreferenceChange(SizePreferenceKey.self) { newSize in
            self.size(newSize)
        }
    }
}

struct PieChartRows: View {
    // MARK: Properties
    var colors: [Color]
    var names: [String]
    var values: [String]
    var percents: [String]
    var foregroundColor: Color
    
    // MARK: Body
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 25) {
                ForEach(0..<values.count) { i in
                    VStack {
                        RoundedRectangle(cornerRadius: 5.0)
                            .fill(self.colors[i])
                            .frame(width: 20, height: 20)
                        Text(self.names[i])
                            .foregroundColor(foregroundColor)
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text(self.values[i])
                            .foregroundColor(foregroundColor)
                        Text(self.percents[i])
                            .foregroundColor(Color.gray)
                        
                    }
                    if i < values.count-1 {
                        Divider()
                    }
                }
            }
        }
    }
}

#Preview {
    PieChartView(values: [1300, 500, 300], 
                 names: ["Rent", "Transport", "Education"], 
                 formatter: {value in String(format: "$%.2f", value)},
                 colorScheme: .dark,
                 size: {_ in})
}
