# Genetic Algorithm

![https://www.freepik.com/](https://image.freepik.com/free-vector/dna-sequence-hands-wireframe-dna-code-molecules-structure-mesh_127544-899.jpg)

This is a genetic algorithm written in Powershell.

## [What is GA?](https://en.wikipedia.org/wiki/Genetic_algorithm)

> In computer science and operations research, a genetic algorithm (GA) is a metaheuristic inspired by the process of natural selection that belongs to the larger class of evolutionary algorithms (EA). Genetic algorithms are commonly used to generate high-quality solutions to optimization and search problems by relying on biologically inspired operators such as mutation, crossover and selection.[1] John Holland introduced genetic algorithms in 1960 based on the concept of Darwin’s theory of evolution, and his student David E. Goldberg further extended GA in 1989.

I decided to write it for two reasons. The first reason was to learn what a genetic algorithm is, the second reason was to gain experience in Powershell. The implementation of this algorithm is not difficult, but requires understanding what GA is and how it works.

## Syntax

The command has the following syntax:

```powershell
Start-GA [[-Generations] <int>] [[-PopulationSize] <int>] [[-ChromosomeSize] <int>] [[-CrossOverProbability] <double>] [[-MutationProbability] <double>] [[-Selection] <Object>] [-Log] [-Zeros] [-ShowGraph] [-ShowChart] [<CommonParameters>]
```

Let us now analyze the command syntax given above. I will describe all the parameters.

### Generations

```[[-Generations] <int>]```

The parameter defines the number of recalculation iterations for the population before we complete the algorithm.

The parameter has a default value and it is **20** generations.

**Example**. We resize the population to 100 genomes:

```powershell
-Generations 100
```

### PopulationSize

```[[-PopulationSize] <int>]```

We define the size of the population used in the GA. Size is understood as the number of genomes - in this abbreviation a genome is equal to a chromosome. The size of the population is constant for the duration of the algorithm's operation and ___must be even___.

The parameter has a default value and it is **30** genomes.

**Example**. We resize the population to 100 genomes:

```powershell
-PopulationSize 50
```

### ChromosomeSize

```[[-ChromosomeSize] <int>]```

**Example**. We resize the genom/chromosome to 35 genes:

```powershell
-ChromosomeSize 35
```

## How to use it

As the syntax is already known, we will learn how to run and use the script.

Using the script is very simple. First you need to run the script:

```powershell
. .\start-genalog.ps1
```

The first period allows you to load functions from a file into the current scope.

Then the genetic algorithm can be run:

```powershell
Start-GA
```

Sample output result:

```powershell
Best generation: [14]
Best fitness: [390]
Fitness gain: [261,11 %]
OUT DATA: C:\Users\user\AppData\Local\Temp\allGenerations.log
PNG: C:\Users\user\AppData\Local\Temp\GA.png
```
