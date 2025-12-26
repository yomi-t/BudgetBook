import SwiftUI

public struct AddSourceView: View {
    // アラートのタイトル
    let title: String
    
    // アラートの表示/非表示を切り替えるためのBinding
    @Binding var isPresented: Bool
    
    // 決定時の処理（入力された文字列を渡す）
    let addSource: (String) -> Void
    
    // 入力テキストの状態管理
    @State private var text: String = ""

    public var body: some View {
        ZStack {
            // 1. 背景を半透明の黒にする（タップで閉じる機能付き）
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
            
            // 2. アラートの本体（白い箱）
            VStack(spacing: 20) {
                Text(title)
                    .font(.headline)
                    .padding(.top)
                
                TextField("収入源を入力", text: $text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                HStack(spacing: 0) {
                    // キャンセルボタン
                    Button(action: {
                        isPresented = false
                        text = "" // キャンセル時はクリア
                    }) {
                        Text("キャンセル")
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                    
                    Divider() // ボタンの区切り線
                    
                    // 決定ボタン
                    Button(action: {
                        if !text.isEmpty {
                            addSource(text) // 親に値を渡す
                            text = ""      // 入力をクリア
                            isPresented = false // アラートを閉じる
                        }
                    }) {
                        Text("決定")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                    .disabled(text.isEmpty)
                }
                .frame(height: 50)
            }
            .frame(width: 300) // アラートの幅
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 10)
        }
    }
}
