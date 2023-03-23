//
//  Example.swift
//  Example
//
//  Created by jeongjiwoo on 2023/03/24.
//

import WidgetKit
import SwiftUI

public struct TodoModel:Codable {
  let id:Int, isCompleted: Bool, text: String;
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
      SimpleEntry(date: Date(), todos:[])
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
      let entry = SimpleEntry(date: Date(), todos:[])
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
      
        let userDefaults = UserDefaults(suiteName: "group.react.native.widget.example")
        let jsonText = userDefaults?.string(forKey: "data")
      
        var todos : [TodoModel] = []
        
        do {
          if jsonText != nil {
            let jsonData = Data(jsonText?.utf8 ?? "".utf8)
            let valueData = try JSONDecoder().decode([TodoModel].self, from: jsonData)
            
            todos = valueData
          }
        } catch {
          print(error)
        }

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, todos: todos)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
  let date: Date, todos: [TodoModel]
}

struct ExampleEntryView : View {
    var entry: Provider.Entry
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
      ZStack{
        colorScheme == .dark ? Color(red:51/255, green: 51/255, blue: 51/255) : Color(red:1.0, green:1.0, blue: 1.0)
        VStack(alignment: .leading){
          if entry.todos.count > 0 {
            VStack(alignment: .leading){
              ForEach(entry.todos, id : \.self.id){ todo in
                RowView(todo: todo)
              }
            }.frame(alignment: .leading)
          }
          else {
            Text("Please Add Todo").font(.system(size:14)).foregroundColor(Color.gray)
          }
        }.padding()
      }
    }
}

struct Example: Widget {
    let kind: String = "Example"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
          
            ExampleEntryView(entry: entry)
        }
        .configurationDisplayName("Simple Todo")
        .description("This is an simple todo widget.").supportedFamilies([.systemMedium])
    }
}

struct Example_Previews: PreviewProvider {
    static var previews: some View {
        ExampleEntryView(entry: SimpleEntry(date: Date(), todos: []))
        .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}

struct RowView : View {
  let todo : TodoModel
  @Environment(\.colorScheme) var colorScheme
  var body: some View {
    HStack(alignment: .center){
      
      if todo.isCompleted {
        NetworkImage(url:URL(string:colorScheme == .dark ? "https://d246jgzr1jye8u.cloudfront.net/development/admin/1679407341788-0.png":"https://d246jgzr1jye8u.cloudfront.net/development/admin/1679287981894-0.png")).frame(width: 16, height:16)
        Text(todo.text).font(.system(size: 14)).foregroundColor(Color.gray).strikethrough(true).frame(width:140, alignment: .leading).lineLimit(1)
      }
      else {
        NetworkImage(url:URL(string:colorScheme == .dark ? "https://d246jgzr1jye8u.cloudfront.net/development/admin/1679407364726-0.png":"https://d246jgzr1jye8u.cloudfront.net/development/admin/1679287954386-0.png")).frame(width: 16, height:16)
        Text(todo.text).font(.system(size: 14)).foregroundColor(colorScheme == .dark ? Color(red:1.0, green: 1.0, blue: 1.0) : Color(red:0.0, green: 0.0, blue: 0.0)).frame(width:140,alignment: .leading).lineLimit(1)
      }
    }
    Spacer()
  }
}

struct NetworkImage: View {

  let url: URL?

  var body: some View {

    Group {
     if let url = url, let imageData = try? Data(contentsOf: url),
       let uiImage = UIImage(data: imageData) {

       Image(uiImage: uiImage)
         .resizable()
         .aspectRatio(contentMode: .fill)
      }
      else {
       Image("default_image")
      }
    }
  }

}
