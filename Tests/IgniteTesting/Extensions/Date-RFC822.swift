//
//  Date-RFC822.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `Date-RFC822` extension.
///
/// NOTE: These tests only test against dates in the Unix Epoch (since January 1, 1970, see https://en.wikipedia.org/wiki/Unix_time)
/// testing time zone output against historical times (times before standardized time zones)
/// is tricky and beyond the scope of what this project needs.
@Suite("Date-RFC822 Tests")
@MainActor
struct DateRFC822Tests {

    struct Instance {
        let input: Date
        let expected: String
    }

    @Test("Generate Example Dates")
    func generateExampleDatesForTesting() {
        for _ in 0 ..< 10 {
            let time = TimeInterval.random(in: 0 ..< Date.distantFuture.timeIntervalSince1970)
            print(time)
        }
        
        /* Output
         20012346618.957466
         56076958399.89086
         43889947931.30432
         60401587537.13003
         2887257381.52073
         15764928045.389473
         30573435574.337566
         2818825684.6154914
         9199677333.36627
         53706378711.11124
         */
    }
    
    @Test("Print Out supported timezones with abbreviations")
    func reportTimeZoneInfo() async throws {
        for (abbreviation, identifier) in TimeZone.abbreviationDictionary {
            guard let timezone = TimeZone(identifier: identifier) else { continue }
            
            print("\(abbreviation)\t\(Double(timezone.secondsFromGMT())/3600)\t\(identifier)")
        }
        /* Output:
         PET    -5.0    America/Lima
         EST    -5.0    America/New_York
         PDT    -8.0    America/Los_Angeles
         KST    9.0    Asia/Seoul
         MST    -7.0    America/Phoenix
         WET    0.0    Europe/Lisbon
         BDT    6.0    Asia/Dhaka
         EEST    2.0    Europe/Athens
         SGT    8.0    Asia/Singapore
         CLST    -3.0    America/Santiago
         BRST    -3.0    America/Sao_Paulo
         CDT    -6.0    America/Chicago
         CEST    1.0    Europe/Paris
         EAT    3.0    Africa/Addis_Ababa
         CST    -6.0    America/Chicago
         UTC    0.0    UTC
         WEST    0.0    Europe/Lisbon
         PHT    8.0    Asia/Manila
         GMT    0.0    GMT
         MSK    3.0    Europe/Moscow
         NDT    -3.5    America/St_Johns
         IRST    3.5    Asia/Tehran
         AKST    -9.0    America/Juneau
         ICT    7.0    Asia/Bangkok
         AKDT    -9.0    America/Juneau
         EET    2.0    Europe/Athens
         CLT    -3.0    America/Santiago
         PST    -8.0    America/Los_Angeles
         TRT    3.0    Europe/Istanbul
         BRT    -3.0    America/Sao_Paulo
         COT    -5.0    America/Bogota
         NZST    13.0    Pacific/Auckland
         CET    1.0    Europe/Paris
         NST    -3.5    America/St_Johns
         WAT    1.0    Africa/Lagos
         NZDT    13.0    Pacific/Auckland
         PKT    5.0    Asia/Karachi
         CAT    2.0    Africa/Harare
         ADT    -4.0    America/Halifax
         HST    -10.0    Pacific/Honolulu
         AST    -4.0    America/Halifax
         GST    4.0    Asia/Dubai
         MSD    3.0    Europe/Moscow
         EDT    -5.0    America/New_York
         JST    9.0    Asia/Tokyo
         HKT    8.0    Asia/Hong_Kong
         MDT    -7.0    America/Denver
         BST    0.0    Europe/London
         WIT    7.0    Asia/Jakarta
         ART    -3.0    America/Argentina/Buenos_Aires
         IST    5.5    Asia/Kolkata
         */
    }
    @Test("Generate Instances in other time zones")
    func generate_EDT_rfc822() async throws {
        let times: [TimeInterval] = [
            60228332501.13208,
            27871740518.22975,
            -3284356034.069809,
            17552683531.75113,
            52184037958.68115,
            -46964633818.02554,
            9676773717.779556,
            -46716978084.27513,
            60228133082.71135,
            -37373736994.632614
        ]
                
        let timezones: [TimeZone] = [
            TimeZone(abbreviation: "EDT"), // north america, daylight savings
            TimeZone(abbreviation: "NDT"), // americas, off by 30 min from most timezones
            TimeZone(abbreviation: "WIT"), // asica, ahead of GMT
            TimeZone(abbreviation: "IST") // asia, ahead of GMT, off by 30 min from most timezones
        ].compactMap(\.self)
        
        for timezone in timezones {
            print(timezone.abbreviation())
            for time in times {
                let date = Date(timeIntervalSince1970: time)
                print("Instance(input: Date(timeIntervalSince1970: \(time)), expected: \"\(date.asRFC822(timeZone: timezone))\"),")
            }
        }
        /* Output:
         Optional("EST")
         Instance(input: Date(timeIntervalSince1970: 60228332501.13208), expected: "Wed, 24 Jul 3878 00:21:41 -0400"),
         Instance(input: Date(timeIntervalSince1970: 27871740518.22975), expected: "Fri, 21 Mar 2853 10:08:38 -0400"),
         Instance(input: Date(timeIntervalSince1970: -3284356034.069809), expected: "Sun, 03 Dec 1865 09:56:43 -045602"),
         Instance(input: Date(timeIntervalSince1970: 17552683531.75113), expected: "Fri, 22 Mar 2526 21:25:31 -0400"),
         Instance(input: Date(timeIntervalSince1970: 52184037958.68115), expected: "Thu, 24 Aug 3623 18:05:58 -0400"),
         Instance(input: Date(timeIntervalSince1970: -46964633818.02554), expected: "Tue, 29 Sep 0481 15:26:59 -045602"),
         Instance(input: Date(timeIntervalSince1970: 9676773717.779556), expected: "Wed, 23 Aug 2276 12:41:57 -0400"),
         Instance(input: Date(timeIntervalSince1970: -46716978084.27513), expected: "Sat, 05 Aug 0489 00:42:33 -045602"),
         Instance(input: Date(timeIntervalSince1970: 60228133082.71135), expected: "Sun, 21 Jul 3878 16:58:02 -0400"),
         Instance(input: Date(timeIntervalSince1970: -37373736994.632614), expected: "Tue, 30 Aug 0785 09:27:23 -045602"),
         
         NDT
         Optional("GMT-3:30")
         Instance(input: Date(timeIntervalSince1970: 60228332501.13208), expected: "Wed, 24 Jul 3878 01:51:41 -0230"),
         Instance(input: Date(timeIntervalSince1970: 27871740518.22975), expected: "Fri, 21 Mar 2853 11:38:38 -0230"),
         Instance(input: Date(timeIntervalSince1970: -3284356034.069809), expected: "Sun, 03 Dec 1865 11:21:53 -033052"),
         Instance(input: Date(timeIntervalSince1970: 17552683531.75113), expected: "Fri, 22 Mar 2526 22:55:31 -0230"),
         Instance(input: Date(timeIntervalSince1970: 52184037958.68115), expected: "Thu, 24 Aug 3623 19:35:58 -0230"),
         Instance(input: Date(timeIntervalSince1970: -46964633818.02554), expected: "Tue, 29 Sep 0481 16:52:09 -033052"),
         Instance(input: Date(timeIntervalSince1970: 9676773717.779556), expected: "Wed, 23 Aug 2276 14:11:57 -0230"),
         Instance(input: Date(timeIntervalSince1970: -46716978084.27513), expected: "Sat, 05 Aug 0489 02:07:43 -033052"),
         Instance(input: Date(timeIntervalSince1970: 60228133082.71135), expected: "Sun, 21 Jul 3878 18:28:02 -0230"),
         Instance(input: Date(timeIntervalSince1970: -37373736994.632614), expected: "Tue, 30 Aug 0785 10:52:33 -033052"),
         
         WIT
         Optional("GMT+7")
         Instance(input: Date(timeIntervalSince1970: 60228332501.13208), expected: "Wed, 24 Jul 3878 11:21:41 +0700"),
         Instance(input: Date(timeIntervalSince1970: 27871740518.22975), expected: "Fri, 21 Mar 2853 21:08:38 +0700"),
         Instance(input: Date(timeIntervalSince1970: -3284356034.069809), expected: "Sun, 03 Dec 1865 21:59:57 +070712"),
         Instance(input: Date(timeIntervalSince1970: 17552683531.75113), expected: "Sat, 23 Mar 2526 08:25:31 +0700"),
         Instance(input: Date(timeIntervalSince1970: 52184037958.68115), expected: "Fri, 25 Aug 3623 05:05:58 +0700"),
         Instance(input: Date(timeIntervalSince1970: -46964633818.02554), expected: "Wed, 30 Sep 0481 03:30:13 +070712"),
         Instance(input: Date(timeIntervalSince1970: 9676773717.779556), expected: "Wed, 23 Aug 2276 23:41:57 +0700"),
         Instance(input: Date(timeIntervalSince1970: -46716978084.27513), expected: "Sat, 05 Aug 0489 12:45:47 +070712"),
         Instance(input: Date(timeIntervalSince1970: 60228133082.71135), expected: "Mon, 22 Jul 3878 03:58:02 +0700"),
         Instance(input: Date(timeIntervalSince1970: -37373736994.632614), expected: "Tue, 30 Aug 0785 21:30:37 +070712"),
         
         IST
         Optional("GMT+5:30")
         Instance(input: Date(timeIntervalSince1970: 60228332501.13208), expected: "Wed, 24 Jul 3878 09:51:41 +0530"),
         Instance(input: Date(timeIntervalSince1970: 27871740518.22975), expected: "Fri, 21 Mar 2853 19:38:38 +0530"),
         Instance(input: Date(timeIntervalSince1970: -3284356034.069809), expected: "Sun, 03 Dec 1865 20:46:05 +055320"),
         Instance(input: Date(timeIntervalSince1970: 17552683531.75113), expected: "Sat, 23 Mar 2526 06:55:31 +0530"),
         Instance(input: Date(timeIntervalSince1970: 52184037958.68115), expected: "Fri, 25 Aug 3623 03:35:58 +0530"),
         Instance(input: Date(timeIntervalSince1970: -46964633818.02554), expected: "Wed, 30 Sep 0481 02:16:29 +055328"),
         Instance(input: Date(timeIntervalSince1970: 9676773717.779556), expected: "Wed, 23 Aug 2276 22:11:57 +0530"),
         Instance(input: Date(timeIntervalSince1970: -46716978084.27513), expected: "Sat, 05 Aug 0489 11:32:03 +055328"),
         Instance(input: Date(timeIntervalSince1970: 60228133082.71135), expected: "Mon, 22 Jul 3878 02:28:02 +0530"),
         Instance(input: Date(timeIntervalSince1970: -37373736994.632614), expected: "Tue, 30 Aug 0785 20:16:53 +055328"),

         */
    }


    @Test("Test Against Known Output for Default Time Zone", arguments: [
        Instance(input: Date(timeIntervalSince1970: 60228332501.13208), expected: "Wed, 24 Jul 3878 04:21:41 +0000"),
        Instance(input: Date(timeIntervalSince1970: 27871740518.22975), expected: "Fri, 21 Mar 2853 14:08:38 +0000"),
        Instance(input: Date(timeIntervalSince1970: -3284356034.069809), expected: "Sun, 03 Dec 1865 14:52:45 +0000"),
        Instance(input: Date(timeIntervalSince1970: 17552683531.75113), expected: "Sat, 23 Mar 2526 01:25:31 +0000"),
        Instance(input: Date(timeIntervalSince1970: 52184037958.68115), expected: "Thu, 24 Aug 3623 22:05:58 +0000"),
        Instance(input: Date(timeIntervalSince1970: -46964633818.02554), expected: "Tue, 29 Sep 0481 20:23:01 +0000"),
        Instance(input: Date(timeIntervalSince1970: 9676773717.779556), expected: "Wed, 23 Aug 2276 16:41:57 +0000"),
        Instance(input: Date(timeIntervalSince1970: -46716978084.27513), expected: "Sat, 05 Aug 0489 05:38:35 +0000"),
        Instance(input: Date(timeIntervalSince1970: 60228133082.71135), expected: "Sun, 21 Jul 3878 20:58:02 +0000"),
        Instance(input: Date(timeIntervalSince1970: -37373736994.632614), expected: "Tue, 30 Aug 0785 14:23:25 +0000")
    ])
    func outputs_expected_result(instance: Instance) async throws {
        #expect(instance.input.asRFC822() == instance.expected)
    }
    
    @Test("Test Against Known Output for New York Time", arguments: [
        Instance(input: Date(timeIntervalSince1970: 20012346618.957466), expected: "Fri, 02 Mar 2604 04:10:18 -0500"),
        Instance(input: Date(timeIntervalSince1970: 56076958399.89086), expected: "Tue, 03 Jan 3747 15:53:19 -0500"),
        Instance(input: Date(timeIntervalSince1970: 43889947931.30432), expected: "Sat, 25 Oct 3360 08:12:11 -0400"),
        Instance(input: Date(timeIntervalSince1970: 60401587537.13003), expected: "Sat, 19 Jan 3884 05:45:37 -0500"),
        Instance(input: Date(timeIntervalSince1970: 2887257381.52073), expected: "Wed, 29 Jun 2061 03:56:21 -0400"),
        Instance(input: Date(timeIntervalSince1970: 15764928045.389473), expected: "Sat, 27 Jul 2469 06:40:45 -0400"),
        Instance(input: Date(timeIntervalSince1970: 30573435574.337566), expected: "Sat, 01 Nov 2938 00:59:34 -0400"),
        Instance(input: Date(timeIntervalSince1970: 2818825684.6154914), expected: "Tue, 29 Apr 2059 03:08:04 -0400"),
        Instance(input: Date(timeIntervalSince1970: 9199677333.36627), expected: "Thu, 11 Jul 2261 13:55:33 -0400"),
        Instance(input: Date(timeIntervalSince1970: 53706378711.11124), expected: "Fri, 20 Nov 3671 09:31:51 -0500"),
    ])
    func outputs_expected_result_for_new_york_time(instance: Instance) async throws {
        // EDT - America/New_York
        // western hemisphere
        // 5 hours behind GMT
        let timezone = TimeZone(abbreviation: "EDT")
        #expect(instance.input.asRFC822(timeZone: timezone) == instance.expected)
    }

    @Test("Test Against Known Output for America/St Johns Time", arguments: [
        Instance(input: Date(timeIntervalSince1970: 20012346618.957466), expected: "Fri, 02 Mar 2604 05:40:18 -0330"),
        Instance(input: Date(timeIntervalSince1970: 56076958399.89086), expected: "Tue, 03 Jan 3747 17:23:19 -0330"),
        Instance(input: Date(timeIntervalSince1970: 43889947931.30432), expected: "Sat, 25 Oct 3360 09:42:11 -0230"),
        Instance(input: Date(timeIntervalSince1970: 60401587537.13003), expected: "Sat, 19 Jan 3884 07:15:37 -0330"),
        Instance(input: Date(timeIntervalSince1970: 2887257381.52073), expected: "Wed, 29 Jun 2061 05:26:21 -0230"),
        Instance(input: Date(timeIntervalSince1970: 15764928045.389473), expected: "Sat, 27 Jul 2469 08:10:45 -0230"),
        Instance(input: Date(timeIntervalSince1970: 30573435574.337566), expected: "Sat, 01 Nov 2938 02:29:34 -0230"),
        Instance(input: Date(timeIntervalSince1970: 2818825684.6154914), expected: "Tue, 29 Apr 2059 04:38:04 -0230"),
        Instance(input: Date(timeIntervalSince1970: 9199677333.36627), expected: "Thu, 11 Jul 2261 15:25:33 -0230"),
        Instance(input: Date(timeIntervalSince1970: 53706378711.11124), expected: "Fri, 20 Nov 3671 11:01:51 -0330"),
    ])
    func outputs_expected_result_for_st_johns_time(instance: Instance) async throws {

        // NDT - America/St_Johns
        // western hemisphere
        // 3.5 hours behind GMT
        let timezone = TimeZone(abbreviation: "NDT")
        #expect(instance.input.asRFC822(timeZone: timezone) == instance.expected)
    }

}
