
var dancersComplementHash =
    {"ladles": "gentlespoons"
    ,"gentlespoons": "ladles"
    ,"ones": "twos"
    ,"twos": "ones"
    ,"first corners": "second corners"
    ,"second corners": "first corners"
    };
// If this names 2 dancers, this returns the names for the other 2 dancers
// it's sketchy, because it assumes 4 dancers, so only use it in contra moves
function dancersComplement(whostr) {
    return dancersComplementHash[whostr] ||
        throw_up("bogus parameter to dancersComplementHash: "+ whostr)
}

function sumBeats(figures,optional_limit) {
    var acc = 0;
    var n = isInteger(optional_limit) ? optional_limit : figures.length;
    for (var i = 0; i < n; i++)
        acc += figures[i].beats;
    return acc;
}

function labelForBeats(beats) {
    if ((beats%16) == 0)
        switch (beats/16) {
        case 0: return "A1";
        case 1: return "A2";
        case 2: return "B1";
        case 3: return "B2";
        case 4: return "C1";
        case 5: return "C2";
        case 6: return "D1";
        case 7: return "D2";
    }
    return "";
}
