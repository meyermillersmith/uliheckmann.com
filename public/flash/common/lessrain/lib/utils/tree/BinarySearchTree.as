import lessrain.lib.utils.tree.TreeNode;
import lessrain.lib.utils.tree.ComparableInterface;

class lessrain.lib.utils.tree.BinarySearchTree 
{
    private var root:TreeNode;
    private var numNodes:Number = 0;
    public function getSize(node:TreeNode) 
    {
        if (node == undefined) 
        {
            return 0;
        } 
        else 
        {
            return (1+getSize(node.left)+getSize(node.right));
        }
    }
    public function clear() 
    {
        delete root;
        numNodes = 0;
    }
    
    public function isEmpty() 
    {
        return (numNodes == 0);
    }
    
    public function contains(obj:ComparableInterface):Boolean 
    {
        return _contains(root, obj);
    }
    
    public function addNode(obj:ComparableInterface):Boolean 
    {
        var tmpNumNodes:Number = numNodes;
        root = _addNode(root, obj);
        if (tmpNumNodes<0)
        {
        	// this line was obviously wring... there is no "node", so i made it root...
            return _contains(root, obj);
            //return _contains(node.left, obj);
        } 
        else 
        {
        	// this line was obviously wring... there is no "node", so i made it root...
            return _contains(root, obj);
            //return _contains(node.right, obj);
        }
    }
    private function _contains(node:TreeNode, obj:ComparableInterface) :Boolean
    {
    	// this one's missing
    	return false;
    }
    	
   private function _addNode(node:TreeNode, obj:ComparableInterface) 
    {
        if (node == undefined) 
        {
            numNodes++;
            return new TreeNode(obj, null, null);
        } 
        else if (obj.compareTo(node.data)<0) 
        {
            node.left = _addNode(node.left, obj);
            return node;
        } 
        else if (obj.compareTo(node.data)>0) 
        {
            node.right = _addNode(node.right, obj);
            return node;
        } 
        else 
        {
            return node;
        }
    }
    private function _removeNode(node:TreeNode, obj:ComparableInterface) 
    {
        if (node == undefined) 
        {
            return node;
        } 
        else if (obj.compareTo(node.data)<0) 
        {
            node.left = _removeNode(node.left, obj);
            return node;
        } 
        else if (obj.compareTo(node.data)>0) 
        {
            node.right = _removeNode(node.right, obj);
            return node;
        } 
        else 
        {
            numNodes--;
            return merge(node.left, node.right);
        }
    }
    private function merge(leftNode:TreeNode, rightNode:TreeNode) 
    {
        if (rightNode == undefined) 
        {
            return leftNode;
        }
        else if (rightNode.left == undefined) 
        {
            rightNode.left = leftNode;
            return rightNode;
        }
        else
        {
            var ptrParent:TreeNode = rightNode;
            var ptr:TreeNode = rightNode.left;
            while (ptr.left != null) 
            {
                ptrParent = ptr;
                ptr = ptr.left;
            }
            ptrParent.left = ptr.right;
            ptr.left = leftNode;
            ptr.right = rightNode;
            return ptr;
        }
    }
}