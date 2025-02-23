import SwiftUI

struct MaterialsView: View {
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    TextField("Поиск", text: .constant(""))
                        .padding(10)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(12)
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Курсы")
                            .font(.headline)
                            .bold()
                            .padding(.horizontal, 20)
                        
                        ForEach(1...3, id: \.self) { _ in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Тема")
                                        .font(.subheadline)
                                        .bold()
                                    Text("Название курса")
                                        .font(.footnote)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(radius: 2)
                            .padding(.horizontal, 20)
                        }
                        
                        Text("Материалы")
                            .font(.headline)
                            .bold()
                            .padding(.horizontal, 20)
                            .padding(.top, 10)
                        
                        ForEach(1...2, id: \.self) { index in
                            HStack {
                                Text("Название")
                                Spacer()
                                Text(index == 1 ? "15%" : "0%")
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(radius: 2)
                            .padding(.horizontal, 20)
                        }
                    }
                }
            }
            .navigationBarTitle("Материалы", displayMode: .large)
        }
    }
}

struct LearningView_Previews: PreviewProvider {
    static var previews: some View {
        MaterialsView()
    }
}
