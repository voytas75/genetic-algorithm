# script for learning genetics algorithms 
# locus [łac.], genet. pozycja w chromosomie zajmowana przez dany gen;
function generateChromosome {
    param (
        [ValidateNotNullorEmpty()]
        [int]$geneCount = 6
    )
    # function generate vale of gene
    # powershell statistics
    # check .net statistics 
    [array]$geneValue = 1..$genecount | ForEach-Object {0..1 | get-random } 
    return $geneValue
}

function generatePopulation {
    [CmdletBinding()]
    param (
        [ValidateNotNullorEmpty()]
        [int]$chromosomeCount = 4,
        [ValidateNotNullorEmpty()]
        [int]$geneCount = 8
    )
    <# 
    function generates chromosome one or more. 
    default values are definied. 
    #>
    begin {
        $_chromosome = @()
        
    }
    
    process {
        #New-Object [PSCustomObject]@{
        #    Gene = Value
        #}    
        for ($i = 0; $i -lt $chromosomeCount; $i++) {
            #for ($j = 0; $j -lt $geneCount; $j++) {
                #Write-Information -MessageData $i -InformationAction Continue
                $_chromosome += ,[array](generateChromosome -geneCount $geneCount)
            # , - https://devblogs.microsoft.com/powershell/array-literals-in-powershell/
                #}
        }
       #1..[int]$chromosomeCount | ForEach-Object {1..[int]$geneCount} | ForEach-Object {$_chromosomeIndex = $_ - 1;Write-Output $_chromosomeIndex; $_chromosome[$_chromosomeIndex] += generateGene}
       $_chromosome
    }
    
    end {
        
    }
}

function PopulationStatictics {
    param (
        [ValidateNotNullorEmpty()]
        [array]$population
    )
    # param options - https://learn-powershell.net/2014/02/04/using-powershell-parameter-validation-to-make-your-day-easier/
    return $population.count
}

function GenerateFitnessValue_Population {
    param (
        [ValidateNotNullorEmpty()]
        [array]$population
    )
    # example fitness function
    # sum of genes is odd
    #Write-Information -MessageData "witam w funkcji 'GenerateFitnessValue_Population'" -InformationAction Continue
    #Write-Information -MessageData ($population.count) -InformationAction Continue
    #$_ValueFenotype = @()
    $_GenerateSumGenes = $population.ForEach{($_ -match 1).count} # array of sums 1 in genes
    #$population.ForEach{Write-Output $PSItem}
    #$_GenerateSumGenes.foreach{+=$_    } 
    #$_GenerateSumGenes | ForEach-Object {"Sum Genes Item: [$PSItem]"}

    [array]$_IsOdd = $_GenerateSumGenes.foreach{[bool]($psitem%2)}
    #$_IsOdd.ForEach{"Odd Item (<sum genes with 1>): [$PSItem]"}# generate sum all gene sum

    [array]$_FitnessValue = $_GenerateSumGenes.foreach{if([bool]($psitem%2)){$PSItem}else{0}}
    #$_FitnessValue.foreach{"Fitness value: [$PSITEM]"}    
    return $_FitnessValue

    #[array]$_indexPopulation_odd = $(0..($_IsOdd.Count-1)).where{$_indexpopulation = ($_IsOdd[$_] -eq $true);$_indexpopulation}

    #$_IsOdd.IndexOf($true)
    #$_indexPopulation_odd
    #($population[$_indexPopulation_odd]).ForEach{"Odd Item: [$PSItem]"}
    #($_GenerateSumGenes[$_indexPopulation_odd]).ForEach{"Odd values Item: [$PSItem]"}

    #$_GenerateSumGenes[$_indexPopulation_odd] | Sort-Object -Descending # sorted desc of sums of 1es in gemes
    #$_SumOddItems = ($_IsOdd.where{$_ -match $true}).count #sum items with odd sum of genes
    #$_SumOddItems.foreach{Write-Output "Sum items in population with odd sum of genes: [$psitem]"}

    #$_IsOddValue
    #$_meansumpopulation = 
    #$_Sumpopulation/($population.count)


}

function Roulette {
    param (
        $population,
        $fitness
    )
    $_FitnessSum = 0
    $_NormalizeItem = @()
    $_aggregatesum = 0
    $fitness.foreach{$_FitnessSum+=$PSItem}
    #$_FitnessSum.foreach{"Fitness sum: [$PSItem]"}
    if (-not $_FitnessSum) {
        "STOP"
        exit
    }

    $_NormalizeItem = $fitness.foreach{$Psitem/$_FitnessSum}
    #$_NormalizeItem = $population / $_FitnessSum[0]
    #$_NormalizeItem.foreach{"Normalize: [$PSItem]"}

    [array]$AgregateSum = $_NormalizeItem.foreach{$_aggregatesum += $PSItem;$_aggregatesum}
    #$AgregateSum.foreach{"Agregate: [$PSItem]"}
    [Object]$Random = New-Object System.Random
    $_popcount = $population.count
    $_randomvalue = 1..$_popcount | % {$Random.NextDouble()}
    #$_randomvalue.foreach{"Random value: [$psitem]"}
    $i=$j=0
    $_reproduceItems = @()
    do {
        #$_randomvalue[$i]
        #"`$i = $i"
        $j=0
        #$_NormalizeItem[0]
        #$_NormalizeItem[0] -lt 1
        if ($_Normalizeitem[0] -lt 1) {
            do {
            #"`$j = $j"
            #"aa"
            #$_randomvalue[0] -le $AgregateSum[0]
            if ($_randomvalue[0] -le $AgregateSum[0]) {
                break
            }
            #$_randomvalue[$i]
            #$AgregateSum[$j] 
            #"bb"
            if ($_randomvalue[$i] -lt $AgregateSum[0]) {
                break
            }
            $j++
            #$_randomvalue[$i] -gt $AgregateSum[$j-1]
            #$_randomvalue[$i] -le $AgregateSum[$j]
            #$AgregateSum[$j-1] -eq 1
            #"------"
        } until (($_randomvalue[$i] -gt $AgregateSum[$j-1] -and $_randomvalue[$i] -le $AgregateSum[$j]) -or $AgregateSum[$j-1] -eq 1 -or $j -gt $_popcount)
    }
        #($j).foreach{"Wybrano $($psitem)"}
        [array]$_reproduceItems += ,@($population[($j)])
        #$fitness[$i]
        #$population #| where {"asd: [$PSItem]"}
        #[String]::Join(' ', $population[($j)]);
        #-join $population[$i]
        #$_NormalizeItem[$i] 
        $i++
        #"=========="
    } until ($i -ge $_popcount)
    #$_reproduceItems.foreach{"[$Psitem]"}
    return $_reproduceItems
}

function Get-Entropy
{
    Param (
        [Parameter(Mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        [Byte[]]
        $Bytes
   )
 
   $FrequencyTable = @{}
   foreach ($Byte in $Bytes) {
       $FrequencyTable[$Byte]++
   }
   $Entropy = 0.0
 
   foreach ($Byte in 0..255)
   {
       $ByteProbability = ([Double]$FrequencyTable[[Byte]$Byte])/$Bytes.Length
       if ($ByteProbability -gt 0)
       {
           $Entropy += -$ByteProbability * [Math]::Log($ByteProbability, 2)
       }
   }
   $Entropy
}

function Get-RandomByte
{
    Param (
        [Parameter(Mandatory = $True)]
        [UInt32]
        $Length,
 
        [Parameter(Mandatory = $True)]
        [ValidateSet('GetRandom', 'CryptoRNG')]
        [String]
        $Method
    )
 
    $RandomBytes = New-Object Byte[]($Length)
 
    switch ($Method)
    {
        'GetRandom' {
            foreach ($i in 0..($Length - 1))
            {
                $RandomBytes[$i] = Get-Random -Minimum 0 -Maximum 256
            }
         }
         'CryptoRNG' {
             $RNG = [Security.Cryptography.RNGCryptoServiceProvider]::Create()
             $RNG.GetBytes($RandomBytes)
         }
    }
    $RandomBytes
}

#random
#$Length = 0x1000
#$CryptoRNGBytes = Get-RandomByte -Length $Length -Method CryptoRNG
#$Randomness = @{
#    CryptoRNGEntropy = Get-Entropy -Bytes $CryptoRNGBytes
#}
New-Object PSObject -Property $Randomness
#$CryptoRngAverage = $Results | measure -Average -Property CryptoRNGEntropy

#Get-Random -SetSeed ([int]($CryptoRngAverage * 10000000))


#generateGene
Write-Information -MessageData "Initialization" -InformationAction Continue
[array]$population = generatePopulation -chromosomeCount 5 -geneCount 10
#$chromosome.GetType()
#foreach ($individual in $population) {
    #Write-Output "Individual:"
    #$individual
#}

$populationStatistics = PopulationStatictics -population $population
$populationStatistics | ForEach-Object {"Population count: [$PSItem]"}
$population | ForEach-Object {"Item: [$PSItem]"}

Write-Information -MessageData "Fitness" -InformationAction Continue
$populationFitnessValue = GenerateFitnessValue_Population -population $population
$populationFitnessValue.foreach{"Fitness value: [$PSItem]"}

Write-Information -MessageData "Roulette" -InformationAction Continue
$_ReproductionItems = Roulette -population $population -fitness $populationFitnessValue
$_ReproductionItems.foreach{"Reproduction item: [$Psitem]"}