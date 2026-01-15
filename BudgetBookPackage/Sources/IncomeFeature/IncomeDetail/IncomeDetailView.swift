import SwiftUI

public struct DetailIncomeView: View {
    
    public init() {
        
    }
    
    public var body: some View {
        VStack {
            SourceRateGraphView()
            IncomeSourceListView()
        }
    }
}
