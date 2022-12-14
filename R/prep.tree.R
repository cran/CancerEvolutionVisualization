prep.tree <- function(
    tree.df,
    text.df,
    bells = TRUE,
    colour.scheme
    ) {

    if (!('parent' %in% colnames(tree.df))) {
        stop('No parent column provided');
        }

    # Error on invalid tree structure
    get.root.node(tree.df);

    if ('angle' %in% colnames(tree.df)) {
        message(paste(
            'Overriding branch angles will be supported in a future version.',
            'The angle column will not be used.'
            ));
        }

    tree.df$parent <- prep.tree.parent(tree.df$parent);

    if (!check.parent.values(rownames(tree.df), tree.df$parent)) {
        stop('Parent column references invalid node');
        }

    if (!is.null(text.df)) {
        text.df <- prep.text(
            text.df,
            tree.rownames = rownames(tree.df)
            );
        }

    if (!check.circular.node.parents(tree.df)) {
        stop(paste(
            'Circular node reference.',
            'A node cannot be the parent of its own parent.'
            ));
        }

    if (!is.null(tree.df$CP)) {
        tree.df$CP <- suppressWarnings(as.numeric(tree.df$CP));

        if (any(is.na(tree.df$CP))) {
            warning(paste(
                'Non-numeric values found in CP column.',
                'Cellular prevalence will not be used.'
                ));

            tree.df$CP <- NULL;
            }
        }

    tree.df <- reorder.nodes(tree.df);

    # Include -1 value for root node.
    # This may be temporary, as NULL/NA will likely replace -1
    node.id.index <- get.value.index(
        old.values = c(-1, rownames(tree.df)),
        new.values = c(-1, 1:nrow(tree.df))
        );

    tree.df <- reset.tree.node.ids(tree.df, node.id.index);
    tree.df$child <- rownames(tree.df);

    text.df$node <- reindex.column(text.df$node, node.id.index);

    tree.df$label <- as.character(
        if (is.null(tree.df$label)) tree.df$child else tree.df$label
        );

    out.df <- data.frame(
        id = c(-1, tree.df$child),
        label.text = c('', tree.df$label),
        ccf = if (is.null(tree.df$CP)) NA else c(1, tree.df$CP),
        color = colour.scheme[1:(nrow(tree.df) + 1)],
        parent = as.numeric(c(NA,tree.df$parent)),
        excluded = c(TRUE, rep(FALSE, nrow(tree.df))),
        bell = c(FALSE, rep(bells, nrow(tree.df))),
        alpha = rep(0.5, (nrow(tree.df) + 1)),
        stringsAsFactors = FALSE
        );

    out.df$tier <- get.num.tiers(out.df)

    out.tree <- data.frame(
        parent = as.numeric(tree.df$parent),
        tip = as.numeric(tree.df$child),
        prep.branch.lengths(tree.df)
        );

    branching <- any(duplicated(out.tree$parent));

    return(list(
        in.tree.df = out.df,
        tree = out.tree,
        text.df = text.df,
        branching = branching
        ));
    }

prep.tree.parent <- function(parent.column) {
    parent.column[parent.column %in% c(0, NA)] <- -1;
    return(parent.column);
    }

reorder.nodes <- function(tree.df) {
    if (any(!is.na(tree.df$CP))) {
        tree.df <- reorder.nodes.by.CP(tree.df);
        }

    return(reorder.trunk.node(tree.df));
    }

reorder.nodes.by.CP <- function(tree.df) {
    return(tree.df[order(-(tree.df$CP), tree.df$parent), ]);
    }

reorder.trunk.node <- function(tree.df) {
    is.trunk <- is.na(tree.df$parent) | tree.df$parent == -1;

    # Skip reindexing data.frame if trunk node is already first
    if (!is.trunk[[1]]) {
        tree.df[c(which(is.trunk), which(!is.trunk)), ];
    } else {
        tree.df;
        }
    }

reset.tree.node.ids <- function(tree.df, value.index) {
    rownames(tree.df) <- 1:nrow(tree.df);

    # Convert parent values to character to safely index names list
    tree.df$parent <- reindex.column(tree.df$parent, value.index);

    return(tree.df);
    }



check.parent.values <- function(node.names, parent.col) {
    unique.node.names <- as.list(setNames(
        !vector(length = length(unique(node.names))),
        unique(node.names)
        ));

    all(sapply(
        parent.col,
        FUN = function(parent) {
            !is.null(unlist(unique.node.names[parent])) | parent == -1;
            }
        ));
    }

check.circular.node.parents <- function(tree) {
    has.circular.ref <- all(sapply(
        row.names(tree),
        function(node.name) {
            !is.circular.node.parent(tree, node.name);
            }
        ));

    return(has.circular.ref)
    }

is.circular.node.parent <- function(tree, node) {
    node.parent <- tree[node, 'parent'];
    parent.parent <- tree[node.parent, 'parent'];

    is.root <- function(node.name) {
        is.na(node.name) || node.name == '-1';
        }
    contains.root.node <- (is.root(node.parent)) || is.root(parent.parent);

    is.circular <- !contains.root.node && parent.parent == node;

    return(is.circular)
    }

get.root.node <- function(tree) {
    valid.values <- as.character(c(-1, 0));
    candidates <- which(is.na(tree$parent) | tree$parent %in% valid.values);

    if (length(candidates) > 1) {
        stop('More than one root node detected.');
    } else if (length(candidates) == 0) {
        stop('No root node provided.');
        }

    return(candidates);
    }

get.y.axis.position <- function(tree.colnames) {
    num.branch.length.cols <- length(get.branch.length.colnames(tree.colnames));

    y.axis.position <- if (num.branch.length.cols == 1) 'left' else {
        if (num.branch.length.cols > 1) 'both' else 'none';
        };

    return(y.axis.position);
    }
