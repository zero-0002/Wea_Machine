.pragma library

function fdRatio(x) {
    return wQuick.theme.displayRatio * x;
}

function idRatio(x) {
    return parseInt((wQuick.theme.displayRatio * x).toFixed(0));
}

function idRatio2(x) {
    return parseInt((wQuick.theme.displayRatio * x).toFixed(0) / 2) * 2;
}

function fillArray(count, value) {
    var result = [];

    for (var i = 0; i < count; ++i) {
        result.push(value);
    }

    return result;
}

function darker(colors, factor) {
    let result = [];
    for (var i = 0; i < colors.length; ++i) {
        const color = colors[i];
        result.push(Qt.darker(color, factor));
    }
    return result;
}

function lighter(colors, factor) {
    let result = [];
    for (var i = 0; i < colors.length; ++i) {
        const color = colors[i];
        result.push(Qt.lighter(color, factor));
    }
    return result;
}

function textIsEmpty(text) {
    return !text || text === "";
}

/*!
*  \brief arrayTextSearch: simple text search using js array.
*
*  \param src: var -> sourceData array.
*  \param text: string -> text to filter
*  \param caseSensitive: bool
*  \param inverted: bool -> true means if value not found by input pattern
*
*  \return var: filteredData.
*/
function arrayTextSearch(src, text, caseSensitive = false, inverted = false) {
    if (textIsEmpty(text)) {
        return src;
    }

    const pattern = caseSensitive ? text : text.toLowerCase();
    return src.filter(function (item) {
        const itemText = caseSensitive ? item : item.toLowerCase();
        return inverted ? itemText.indexOf(pattern) === -1 : itemText.indexOf(pattern) !== -1;
    });
}

function clamp(value, min, max) {
    return Math.min(max, Math.max(min, value));
}

function normalize(value, min, max) {
    return (value - min) / (max - min);
}
