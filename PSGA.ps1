<#
script for learning genetics algorithms 
# locus [łac.], genet. pozycja w chromosomie zajmowana przez dany gen;
GA tutorial - https://www.tutorialspoint.com/genetic_algorithms/index.htm
PowerShell Multithreading: A Deep Dive - https://adamtheautomator.com/powershell-multithreading/
MathNet - https://www.sans.org/blog/truerng-random-numbers-with-powershell-and-math-net-numerics/
charts in Powershell - https://docs.microsoft.com/en-us/archive/blogs/richard_macdonald/charting-with-powershell
Trace-Command -Name ParameterBinding, TypeConversion -Expression {.\start-genalg.ps1} -PSHost
PS2EXE:
Invoke-ps2exe -inputFile .\start-genalg.ps1 -outputFile ga_x64.exe -x64 -noConsole -MTA
, - https://devblogs.microsoft.com/powershell/array-literals-in-powershell/
posortowanie tabeli hash po value i pobranie z pierwszego rekordu wartsci value:
($b.GetEnumerator() | Sort-Object -Descending -Property value |Select-Object -First 1).value

convert array to hash table:
$d=@{}
$i=0
($population).foreach{$d[$i]=$_;$i++}
Get-Random -Minimum 0.0 -maximum 1.0
#>

#8
function Start-GA {
    [CmdletBinding()]
    param (
        [int]$Generations = 20,
        [ValidateScript( {
                if ($_ -eq 0) {
                    throw "Population size can not be [$_]!"
                }
                elseif ($_ -gt 0 -and ($_ % 2) -ne 0 ) {
                    throw "Population size [$_] is not even!"
                }
                else {
                    $true
                }
            })]
        [int]$PopulationSize = 30,
        [int]$ChromosomeSize = 20,
        [double]$CrossOverProbability = 0.6,
        [double]$MutationProbability = 0.001,
        [Validateset("Roulette", "Tournament")]
        $Selection = "Roulette",
        [switch]$Log,
        [switch]$Zeros,
        [switch]$ShowGraph,
        [switch]$ShowChart
    )

    $MeasureScript = [system.diagnostics.stopwatch]::startnew()

    #7
    if (Get-Module -ListAvailable -Name importexcel) {
        try {
            import-module importexcel  
        }
        catch {
            continue
        } 
    } 
    else {
        write-warning "Module 'ImportExcel' wasn't found. Invoke 'install-module importexcel'."
    }
    if (Get-Module -ListAvailable -Name Graphical) {
        try {
            import-module Graphical
        }
        catch {
            continue
        } 
    } 
    else {
        #20
        write-warning "Module 'Graphical' wasn't found. Invoke 'install-module Graphical'."
    }
    #7 if (!(get-module importexcel)) { write-warning "Module 'ImportExcel wasn't found. Invoke 'install-module importexcel'." }

    if ($Log) { Write-Log "$(Get-Date): [Initialize GA]" }
    if (Get-Variable m -ErrorAction SilentlyContinue) { Remove-Variable m -Scope script }
    if (Get-Variable _crossover -ErrorAction SilentlyContinue) { Remove-Variable _crossover -Scope script }
    if (Get-Variable _functionExecutionTime -ErrorAction SilentlyContinue) { Remove-Variable _functionExecutionTime -Scope script }
        
    #4
    new-variable -scope script -name m -Value 0
    #9
    new-variable -scope script -name _crossover -Value 0
    #5
    New-Variable -Scope script -Name _functionExecutionTime -Value 0
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
    if ($zeros) {
        [array]$population = generatePopulation -zeros -chromosomeCount $PopulationSize -geneCount $ChromosomeSize
    }
    else {
        [array]$population = generatePopulation -chromosomeCount $PopulationSize -geneCount $ChromosomeSize
    }
    if ($Log) { Write-Log "$(Get-Date): Population was generated." }
    #11
    if ($zeros -and $log) { Write-Log "$(Get-Date): Used param '-zeros'. Population with all genes = 0." }

    if ($Log) { Write-Log "$(Get-Date): Generation/Iteration: [0]" }
    if ($zeros) {
        $populationFitnessValue = GenerateFitnessValue_Population -population $population
        $fitnessPopulation_max = 0
        $fitnessPopulation_avg = 0
        $fitnessPopulationZero = $fitnessPopulation = 0
    }
    else {
        $populationFitnessValue = GenerateFitnessValue_Population -population $population
        $fitnessPopulation_max = ($populationFitnessValue | Measure-Object -Maximum).Maximum
        $fitnessPopulation_avg = ($populationFitnessValue | Measure-Object -Average).Average
        $fitnessPopulationZero = $fitnessPopulation = PopulationStatictics -population $population -fitness
    }
    if ($Log) { Write-Log "$(Get-Date): Value of the fitness function of population: [$($fitnessPopulation)]" }
    if ($Log) { Write-Log "$(Get-Date): Maximum value of the fitness function for a chromosome in the population: [$($fitnessPopulation_max)]" }
    if ($Log) { Write-Log "$(Get-Date): Average value of the fitness function for the population: [$($fitnessPopulation_avg)]" }
    $IndexBestGeneration_2 = 0
    $fitnessPopulationZero_2 = $fitnessPopulationZero
    [array[]]$allGenerations += , @(0, $fitnessPopulation, $population)
    for ($i = 1; $i -le $generations; $i++) {
        $fitnessPopulation = 0
        if ($Log) { Write-Log "$(Get-Date): No. Generation/Iteration: [$($i)]" }
        if ($Log) { Write-Log "$(Get-Date): Selection." }
        switch ($selection) {
            "roulette" {         
                $_ReproductionItems = Roulette -population $population -fitness $populationFitnessValue -Population_Size $populationSize -_ChromosomeSize $ChromosomeSize
            }
            "tournament" {
                $_ReproductionItems = Tournament -population $population -fitness $populationFitnessValue -Population_Size $populationSize
            }
            Default {}
        }
        $_SelectionGlobalExecutionTime = $_SelectionGlobalExecutionTime + $script:_functionExecutionTime
        $script:_functionExecutionTime = 0
        if ($Log) { Write-Log "$(Get-Date): Crossover." }
        $CrossovertPopulation = Crossover -population $_ReproductionItems -ChromosomeSize $ChromosomeSize -crossoverProb $CrossOverProbability -Population_Size $populationSize
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
        if ($fitnessPopulationZero_2 -lt $fitnessPopulation) {
            # first generation index with max
            $IndexBestGeneration_2 = $i
            $fitnessPopulationZero_2 = $fitnessPopulation
        }
        [array[]]$allGenerations += , @($i, $fitnessPopulation, $mutedPopulation)
        $population = $mutedPopulation
        if ($Log) { Write-Log "$(Get-Date): End generation/iteration (index): [$($i)]" }
        Write-Progress -Activity "Reproduction" -Status "Progress:" -PercentComplete ($i / $generations * 100)
    }
    $allGenerations | ConvertTo-Json | Out-File "$env:TEMP\allGenerations.log"
    if ($Log) { Write-Log "$(Get-Date): End of all generations/Iterations." }
    #9
    if ($Log) { Write-Log "$(Get-Date): Number of all crossovers: [$_crossoverGlobalCount]" }
    #4
    if ($Log) { Write-Log "$(Get-Date): Number of all mutations: [$_mutations]" }
    #5
    if ($Log) { Write-Log "$(Get-Date): Global selection execution time: [$_SelectionGlobalExecutionTime ms]" }
    if ($Log) { Write-Log "$(Get-Date): Global crossover execution time: [$_CrossoverGlobalExecutionTime ms]" }
    if ($Log) { Write-Log "$(Get-Date): Global mutation execution time: [$_MutationGlobalExecutionTime ms]" }

    $IndexBestGeneration = ($allGenerations | sort-object @{Expression = { $_[1] }; Ascending = $false } | Select-Object @{expression = { $_[0] }; Label = "Generation" }, @{expression = { $_[1] }; Label = "Fitness" } -First 1).Generation
    if ($Log) { Write-Log "$(Get-Date): Index of generation with highest value of fitness function: [$IndexBestGeneration]" }
    if ($Log) { Write-Log "$(Get-Date): Index of generation with highest value of fitness function: [$IndexBestGeneration_2]" }

    if ($Log) { Write-Log "$(Get-Date): Highest value of fitness function: [$($allGenerations[$IndexBestGeneration][1])]" }
    if ($zeros) {
        $FitnessGain = (($allGenerations[$IndexBestGeneration_2][1] - $fitnessPopulationZero) * 100)
    }
    else {
        $FitnessGain = (($allGenerations[$IndexBestGeneration_2][1] - $fitnessPopulationZero) / $fitnessPopulationZero) * 100
    }
    $FitnessGain = "{0:n2}" -f $FitnessGain
    if ($Log) { Write-Log "$(Get-Date): Fitness gain (((f(max)-f(0))/f(0))*100): [$FitnessGain %]" }
    Write-output "Best generation: [$IndexBestGeneration_2]"
    Write-output "Best fitness: [$($allGenerations[$IndexBestGeneration_2][1])]"
    Write-output "Fitness gain: [$FitnessGain %]"

    $AllGenerationFitness = $allGenerations.foreach{ $psitem[1] }
    if ($showgraph) {
        Show-Graph $AllGenerationFitness -XAxisTitle "Generations" -YAxisTitle "Fitness" -GraphTitle "GA"
    }
    if ($Log) { Write-Log "$(Get-Date): Script execution time: [$($MeasureScript.ElapsedMilliseconds) ms]" }
    if ($Log) { Write-Log "$(Get-Date): [End of GA]" }
    if ($Log) { "LOG: $env:TEMP\GA.log" }
    #10
    $allGenerations | ConvertTo-Json | Out-File "$env:TEMP\allGenerations.log"
    "OUT DATA: $env:TEMP\allGenerations.log"
    #19
    if ($ShowChart) {
        # show and save
        ShowChart -AllGenerationFitness $AllGenerationFitness -ShowChart -SaveChart
    }
    else {
        # save only
        ShowChart -AllGenerationFitness $AllGenerationFitness -SaveChart
   
    }
    <#
.SYNOPSIS
Finding scheduled tasks, system services on computer by user name. 
.DESCRIPTION
Finding scheduled tasks, system services on local or remote computer by given user name. 
'Administrator' and local computer are default values.
The results can be redirected to the log file (see 'log' parameter).
.PARAMETER User
User name to find scheduled tasks or system services. Default value is 'Administrator'.
.PARAMETER Computer
Computer to find tasks/services. Default value is 'localhost' ($env:COMPUTERNAME).
.PARAMETER Task
A Switch to look for scheduled tasks where user name is matched.
.PARAMETER Service
A Switch to look for system services where user name is matched.
.PARAMETER Strict
Find tasks, services by exact username.
.PARAMETER Minimal
A switch to enable minimalistic results. Object containing the computer name, number of tasks and/or number of services only. With -Log information about log file path is displayed but log file is not minimal. The return value is en object.
.PARAMETER Export
Enable exporting results objectsr to file (using "Export-Clixml"). Export file path is defined in "Exportpath" parameter.
.PARAMETER Exportpath
File name path to export results finding scheduled tasks and/or system services.
.PARAMETER ExportJSON
Enable exporting results as JSON object.
.PARAMETER ExportJSONpath
File name path for JSON export.
.PARAMETER Log
A switch to enable logging of output data to a log file. The log file with the path is defined in "LogFile" parameter.
.PARAMETER Logfile
Path with file name where logging output. Default value is [$env:TEMP]\find-taskserviceuser.log. Works only with Log switch.
.PARAMETER OpenProjectSite
The switch opens the project web page on GitHub and ends the script operation.
.EXAMPLE
PS> Find-TaskServiceUser -Computer "WSRV00" -User "BobbyK" -Service -Task -Log

Description
-----------
Find system services and scheduled tasks on "WSRV00" for user name is matched "BobbyK". Logging is enabled.
.EXAMPLE
PS> "WSRV01","WSRV02" | Find-TaskServiceUser -Service -Task

Description
-----------
Find system services and scheduled tasks on computers "WSRV01", "WSRV02"  where user name is matched "Administrator".
.EXAMPLE
PS> $data = Find-TaskServiceUser -Task -Service -Server "WSRV04" -User "SYSTEM" -Minimal
PS> $data

Description
-----------
Find tasks and services on computer "WSRV04" for "SYSTEM" user and return a minimalistic result as custom object `$data`.
.EXAMPLE
PS> "WSRV01","WSRV10" | Find-TaskServiceUser -Service -Task -Export
PS> $data = Import-Clixml "C:\Users\test_user\Documents\Find-TaskServiceUser.XML"
PS> $data.Tasks | Format-Table -Autosize
PS> $data.Services | Format-Table -Autosize

Description
-----------
Find system services and scheduled tasks on computers "WSRV01", "WSRV10" where user name is matched "Administrator". Results are exported to XML file and then imported to $data variable. Results are displayed.
.LINK
https://github.com/voytas75/Find-TaskServiceUser
.LINK
https://www.powershellgallery.com/packages/Find-TaskServiceUser
.NOTES
ICON CREDITS: Module icon made by [Freepik](https://www.freepik.com/) from [Flaticon](https://www.flaticon.com/) is licensed [CC 3.0 BY](http://creativecommons.org/licenses/by/3.0/)
DONATION: If you want to support my work https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=ZQJXFYKHL7JUA&currency_code=PLN&source=url
My post on reddit to request for comments: https://www.reddit.com/r/PowerShell/comments/fzzf1u/i_would_like_to_show_off_my_first_module_to_find/
Weekend Scripter: Welcome to the PowerShell Information Stream: https://devblogs.microsoft.com/scripting/weekend-scripter-welcome-to-the-powershell-information-stream/
#>

}
function generateChromosome {
    param (
        [ValidateNotNullorEmpty()]
        [int]$geneCount, #18
        [switch]$zeros
    )
    <#
    function generate vale of gene
    powershell statistics
    check .net statistics 
    #>
    $_chromosome = @()
    if ($zeros) {
        return [array]$_chromosome = (1..$genecount).foreach{ 0 } 
    }
    else {
        return [array]$_chromosome = (1..$genecount).foreach{ 0..1 | get-random } 
    }
}
function generatePopulation {
    [CmdletBinding()]
    param (
        [ValidateNotNullorEmpty()]
        [int]$chromosomeCount, #18
        [ValidateNotNullorEmpty()]
        [int]$geneCount, #18
        [switch]$zeros
    )
    <# 
    function generates chromosome one or more. 
    default values are definied. 
    #>
    $_population = @()
    if ($zeros) {
        (1..$chromosomeCount).foreach{ $_population += , [array](generateChromosome -zeros -geneCount $geneCount) }
    }
    else {
        (1..$chromosomeCount).foreach{ $_population += , [array](generateChromosome -geneCount $geneCount) }
    }
    return $_population
}
function PopulationStatictics {
    param (
        [ValidateNotNullorEmpty()]
        [array[]]$population,
        [switch]$Count,
        [switch]$fitness,
        [switch]$Maximum,
        [switch]$Average,
        [switch]$display        
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
    elseif ($display) {
        $population.foreach{ "[$_]" }
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
        [array]$fitness,
        $Population_Size,
        $_ChromosomeSize
    )
    #5
    $MeasureFunction = [system.diagnostics.stopwatch]::startnew()
    $script:_functionExecutionTime = 0
    $_FitnessSum = 0
    $_NormalizeItem = @()
    $_aggregatesum = 0
    $fitness.foreach{ $_FitnessSum += $PSItem }
    #13 #15
    if ($_FitnessSum -eq 0 -and -not $zeros) {
        #$_FitnessSum.foreach{ "Fitness sum: [$PSItem]" }
        #$population.foreach{ "Population item: [$PSItem]" }
        #"[STOP]"
        #14
        if ($Log) { Write-Log "$(Get-Date): [EXIT] Fitness is 0. Terminating." }
        if ($Log) { Write-Log "$(Get-Date): [End of GA]" }
        Write-output "[EXIT] Fitness is 0. Terminating."
        exit
    }
    elseif ($_FitnessSum -gt 0) {
        $_NormalizeItem = $fitness.foreach{ $Psitem / $_FitnessSum }
    }
    elseif ($_FitnessSum -eq 0 -and $zeros) {
        #$_NormalizeItem = $fitness.foreach{ 0 }
        #16
        return (generatePopulation -zeros -chromosomeCount $Population_Size -geneCount $_ChromosomeSize)
    } 
    [array]$AgregateSum = $_NormalizeItem.foreach{ $_aggregatesum += $PSItem; $_aggregatesum }
    [Object]$Random = New-Object System.Random
    #17
    #[int]$_popcount = PopulationStatictics -population $population -count
    [int]$_popcount = $Population_Size
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
        [array]$fitness,
        $Population_Size
    )
    #5
    $MeasureFunction = [system.diagnostics.stopwatch]::startnew()
    $_Kindividuals = 4
    #17
    $_PopulationWinners = @()
    $_PopulationSize = $Population_Size
    for ($ii = 0; $ii -lt $_PopulationSize; $ii++) {
        $_population_hashtable_temp = @{}
        $_populationHashTable = @{}
        $i = 0
        # convert array to hash table:
        $_populationHashTable = ($population).foreach{ $_population_hashtable_temp + @{item = $i; genome = $_; fitness = $fitness[$i] }; $i++ }
        # get items to tournament
        $_TournamentPlayers = get-random -InputObject $_populationHashTable -count $_Kindividuals 
        # sort items by fitness
        $_TournamentPlayers_SortFitness = $_TournamentPlayers.GetEnumerator() | Sort-Object -property { $_.fitness } -descending
        $_TurnamentWinner = @{}
        # sorting items by fitness and take first one
        $_TurnamentWinner = $_TournamentPlayers_SortFitness | Select-Object -first 1
        # building Tournament winner as population to mutate
        $_PopulationWinners += , ($population[$_TurnamentWinner.item])
    }
    #5
    $script:_functionExecutionTime = $MeasureFunction.ElapsedMilliseconds
    if ($Log) { Write-Log "$(Get-Date): Selection 'Tournament' execution time: ($script:_functionExecutionTime ms)" }
    return $_PopulationWinners
}
function Crossover {
    param (
        [ValidateNotNullorEmpty()]
        [array[]]$population,
        [ValidateNotNullorEmpty()]
        $ChromosomeSize,
        [ValidateNotNullorEmpty()]
        $crossoverProb,
        $Population_Size
    )
    $MeasureFunction = [system.diagnostics.stopwatch]::startnew()
    $script:_crossover = 0  #9
    [Object]$Random = New-Object System.Random
    #17
    $_PopulationSize = $Population_Size
    for ($i = 0; $i -lt $_PopulationSize; $i += 2) {
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
                # we are in! mutation time! Lets change some genes!
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
#19
function ShowChart {
    param (
        $AllGenerationFitness,
        [switch]$SaveChart,
        [switch]$ShowChart
    )
    # CHART
    # load the appropriate assemblies
    [void][Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
    [void][Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms.DataVisualization")

    # create chart object
    $Chart = New-object System.Windows.Forms.DataVisualization.Charting.Chart
    $Chart.Width = 1000
    $Chart.Height = 400
    $Chart.Left = 40
    $Chart.Top = 30

    # create a chartarea to draw on and add to chart
    $ChartArea = New-Object System.Windows.Forms.DataVisualization.Charting.ChartArea
    $Chart.ChartAreas.Add($ChartArea)

    # add data to chart
    #$Cities = @{London = 7556900; Berlin = 3429900; Madrid = 3213271; Rome = 2726539; Paris = 2188500 }
    [void]$Chart.Series.Add("Data")
    $gg = 0
    $Chart.Series["Data"].Points.DataBindXY([int[]]$AllGenerationFitness.foreach{ , ($gg++) }, [int[]]$AllGenerationFitness )

    # Find point with max/min values and change their colour
    $maxValuePoint = $Chart.Series["Data"].Points.FindMaxByValue()
    $maxValuePoint.Color = [System.Drawing.Color]::Red

    $minValuePoint = $Chart.Series["Data"].Points.FindMinByValue()
    $minValuePoint.Color = [System.Drawing.Color]::Green

    # change chart area colour
    #$Chart.BackColor = [System.Drawing.Color]::Transparent
    # add a save button
    $SaveButton = New-Object Windows.Forms.Button
    $SaveButton.Text = "Save"
    $SaveButton.Top = 500
    $SaveButton.Left = 450
    $SaveButton.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right
    $SaveButton.add_click( { $Chart.SaveImage($env:TEMP + "\GA.png", "PNG") })
    if ($SaveChart) {
        $Chart.SaveImage($env:TEMP + "\GA.png", "PNG")
        "PNG: $env:TEMP\GA.png" 
    }
    if ($ShowChart) {
        # display the chart on a form
        $Chart.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right -bor [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Left
        $Form = New-Object Windows.Forms.Form
        $Form.Text = "PowerShell Chart"
        $Form.Width = 1100
        $Form.Height = 600
        $Form.controls.add($Chart)
        $Form.Add_Shown( { $Form.Activate() })
        #$Form.controls.add($SaveButton)
        $Form.ShowDialog()
    }
}
function Write-Log {
    param(
        [string]$logstring
    )
    [string]$Logfile = "$env:TEMP\GA.log"
    Add-Content $logfile -Value $logstring -Force
}