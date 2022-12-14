create.test.tree <- function(tree, node.text, sample, ...) {
    out <- SRCGrob(
        tree,
        node.text,
        node.radius = 0.1,
        node.text.cex = 0.85,
        scale1 = 0.9,
        seg1.col = 'navy',
        seg2.col = 'gold',
        node.col = 'grey40',
        line.lwd = 4,
        yaxis1.label = 'PGA',
        yaxis2.label = 'SNV',
        xaxis.label = 'CP',
        main = sample,
        main.cex = 1.55,
        main.y = 0.3,
        size.units = 'inches',
        ...
        );

    return(out);
    }
