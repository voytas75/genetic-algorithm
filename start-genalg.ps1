# script for learning genetics algorithms 
function generateGene {
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

function generateChromosomes {
    [CmdletBinding()]
    param (
        [ValidateNotNullorEmpty()]
        [int]$geneCount = 8,
        [ValidateNotNullorEmpty()]
        [int]$chromosomeCount = 4
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
                $_chromosome += ,[array](generateGene -geneCount $geneCount)
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







#generateGene
[array]$population = generateChromosomes -geneCount 16 -chromosomeCount 10
#$chromosome.GetType()
#foreach ($individual in $population) {
    #Write-Output "Individual:"
    #$individual
    $population | ForEach-Object {"Item: [$PSItem]"}
#}
$populationStatistics = PopulationStatictics -population $population
$populationStatistics | ForEach-Object {"population count: [$PSItem]"}
