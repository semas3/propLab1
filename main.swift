import Foundation

enum Cell {
    case X
    case O
    case Empty
    case Draw
}

class Game {
    private var size: Int
    private var field: [[Cell]]
    init(size: Int = 3) {
        self.size = size
        field = [[Cell]](repeating: [Cell](repeating: Cell.Empty, count: size), count: size)
    }

    func whoWin() -> Cell {
        func checkRowsAndDiagonals(v: Cell) -> Bool {
            for row in field {
                var isRowEqual: Bool = true
                for element in row {
                    if (element != v) {
                        isRowEqual = false
                        break
                    }
                }
                if (isRowEqual) {
                    return true
                }
            }

            var diagonalEqual: Bool = true
            for (index, row) in field.enumerated() {
                if (row[index] != v) {
                    diagonalEqual = false
                    break
                }
            }
            if (diagonalEqual) {
                return true
            }

            var revDiagonalEqual: Bool = true
            for (index, row) in field.enumerated() {
                if (row[size - 1 - index] != v) {
                    revDiagonalEqual = false
                    break
                }
            }
            if (revDiagonalEqual) {
                return true
            }

            return false
        }

        if (checkRowsAndDiagonals(v: Cell.X)) { return Cell.X }
        if (checkRowsAndDiagonals(v: Cell.O)) { return Cell.O }

        for i in field.indices {
            var f1 = true
            var f0 = true
            for j in field.indices {
                if (field[j][i] != Cell.X) { f1 = false }
                if (field[j][i] != Cell.O) { f0 = false }
            }
            if (f1) { return Cell.X }
            if (f0) { return Cell.O }
        }

        for row in field {
            for element in row {
                if (element == Cell.Empty) { return Cell.Empty }
            }
        }
        return Cell.Draw
    }

    func render() {
        for (index, row) in field.enumerated() {
            for (index2, element) in row.enumerated() {
                let char: Character
                switch element {
                case Cell.X:
                    char = "X"
                case Cell.O:
                    char = "O"
                default:
                    char = " "
                }
                if (index2 != 0) {
                    print("| ", terminator: "")
                }
                print("\(char) ", terminator: "")
            }

            print()
            if (index != size - 1) { print(String(repeating: "-", count: 4*size-3)) }
        }
    }

    func changeField(row: Int, col: Int, v: Cell) -> Bool {
        if (!(1...size).contains(row) || !(1...size).contains(col) || field[row-1][col-1] != Cell.Empty) {
            return false
        }
        field[row-1][col-1] = v
        return true
    }
}


func main() {
    var answer = "r"

    repeat {
        clear()
        var size = 0
        repeat {
            print("Размерность поля (>=1): ", terminator: "")
            if let sizeBuf = Int(readLine()!) {
                size = sizeBuf
            }
        } while (size < 1)

        let game = Game(size: size)
        var xStep = true
        repeat {
            clear()
            game.render()
            var changed = false
            repeat {
                var cellValue: Cell
                if (xStep) {
                    print("Ход X: ", terminator: "")
                    cellValue = Cell.X
                } else {
                    print("Ход O: ", terminator: "")
                    cellValue = Cell.O
                }
                guard let row = Int(readLine()!)
                else {continue}
                guard let col = Int(readLine()!)
                else {continue}
                changed = game.changeField(row: row, col: col, v: cellValue)
            } while(!changed)
            xStep = !xStep
        } while (game.whoWin() == Cell.Empty)
        clear()
        switch (game.whoWin()) {
        case Cell.X:
            print("X победил")
        case Cell.O:
            print("O победил")
        default:
            print("Ничья")
        }
        game.render()

        print("Партия? r")
        answer = readLine()!
    } while (answer == "r")
}

func clear() {
    print(String(repeating: "\n\n\n\n\n\n\n\n\n\n", count: 5))
}

main()