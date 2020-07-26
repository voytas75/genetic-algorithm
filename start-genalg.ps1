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

    $_GenerateSumGenes | ForEach-Object {"Sum Genes Item: [$PSItem]"}
    [array]$_IsOdd = $_GenerateSumGenes.foreach{[bool]($psitem%2)}  
    $_IsOdd.ForEach{"Odd Item (<sum genes with 1>): [$PSItem]"}# generate sum all gene sum

    [array]$_indexPopulation_odd = $(0..($_IsOdd.Count-1)).where{$_indexpopulation = ($_IsOdd[$_] -eq $true);$_indexpopulation}
    #$_IsOdd.IndexOf($true)
    $_indexPopulation_odd
    ($population[$_indexPopulation_odd]).ForEach{"Odd Item: [$PSItem]"}
    ($_GenerateSumGenes[$_indexPopulation_odd]).ForEach{"Odd values Item: [$PSItem]"}
    $_GenerateSumGenes[$_indexPopulation_odd] | Sort-Object -Descending # sorted desc of sums of 1es in gemes
    $_SumOddItems = ($_IsOdd.where{$_ -match $true}).count #sum items with odd sum of genes
    $_SumOddItems.foreach{Write-Output "Sum items in population with odd sum of genes: [$psitem]"}

    #$_IsOddValue
    #$_meansumpopulation = 
    #$_Sumpopulation/($population.count)


}





#generateGene
[array]$population = generatePopulation -chromosomeCount 20 -geneCount 20
#$chromosome.GetType()
#foreach ($individual in $population) {
    #Write-Output "Individual:"
    #$individual
    $population | ForEach-Object {"Item: [$PSItem]"}
#}

$populationStatistics = PopulationStatictics -population $population
$populationStatistics | ForEach-Object {"Population count: [$PSItem]"}
GenerateFitnessValue_Population -population $population