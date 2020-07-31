<#
script for learning genetics algorithms 
# locus [łac.], genet. pozycja w chromosomie zajmowana przez dany gen;
GA tutorial - https://www.tutorialspoint.com/genetic_algorithms/index.htm
#> 
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
        [switch]$Count,
        [switch]$fitness,
        [switch]$Maximum,
        [switch]$Average        
    )
    <# 
    param options - https://learn-powershell.net/2014/02/04/using-powershell-parameter-validation-to-make-your-day-easier/
    #>
    $_FitnessSum = 0
    if ($fitness) {
        #$_fitness = GenerateFitnessValue_Population -population $population
        (GenerateFitnessValue_Population -population $population).foreach{ $_FitnessSum += $PSItem }
        return $_FitnessSum
    }
    elseif ($Count) {
        return $population.count
    }
    elseif ($Maximum) {
        return $population.count
    }
    elseif ($Average) {
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
        #$_FitnessSum.foreach{ "Fitness sum: [$PSItem]" }
        #$population.foreach{ "Population item: [$PSItem]" }
        #"[STOP]"
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
        $ChromosomeSize,
        $crossoverProb
    )
    [Object]$Random = New-Object System.Random
    for ($i = 0; $i -lt (PopulationStatictics -population $population -count); $i += 2) {
        if (($Random.NextDouble()) -le $crossoverProb) { 
            $_crossoverPoint = 1..($ChromosomeSize - 2) | get-random
            [array]$_crossoverpopulation += , ($population[$i][0..$_crossoverPoint] + $population[$i + 1][($_crossoverPoint + 1)..($ChromosomeSize)]) 
            [array]$_crossoverpopulation += , ($population[$i + 1][0..$_crossoverPoint] + $population[$i][($_crossoverPoint + 1)..($ChromosomeSize)])
        }
        else {
            [array]$_crossoverpopulation += , ($population[$i])
            [array]$_crossoverpopulation += , ($population[$i + 1])
        }
    }
    return $_CrossoverPopulation
}
function Mutation {
    param (
        $population,
        $mutationProb
    )
    [Object]$Random = New-Object System.Random
    $i = 0
    foreach ($items in $population) {
        $j = 0
        foreach ($item in $items) {
            if (($Random.NextDouble()) -le $mutationProb) {
                if ($population[$i][$j] -eq 1) {
                    $population[$i][$j] = 0
                }
                else {
                    $population[$i][$j] = 1
                }
            }    
            $j++
        }
        $i++
    }
    return $population
}
Import-Module importexcel
. .\Write-Log.ps1
$log = $true
if ($Log) { Write-Log "$(Get-Date): Initialize GA." }
$generations = 10
$PopulationSize = 20
$ChromosomeSize = 15
$CrossOverProbability = 0.6
$MutationProbability = 0.009
if ($Log) { 
    Write-Log "$(Get-Date): Number of iterations/generations: [$($generations)]" 
    Write-Log "$(Get-Date): Population size (chromosomes): [$($populationSize)]" 
    Write-Log "$(Get-Date): Chromosome Size (genes): [$($ChromosomeSize)]" 
    Write-Log "$(Get-Date): Crossover probability: [$($CrossOverProbability)]" 
    Write-Log "$(Get-Date): Mutation probability: [$($MutationProbability)]" 
}

[array]$population = generatePopulation -chromosomeCount $PopulationSize -geneCount $ChromosomeSize
if ($Log) { Write-Log "$(Get-Date): Population was generated." }
if ($Log) { Write-Log "$(Get-Date): Generation/Iteration: [0]" }

$populationFitnessValue = GenerateFitnessValue_Population -population $population
$fitnessPopulation_max = ($populationFitnessValue | Measure-Object -Maximum).Maximum
$fitnessPopulation_avg = ($populationFitnessValue | Measure-Object -Average).Average
$fitnessPopulation = PopulationStatictics -population $population -fitness
if ($Log) { Write-Log "$(Get-Date): Value of the fitness function of population: [$($fitnessPopulation)]" }
if ($Log) { Write-Log "$(Get-Date): Maximum value of the fitness function for a chromosome in the population: [$($fitnessPopulation_max)]" }
if ($Log) { Write-Log "$(Get-Date): Average value of the fitness function for the population: [$($fitnessPopulation_avg)]" }
[array]$allGenerations += , @(0, $fitnessPopulation, $population)
for ($i = 1; $i -le $generations; $i++) {
    $fitnessPopulation = 0
    if ($Log) { Write-Log "$(Get-Date): Generation/Iteration: [$($i)]" }
    if ($Log) { Write-Log "$(Get-Date): Selection." }
    $_ReproductionItems = Roulette -population $population -fitness $populationFitnessValue
    if ($Log) { Write-Log "$(Get-Date): Crossover." }
    $CrossovertPopulation = Crossover -population $_ReproductionItems -ChromosomeSize $ChromosomeSize -crossoverProb $CrossOverProbability
    if ($Log) { Write-Log "$(Get-Date): Mutating." }
    $mutedPopulation = Mutation -population $CrossovertPopulation -mutationProb $MutationProbability
    $populationFitnessValue = GenerateFitnessValue_Population -population $mutedPopulation
    $fitnessPopulation_max = ($populationFitnessValue | Measure-Object -Maximum).Maximum
    $fitnessPopulation_avg = ($populationFitnessValue | Measure-Object -Average).Average
    $fitnessPopulation = PopulationStatictics -population $mutedPopulation -fitness 
    if ($Log) { Write-Log "$(Get-Date): Value of the fitness function of population: [$($fitnessPopulation)]" }
    if ($Log) { Write-Log "$(Get-Date): Maximum value of the fitness function for a chromosome in the population: [$($fitnessPopulation_max)]" }
    if ($Log) { Write-Log "$(Get-Date): Average value of the fitness function for the population: [$($fitnessPopulation_avg)]" }
    [array]$allGenerations += , @($i, $fitnessPopulation, $mutedPopulation)
    $population = $mutedPopulation
}
if ($Log) { Write-Log "$(Get-Date): End Generation/Iteration." }

$IndexBestGeneration = ($allGenerations  | sort-object @{Expression={$_[1]}; Ascending=$false} | Select-Object @{expression={$_[0]};Label="Generation"}, @{expression={$_[1]};Label="Fitness"} -First 1).Generation
if ($Log) { Write-Log "$(Get-Date): Index of generation with highest value of fitness function: [$($IndexBestGeneration)]" }
if ($Log) { Write-Log "$(Get-Date): highest value of fitness function: [$($allGenerations[$IndexBestGeneration][1])]" }
$allGenerations[$IndexBestGeneration][2].foreach{"[$psitem]"}
#$allGenerations[$generations][0]
#$allGenerations[$generations][1]
#($allGenerations[$generations][2]).foreach{ "{$psitem}" }
#($allGenerations[$generations].ForEach{$psitem}).foreach{$PSItem} | Out-GridView
#$allGenerations | Out-GridView
#$allGenerations.foreach{$psitem[1]} | export-excel -Path "c:\temp\ga.xlsx" -barchart -autofilter -show


<#
$AllGenerationFitness = $allGenerations.foreach{ $psitem[1] }
barchart ($AllGenerationFitness) -ChartType line -nolegend -title "Generation's fitness value"
#>


#$cd = New-ExcelChartDefinition -
#$newarray | export-excel -Path "c:\temp\ga.xlsx" -barchart -show
#$cd = New-ExcelChartDefinition -xrange "test" -ChartType ColumnClustered -ChartTrendLine Linear 
#$allGenerations.foreach{$psitem[1]} | Export-Excel -Path "c:\temp\ga.xlsx" -ExcelChartDefinition $cd -AutoNameRange -Show 
#$newarray | Export-Excel -Path "c:\temp\ga.xlsx" -ExcelChartDefinition $cd -AutoNameRange -Show 
