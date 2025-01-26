package tree


import "base:runtime"
import "core:fmt"
import "core:strings"


Tree :: struct($K: typeid, $T: typeid) {
	allocator: runtime.Allocator,
	head:      ^Node(K, T),
	len:       int,
}

Node :: struct($K: typeid, $T: typeid) {
	weight: int,
	// depth: u32,
	parent: ^Node(K, T),
	// children: [dynamic]^Node(K,T),
	left:   ^Node(K, T),
	right:  ^Node(K, T),
	// data: [dynamic]Cell(K,T)
	data:   Cell(K, T),
}


Cell :: struct($K: typeid, $T: typeid) {
	key:   K,
	value: T,
}


make :: proc(
	$tree: typeid/Tree($K, $T),
	allocator := context.allocator,
) -> Tree(K, T) where size_of(K) <= int(max(u16)) ||
	K == string {
	return Tree(K, T){allocator = allocator, len = 0}

}


push :: proc(tree: ^Tree($K, $T), key: K, value: T) -> bool where size_of(K) <= int(max(u16)) {
	node := new(Node(K, T), tree.allocator)
	node.data = Cell(K, T) {
		key   = key,
		value = value,
	}
	key := key
	size := get_key_size(rawptr(&key), K)
	// if size < 0 {
	// free(node)
	// return false
	// }
	node.weight = size

	if tree.head == nil {
		tree.head = node
		return true
	} else {

		if insert_fit(tree.head, node) {

			tree.len += 1
			return true
		} else {

			free(node)
		}
	}

	return false
}

insert_fit :: proc(old: ^Node($K, $T), new: ^Node(K, T)) -> bool {
	if old.weight <= new.weight {
		if old.right == nil {
			new.parent = old
			old.right = new
			return true
		} else if old.right.weight == new.weight {
			if old.right.data.key == new.data.key {
				return false
			} else {
				oldr := old.right
				new.right = oldr
				new.parent = oldr.parent
				old.right = new
				oldr.parent = new
				return true

			}
		} else {
			return insert_fit(old.right, new)
		}
	} else {
		if old.left == nil {
			new.parent = old
			old.left = new
			return true
		} else if old.left.weight == new.weight {
			if old.left.data.key == new.data.key {
				return false
			} else {
				new.parent = old
				oldl := old.left
				oldl.parent = new
				new.left = oldl
				old.left = new
				return true

			}
		} else {
			return insert_fit(old.left, new)
		}
	}

	return false
}

find :: proc(node: ^Node($K, $T), key: K, weight: int) -> (k: K, val: T, check: bool) {
	if node.weight == weight && node.data.key == key {
		return node.data.key, node.data.value, true
	}
	if node.weight <= weight {
		if node.right == nil {
			return
		} else {

			return find(node.right, key, weight)
		}} else if node.left == nil {
		return
	} else {

		return find(node.left, key, weight)
	}
	return
}


find_node :: proc(
	node: ^Node($K, $T),
	key: K,
	weight: int,
) -> (
	out_node: ^Node(K, T),
	check: bool,
) {
	if node.weight == weight && node.data.key == key {
		return node, true
	}
	if node.weight <= weight {
		if node.right == nil {
			return
		} else {

			return find_node(node.right, key, weight)
		}} else if node.left == nil {
		return
	} else {

		return find_node(node.left, key, weight)
	}
	return
}


get_key_size :: proc(key: rawptr, type: typeid) -> int {

	switch type {

	case string:
		{
			s := cast(^string)key
			count := 0
			b: []byte = transmute([]byte)s^
			for c in b {
				count += int(c)
			}
			return count
		}
	case int:
		{
			i := cast(^int)key
			u := i^

			return u
		}
	case i32:
		{
			i := cast(^i32)key
			return int(i^)
		}
	case f32:
		{
			i := cast(^f32)key
			return int(i^)
		}
	case f64:
		{
			i := cast(^f64)key
			return int(i^)
		}
	case i16:
		{
			i := cast(^i16)key
			return int(i^)
		}
	case u16:
		{
			i := cast(^u16)key
			return int(i^)
		}
	case u32:
		{
			i := cast(^u32)key
			return int(i^)
		}
	case i64:
		{
			i := cast(^i64)key
			return int(i^)
		}
	case u64:
		{
			i := cast(^u64)key
			return int(i^)
		}
	case:
		return -1


	}


	return -1
}


Iterator :: struct($K: typeid, $T: typeid) {
	node:      ^Node(K, T),
	pos:       u64,
	depth:     int,
	range:     [2]int
	
	
	direction: Direction,
}
Direction :: enum u8 {
	Left,
	Right,
}
iter :: proc(tree: ^Tree($K, $T)) -> Iterator(K, T) {
    if tree.head == nil {
        
       	return Iterator(K, T){
            range =  {0,0}
        }

    }

    f := find_first_node(tree.head)
    l := find_last_node(tree.head)
    range := {f.weight,l.weight}
   	return Iterator(K, T) {
        node = f, 
        range = range
    }

}
get :: proc(tree: ^Tree($K, $T), k: K) -> (key: K, val: T, check: bool) {
	if tree.head == nil {
		return
	}
	_k := k
	p := rawptr(&_k)
	i := get_key_size(p, K)
	return find(tree.head, k, i)
}
get_node :: proc(tree: ^Tree($K, $T), k: K) -> (node: ^Node(K, T), check: bool) {
	if tree.head == nil {
		return
	}
	_k := k
	p := rawptr(&_k)
	i := get_key_size(p, K)
	return find_node(tree.head, k, i)
}
next :: proc(it: ^Iterator($K, $T)) -> (key: K, val: T, check: bool) {
    node := it.node
    if node.weight >= range[0] {
        range
    }
	if it.node != nil {
		key = it.node.data.key
		val = it.node.data.value
		it.node = it.node.left
		if node.right != nil {
		
		} else	if  node.parent != nil {
		      it.range[0] = node.parent
				it.node = node.parent
						
		
		}
		return key, value, true
	} else {
		return
	}
	return
}


remove :: proc(tree: ^Tree($K, $T), key: K) -> bool {
	if tree.head == nil {
		return false
	}
	node, b := get_node(tree, key)
	if b {

		if tree.head.data.key == key {
			tree.len -= 1
			if node.right != nil && node.left == nil {
				right := node.right

				right.parent = nil
				tree.head = right
			}
			if node.left != nil && node.right == nil {
				left := node.right

				left.parent = nil
				tree.head = left
			}


			if node.left != nil && node.right != nil {
				right := node.right

				right.parent = nil
				tree.head = right
				left := node.left
				right.parent = nil
				right.left = left
				left.parent = right

			}

			free(node)
			return true


		} else {
			parent := node.parent

			if parent.left != nil && parent.left.data.key == node.data.key {
				tree.len -= 1
				if node.right != nil && node.left == nil {

					right := node.right
					parent.right = right
					right.parent = parent
				}
				if node.left != nil && node.right == nil {

					left := node.left
					parent.left = left
					left.parent = parent

				}

				if node.left != nil && node.right != nil {
					left := node.left
					right := node.right
					right.parent = left
					left.right = right

				}


				free(node)
				return true
			} else if parent.right != nil && parent.left.data.key == node.data.key {
				tree.len -= 1


				if node.right != nil && node.left == nil {

					right := node.right
					parent.right = right
					right.parent = parent
				}
				if node.left != nil && node.right == nil {

					left := node.left
					parent.left = left
					left.parent = parent

				}

				if node.left != nil && node.right != nil {
					left := node.left
					right := node.right
					right.parent = parent
					right.left = left
					left.parent = right

				}
				free(node)
				return true
			}
		}

	}

	return false

}


find_first_node :: proc(node: ^Node($K,$T)) -> (first_n: ^Node(K,T) ) {
    if node.left != nil {
        
        return find_first_node(node.left)
    } 
    
    return  node   
}
find_last_node :: proc(node: ^Node($K,$T)) -> (first_n: ^Node(K,T) ) {
    if node.right != nil {
        
        return find_first_node(node.right)
    } 
    
    return  node   
}
main :: proc() {

	tree := make(Tree(string, int))
	b := push(&tree, "0", 1)
	b = push(&tree, "21", 1)

	b = push(&tree, "-12", 1)
	remove(&tree, "0")

	remove(&tree, "21")
	fmt.println("Key: ", tree.head.data.key, " Value: ", tree.head.data.value)
	k, v, b2 := get(&tree, "-12")
	fmt.println("Key: ", k, " Value: ", b2)
	// fmt.println("Key: ", tree.head.right.left.data.key,
	// " Value: ",tree.head.right.left.data.value)

}
