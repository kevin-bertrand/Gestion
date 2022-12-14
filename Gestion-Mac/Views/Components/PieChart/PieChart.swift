//
//  PieChart.swift
//  Gestion-Mac
//
//  Created by Kevin Bertrand on 27/10/2022.
//

import SwiftUI

public struct PieChartView: View {
    private let values: [Double]
    private let names: [String]
    private let formatter: (Double) -> String
    
    private var colors: [Color]
    private var foregroundColor: Color
    
    private var widthFraction: CGFloat
    private var innerRadiusFraction: CGFloat
    
    @State private var activeIndex: Int = -1
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
    
    public init(values:[Double],
                names: [String],
                formatter: @escaping (Double) -> String,
                colors: [Color] = [Color.accentColor,
                                   Color.gray,
                                   Color.orange],
                colorScheme: ColorScheme,
                widthFraction: CGFloat = 0.75,
                innerRadiusFraction: CGFloat = 0.60,
                size: @escaping (CGSize) -> Void){
        self.values = values
        self.names = names
        self.formatter = formatter
        self.size = size
        self.colors = colors
        self.foregroundColor = (colorScheme == .dark) ? .white : .black
        self.widthFraction = widthFraction
        self.innerRadiusFraction = innerRadiusFraction
    }
    
    public var body: some View {
        GeometryReader { geometry in
            VStack{
                ZStack{
                    ForEach(0..<3){ i in
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
                        .fill(Color("TileBackground"))
                        .frame(width: widthFraction * geometry.size.width * innerRadiusFraction, height: widthFraction * geometry.size.width * innerRadiusFraction)
                    
                    VStack {
                        Text(self.activeIndex == -1 ? "Total" : names[self.activeIndex])
                            .font(.title)
                            .foregroundColor(Color.gray)
                        Text(self.formatter(self.activeIndex == -1 ? values.reduce(0, +) : values[self.activeIndex]))
                            .font(.title)
                    }.foregroundColor(foregroundColor)
                    
                }
                PieChartRows(colors: self.colors, names: self.names, values: self.values.map { self.formatter($0) }, percents: self.values.map { String(format: "%.0f%%", $0 * 100 / self.values.reduce(0, +)) }, foregroundColor: foregroundColor)
            }
            .background(Color("TileBackground"))
            .foregroundColor(Color.white)
            .preference(key: SizePreferenceKey.self, value: geometry.size)
        }
        .onPreferenceChange(SizePreferenceKey.self) { newSize in
            self.size(newSize)
        }
    }
}

struct PieChartRows: View {
    var colors: [Color]
    var names: [String]
    var values: [String]
    var percents: [String]
    var foregroundColor: Color
    
    var body: some View {
        VStack{
            ForEach(0..<3){ i in
                HStack {
                    RoundedRectangle(cornerRadius: 5.0)
                        .fill(self.colors[i])
                        .frame(width: 20, height: 20)
                    Text(self.names[i])
                        .foregroundColor(foregroundColor)
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text(self.values[i])
                            .foregroundColor(foregroundColor)
                        Text(self.percents[i])
                            .foregroundColor(Color.gray)
                    }
                }
            }
        }
    }
}

struct PieChartView_Previews: PreviewProvider {
    static var previews: some View {
        PieChartView(values: [1300, 500, 300], names: ["Rent", "Transport", "Education"], formatter: {value in String(format: "$%.2f", value)}, colorScheme: .dark, size: {_ in })
    }
}
