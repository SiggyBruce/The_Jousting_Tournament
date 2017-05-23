with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Strings.Fixed; use Ada.Strings.Fixed;
with Ada.Exceptions; use Ada.Exceptions;
with stacks;
with queues;
-------------------------------------------------------------------------------
-- Name: Tre Haga
-- Date: 12/11/2016
-- Course: ITEC 320 - Procedural Analysis and Design
-- Title: Project 5 - The Jousting Tournament
-- Purpose: This program simulates a jousting tournament by taking in a set of
-- players from standard input and determining a champion among them.
-- The algorithm sorts the winners for the incoming players in ascending or
-- descending order based on the player's initial skill level. If two or more
-- players have the same skill level, then they are sorted by the greatest
-- amount of wins they have. If two or more players have the same amount
-- of wins, then they are sorted by the least amount of losses they have. If
-- two or more players have the same amount of losses, then they are sorted by
-- their respective arrival time (least to greatest). The player with the
-- larger skill level (or meets the conditions to win) wins the match and gets
-- to stay in the same coliseum to joust more players until they lose or is
-- declared the champion. The loser then moves onto the next coliseum to joust
-- other players until another player is the last one left. Once a coliseum has
-- only one player left, they are put on the winning list in order by when the
-- player became a champion of a coliseum. This program utilizes three dynamic 
-- queues (queues package), one dynamic stack (stacks package), and pointers.
-------------------------------------------------------------------------------
procedure sorter is

	-- Exceptions.
	No_Data, No_Players, Invalid_Sort, Invalid_Skill: exception;

	-- Enumeration type for sorting.
	type SortType is (Descending, Ascending);
	package SortType_IO is new ada.text_io.enumeration_io(SortType);
	use SortType_IO;

	-- A pointer to the player's name.
	type NamePointer is access String;

	-- A player.
	type Player is record
		Arrival: Natural;
		Skill: Positive;
		Wins: Natural;
		Losses: Natural;
		Name: NamePointer;
	end record;

	-- A pointer to a player.
	type PlayerPointer is access Player;

	---------------------------------------------------------------------------
	-- Purpose: This procedure prints all of the data assosiated with a player.
	---------------------------------------------------------------------------
	procedure print(new_Player: Player) is
	begin
		Put(new_Player.Arrival, 4);
		Put(new_Player.Skill, 7);
		Put(new_Player.Wins, 7);
		Put(new_Player.Losses, 6);
		Put("     " & new_Player.Name.all);
		New_Line;
	end print;

	-- Access to the queues package for dynamic queues.
	package MyQueuePackage is new queues(Player, print);
	use MyQueuePackage;

	-- Access to the stacks package for dynamic stacks.
	package MyStackPackage is new stacks(Player, print);
	use MyStackPackage;

	-- The main data record for the program.
	type Data is record
		ColiseumOneQueue: Queue;
		ColiseumTwoQueue: Queue;
		WinnerQueue: Queue;
		ReverserStack: Stack;
		Sort: SortType;
	end record;

	---------------------------------------------------------------------------
	-- Purpose: This procedure process the first coliseum matches for the
	-- tournament by placing the winners back into the ColiseumOneQueue and the
	-- losers into the ColiseumTwoQueue. If there is one player left in the
	-- ColiseumOneQueue then that player is moved into the WinnerQueue.
	---------------------------------------------------------------------------
	procedure coliseum_One_Matches(playerData: in out Data) is
		playerOne, playerTwo: Player;
		playerOnePointer, playerTwoPointer: PlayerPointer;
	begin
		while not is_Empty(playerData.ColiseumOneQueue) loop
			if size(playerData.ColiseumOneQueue) = 1 then
				enqueue(front(playerData.ColiseumOneQueue), playerData.WinnerQueue);
				dequeue(playerData.ColiseumOneQueue);
			else
				playerOne := front(playerData.ColiseumOneQueue);
				playerOnePointer := new Player'(playerOne);
				dequeue(playerData.ColiseumOneQueue);
				playerTwo := front(playerData.ColiseumOneQueue);
				playerTwoPointer := new Player'(playerTwo);
				dequeue(playerData.ColiseumOneQueue);
				if playerOnePointer.all.Skill > playerTwoPointer.all.Skill then
					playerOnePointer.all.Wins := playerOnePointer.all.Wins + 1;
					playerTwoPointer.all.Losses := playerTwoPointer.all.Losses + 1;
					enqueue(playerOnePointer.all, playerData.ColiseumOneQueue);
					enqueue(playerTwoPointer.all, playerData.ColiseumTwoQueue);
				elsif playerOnePointer.all.Skill = playerTwoPointer.all.Skill then
					if playerOnePointer.all.Wins > playerTwoPointer.all.Wins then
						playerOnePointer.all.Wins := playerOnePointer.all.Wins + 1;
						playerTwoPointer.all.Losses := playerTwoPointer.all.Losses + 1;
						enqueue(playerOnePointer.all, playerData.ColiseumOneQueue);
						enqueue(playerTwoPointer.all, playerData.ColiseumTwoQueue);
					elsif playerOnePointer.all.Wins = playerTwoPointer.all.Wins then
						if playerOnePointer.all.Losses < playerTwoPointer.all.Losses then
							playerOnePointer.all.Wins := playerOnePointer.all.Wins + 1;
							playerTwoPointer.all.Losses := playerTwoPointer.all.Losses + 1;
							enqueue(playerOnePointer.all, playerData.ColiseumOneQueue);
							enqueue(playerTwoPointer.all, playerData.ColiseumTwoQueue);
						elsif playerOnePointer.all.Losses = playerTwoPointer.all.Losses then
							if playerOnePointer.all.Arrival < playerTwoPointer.all.Arrival then
								playerOnePointer.all.Wins := playerOnePointer.all.Wins + 1;
								playerTwoPointer.all.Losses := playerTwoPointer.all.Losses + 1;
								enqueue(playerOnePointer.all, playerData.ColiseumOneQueue);
								enqueue(playerTwoPointer.all, playerData.ColiseumTwoQueue);
							else
								playerTwoPointer.all.Wins := playerTwoPointer.all.Wins + 1;
								playerOnePointer.all.Losses := playerOnePointer.all.Losses + 1;
								enqueue(playerTwoPointer.all, playerData.ColiseumOneQueue);
								enqueue(playerOnePointer.all, playerData.ColiseumTwoQueue);
							end if;
						else
							playerTwoPointer.all.Wins := playerTwoPointer.all.Wins + 1;
							playerOnePointer.all.Losses := playerOnePointer.all.Losses + 1;
							enqueue(playerTwoPointer.all, playerData.ColiseumOneQueue);
							enqueue(playerOnePointer.all, playerData.ColiseumTwoQueue);
						end if;
					else
						playerTwoPointer.all.Wins := playerTwoPointer.all.Wins + 1;
						playerOnePointer.all.Losses := playerOnePointer.all.Losses + 1;
						enqueue(playerTwoPointer.all, playerData.ColiseumOneQueue);
						enqueue(playerOnePointer.all, playerData.ColiseumTwoQueue);
					end if;
				else
					playerTwoPointer.all.Wins := playerTwoPointer.all.Wins + 1;
					playerOnePointer.all.Losses := playerOnePointer.all.Losses + 1;
					enqueue(playerTwoPointer.all, playerData.ColiseumOneQueue);
					enqueue(playerOnePointer.all, playerData.ColiseumTwoQueue);
				end if;
			end if;
		end loop;
	end coliseum_One_Matches;

	---------------------------------------------------------------------------
	-- Purpose: This procedure process the second coliseum matches for the
	-- tournament by placing the winners back into the ColiseumTwoQueue and the
	-- losers into the ColiseumOneQueue. If there is one player left in the
	-- ColiseumTwoQueue then that player is moved into the WinnerQueue.
	---------------------------------------------------------------------------
	procedure coliseum_Two_Matches(playerData: in out Data) is
		playerOne, playerTwo: Player;
		playerOnePointer, playerTwoPointer: PlayerPointer;
	begin
		while not is_Empty(playerData.ColiseumTwoQueue) loop
			if size(playerData.ColiseumTwoQueue) = 1 then
				enqueue(front(playerData.ColiseumTwoQueue), playerData.WinnerQueue);
				dequeue(playerData.ColiseumTwoQueue);
			else
				playerOne := front(playerData.ColiseumTwoQueue);
				playerOnePointer := new Player'(playerOne);
				dequeue(playerData.ColiseumTwoQueue);
				playerTwo := front(playerData.ColiseumTwoQueue);
				playerTwoPointer := new Player'(playerTwo);
				dequeue(playerData.ColiseumTwoQueue);
				if playerOnePointer.all.Skill > playerTwoPointer.all.Skill then
					playerOnePointer.all.Wins := playerOnePointer.all.Wins + 1;
					playerTwoPointer.all.Losses := playerTwoPointer.all.Losses + 1;
					enqueue(playerOnePointer.all, playerData.ColiseumTwoQueue);
					enqueue(playerTwoPointer.all, playerData.ColiseumOneQueue);
				elsif playerOnePointer.all.Skill = playerTwoPointer.all.Skill then
					if playerOnePointer.all.Wins > playerTwoPointer.all.Wins then
						playerOnePointer.all.Wins := playerOnePointer.all.Wins + 1;
						playerTwoPointer.all.Losses := playerTwoPointer.all.Losses + 1;
						enqueue(playerOnePointer.all, playerData.ColiseumTwoQueue);
						enqueue(playerTwoPointer.all, playerData.ColiseumOneQueue);
					elsif playerOnePointer.all.Wins = playerTwoPointer.all.Wins then
						if playerOnePointer.all.Losses < playerTwoPointer.all.Losses then
							playerOnePointer.all.Wins := playerOnePointer.all.Wins + 1;
							playerTwoPointer.all.Losses := playerTwoPointer.all.Losses + 1;
							enqueue(playerOnePointer.all, playerData.ColiseumTwoQueue);
							enqueue(playerTwoPointer.all, playerData.ColiseumOneQueue);
						elsif playerOnePointer.all.Losses = playerTwoPointer.all.Losses then
							if playerOnePointer.all.Arrival < playerTwoPointer.all.Arrival then
								playerOnePointer.all.Wins := playerOnePointer.all.Wins + 1;
								playerTwoPointer.all.Losses := playerTwoPointer.all.Losses + 1;
								enqueue(playerOnePointer.all, playerData.ColiseumTwoQueue);
								enqueue(playerTwoPointer.all, playerData.ColiseumOneQueue);
							else
								playerTwoPointer.all.Wins := playerTwoPointer.all.Wins + 1;
								playerOnePointer.all.Losses := playerOnePointer.all.Losses + 1;
								enqueue(playerTwoPointer.all, playerData.ColiseumTwoQueue);
								enqueue(playerOnePointer.all, playerData.ColiseumOneQueue);
							end if;
						else
							playerTwoPointer.all.Wins := playerTwoPointer.all.Wins + 1;
							playerOnePointer.all.Losses := playerOnePointer.all.Losses + 1;
							enqueue(playerTwoPointer.all, playerData.ColiseumTwoQueue);
							enqueue(playerOnePointer.all, playerData.ColiseumOneQueue);
						end if;
					else
						playerTwoPointer.all.Wins := playerTwoPointer.all.Wins + 1;
						playerOnePointer.all.Losses := playerOnePointer.all.Losses + 1;
						enqueue(playerTwoPointer.all, playerData.ColiseumTwoQueue);
						enqueue(playerOnePointer.all, playerData.ColiseumOneQueue);
					end if;
				else
					playerTwoPointer.all.Wins := playerTwoPointer.all.Wins + 1;
					playerOnePointer.all.Losses := playerOnePointer.all.Losses + 1;
					enqueue(playerTwoPointer.all, playerData.ColiseumTwoQueue);
					enqueue(playerOnePointer.all, playerData.ColiseumOneQueue);
				end if;
			end if;
		end loop;
	end coliseum_Two_Matches;

	---------------------------------------------------------------------------
	-- Purpose: This procedure gathers all of the data on players from standard
	-- input and places them into the first coliseum (ColiseumOneQueue).
	---------------------------------------------------------------------------
	procedure input_Data(playerData: in out Data) is
		newPlayer: Player;
		newPlayerPointer: PlayerPointer;
		arrivalTime: Natural := 0;
		skillLevel: Positive;
	begin
		Get(playerData.Sort);
		while not End_of_File loop
			begin
				arrivalTime := arrivalTime + 1;
				newPlayer.Arrival := arrivalTime;
				Get(skillLevel);
				newPlayer.Skill := skillLevel;
				newPlayer.Wins := 0;
				newPlayer.Losses := 0;
				newPlayer.Name := new String'(Trim(Get_Line, Ada.Strings.Both));
				newPlayerPointer := new Player'(newPlayer);
				enqueue(newPlayerPointer.all, playerData.ColiseumOneQueue);
			exception
				when CONSTRAINT_ERROR => raise Invalid_Skill;
				when DATA_ERROR => raise Invalid_Skill;
			end;
		end loop;
		if is_Empty(playerData.ColiseumOneQueue) then
			raise No_Players;
		end if;
	exception
		when DATA_ERROR => raise Invalid_Sort;
		when END_ERROR => raise No_Data;
	end input_Data;

	---------------------------------------------------------------------------
	-- Purpose: This procedure controls the conditions in which a player wins a
	-- jousting match.
	---------------------------------------------------------------------------
	procedure process_Data(playerData: in out Data) is
		done: Boolean := false;
	begin
		while not done loop
			coliseum_One_Matches(playerData);
			coliseum_Two_Matches(playerData);
			if is_Empty(playerData.ColiseumOneQueue) and
				is_Empty(playerData.ColiseumTwoQueue) then
				done := true;
			end if;
		end loop;
	end process_Data;

	---------------------------------------------------------------------------
	-- Purpose: This procedure displays the output of all players who
	-- participated in the jousting tournament by the order in which they won
	-- matches. (Prints in ascending order by printing the ReverserStack or
	-- descending order by printing the WinnerQueue.
	---------------------------------------------------------------------------
	procedure output_Data(playerData: in out Data) is
		newPlayer: Player;
	begin
		Put("Number  ");
		Put("Skill  ");
		Put("Wins  ");
		Put("Losses  ");
		Put("Name  ");
		New_Line;
		if playerData.Sort = Ascending then
			while not is_Empty(playerData.WinnerQueue) loop
				newPlayer := front(playerData.WinnerQueue);
				push(newPlayer, playerData.ReverserStack);
				dequeue(playerData.WinnerQueue);
			end loop;
			print(playerData.ReverserStack);
		else
			print(playerData.WinnerQueue);
		end if;
	end output_Data;

	playerData: Data;

begin

	-- Procedure calls that use the main data record to complete the program.
	input_Data(playerData);
	process_Data(playerData);
	output_Data(playerData);

exception

	-- Program exceptions handled here.
	when No_Data => Put("There is no data to process!");
	when No_Players => Put("There are no players!");
	when Invalid_Sort => Put("Invalid sort type!");
	when Invalid_Skill => Put("Invalid skill level!");
	when Queue_Full => Put("The queue is full!");
	when Queue_Empty => Put("The queue is empty!");
	when Stack_Full => Put("The stack is full!");
	when Stack_Empty => Put("The stack is empty!");

end sorter;
