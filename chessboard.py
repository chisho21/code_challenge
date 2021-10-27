#!/usr/bin/env python3
## dependencies

## Make chess board array blanks will be 0's
Table = [['a','b','c','0','e'],['0','g','h','i','j'], ['k','l','m','n','o'], ['p','q','r','s','t'], ['u','v','0','0','y']]

## Function to resolve a letter to coordinates
def getCoordinate(letter):
    count = 0
    for row in Table:
        if letter in row:
            rownum = count
            colnum = row.index(letter)
            array = [rownum , colnum]
            return array
        count += 1


## Function to resolve coordinates to a letter
def getLetter(y,x):
    yint = int(y)
    xint = int(x)
    return Table[yint][xint]


## function to determine valid knight moves on the board
def validMoveEnumerator(letter):
    
    maxy = len(Table) - 1
    maxx = len(Table[0]) -1

    coordinate = getCoordinate(letter)
    if not coordinate:
        return
    validmoves = []
    knightmoves = [[1,2], [2,1], [-1,2], [-2,1], [1,-2], [2,-1], [-1,-2], [-2,-1]]
    for move in knightmoves:
        newy = coordinate[0] + move[0]
        newx = coordinate[1] + move[1]
        if newx >= 0 and newx <= maxx and newy >= 0 and newy <= maxy: 
            let = getLetter(newy,newx)
            if let != '0':
                validmoves += let
    
    return validmoves

## final function to solve matrix
def SovleMatrix(letter, maxmoves = 8 , maxvowels = 2, vowels = ['a','e','i','o','u','y']):
    levels = []
    move = 1
    while move < maxmoves:
        if move == 1:
            valids = validMoveEnumerator(letter)
            for valid in valids:
                cat = letter + valid[0]
                levels += [cat]
        else :
            templevel = []
            for level in levels:
                valids = validMoveEnumerator(level[-1])
                for valid in valids:
                    cat = level + valid
                    vcount = 0
                    for v in vowels:
                        vc = cat.count(v)
                        vcount += vc
                    if cat not in templevel and vcount <= maxvowels:
                        templevel += [cat]
            levels = templevel

        move += 1
    #only select unique
    levelcount = len(levels)
    return levelcount



#SovleMatrix('a')  

allletters = []
for T in Table:
    for l in T:
        if l != '0':
            allletters += l
tally = 0
for letter in allletters:
    tally += SovleMatrix(letter)

print(tally)

