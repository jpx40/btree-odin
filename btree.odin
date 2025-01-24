package btree

import "base:/runtime"


Btree :: struct($K: typeid,$T: typeid ) {
    allocator: runtime.Allocator,
    head: ^Node(K,T),
    len: int
}

Node :: struct($K: typeid,$T: typeid ) {
    weight: u64,
    depth: u32,
    parent: ^Node(K,T),
    children: [dynamic]^Node(K,T),
    left: ^Node(K,T),
    right: ^Node(K,T),
    data: [dynamic]Cell(K,T)
    
}



Cell :: struct($K: typeid,$T: typeid ) {
    key: K,
    value: T,
}

make :: proc($tree: typeid/Btree($K,$T), allocator := context.allocator) -> Btree(K,T) 
where size_of(T) <= int(max(u16)) && size_of(K) <= int(max(u16)) {
    return BTree {allocator = allocator, len = 0}
    
}

Iterator :: struct($K: typeid ,$T: typeid ) {
    head: ^Node(K,T),
    node: ^Node(K,T),
    depth: int,
    current_weight: int,
    child_count: int,
    pos_node: int,
    pos: int,
}

iter :: proc(tree : ^Btree($K,$T)) -> (it: Iterator(K,T)) {
    it := Iterator { head= tree.head,node= tree.head, pos = 0}
    return it
}

next :: proc(it: ^Iterator($K,$T)) -> (K,T,bool) {
    if len(it.node.data) == it.pos {
        
            if len(it.node.children) != 0 {
                it.node = it.children[0]
                it.pos = 0
                return next(it)
            }
            else {
        
    }
    } else if len(it.node.data) != 0 {
        d := it.node.data[pos]
        it.pos += 1
        return d.key, d.value, true
    }   
    
}


exist  :: proc(tree : ^Btree($K,$T),key: K) -> bool {
    
    return false
}

main :: proc() {}