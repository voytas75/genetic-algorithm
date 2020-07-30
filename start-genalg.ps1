# script for learning genetics algorithms 
# locus [łac.], genet. pozycja w chromosomie zajmowana przez dany gen;
function generateChromosome {
    param (
        [ValidateNotNullorEmpty()]
        [int]$geneCount = 6
    )
    <#
    function generate vale of gene
    powershell statistics
    check .net statistics 
    #>
    $_chromosome = @()
    return [array]$_chromosome = (1..$genecount).foreach{ 0..1 | get-random } 
}

function generatePopulation {
    [CmdletBinding()]
    param (
        [ValidateNotNullorEmpty()]
        [int]$chromosomeCount = 10,
        [ValidateNotNullorEmpty()]
        [int]$geneCount = 10
    )
    <# 
    function generates chromosome one or more. 
    default values are definied. 

    # , - https://devblogs.microsoft.com/powershell/array-literals-in-powershell/
    #>
    $_population = @()
    (1..$chromosomeCount).foreach{ $_population += , [array](generateChromosome -geneCount $geneCount) }
    return $_population
}

function PopulationStatictics {
    param (
        [ValidateNotNullorEmpty()]
        [array]$population,
        [switch]$count,
        [switch]$fitness
    )
    # param options - https://learn-powershell.net/2014/02/04/using-powershell-parameter-validation-to-make-your-day-easier/
    #$_FitnessSum = 0
    if ($fitness) {
        #$_fitness = GenerateFitnessValue_Population -population $population
        (GenerateFitnessValue_Population -population $population).foreach{ $_FitnessSum += $PSItem }
        return $_FitnessSum
    }
    elseif ($count) {
        return $population.count
    }
    else {
        return $null
    }
}

function GenerateFitnessValue_Population {
    param (
        [ValidateNotNullorEmpty()]
        [array]$population
    )
    <#
    example fitness function
    sum of genes is odd
    #>
    $_FitnessPopulationItems = @()
    $_GenerateSumGenes = $population.ForEach{ ($_ -match 1).count } # array of sums 1 in genes
    return [array]$_FitnessPopulationItems = $_GenerateSumGenes.foreach{ if ([bool]($psitem % 2)) { $PSItem }else { 0 } }
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
    if (-not $_FitnessSum) {
        $_FitnessSum.foreach{ "Fitness sum: [$PSItem]" }
        $population.foreach{ "Population item: [$PSItem]" }
        "[STOP]"
        exit
    }
    $_NormalizeItem = $fitness.foreach{ $Psitem / $_FitnessSum }
    [array]$AgregateSum = $_NormalizeItem.foreach{ $_aggregatesum += $PSItem; $_aggregatesum }
    [Object]$Random = New-Object System.Random
    [int]$_popcount = PopulationStatictics -population $population -count
    [array]$_randomvalue = (1..$_popcount).foreach{ $Random.NextDouble() }
    $i = $j = 0
    $_reproduceItems = @()
    do {
        $j = 0
        if ($_Normalizeitem[0] -lt 1) {
            do {
                if ($_randomvalue[0] -le $AgregateSum[0] -or $_randomvalue[$i] -lt $AgregateSum[0]) {
                    break
                }
                $j++
            } until (($_randomvalue[$i] -gt $AgregateSum[$j - 1] -and $_randomvalue[$i] -le $AgregateSum[$j]) -or $AgregateSum[$j - 1] -eq 1 -or $j -gt $_popcount)
        }
        [array]$_reproduceItems += , @($population[($j)])
        $i++
    } until ($i -ge $_popcount)
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
            $_crossoverPoint = 1..($population[0].count - 2) | get-random
            [array]$_crossoverpopulation += , ($population[$i][0..$_crossoverPoint] + $population[$i + 1][($_crossoverPoint + 1)..($population[0].Count)]) 
            [array]$_crossoverpopulation += , ($population[$i + 1][0..$_crossoverPoint] + $population[$i][($_crossoverPoint + 1)..($population[0].Count)])
        }
        else {
            [array]$_crossoverpopulation += , ($population[$i])
            [array]$_crossoverpopulation += , ($population[$i + 1])
        }
    }
    return $_crossoverpopulation
}
function Mutation {
    param (
        $population,
        $mutationProb
    )
    [Object]$Random = New-Object System.Random
    $i = 0
    foreach ($items in $population) {
        #"i="+$i   #$items
        $j = 0
        foreach ($item in $items) {
            #" j="+$j
            #$item
            $_crossoverprob_rand = $Random.NextDouble()
            #$_crossoverprob_rand
            #$_crossoverprob_rand -le $mutationProb
            if ($_crossoverprob_rand -le $mutationProb) {
                #"  indexy: "+$i+$j    
                #$items[$item]
                #$population[$i][$j]    
                if ($population[$i][$j] -eq 1) {
                    #" zmiana z 1 na 0"
                    #$_tmp_item=$items[$item]
                    #" "+$_tmp_item
                    #"  indexy: "+$i+$j    
                    #"  item z items population PRZED: "+$items
                    #"  item z array population PRZED: "+$population[$i]
                    #$items[$item] = 0
                    #$item=0
                    #$population[$i][$j]
                    $population[$i][$j] = 0
                    #$items[$item]
                    #"na dole musi byc 0 a na gorze 1"
                    #"  item z items population PO:    "+$items
                    #"  item z array population PO:    "+$population[$i]
                    #$population[0][1]
                }
                else {
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
                    $population[$i][$j] = 1
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
$generations = 10
#generateGene
#Write-Information -MessageData "Initialization" -InformationAction Continue
[array]$population = generatePopulation -chromosomeCount 6 -geneCount 5
#$chromosome.GetType()
#foreach ($individual in $population) {
#Write-Output "Individual:"
#$individual
#}

#$populationStatistics = PopulationStatictics -population $population
#$populationStatistics | ForEach-Object { "Population count: [$PSItem]" }
#$population | ForEach-Object { "Item: [$PSItem]" }

#Write-Information -MessageData "Fitness" -InformationAction Continue
$populationFitnessValue = GenerateFitnessValue_Population -population $population
#$populationFitnessValue.foreach{ "Fitness value: [$PSItem]" }
$fitnessPopulation = PopulationStatictics -population $population -fitness
#$fitnessPopulation
[array]$allGenerations += , @(0, $fitnessPopulation, $population)

for ($i = 0; $i -lt $generations; $i++) {
    $fitnessPopulation = 0
    #Write-Information -MessageData "Selection $($i)" -InformationAction Continue
    #Write-Information -MessageData "Roulette $($i)" -InformationAction Continue
    $_ReproductionItems = Roulette -population $population -fitness $populationFitnessValue
    #$_ReproductionItems.foreach{ "Reproduction item $($i): [$Psitem]" }

    #Write-Information -MessageData "Crossover $($i)" -InformationAction Continue
    $CrossovertPopulation = Crossover -population $_ReproductionItems -crossoverProb 0.2
    #$CrossovertPopulation.foreach{"CrossedOver Item $($i): [$psitem]"}

    #Write-Information -MessageData "Mutation $($i)" -InformationAction Continue
    $mutedPopulation = Mutation -population $CrossovertPopulation -mutationProb 0.01
    #$mutedPopulation.foreach{"Muted Item $($i): [$psitem]"}


    #Write-Information -MessageData "Fitness $($i)" -InformationAction Continue
    $populationFitnessValue = GenerateFitnessValue_Population -population $mutedPopulation
    #$populationFitnessValue.foreach{ "Fitness value $($i): [$PSItem]" }

    $fitnessPopulation = PopulationStatictics -population $mutedPopulation -fitness 
    #$fitnessPopulation

    [array]$allGenerations += , @(($i + 1), $fitnessPopulation, $mutedPopulation)

    $population = $mutedPopulation

}
$allGenerations[$generations][0]
$allGenerations[$generations][1]
($allGenerations[$generations][2]).foreach{ "{$psitem}" }
#($allGenerations[$generations].ForEach{$psitem}).foreach{$PSItem} | Out-GridView
#$allGenerations | Out-GridView
#$allGenerations.foreach{$psitem[1]} | export-excel -Path "c:\temp\ga.xlsx" -barchart -autofilter -show

$newarray = $allGenerations.foreach{ $psitem[1] }
#$cd = New-ExcelChartDefinition -
#$newarray | export-excel -Path "c:\temp\ga.xlsx" -barchart -show
#barchart ($newarray)
#$cd = New-ExcelChartDefinition -xrange "test" -ChartType ColumnClustered -ChartTrendLine Linear 
#$allGenerations.foreach{$psitem[1]} | Export-Excel -Path "c:\temp\ga.xlsx" -ExcelChartDefinition $cd -AutoNameRange -Show 
#$newarray | Export-Excel -Path "c:\temp\ga.xlsx" -ExcelChartDefinition $cd -AutoNameRange -Show 
