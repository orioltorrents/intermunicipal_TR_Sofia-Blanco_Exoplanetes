### Activem llibreries
library(googlesheets4)
library(tidyverse)
library(knitr)
library(ggplot2)
library(cowplot)
library(magick)
library(dplyr)
library(vegan)
library(permute)
library(lattice)
library(tinytex)
# llibreries de 3D plots
library(rgl)
library(plot3D)

# Posem el Fitxer i Sheet en variables
url_dades_exoplanetes <- "https://docs.google.com/spreadsheets/d/1jYRwz5ruWNcyz4N3flDKCQsBZyM-jdG19IEfjYhcy0o/edit#gid=585883389"
dades_exoplanetes <- googlesheets4::read_sheet(url_dades_exoplanetes, sheet = "Densitat3")

# Posem les variables x,y,z en cada eix
x <- dades_exoplanetes$st_rad
y <- dades_exoplanetes$st_mass
z <- dades_exoplanetes$st_density

# Avaluem la variable Planet_type que ha de ser factor
planet_type <- dades_exoplanetes$Planet_Type

# Si no és factor (mirant el environment), el convertim a factor
factor_planet_type <-factor(planet_type)

# Add a new column with color
mycolors <- c('royalblue1', 'darkolivegreen1', 'coral')
dades_exoplanetes$color <- mycolors[as.numeric(factor_planet_type)]

# open 3d window
open3d()

# resize window
par3d(windowRect = c(100, 100, 800, 800))

# Plot
plot3d( 
  x, y, z,
  type = "p",
  size = 12,
  col = dades_exoplanetes$color,
  xlab="Radi", ylab="Massa", zlab="Densitat")

# Movie 3D
movie3d(spin3d(axis=c(0,0,1), rpm = 3), duration = 15, dir = "./")

#########################################
##### Plot Scatter3D amb fons negre
######################################333
points3D(x,y,z, 
# Add a nice background
bty = "u",
col.grid = "darkgrey", 
col.panel = "black",
col = dades_exoplanetes$color,
colkey = F,
pch = 16,
# Specify Labels
main = "Exoplanetes",
clab = "Tipus de cold",
xlab = "\nradi",
ylab = "\nmassa",
zlab = "\ndensitat",
# Adjust label sizing
cex = 1, # Multiply dot size by 2
cex.main = 1.5, # Multiply the size of main title text by 2
cex.lab = 1) # Multiply size of axis label text by 2

# Plot Scatter3D
points3D(x,y,z,
        col = dades_exoplanetes$color,
        xlab = "\nRadi", ylab = "\nMassa", zlab = "\nDensitat",
        colkey = F,
        pch = 16)
## Documentació
## https://cran.r-project.org/web/packages/scatterplot3d/vignettes/s3d.pdf

## Prova llegenda Points3d 
legend(s3d$xyz.convert(18, 0, 12), col= c("green","blue", "red", "black"), bg="white", lty=c(1,1), lwd=2, yjust=0, legend = c("2010", "2011", "2012", "Prognose für 2013"), cex = 1.1)
## a adaptar


# preparant llegenda
k <- sort(unique(planet_type))

# add horitzontal legend
legend3d(x=.1, y=.95, legend = k, pch = 8, col = mycolors, title='Tipus de Cold', horiz=TRUE)

# add vertical legend
legend3d("topright", legend = k, pch = 8, col = mycolors, title='Tipus de Cold', cex=1)

# capture snapshot
snapshot3d(filename = '3dplot3.png', fmt = 'png')

#### Proves amb la base de dades Iris ####

# Data: the iris data is provided by R
data <- iris

# Avaluem la variable Species que ha de ser factor
species <- iris$Species

# Add a new column with color
mycolors <- c('royalblue1', 'darkcyan', 'oldlace')
data$color <- mycolors[as.numeric(data$Species)]

# Plot
plot3d( 
  x=data$`Sepal.Length`, y=data$`Sepal.Width`, z=data$`Petal.Length`, 
  col = data$color, 
  type = 's', 
  radius = .3,
  xlab="Sepal Length", ylab="Sepal Width", zlab="Petal Length")

# To save to a file:
htmlwidgets::saveWidget(rglwidget(width = 520, height = 520), 
                        file = "HtmlWidget/3dscatter.html",
                        libdir = "libs",
                        selfcontained = FALSE
)
