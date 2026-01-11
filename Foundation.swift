import Foundation

protocol Fighter {
    var name: String { get }
    var hp: Int { get set }
    var power: Int { get }
    func attack() -> Int
    func takeDamage(_ amount: Int)
}

print("Fighter protocol created")

enum Universe {
    case attackOnTitan
    case jujutsuKaisen
    case demonSlayer

    var title: String {
        switch self {
        case .attackOnTitan: return "Attack on Titan"
        case .jujutsuKaisen: return "Jujutsu Kaisen"
        case .demonSlayer: return "Demon Slayer"
        }
    }
}

let universe = Universe.jujutsuKaisen
print("Universe enum ready: \(universe.title)")

class Character: Fighter {
    let name: String
    var hp: Int
    let power: Int
    let universe: Universe
    private var shield: Int

    var shieldPoints: Int {
        get { shield }
        set { shield = min(max(newValue, 0), 100) }
    }

    init(name: String, hp: Int, power: Int, universe: Universe, shield: Int) {
        self.name = name
        self.hp = hp
        self.power = power
        self.universe = universe
        self.shield = shield
    }

    func attack() -> Int {
        power
    }

    func takeDamage(_ amount: Int) {
        var damage = amount
        if shield > 0 {
            let absorbed = min(shield, damage)
            shield -= absorbed
            damage -= absorbed
            print("🛡 Shield absorbed \(absorbed). Shield now: \(shield)")
        }
        hp = max(hp - damage, 0)
        print("Took \(damage) damage. HP now: \(hp)")
    }

    func status() {
        print("Name: \(name) | HP: \(hp) | Power: \(power) | Shield: \(shield) | Universe: \(universe.title)")
    }
}

class TitanShifter: Character {
    let titanForm: String

    init(name: String, hp: Int, power: Int, universe: Universe, shield: Int, titanForm: String) {
        self.titanForm = titanForm
        super.init(name: name, hp: hp, power: power, universe: universe, shield: shield)
    }

    override func attack() -> Int {
        power + 20
    }
}

class Sorcerer: Character {
    let cursedEnergy: Int

    init(name: String, hp: Int, power: Int, universe: Universe, shield: Int, cursedEnergy: Int) {
        self.cursedEnergy = cursedEnergy
        super.init(name: name, hp: hp, power: power, universe: universe, shield: shield)
    }

    override func attack() -> Int {
        power + cursedEnergy / 10
    }
}

let mikasa = Character(name: "Mikasa", hp: 90, power: 25, universe: .attackOnTitan, shield: 15)
let eren = TitanShifter(name: "Eren", hp: 120, power: 30, universe: .attackOnTitan, shield: 30, titanForm: "Attack Titan")
let gojo = Sorcerer(name: "Gojo", hp: 110, power: 28, universe: .jujutsuKaisen, shield: 10, cursedEnergy: 250)

let fighters: [Character] = [mikasa, eren, gojo]

print("\nPolymorphism demo:")
for f in fighters {
    f.status()
    print("Attack damage: \(f.attack())")
}

func pickRandom<T>(_ items: [T]) -> T? {
    items.randomElement()
}

if let randomFighter = pickRandom(fighters) {
    print("\nRandom character: \(randomFighter.name)")
}

let universes: [Universe] = [.attackOnTitan, .jujutsuKaisen, .demonSlayer]
if let randomUniverse = pickRandom(universes) {
    print("Random universe: \(randomUniverse.title)")
}

enum BattleError: Error {
    case sameFighter
    case deadFighter
    case invalidPower
}

func validateForBattle(_ a: Character, _ b: Character) throws {
    if a.name == b.name { throw BattleError.sameFighter }
    if a.hp == 0 || b.hp == 0 { throw BattleError.deadFighter }
    if a.power <= 0 || b.power <= 0 { throw BattleError.invalidPower }
}

protocol BattleLoggerDelegate: AnyObject {
    func didStartBattle(_ a: String, _ b: String)
    func didEndBattle(winner: String)
}

class BattleLogger: BattleLoggerDelegate {
    func didStartBattle(_ a: String, _ b: String) {
        print("\nBattle started: \(a) vs \(b)")
    }

func didEndBattle(winner: String) {
        print("Winner: \(winner)")
    }
}

class BattleArena {
    weak var delegate: BattleLoggerDelegate?

    func fight(_ a: Character, _ b: Character) {
        delegate?.didStartBattle(a.name, b.name)
        for round in 1...3 {
            if a.hp == 0 || b.hp == 0 { break }
            print("Round \(round): \(a.name) attacks for \(a.attack())")
            b.takeDamage(a.attack())
            if b.hp == 0 { break }
            print("Round \(round): \(b.name) attacks for \(b.attack())")
            a.takeDamage(b.attack())
        }
        let winner = a.hp > b.hp ? a.name : b.name
        delegate?.didEndBattle(winner: winner)
    }
}

let arena = BattleArena()
arena.delegate = BattleLogger()

do {
    try validateForBattle(eren, gojo)
    arena.fight(eren, gojo)
} catch BattleError.deadFighter {
    print("Error: dead fighter cannot battle")
} catch {
    print("Error occurred")
}

// MARK: - Functional Programming
print("\nFunctional Programming results:")
print("map ->", fighters.map { "\($0.name) (HP: \($0.hp))" })
print("filter ->", fighters.filter { $0.hp > 50 }.map { $0.name })
print("sorted ->", fighters.sorted { $0.power > $1.power }.map { "\($0.name):\($0.power)" })
