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
    # sum of genes >= mean sum all genes
    #Write-Information -MessageData "witam w funkcji 'GenerateFitnessValue_Population'" -InformationAction Continue
    #Write-Information -MessageData ($population.count) -InformationAction Continue
    #$_ValueFenotype = @()
    $_GenerateSumGenes = $population.ForEach{($_ -match 1).count} # array of sum genes where are 1
    #$population.ForEach{Write-Output $PSItem}
    #$_GenerateSumGenes.foreach{+=$_    } 

    $_GenerateSumGenes | ForEach-Object {"Sum Genes Item: [$PSItem]"}
    $_GenerateSumGenes.foreach{$_Sumpopulation += $PSItem}
    #$_meansumpopulation = 
    $_Sumpopulation/($population.count)


}





#generateGene
[array]$population = generatePopulation -chromosomeCount 10 -geneCount 8
#$chromosome.GetType()
#foreach ($individual in $population) {
    #Write-Output "Individual:"
    #$individual
    $population | ForEach-Object {"Item: [$PSItem]"}
#}

$populationStatistics = PopulationStatictics -population $population
$populationStatistics | ForEach-Object {"Population count: [$PSItem]"}
GenerateFitnessValue_Population -population $population