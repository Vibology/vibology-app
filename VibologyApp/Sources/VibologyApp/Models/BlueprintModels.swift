import Foundation

// MARK: - Request

struct BlueprintRequest: Encodable {
    let name: String
    let year: Int
    let month: Int
    let day: Int
    let hour: Int
    let minute: Int
    let second: Int
    let place: String

    init(name: String, year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int = 0, place: String) {
        self.name = name
        self.year = year
        self.month = month
        self.day = day
        self.hour = hour
        self.minute = minute
        self.second = second
        self.place = place
    }
}

// MARK: - Response Root

struct BlueprintResponse: Decodable {
    let meta: BlueprintMeta
    let astrology: AstrologyData
    let humanDesign: HumanDesignData
}

// MARK: - Meta

struct BlueprintMeta: Decodable {
    let name: String
    let birthDate: String
    let birthTime: String
    let designDate: String
    let designTime: String
    let place: String
    let coordinates: Coordinates
    let timezone: String
    let calculationTimestamp: String

    struct Coordinates: Decodable {
        let lat: Double
        let lon: Double
    }
}

// MARK: - Astrology

struct AstrologyData: Decodable {
    let planets: [String: PlanetData]
    let houses: [String: Double]
    let aspects: [AspectData]
    let lunarPhase: LunarPhase
    let elements: [String: Int]
    let modalities: [String: Int]
}

struct PlanetData: Decodable {
    let sign: String
    let longitude: Double
    let latitude: Double?
    let speed: Double?
    let retrograde: Bool
    let house: Int
}

struct AspectData: Decodable {
    let planet1: String
    let planet2: String
    let aspect: String
    let orb: Double
    let applying: Bool
}

struct LunarPhase: Decodable {
    let degreesBetweenSM: Double
    let moonPhase: Int
    let moonPhaseName: String
}

// MARK: - Human Design

struct HumanDesignData: Decodable {
    let type: HDType
    let authority: HDAuthority
    let profile: HDProfile
    let definition: HDDefinition
    let variables: HDVariables
    let planets: HDPlanets
    let channels: [String]
}

struct HDType: Decodable {
    let energyType: String
    let strategy: String
    let signature: String
    let notSelf: String
    let aura: String
}

struct HDAuthority: Decodable {
    let innerAuthority: String
}

struct HDProfile: Decodable {
    let profile: String
    let incarnationCross: String
}

struct HDDefinition: Decodable {
    let definitionType: String
    let definedCenters: [String]
    let undefinedCenters: [String]
}

struct HDVariables: Decodable {
    let topLeft: HDVariableArrow?
    let bottomLeft: HDVariableArrow?
    let topRight: HDVariableArrow?
    let bottomRight: HDVariableArrow?

    struct HDVariableArrow: Decodable {
        let value: String
    }
}

struct HDPlanets: Decodable {
    let personality: [String: HDPlanetData]
    let design: [String: HDPlanetData]
}

struct HDPlanetData: Decodable {
    let longitude: Double?
    let gate: Int
    let line: Int
    let color: Int?
    let tone: Int?
    let base: Int?
    let channelPartner: Int?
    let dignity: String?
}
