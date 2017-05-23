with Ada.Text_IO; use Ada.Text_IO;
-- This is the generic specification for a dynamic stack abstract data type.
generic

	type ItemType is private;
	with procedure print(item: ItemType);
	
package stacks is

	type Stack is limited private;

	Stack_Empty, Stack_Full: exception;

	function is_Empty(S: Stack) return Boolean;
	function is_Full(S: Stack) return Boolean;
	procedure push(Item: ItemType; S : in out Stack);
	procedure pop(S: in out Stack);
	function top(S: Stack) return ItemType;
	procedure print(S: in Stack);

private

	type StackNode;

	type Stack is access StackNode;

	type StackNode is record
		Item: ItemType;
		Next: Stack;
	end record;

end stacks;