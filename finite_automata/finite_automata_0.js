function getNextState(pattern, state, char) {
  if (state < pattern.length && char === pattern[state])
    return state + 1;

  var nextState, i;
  for (nextState = state; nextState > 0; nextState--) {
    if (pattern[nextState-1] === char) {
      for (i = 0; i < nextState-1; i++) {
        if (pattern[i] !== pattern[state-nextState+1+i])
          break;
      }
      if (i === nextState-1)
        return nextState;
    }
  }
  return 0;
}

function computeTF(pattern, dictionary) {
  var tf = [];
  var state;
  for (state = 0; state <= pattern.length; state++)
    Object.keys(dictionary).forEach(function(char) {
      tf[state] = tf[state] || []
      tf[state][dictionary[char]] = getNextState(pattern, state, char)
    })
  return tf;
}

function search(pattern, txt) {
  var dictionary = buildDict(pattern + txt);
  var tf = computeTF(pattern, dictionary);
  var i, state = 0;
  for (i = 0; i < txt.length; i++) {
    state = tf[state][dictionary[txt[i]]];
    if (state === pattern.length) {
      return i - pattern.length + 1;
    }
  }
  return -1;
}

function buildDict(str) {
  var dictionary = {}
  str.split('').filter(uniq).sort().forEach(function(el, idx) {
    dictionary[el] = idx
  })
  return dictionary
}

function uniq(val, index, self) {
  return self.indexOf(val) === index
}

var txt = "AABAACAADAABAAABAA";
var pattern = "BAAA";
var res = search(pattern, txt);
console.log(res);
