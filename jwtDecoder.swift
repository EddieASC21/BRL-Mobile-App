import Foundation

struct JWTPayload: Codable {
    let exp: TimeInterval
}

final class JWTDecode {
    static func decodeExpiration(from token: String) -> Date? {
        let segments = token.split(separator: ".")
        guard segments.count > 1 else { return nil }

        let payloadSegment = segments[1]
        
        // Pad base64 if necessary
        var base64 = payloadSegment.replacingOccurrences(of: "-", with: "+")
                                    .replacingOccurrences(of: "_", with: "/")
        let paddedLength = 4 * ((base64.count + 3) / 4)
        base64 = base64.padding(toLength: paddedLength, withPad: "=", startingAt: 0)
        
        guard let data = Data(base64Encoded: base64) else { return nil }
        guard let payload = try? JSONDecoder().decode(JWTPayload.self, from: data) else { return nil }

        return Date(timeIntervalSince1970: payload.exp)
    }
}
