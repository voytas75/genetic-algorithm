# Genetic Algorithm

![https://www.freepik.com/](https://image.freepik.com/free-vector/dna-sequence-hands-wireframe-dna-code-molecules-structure-mesh_127544-899.jpg)

This is a genetic algorithm written in Powershell.

## [What is GA?](https://en.wikipedia.org/wiki/Genetic_algorithm)

> In computer science and operations research, a genetic algorithm (GA) is a metaheuristic inspired by the process of natural selection that belongs to the larger class of evolutionary algorithms (EA). Genetic algorithms are commonly used to generate high-quality solutions to optimization and search problems by relying on biologically inspired operators such as mutation, crossover and selection.[1] John Holland introduced genetic algorithms in 1960 based on the concept of Darwin’s theory of evolution, and his student David E. Goldberg further extended GA in 1989.

I decided to write it for two reasons. The first reason was to learn what a genetic algorithm is, the second reason was to gain experience in Powershell. The implementation of this algorithm is not difficult, but requires understanding what GA is and how it works.

## Syntax

```powershell
Start-GA [[-Generations] <int>] [[-PopulationSize] <int>] [[-ChromosomeSize] <int>] [[-CrossOverProbability] <double>] [[-MutationProbability] <double>] [[-Selection] <Object>] [-Log] [-Zeros] [-ShowGraph] [-ShowChart] [<CommonParameters>]
```

## How to use it

Using the script is very simple. First you need to run the script:

```powershell
. .\start-genalog.ps1
```

The first period allows you to load functions from a file into the current scope.

Then the genetic algorithm can be run:

```powershell
Start-GA
```


