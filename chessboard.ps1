## Make chess board array blanks will be 0's
$table =  @(
    ('a','b','c','0','e'),
    ('0','g','h','i','j'),
    ('k','l','m','n','o'), 
    ('p','q','r','s','t'),
    ('u','v','0','0','y')
)

# Function to resolve a letter to coordinates
function getCoordinate {
    param (
        [ValidatePattern("^[a-zA-Z]$")][string]
        $Letter,
        [array]$Table = $Table
    )
    # Get Coordinate of start
    ### RFI: Where-Object is inefficient (even by powershell standards)
    $row = ($table | Where-Object {$_ -like "*$Letter*"})
    if (!$row){
        Write-Error "$letter not found in table"
        return
    }
    $rownum = $table.IndexOf($row)
    $colnum = $row.IndexOf($LETTER)

    #eturn "$rownum,$colnum"
    @{y = $rownum; x = $colnum}
   
}
# Function to resolve coordinates to a letter
function getLetter {
    param (
        [int]$Y,
        [int]$X,
        [array]$Table = $Table
    )
    # uncomment for tshooting
    #write-host "Trying X: $X and Y: $Y"
    $table[($Y)][($X)]
    
}

## function to determine valid knight moves on the board
function validMoveEnumerator {
    param (
        [ValidatePattern("^[a-zA-Z]$")][string]
        $Letter,
        [array]$Table = $Table
    )
    $maxy = $table.count -1
    $maxx = $table[0].count -1

    $coordinate = getCoordinate $Letter
    if (!$coordinate){
        Write-Error "$letter not found with getCoordinate"
        return
    }

    # Check all possibilities
    $validmoves = @()
    $knightmoves = @( '1,2','2,1','-1,2','-2,1','1,-2','2,-1','-1,-2','-2,-1' )
    foreach ($move in $knightmoves){
        $movey = $move.split(',')[0]
        $movex = $move.split(',')[1]
        ### RFI: could make a coordinate class and do it "right"
        $newy = $coordinate.y + $movey
        $newx = $coordinate.x + $movex

        if ($newx -ge 0 -and $newx -le $maxx -and $newy -ge 0 -and $newy -le $maxy ){
            $let = getLetter -y $newy -x $newx
            if ($let -notlike "0"){
                $validmoves += $let
            }
        }
        else {
            Write-Verbose "Move [] $move ] is off the board"
        }

    }
    $validmoves
}

function SovleMatrix {
    param (
        [ValidatePattern("^[a-zA-Z]$")][string]
        $Letter,
        [int]$MaxMoves = 8,
        [int]$MaxVowels = 2,
        $NoTriples = @('a','e','i','o','u','y'),
        [array]$Table = $Table,
        [switch]$ShowValues
    )
    $levels = @()
    $move = 1
    Do {

        #first loop
        ### RFI: I'm sure there's logic to not have separate loops but quick and dirty will have to do for now.
        if ($move -eq 1){
            $valids = validMoveEnumerator -Letter $Letter -Table $Table
            foreach ($valid in $valids){
                $levels += "$Letter$valid"
            }
        }
        else {
            foreach ($level in $levels){
                $valids = validMoveEnumerator -Letter $level[-1] -Table $Table
                foreach ($valid in $valids){
                    $levels += "$Level$valid"
                }
            }
        }
        
    $move ++
    }until ($move -gt $MaxMoves)
    $levels = $levels | Where-Object {$_.length -eq $maxmoves + 1} | Select-Object -Unique
    ## Do the Vowel check
    $finallevels = @()
    foreach ($level in $levels){
        $vcount = 0
        foreach ($l in $level.ToCharArray()){
            ### RFI: Regex match would be faster, but need to learn black magic first.
            if ($notriples -contains $l){
                $vcount ++
            }
        }
        if ($vcount -le $MaxVowels){
            $finallevels += $level
        }
    }
    if ($ShowValues){
        $finallevels
    }
    else {
        $finallevels.count
    }
    
}


# Performance Test
# Measure-Command -Expression { SovleMatrix -Letter a -MaxMoves 8 | Out-Default}

SovleMatrix -Letter b -MaxMoves 8