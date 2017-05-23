with Unchecked_Deallocation;
-------------------------------------------------------------------------------
-- Name: Tre Haga
-- Date: 12/11/2016
-- Course: ITEC 320 - Procedural Analysis and Design
-- Purpose: Dynamic implementation of a queue.
-------------------------------------------------------------------------------
package body queues is

	procedure Dispose is new Unchecked_Deallocation(Object => QueueNode,
		Name => QueueNodePointer);
	
	function is_Empty(Q: Queue) return Boolean is
	begin
		return Q.Front = NULL;
	end is_Empty;
	
	function is_Full(Q: Queue) return Boolean is
		Tmp_Pointer: QueueNodePointer;
	begin
		Tmp_Pointer := new QueueNode;
		Dispose(Tmp_Pointer);
		return false;
	exception
		when STORAGE_ERROR => return true;
	end is_Full;

	function size(Q: Queue) return Natural is
	begin
		return Q.Count;
	end size;

	function front(Q: Queue) return ItemType is
	begin
		return Q.Front.Data;
	end front;

	procedure enqueue(Item: ItemType; Q: in out Queue) is
		Tmp_Pointer: QueueNodePointer;
	begin
		if is_Full(Q) then
			raise Queue_Full;
		elsif is_Empty(Q) then
			Q.Back := new QueueNode'(Item, NULL);
			Q.Front := Q.Back;
			Q.Count := Q.Count + 1;
		elsif Q.Front.Next = NULL then
			Q.Back := new QueueNode'(Item, NULL);
			Q.Front.Next := Q.Back;
			Q.Count := Q.Count + 1;
		else
			Tmp_Pointer := new QueueNode'(Item, NULL);
			Q.Back.Next := Tmp_Pointer;
			Q.Back := Q.Back.Next;
			Q.Count := Q.Count + 1;
		end if;
	end enqueue;
	
	procedure dequeue(Q: in out Queue) is
		Tmp_Pointer: QueueNodePointer;
	begin
		if is_Empty(Q) then
			raise Queue_Empty;
		else
			if Q.Front.Next = NULL then
				Dispose(Q.Front);
				Q.Count := Q.Count - 1;
			else
				Tmp_Pointer := Q.Front.Next;
				Dispose(Q.Front);
				Q.Front := Tmp_Pointer;
				Q.Count := Q.Count - 1;
			end if;
		end if;
	end dequeue;

	procedure print(Q: in Queue) is
		Tmp_Pointer: QueueNodePointer;
	begin
		Tmp_Pointer := Q.Front;
		if is_Empty(Q) then
			raise Queue_Empty;
		else
			while Tmp_Pointer /= NULL loop
				print(Tmp_Pointer.Data);
				Tmp_Pointer := Tmp_Pointer.Next;
			end loop;
		end if;
	end print;
	
end queues;