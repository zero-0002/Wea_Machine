.pragma library

const indicatorActiveLevels = {
    red: 0,
    yellow: 1,
    green: 2,
    orange: 3
};

function getInputActiveLevel(active, feedback) {
    if (active) {
        return indicatorActiveLevels.red;
    }
    return indicatorActiveLevels.green;
}
