## ---- echo=F, message=F-------------------------------------------------------
library(CancerEvolutionVisualization);

## ----echo=F-------------------------------------------------------------------
load('data/input.examples.Rda');

## ----echo=F-------------------------------------------------------------------
parent.only <- data.frame(tree.input[, 'parent', drop = FALSE]);

knitr::kable(
    parent.only,
    col.names = c(colnames(tree.input)[1]),
    row.names = TRUE
    );

## ---- fig.show='hide'---------------------------------------------------------
parent.only.tree <- SRCGrob(parent.only);

## ----echo=F-------------------------------------------------------------------
grid.draw(parent.only.tree);

## ----echo=F-------------------------------------------------------------------
branch.lengths <- tree.input[, 1:3];

knitr::kable(
    branch.lengths,
    row.names = TRUE
    );

## ---- fig.show='hide'---------------------------------------------------------
branch.lengths.tree <- SRCGrob(branch.lengths);

## ---- fig.dim=c(5, 3.5)-------------------------------------------------------
grid.draw(branch.lengths.tree);

## ----echo=F-------------------------------------------------------------------
CP <- tree.input[, c('parent', 'length1', 'length2', 'CP')];

knitr::kable(
    CP,
    row.names = TRUE
    );

## ---- fig.show='hide'---------------------------------------------------------
CP.tree <- SRCGrob(CP);

## ---- echo=F------------------------------------------------------------------
grid.draw(CP.tree);

## ----echo=F-------------------------------------------------------------------
simple.text.data <- text.input[, 1:2];

knitr::kable(
    simple.text.data,
    col.names = colnames(text.input)[1:2]
    );

## ---- fig.show='hide'---------------------------------------------------------
simple.text.tree <- SRCGrob(parent.only, simple.text.data);

## -----------------------------------------------------------------------------
grid.draw(simple.text.tree);

## ----echo=F-------------------------------------------------------------------
knitr::kable(
    text.input
    );

## ---- fig.show='hide'---------------------------------------------------------
full.text.tree <- SRCGrob(parent.only, text.input);

## -----------------------------------------------------------------------------
grid.draw(full.text.tree);

## ---- fig.show='hide'---------------------------------------------------------
padding.tree <- SRCGrob(
    branch.lengths,
    horizontal.padding = -0.8
    );

## ---- fig.dim=c(3.5, 3.5)-----------------------------------------------------
grid.draw(padding.tree);

## ---- fig.show='hide'---------------------------------------------------------
scaled.tree <- SRCGrob(
    branch.lengths,
    scale1 = 1.5,
    scale2 = 0.5
    );

## ---- fig.height=4------------------------------------------------------------
grid.draw(scaled.tree);

## ---- fig.show='hide'---------------------------------------------------------
title.tree <- SRCGrob(
    parent.only,
    main = 'Example Plot'
    );

## ---- echo=F------------------------------------------------------------------
title.tree$vp$y <- unit(0.8, 'npc');

## ---- fig.height=3.5----------------------------------------------------------
grid.draw(title.tree);

## ---- fig.show='hide'---------------------------------------------------------
axis.title.tree <- SRCGrob(
    parent.only,
    yaxis1.label = 'SNVs',
    horizontal.padding = -0.6
    );

## ---- echo=F------------------------------------------------------------------
axis.title.tree$vp$x <- unit(0.75, 'npc');

## -----------------------------------------------------------------------------
grid.draw(axis.title.tree);

## ---- fig.show='hide'---------------------------------------------------------
xaxis1.ticks <- c(10, 20, 30, 35, 40);
xaxis2.ticks <- c(100, 250, 400);

yat.tree <- SRCGrob(
    branch.lengths,
    yat = list(
        xaxis1.ticks,
        xaxis2.ticks
        ),
    horizontal.padding = -0.4
    );

## ---- fig.width=5-------------------------------------------------------------
grid.draw(yat.tree);

## ---- fig.show='hide'---------------------------------------------------------
normal.tree <- SRCGrob(
    parent.only,
    add.normal = TRUE
    );

## -----------------------------------------------------------------------------
grid.draw(normal.tree);

