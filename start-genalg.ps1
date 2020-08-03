<#
script for learning genetics algorithms 
# locus [łac.], genet. pozycja w chromosomie zajmowana przez dany gen;
GA tutorial - https://www.tutorialspoint.com/genetic_algorithms/index.htm
PowerShell Multithreading: A Deep Dive - https://adamtheautomator.com/powershell-multithreading/
MathNet - https://www.sans.org/blog/truerng-random-numbers-with-powershell-and-math-net-numerics/
#> 
param (
    [bool]$log = $true,
    $generations = 10,
    $PopulationSize = 10,
    $ChromosomeSize = 10,
    $CrossOverProbability = 0.6,
    $MutationProbability = 0.003
)

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
        [array[]]$population,
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
        [array[]]$population
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
        [ValidateNotNullorEmpty()]
        [array[]]$population,
        [ValidateNotNullorEmpty()]
        [array]$fitness
    )
    #5
    $MeasureFunction = [system.diagnostics.stopwatch]::startnew()
    $script:_functionExecutionTime = 0
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
    #5
    $script:_functionExecutionTime = $MeasureFunction.ElapsedMilliseconds
    if ($Log) { Write-Log "$(Get-Date): Selection 'Roulette' execution time: ($script:_functionExecutionTime ms)" }
    return $_reproduceItems
}

function Tournament {
    param (
        [ValidateNotNullorEmpty()]
        [array[]]$population,
        [ValidateNotNullorEmpty()]
        [array]$fitness
    )
    #5
    $MeasureFunction = [system.diagnostics.stopwatch]::startnew()
    $_Kindividuals = 4
    $_PopulationSize = PopulationStatictics -population $fitness -Count
    $_PopulationWinners = @()
    for ($ii = 0; $ii -lt $_PopulationSize; $ii++) {
        $_population_hashtable_temp = @{}
        $_populationHashTable = @{}
        $i = 0
        #convert array to hash table:
        $_populationHashTable = ($population).foreach{ $_population_hashtable_temp + @{item = $i; genome = $_; fitness = $fitness[$i] }; $i++ }
        #get items to tournament
        $_TournamentPlayers = get-random -InputObject $_populationHashTable -count $_Kindividuals 
        #sort items by fitness
        $_TournamentPlayers_SortFitness = $_TournamentPlayers.GetEnumerator() | Sort-Object -property { $_.fitness } -descending
        $_TurnamentWinner = @{}
        # sorting items by fitness and take first one
        $_TurnamentWinner = $_TournamentPlayers_SortFitness | Select-Object -first 1
        #building Tournament winner as population to mutate
        $_PopulationWinners += , ($population[$_TurnamentWinner.item])
    }
    #5
    $script:_functionExecutionTime = $MeasureFunction.ElapsedMilliseconds
    if ($Log) { Write-Log "$(Get-Date): Selection 'Tournament' execution time: ($script:_functionExecutionTime ms)" }

    return $_PopulationWinners
    <#
    posortowanie tabeli hash po value i pobranie z pierwszego rekordu wartsci value:
    ($b.GetEnumerator() | Sort-Object -Descending -Property value |Select-Object -First 1).value

    convert array to hash table:
    $d=@{}
    $i=0
    ($population).foreach{$d[$i]=$_;$i++}
    #>

    #$population | Export-Clixml -Path poulation.xml
    #$fitness | Export-Clixml -Path fitness.xml
}
function Crossover {
    param (
        [ValidateNotNullorEmpty()]
        [array[]]$population,
        [ValidateNotNullorEmpty()]
        $ChromosomeSize,
        [ValidateNotNullorEmpty()]
        $crossoverProb
    )
    $MeasureFunction = [system.diagnostics.stopwatch]::startnew()
    $script:_crossover = 0  #9
    [Object]$Random = New-Object System.Random
    for ($i = 0; $i -lt (PopulationStatictics -population $population -count); $i += 2) {
        if (($Random.NextDouble()) -le $crossoverProb) { 
            $script:_crossover++    #9
            $_crossoverPoint = 1..($ChromosomeSize - 2) | get-random
            [array[]]$_crossoverpopulation += , ($population[$i][0..$_crossoverPoint] + $population[$i + 1][($_crossoverPoint + 1)..($ChromosomeSize)]) 
            [array[]]$_crossoverpopulation += , ($population[$i + 1][0..$_crossoverPoint] + $population[$i][($_crossoverPoint + 1)..($ChromosomeSize)])
        }
        else {
            [array[]]$_crossoverpopulation += , ($population[$i])
            [array[]]$_crossoverpopulation += , ($population[$i + 1])
        }
    }    
    if ($Log) { Write-Log "$(Get-Date): Number of all crossovers in population: [$script:_crossover]" }   #9
    $script:_functionExecutionTime = $MeasureFunction.ElapsedMilliseconds
    if ($Log) { Write-Log "$(Get-Date): Crossover execution time: ($script:_functionExecutionTime ms)" }
    return $_CrossoverPopulation
}
function Mutation {
    param (
        [ValidateNotNullorEmpty()]
        [array[]]$population,
        [ValidateNotNullorEmpty()]
        $mutationProb
    )
    $MeasureFunction = [system.diagnostics.stopwatch]::startnew()
    [Object]$Random = New-Object System.Random
    $i = 0
    $script:m = 0
    foreach ($items in $population) {
        $j = 0
        foreach ($item in $items) {
            if (($Random.NextDouble()) -le $mutationProb) {
                #we are in! mutation time! Lets change some genes!
                #4
                $script:m++
                if ($population[$i][$j] -eq 1) {
                    $population[$i][$j] = 0
                    if ($Log) { Write-Log "$(Get-Date): Mutation! Item [$i], Gene [$j] 1 -> 0" }
                }
                else {
                    $population[$i][$j] = 1
                    if ($Log) { Write-Log "$(Get-Date): Mutation! Item [$i], Gene [$j] 0 -> 1" }
                }
            }    
            $j++
        }
        $i++
    }
    if ($Log) { Write-Log "$(Get-Date): Number of all mutations in population: [$script:m]" }
    #5
    $script:_functionExecutionTime = $MeasureFunction.ElapsedMilliseconds
    if ($Log) { Write-Log "$(Get-Date): Mutation execution time: ($script:_functionExecutionTime ms)" }
    return $population
}
# MAIN CODE
$MeasureScript = [system.diagnostics.stopwatch]::startnew()

#7
if (Get-Module -ListAvailable -Name importexcel) {
    import-module importexcel
} 
else {
    write-warning "Module 'ImportExcel wasn't found. Invoke 'install-module importexcel'."
}
#7 if (!(get-module importexcel)) { write-warning "Module 'ImportExcel wasn't found. Invoke 'install-module importexcel'." }
. .\Write-Log.ps1

if ($Log) { Write-Log "$(Get-Date): [Initialize GA]" }
#4
new-variable -scope script -name m -Value 0
#9
new-variable -scope script -name _crossover -Value 0
#5
New-Variable -Scope script -Name _functionExecutionTime -Value 0
$_selectionDictionary = @("Roulette", "Tournament")
$selection = $_selectionDictionary[0]
$_crossoverGlobalCount = 0      #9
$_mutations = 0     #4
$_SelectionGlobalExecutionTime = 0
$_CrossoverGlobalExecutionTime = 0
$_MutationGlobalExecutionTime = 0
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
$fitnessPopulationZero = $fitnessPopulation = PopulationStatictics -population $population -fitness
if ($Log) { Write-Log "$(Get-Date): Value of the fitness function of population: [$($fitnessPopulation)]" }
if ($Log) { Write-Log "$(Get-Date): Maximum value of the fitness function for a chromosome in the population: [$($fitnessPopulation_max)]" }
if ($Log) { Write-Log "$(Get-Date): Average value of the fitness function for the population: [$($fitnessPopulation_avg)]" }
[array[]]$allGenerations += , @(0, $fitnessPopulation, $population)
for ($i = 1; $i -le $generations; $i++) {
    $fitnessPopulation = 0
    if ($Log) { Write-Log "$(Get-Date): No. Generation/Iteration: [$($i)]" }
    if ($Log) { Write-Log "$(Get-Date): Selection." }
    switch ($selection) {
        "roulette" {         
            $_ReproductionItems = Roulette -population $population -fitness $populationFitnessValue
        }
        "tournament" {
            $_ReproductionItems = Tournament -population $population -fitness $populationFitnessValue
        }
        Default {}
    }
    $_SelectionGlobalExecutionTime = $_SelectionGlobalExecutionTime + $script:_functionExecutionTime
    $script:_functionExecutionTime = 0
    if ($Log) { Write-Log "$(Get-Date): Crossover." }
    $CrossovertPopulation = Crossover -population $_ReproductionItems -ChromosomeSize $ChromosomeSize -crossoverProb $CrossOverProbability
    $_CrossoverGlobalExecutionTime = $_CrossoverGlobalExecutionTime + $script:_functionExecutionTime
    $script:_functionExecutionTime = 0
    #9
    $_crossoverGlobalCount = $_crossoverGlobalCount + $script:_crossover
    if ($Log) { Write-Log "$(Get-Date): Mutating." }
    $mutedPopulation = Mutation -population $CrossovertPopulation -mutationProb $MutationProbability
    $_MutationGlobalExecutionTime = $_MutationGlobalExecutionTime + $script:_functionExecutionTime
    $script:_functionExecutionTime = 0
    #4
    $_mutations = $_mutations + $script:m
    $populationFitnessValue = GenerateFitnessValue_Population -population $mutedPopulation
    $fitnessPopulation_max = ($populationFitnessValue | Measure-Object -Maximum).Maximum
    $fitnessPopulation_avg = ($populationFitnessValue | Measure-Object -Average).Average
    $fitnessPopulation = PopulationStatictics -population $mutedPopulation -fitness 
    if ($Log) { Write-Log "$(Get-Date): Value of the fitness function of population: [$($fitnessPopulation)]" }
    if ($Log) { Write-Log "$(Get-Date): Maximum value of the fitness function for a chromosome in the population: [$($fitnessPopulation_max)]" }
    if ($Log) { Write-Log "$(Get-Date): Average value of the fitness function for the population: [$($fitnessPopulation_avg)]" }
    [array[]]$allGenerations += , @($i, $fitnessPopulation, $mutedPopulation)
    $population = $mutedPopulation
    if ($Log) { Write-Log "$(Get-Date): End generation/iteration (index): [$($i)]" }
}
if ($Log) { Write-Log "$(Get-Date): End of all generations/Iterations." }
#9
if ($Log) { Write-Log "$(Get-Date): Number of all crossovers: [$_crossoverGlobalCount]" }
#4
if ($Log) { Write-Log "$(Get-Date): Number of all mutations: [$_mutations]" }
#5
if ($Log) { Write-Log "$(Get-Date): Global selection execution time: [$_SelectionGlobalExecutionTime ms]" }
if ($Log) { Write-Log "$(Get-Date): Global crossover execution time: [$_CrossoverGlobalExecutionTime ms]" }
if ($Log) { Write-Log "$(Get-Date): Global mutation execution time: [$_MutationGlobalExecutionTime ms]" }

$IndexBestGeneration = ($allGenerations  | sort-object @{Expression = { $_[1] }; Ascending = $false } | Select-Object @{expression = { $_[0] }; Label = "Generation" }, @{expression = { $_[1] }; Label = "Fitness" } -First 1).Generation
if ($Log) { Write-Log "$(Get-Date): Index of generation with highest value of fitness function: [$($IndexBestGeneration)]" }
if ($Log) { Write-Log "$(Get-Date): Highest value of fitness function: [$($allGenerations[$IndexBestGeneration][1])]" }
$FitnessGain = (($allGenerations[$IndexBestGeneration][1] - $fitnessPopulationZero) / $fitnessPopulationZero) * 100
$FitnessGain = "{0:n2}" -f $FitnessGain
if ($Log) { Write-Log "$(Get-Date): Fitness gain (((f(max)-f(0))/f(0))*100): [$FitnessGain %]" }
Write-output "Best generation: [$($IndexBestGeneration)]"
Write-output "Fitness gain: [$FitnessGain %]"
<#
 Trace-Command -Name ParameterBinding, TypeConversion -Expression {.\start-genalg.ps1} -PSHost
 PS2EXE:
 Invoke-ps2exe -inputFile .\start-genalg.ps1 -outputFile ga_x64.exe -x64 -noConsole -MTA
#>

<#
$AllGenerationFitness = $allGenerations.foreach{ $psitem[1] }
barchart ($AllGenerationFitness) -ChartType line -nolegend -title "Generation's fitness value"
#>

#$cd = New-ExcelChartDefinition -
#$newarray | export-excel -Path "c:\temp\ga.xlsx" -barchart -show
#$cd = New-ExcelChartDefinition -ChartType ColumnClustered -ChartTrendLine Linear
#$allGenerations.foreach{$psitem[1]} | Export-Excel -ExcelChartDefinition $cd -Show
#$newarray | Export-Excel -Path "c:\temp\ga.xlsx" -ExcelChartDefinition $cd -AutoNameRange -Show 
if ($Log) { Write-Log "$(Get-Date): Script execution time: [$($MeasureScript.ElapsedMilliseconds) ms]" }
if ($Log) { Write-Log "$(Get-Date): [End of GA]" }
