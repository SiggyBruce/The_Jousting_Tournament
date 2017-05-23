with Unchecked_Deallocation;
-------------------------------------------------------------------------------
-- Name: Tre Haga
-- Date: 12/11/2016
-- Course: ITEC 320 - Procedural Analysis and Design
-- Purpose: Dynamic implementation of a stack.
-------------------------------------------------------------------------------
package body stacks is

	procedure Dispose is new Unchecked_Deallocation(Object => StackNode,
		Name => Stack);
	
	function is_Empty(S: Stack) return Boolean is
	begin
		return S = NULL;
	end is_Empty;
	
	function is_Full(S: Stack) return Boolean is
		Tmp_Pointer: Stack;
	begin
		Tmp_Pointer := new StackNode;
        Dispose(Tmp_Pointer);
        return false;
    exception
        when STORAGE_ERROR => return true;
	end is_Full;

	procedure push(Item: ItemType; S : in out Stack) is
	begin
		if is_Full(S) then
			raise Stack_Full;
		else
			S := new StackNode'(Item, S);
		end if;
	end push;
	
	procedure pop(S: in out Stack) is
		Tmp_Pointer: Stack;
	begin
		if is_Empty(S) then
			raise Stack_Empty;
		elsif S.Next = NULL then
			Dispose(S);
		else
			Tmp_Pointer := S.Next;
			Dispose(S);
			S := Tmp_Pointer;
		end if;
	end pop;
	
	function top(S: Stack) return ItemType is
	begin
		return S.Item;
	end top;

	procedure print(S: in Stack) is
		Tmp_Pointer: Stack;
	begin
		Tmp_Pointer := S;
		if is_Empty(S) then
			raise Stack_Empty;
		else
			while Tmp_Pointer /= NULL loop
				print(top(Tmp_Pointer));
				Tmp_Pointer := Tmp_Pointer.Next;
			end loop;
		end if;
	end print;
   
end stacks;