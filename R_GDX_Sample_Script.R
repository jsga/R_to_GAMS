
# Include the gdx library (required)
library(gdxrrw)
# Set the path of your gams executable
igdx('C:/GAMS/win64/24.2')
# Include the R scripts that facilitate the read/write of GDX files
source('R_to_GDX.R')

# Sets
NTime<-10 # t
NGenerators<-3  # i

# Initialise sets for data structuring in GDX file
Time<-uelsGDX('t',NTime)
Generators<-uelsGDX('i',NGenerators)

# Set up fictitious demand profile over t intervals [MWh/h] (assuming hourly resolution)
demand <- c(50,60,70,60,60,55,50,40,40,50)

# Assign minimum and maximum generation levels for generators [MW]
Pmin <-c(20,0,0)
Pmax <-c(50,10,40)

# Define fuel costs for each generator [EUR/MWh]
Cost<- c(30,40,60)

# Set up inputs for GDX file creation

# Sets
set.t<-inputGDX('t',matrix(1, 1, NTime), Time, type="set")
set.i<-inputGDX('i',matrix(1, 1, NGenerators), Generators, type="set")

# Parameters
demand.in <- inputGDX('demand',demand,Time)
Pmin.in <- inputGDX('Pmin', Pmin, Generators)
Pmax.in <- inputGDX('Pmax', Pmax, Generators)
Cost.in <-inputGDX('cost',Cost, Generators)

# The following is included as an example of the input of multi-dimensional data,
# it is not employed in the actual optimisation

tmp<-matrix(0, NTime, NGenerators)

for (i in 1:NTime){
  for (j in 1:NGenerators){
    tmp[i,j]<-i*j    
  }
}
tmp.in<-inputGDX2('test_2D',tmp,Time,Generators)

# Create GDX Input file
wgdx('Input',set.i,set.t, demand.in, Pmax.in,Pmin.in, Cost.in, tmp.in,  squeeze = 'n')

# Run the gams script - change the first variable to the path of your GAMS executable
system('C:/GAMS/win64/24.2/gams.exe Sample_Script.gms lo=3')

# Unpack the outputs

SystemCost<-ProcessRGDX_SingleValue('Output', 'SysCost')
PowerGeneration<-ProcessRGDX('Output', 'P',list(Generators,Time),c("Generator","Time"),"Generator","Time")

