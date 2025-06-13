import ProjectDescription

public enum SigningHelper {
    // 1️⃣ Header Search Paths 설정
    public static let headerSearchPaths: SettingsDictionary = [
      "HEADER_SEARCH_PATHS": .array([
        "$(inherited)",
        "$(SRCROOT)/../../Tuist/.build/checkouts/GTMAppAuth/GTMAppAuth/Sources/Public/GTMAppAuth",
        "$(SRCROOT)/../../Tuist/.build/checkouts/gtm-session-fetcher/Sources/Core/Public"
      ])
    ]

    // 2️⃣ Other Linker Flags 설정
    public static let objcFlags: SettingsDictionary = [
      "OTHER_LDFLAGS": .array(["-ObjC"])
    ]

    // 3️⃣ 기본 서명 설정
    public static let signingSettings: SettingsDictionary = [
      "DEVELOPMENT_TEAM": "D49753ZB3N",
      "CODE_SIGN_IDENTITY": "Apple Development",
      "PROVISIONING_PROFILE_SPECIFIER": "$(PROVISIONING_PROFILE_SPECIFIER)",
      "DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym"
    ]

    // 4️⃣ 세 설정 병합
    public static let mergedBaseSettings: SettingsDictionary = signingSettings
      // 헤더 경로 병합
      .merging(headerSearchPaths) { existing, new in
        if case let .array(old) = existing, case let .array(ne) = new {
          return .array(old + ne)
        }
        return new
      }
      // 링커 플래그 병합
      .merging(objcFlags) { existing, new in
        if case let .array(old) = existing, case let .array(ne) = new {
          return .array(old + ne)
        }
        return new
      }
}
