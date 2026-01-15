import Charts
import Core
import SwiftUI

public struct SourceRateGraphView: View {
    let data: [Income]
    public var body: some View {
        VStack {
            Chart(data, id: \.id) { element in
                SectorMark(
                    angle: .value("Amount", element.amount),
                    innerRadius: .ratio(0.7),
                    angularInset: 1.2
                )
                .foregroundStyle(by: .value("Source", element.source))
            }
            .chartBackground { chartProxy in
                GeometryReader { geometry in
                    let frame = geometry[chartProxy.plotAreaFrame]
                    VStack {
                        Text(data.first?.displayMonth() ?? "")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text("\(data.reduce(0) { $0 + $1.amount })円")
                            .font(.title3.bold())
                            .foregroundColor(.primary)
                    }
                    .position(x: frame.midX, y: frame.midY)
                }
            }
            .padding()
        }
        .background(.ultraThickMaterial)
        .cornerRadius(20)
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .shadow(radius: 10)
        .frame(height: 300)
    }
}
