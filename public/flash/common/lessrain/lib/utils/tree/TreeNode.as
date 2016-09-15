import lessrain.lib.utils.tree.ComparableInterface;

class lessrain.lib.utils.tree.TreeNode
{
    public var left:TreeNode;
    public var right:TreeNode;
    public var data:ComparableInterface;
    
    function TreeNode(d:ComparableInterface,l:TreeNode,r:TreeNode)
    {
        data = d;
        left = l;
        right = r;
    }
}