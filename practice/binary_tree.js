class Node {
  constructor(val) {
    this.val = val
    this.left = null
    this.right = null
  }
}

// height or weight balanced?

function isBalanced(node) {
  /*
    if balanced, return size of tree
    else return -1
  */

  if (!node) return 0 // empty tree is balanced

  var l = isBalanced(node.left)
  var r = isBalanced(node.right)

  if (l<0 || r<0 || Math.abs(l-r) > 1) return -1
  else return l+r+1
}


/*

       1
     /  \
    2    3
   / \  / \
  4  5 6  7
 /  /
8  9

*/

var parent = new Node(1)
parent.left = new Node(2)
parent.right = new Node(3)
parent.left.left = new Node(4)
parent.left.right = new Node(5)
parent.left.left.left = new Node(8)
parent.left.right.left = new Node(9)
parent.right.left = new Node(6)
parent.right.right= new Node(7)

console.log(isBalanced(parent) >= 0)

parent.left.left.left = null
console.log(isBalanced(parent) >= 0)

parent.right.right.right = new Node(10)
console.log(isBalanced(parent) >= 0)
