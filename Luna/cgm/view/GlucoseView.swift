//
//  GlucoseView.swift
//  Luna
//
//  Created by Francis Pascual on 1/29/22.
//

import SwiftUI


struct LatestGlucoseView : View {
    let glucose: DisplayGlucose?
    var color: Color = Color("GlucoseLabel")
    
    var body: some View {
        VStack {
            GlucoseView(glucose: glucose, color: color)
            Text(LocalizedString.mgdl.localizedKey)
                .font(.title2)
                .fixedSize()
        }
    }
}

struct GlucoseView : View {
    let glucose: DisplayGlucose?
    var color: Color = Color("GlucoseLabel")
    
    var body: some View {
        let formatter = GlucoseFormatter()
        if let glucose = glucose {
            HStack {
                Text(formatter.string(mgdl: glucose.egv))
                    .font(.largeTitle)
                    .fixedSize()
                    .foregroundColor(color)
                
                TrendArrowView(trend: glucose.trend, color: color)
                    .frame(minWidth: 24)
            }
        } else {
            Text("--")
                .fixedSize()
                .font(.largeTitle)
                .foregroundColor(color)
        }
        
    }
}

struct TrendArrowView : View {
    let trend: Trend?
    var color: Color = Color("GlucoseLabel")
    
    var body: some View {
        if let trend = trend {
            if let arrowText = getArrowText(trend) {
                Text(arrowText)
                    .font(.largeTitle)
                    .foregroundColor(color)
            }
        }
    }
    
    private func getArrowText(_ trend: Trend) -> String? {
        // TODO: Need proper assets
        let name: String?
        switch(trend) {
        case .unknown:
            name = nil
        case .none:
            name = nil
        case .doubleUp:
            name = "↑↑"
        case .singleUp:
            name = "↑"
        case .fortyFiveUp:
            name = "↗"
        case .flat:
            name = "→"
        case .fortyFiveDown:
            name = "↘︎"
        case .singleDown:
            name = "↓"
        case .doubleDown:
            name = "↓↓"
        }
        return name
    }
}

extension TrendArrowView {
    func color(_ color: Color) -> TrendArrowView {
        var view = self
        view.color = color
        return view
    }
}

#if DEBUG
struct GlucoseView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            VStack {
                Text("No Glucose")
                    .foregroundColor(.red)
                LatestGlucoseView(glucose: nil)
                    .padding()
            }
            .padding()
            .border(.gray, width: 1.0)
            
            Text("All Trends")
                .foregroundColor(.red)
            let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
            LazyVGrid(columns: columns) {
                ForEach(Glucose.allTrends) { glucose in
                    VStack {
                        if let trend = glucose.trend {
                            Text(String(describing: trend))
                                .foregroundColor(.blue)
                        } else {
                            Text("nil")
                                .foregroundColor(.blue)
                        }
                        
                        LatestGlucoseView(glucose: glucose)
                            .padding()
                    }
                    .padding()
                }
            }
            .padding()
            .border(.gray, width: 1.0)
        }
        .frame(minWidth: 600.0, maxWidth: .infinity)
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
#endif
