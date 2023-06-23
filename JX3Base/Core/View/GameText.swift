//
//  GameText.swift
//  JX3Demo
//
//  Created by Wttch on 2023/6/23.
//

import Foundation
import SwiftUI


struct JX3GameText: View {
    var text: String
    
    var color: Color? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(texts, content: { textLine in
                HStack(spacing: 0) {
                    ForEach(textLine.texts, content: { text in
                        Text("\(text.styles["text"]!)".replacingOccurrences(of: "\\n", with: "\n"))
                            .foregroundColor(color ?? text.color)
                    })
                }
            })
        }
    }
    
    var texts: [JX3StyleTextLine] {
        get {
            var result: [JX3StyleTextLine] = []
            var line : [JX3StyleText] = []
            let gameTextParse = GameTextXmlParse(text)
            for text in gameTextParse.styleTexts {
                let textStr = "\(text.styles["text"]!)"
                    .replacingOccurrences(of: "\\\\\\n", with: "\n")
                    .replacingOccurrences(of: "\\\\n", with: "\n")
                    .replacingOccurrences(of: "\\n", with: "\n")
                    .replacingOccurrences(of: "\\\\\\\\$", with: "", options: .regularExpression, range: nil)
                var t = text
                t.styles["text"] = textStr.replacingOccurrences(of: "\n$", with: "", options: .regularExpression, range: nil)
                line.append(t)
                if textStr.hasSuffix("\n") {
                    result.append(JX3StyleTextLine(id: text.id, texts: line))
                    line = []
                }
            }
            if !line.isEmpty {
                result.append(JX3StyleTextLine(id: -1, texts: line))
            }
            return result
        }
    }
    
    
    struct JX3StyleTextLine: Identifiable {
        typealias ID = Int
        var id: Int
        var texts: [JX3StyleText] = []
    }
}

struct JX3GameText_Previews: PreviewProvider {
    static var previews: some View {
        JX3GameText(text: "<Text>text=\"使用：本周每获得5000点战阶积分，可以开启一次瑰石\\n获得如下的装备，每周最多开启二个。\\n\" font=105 </text><Text>text=\"[怒鳞翻江·碎月重剑]\" name=\"iteminfolink\" eventid=513 script=\"this.nVersion=0 this.dwTabType=6 this.dwIndex=27689 this.OnItemLButtonDown=function() OnItemLinkDown(this) end\" font=100 r=255 g=40 b=255 </text><Text>text=\"，\" font=100 </text><Text>text=\"[怒鳞翻江·碎月轻剑]\" name=\"iteminfolink\" eventid=513 script=\"this.nVersion=0 this.dwTabType=6 this.dwIndex=27688 this.OnItemLButtonDown=function() OnItemLinkDown(this) end\" font=100 r=255 g=40 b=255 </text><Text>text=\"。\" font=100 </text>")
    }
}

struct JX3StyleText : Identifiable {
    typealias ID = Int
    var id: Int
    var styles: [String: String]
    var color: Color? {
        get {
            if let rStr = styles["r"], let gStr = styles["g"], let bStr = styles["b"] {
                if let r = Int(rStr), let g = Int(gStr), let b = Int(bStr) {
                    return Color(cgColor: CGColor(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: 1))
                }
            }
            return nil
        }
    }
}

//
//     * 将游戏内的形如`<Text>text="****" font="**" **=***</text>`的字符串进行解析
//     * 返回一个包含font、text等属性的对象，方便进行进一步的渲染或者其他处理。
//     * @param {String} str
//     */
//    extractTextContent(str) {
//        if (!str || typeof str !== "string") return [];
//        let result = [];
//        const innerHTML = str.replace(/<Text>(.*?)<\/text>/gimsy, `<span $1></span>`);
//        let $ = cheerio.load(`<div>${innerHTML}</div>`);
//        let spans = $('span');
//        if (!spans.length) return [];
//        for (let span of spans)
//            result.push(Object.assign({}, span.attribs));
//        return result;
//    },

class GameTextXmlParse: XMLParser {
    var styleTexts: [JX3StyleText] = []

    init(_ text: String) {
        // xml字符串
        var xmlString = "<xml>" + text + "</xml>"
        // 替换<Text>***</text>为<span ***></span>
        xmlString = xmlString.replacingOccurrences(of: "<[Tt]ext>(.*?)</text>", with: "<span $1></span>", options: .regularExpression, range: nil)
        // swift xml库解析时属性的值必须为带引号的
        xmlString  = xmlString.replacingOccurrences(of: "=(\\d+)", with: "='$1'", options: .regularExpression, range: nil)
        logger(xmlString)
        super.init(data: xmlString.data(using: .utf8) ?? Data())
        self.delegate = self
        self.parse()
    }
}

extension GameTextXmlParse: XMLParserDelegate {
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        switch elementName {
        case "span":
            logger("\(attributeDict)")
            styleTexts.append(JX3StyleText(id: styleTexts.count, styles: attributeDict))
        default:
            return
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
    }
        
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
    }
    
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        logger(parseError)
        logger("")
    }
}


/// https://github.com/JX3BOX/jx3box-common/blob/master/js/utils.js
class JX3Util {
    
    
    static func quality2Color(_ quality: Int?) -> Color? {
        guard let quality = quality else {
            return nil
        }
        
        switch (quality) {
            case 0, 1: return Color.white
            // 00d24b
            case 2: return Color(red: 0x00 / 255, green: 0xd2 / 255, blue: 0x4b / 255)
            // 007eff
            case 3: return Color(red: 0x00 / 255, green: 0x7e / 255, blue: 0xff / 255)
            // ff2dff
            case 4: return Color(red: 0xff / 255, green: 0x2d / 255, blue: 0xff / 255)
            // ffa500
            case 5: return Color(red: 0xff / 255, green: 0xa5 / 255, blue: 0x00 / 255)
            default: return Color.white
        }
    }
}
