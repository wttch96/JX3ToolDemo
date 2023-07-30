
/// System Lua 中的属性转换为通用的计算属性
struct LuaConvertValue: Decodable, Identifiable {
    let id: Int
    let slot: String
    let isValue: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case slot = "AttributeSlot"
        case isValue
    }
}
