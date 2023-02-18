window.MathJax = {
    tex: {
        // inlineMath: [["\\(", "\\)"]],
        // displayMath: [["\\[", "\\]"]],
        processEscapes: true,
        processEnvironments: true
    },
    options: {
        ignoreHtmlClass: ".*|",
        processHtmlClass: "arithmatex"
    },
    loader: {load: ['[tex]/boldsymbol', '[tex]/mathtools']},
    tex: {packages: {'[+]': ['boldsymbol', 'mathtools']}}
};

document$.subscribe(() => {
    MathJax.typesetPromise()
})
