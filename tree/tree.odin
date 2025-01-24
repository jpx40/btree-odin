package tree 


import "base:runtime"
import "core:strings"



Tree :: struct($K: typeid,$T: typeid ) {
    allocator: runtime.Allocator,
    head: ^Node(K,T),
    len: int
}

Node :: struct($K: typeid,$T: typeid ) {
    weight: int,
    depth: u32,
    parent: ^Node(K,T),
    // children: [dynamic]^Node(K,T),
    left: ^Node(K,T),
    right: ^Node(K,T),
    // data: [dynamic]Cell(K,T)
    data: Cell(K,T)
    
}



Cell :: struct($K: typeid,$T: typeid ) {
    key: K,
    value: T,
}


make :: proc($tree: typeid/Tree($K,$T), allocator := context.allocator) -> Tree(K,T) 
where  size_of(K) <= int(max(u16)) ||K == string  {
    return Tree {allocator = allocator, len = 0}
    
}




push :: proc(tree: ^Tree($K,$T),key: K,value:T)
    where  K == string && len(key) <= 30 || size_of(K) <= int(max(u16))
{
    node := new(Node(K,T),tree.allocator)
    node.data = Cell{key = key,value= value}
    node.weight = get_key_size(rawptr(&key),K)
    tree.len += 1

    if tree.head == nil {
      tree.head = node
    } else { 
     
        
    }
    
    
}

insert_fit :: proc(old: ^Node($K,$T), new:^Node($K,$T ) -> bool {
    if old.weight <= new.weight {
        
    } else {
        
    }
    
    
}

get_key_size :: proc(key: rawptr, type: typeid) -> int {
    
    	switch type  { 
     
        case string: {
            s :=cast(^string)key
            count := 0 
            b :[]byte= transmute([]byte)s^
            for c in b {
                count += int(c)
            }
            return count
        }
        case int: {
            i :=cast(^int)key
            return i^
        }
        case i32: {
            i :=cast(^i32)key
            return int(i^)
        }
        case f32: {
            i :=cast(^f32)key
            return int(i^)
        }   
        case f64: {
            i :=cast(^f32)key
            return int(i^)
        }
        case i16: {
            i :=cast(^i16)key
            return int(i^)
        }
        case u16: {
            i :=cast(^u16)key
            return int(i^)
        }
        case u32: {
            i :=cast(^u32)key
            return int(i^)
        }
        case i64: {
            i :=cast(^i64)key
            return int(i^)
        }
        case u64: {
            i :=cast(^u64)key
            return int(i^)
        }
        case:
         return -1
        
        
     }
     
     
    return -1
}