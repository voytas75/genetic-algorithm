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
    [array]$geneValue = 1..$genecount | ForEach-Object { 0..1 | get-random } 
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
        $_population = @()
        
    }
    
    process {
        #New-Object [PSCustomObject]@{
        #    Gene = Value
        #}    
        for ($i = 0; $i -lt $chromosomeCount; $i++) {
            #for ($j = 0; $j -lt $geneCount; $j++) {
            #Write-Information -MessageData $i -InformationAction Continue
            $_population += , [array](generateChromosome -geneCount $geneCount)
            # , - https://devblogs.microsoft.com/powershell/array-literals-in-powershell/
            #}
        }
        #1..[int]$chromosomeCount | ForEach-Object {1..[int]$geneCount} | ForEach-Object {$_chromosomeIndex = $_ - 1;Write-Output $_chromosomeIndex; $_chromosome[$_chromosomeIndex] += generateGene}
        
    }
    
    end {
        return $_population
    }
}

function PopulationStatictics {
    param (
        [ValidateNotNullorEmpty()]
        [array]$population,
        [switch]$fitness
    )
    # param options - https://learn-powershell.net/2014/02/04/using-powershell-parameter-validation-to-make-your-day-easier/
    $_FitnessSum = 0
    if ($fitness) {
        $_fitness = GenerateFitnessValue_Population -population $population
        $_fitness.foreach{ $_FitnessSum += $PSItem }
        return $_FitnessSum
    } else {
        return $population.count
    }
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
    $_GenerateSumGenes = $population.ForEach{ ($_ -match 1).count } # array of sums 1 in genes
    #$population.ForEach{Write-Output $PSItem}
    #$_GenerateSumGenes.foreach{+=$_    } 
    #$_GenerateSumGenes | ForEach-Object {"Sum Genes Item: [$PSItem]"}

    #[array]$_IsOdd = $_GenerateSumGenes.foreach{[bool]($psitem%2)}
    #$_IsOdd.ForEach{"Odd Item (<sum genes with 1>): [$PSItem]"}# generate sum all gene sum

    [array]$_FitnessValue = $_GenerateSumGenes.foreach{ if ([bool]($psitem % 2)) { $PSItem }else { 0 } }
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
    $fitness.foreach{ $_FitnessSum += $PSItem }
    #$_FitnessSum.foreach{"Fitness sum: [$PSItem]"}
    if (-not $_FitnessSum) {
        "STOP"
        exit
    }

    $_NormalizeItem = $fitness.foreach{ $Psitem / $_FitnessSum }
    #$_NormalizeItem = $population / $_FitnessSum[0]
    #$_NormalizeItem.foreach{"Normalize: [$PSItem]"}

    [array]$AgregateSum = $_NormalizeItem.foreach{ $_aggregatesum += $PSItem; $_aggregatesum }
    #$AgregateSum.foreach{"Agregate: [$PSItem]"}
    [Object]$Random = New-Object System.Random
    $_popcount = $population.count
    $_randomvalue = 1..$_popcount | ForEach-Object { $Random.NextDouble() }
    #$_randomvalue.foreach{"Random value: [$psitem]"}
    $i = $j = 0
    $_reproduceItems = @()
    do {
        #$_randomvalue[$i]
        #"`$i = $i"
        $j = 0
        #$_NormalizeItem[0]
        #$_NormalizeItem[0] -lt 1
        if ($_Normalizeitem[0] -lt 1) {
            do {
                #"`$j = $j"
                #"aa"
                #$_randomvalue[0] -le $AgregateSum[0]
                if ($_randomvalue[0] -le $AgregateSum[0] -or $_randomvalue[$i] -lt $AgregateSum[0]) {
                    break
                }
                #$_randomvalue[$i]
                #$AgregateSum[$j] 
                #"bb"
                #if ($_randomvalue[$i] -lt $AgregateSum[0]) {
                #    break
                #}
                $j++
                #$_randomvalue[$i] -gt $AgregateSum[$j-1]
                #$_randomvalue[$i] -le $AgregateSum[$j]
                #$AgregateSum[$j-1] -eq 1
                #"------"
            } until (($_randomvalue[$i] -gt $AgregateSum[$j - 1] -and $_randomvalue[$i] -le $AgregateSum[$j]) -or $AgregateSum[$j - 1] -eq 1 -or $j -gt $_popcount)
        }
        #($j).foreach{"Wybrano $($psitem)"}
        [array]$_reproduceItems += , @($population[($j)])
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

function Crossover {
    param (
        $population,
        $crossoverProb
    )
    [Object]$Random = New-Object System.Random
    for ($i = 0; $i -lt $population.Count; $i += 2) {
        $_crossoverprob_rand = $Random.NextDouble()
        if ($_crossoverprob_rand -le $crossoverProb) { 
            #$_crossoverprob_rand    
            $_crossoverPoint = 1..($population[0].count - 2) | get-random
            #$_crossoverPoint
            [array]$_crossoverpopulation += , ($population[$i][0..$_crossoverPoint] + $population[$i + 1][($_crossoverPoint + 1)..($population[0].Count)]) 
            [array]$_crossoverpopulation += , ($population[$i + 1][0..$_crossoverPoint] + $population[$i][($_crossoverPoint + 1)..($population[0].Count)])
        }
        else {
            #0
            [array]$_crossoverpopulation += , ($population[$i])
            [array]$_crossoverpopulation += , ($population[$i + 1])
        }
    }
    #$_crossoverpopulation.foreach{"CrossedOver Item: [$psitem]"}
    return $_crossoverpopulation
}
function Mutation {
    param (
        $population,
        $mutationProb
    )
    [Object]$Random = New-Object System.Random
    $i=0
    foreach ($items in $population) {
     #"i="+$i   #$items
        $j=0
        foreach ($item in $items) {
            #" j="+$j
            #$item
            $_crossoverprob_rand = $Random.NextDouble()
            #$_crossoverprob_rand
            #$_crossoverprob_rand -le $mutationProb
            if($_crossoverprob_rand -le $mutationProb) {
                #"  indexy: "+$i+$j    
                #$items[$item]
                #$population[$i][$j]    
                if([int]$population[$i][$j] -eq 1) {
                    #" zmiana z 1 na 0"
                    #$_tmp_item=$items[$item]
                    #" "+$_tmp_item
                    #"  indexy: "+$i+$j    
                    #"  item z items population PRZED: "+$items
                    #"  item z array population PRZED: "+$population[$i]
                    #$items[$item] = 0
                    #$item=0
                    #$population[$i][$j]
                    $population[$i][$j]=0
                    #$items[$item]
                    #"na dole musi byc 0 a na gorze 1"
                    #"  item z items population PO:    "+$items
                    #"  item z array population PO:    "+$population[$i]
                    #$population[0][1]
                } else {
                    #" zmiana z 0 na 1"
                    #$_tmp_item=$items[$item]
                    #" "+$_tmp_item
                    #"tu ma byc 0: "+$items[$item]
                    #"  indexy: "+$i+$j    
                    #"  item z items population PRZED: "+$items
                    #"  item z array population PRZED: "+$population[$i]
                    #$items[$item]=1
                    #$item=1
                    #$population[$i][$j]
                    $population[$i][$j]=1
                    #"tu ma byc 1: "+$items[$item]
                    #"  item z items population PO:    "+$items
                    #"  item z array population PO:    "+$population[$i]
                    #$population[0][1]
                }
            }    
        $j++
        }
        $i++
    }
    return $population
    #$population.foreach{"Muted       Item: [$psitem]"}
}
$generations = 1
#generateGene
#Write-Information -MessageData "Initialization" -InformationAction Continue
[array]$population = generatePopulation -chromosomeCount 20 -geneCount 20
#$chromosome.GetType()
#foreach ($individual in $population) {
#Write-Output "Individual:"
#$individual
#}

$populationStatistics = PopulationStatictics -population $population
#$populationStatistics | ForEach-Object { "Population count: [$PSItem]" }
#$population | ForEach-Object { "Item: [$PSItem]" }

#Write-Information -MessageData "Fitness" -InformationAction Continue
$populationFitnessValue = GenerateFitnessValue_Population -population $population
#$populationFitnessValue.foreach{ "Fitness value: [$PSItem]" }
$fitnessPopulation = PopulationStatictics -population $population -fitness
$fitnessPopulation

for ($i = 0; $i -lt $generations; $i++) {
$fitnessPopulation = 0
#Write-Information -MessageData "Selection $($i)" -InformationAction Continue
#Write-Information -MessageData "Roulette $($i)" -InformationAction Continue
$_ReproductionItems = Roulette -population $population -fitness $populationFitnessValue
#$_ReproductionItems.foreach{ "Reproduction item $($i): [$Psitem]" }

#Write-Information -MessageData "Crossover $($i)" -InformationAction Continue
$CrossovertPopulation = Crossover -population $_ReproductionItems -crossoverProb 0.4
#$CrossovertPopulation.foreach{"CrossedOver Item $($i): [$psitem]"}

#Write-Information -MessageData "Mutation $($i)" -InformationAction Continue
$mutedPopulation = Mutation -population $CrossovertPopulation -mutationProb 0.05
#$mutedPopulation.foreach{"Muted Item $($i): [$psitem]"}


#Write-Information -MessageData "Fitness $($i)" -InformationAction Continue
$populationFitnessValue = GenerateFitnessValue_Population -population $mutedPopulation
#$populationFitnessValue.foreach{ "Fitness value $($i): [$PSItem]" }

$fitnessPopulation = PopulationStatictics -population $population -fitness 
$fitnessPopulation

[array]$allGenerations += ,($fitnessPopulation,$population)

$population = $mutedPopulation

}
