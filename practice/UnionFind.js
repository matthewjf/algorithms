function UnionFind() {
  this.connectedCount = 0;
  this.parents = {};
  this.treeSize = {};
}

UnionFind.prototype.insert = function (el) {
  this.parents[el] = el;
  this.connectedCount += 1;
};

UnionFind.prototype.union = function (el1, el2) {
  var root1 = this.findRoot(el1);
  var root2 = this.findRoot(el2);

  if (root1 === root2)
    return null;

  if (this.treeSize[root1] > this.treeSize[root2]) {
    this.parents[root2] = root1;
    this.treeSize[root1] += this.treeSize[root2];
  } else {
    this.parents[root1] = root2;
    this.treeSize[root2] += this.treeSize[root1];
  }

  this.connectedCount -= 1;
};

UnionFind.prototype.isConnected = function (el1, el2) {
  return this.findRoot(el1) === this.findRoot(el2);
};

UnionFind.prototype.findRoot = function (el) {
  var curr = el;
  while (this.parents[curr] !== curr) {
    this.parents[curr] = this.parents[this.parents[curr]];
    curr = this.parents[curr];
  }
  return curr;
};

function inherits(sub, parent) {
  var Surrogate = function() {};
  Surrogate.prototype = parent.prototype;
  sub.prototype = Surrogate.new();
  sub.prototype.constructor = sub;
}
