import ComposableArchitecture
import Core
import SwiftUI

public struct HomeView: View {
    @Bindable public var store: StoreOf<HomeReducer>
    public init (store: StoreOf<HomeReducer>) {
        self.store = store
    }
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                BackgroundView()
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    LatestBalanceView(latestMoney: store.latestBalance)
                    HStack {
                        LatestIncomeView(latestIncome: store.latestIncome)
                        LatestExpenseView(latestExpense: store.latestExpense)
                    }
                    GoalSettingButton(goal: store.goal, inputGoal: $store.inputGoal) {
                        store.send(.setGoal)
                    }
                    
                    GoalView(toGoal: store.toGoal, monthEstimate: store.monthEstimate)
                    
                    Spacer()
                    
                }
                .padding(.top, 10)
                .padding(.bottom, geometry.size.width / 5)
            }
            .navigationTitle("ホーム")
            .onAppear {
                store.send(.view(.onAppear))
            }
        }
    }
}
