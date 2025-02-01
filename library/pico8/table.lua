---@meta

--- ----------------------------------------------------------------------------------------------------
---     Table Functions
--- ----------------------------------------------------------------------------------------------------
---
---     With the exception of PAIRS(), the following functions and the # operator apply only to tables
---     that are indexed starting from 1 and do not have NIL entries. All other forms of tables can  be
---     considered as hash maps or sets, rather than arrays that have a length.
---
---

--- ADD(TBL, VAL, [INDEX])
---
---         Add value VAL to the end of table TBL. Equivalent to:
---
---         TBL[#TBL + 1] = VAL
---
---         If index is given then the element is inserted at that position:
---
---             FOO={}        -- CREATE EMPTY TABLE
---             ADD(FOO, 11)
---             ADD(FOO, 22)
---             PRINT(FOO[2]) -- 22
---
---
--- [View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#ADD)
---
---@overload fun(tbl: unknown, val: unknown, index: unknown): unknown
---@param tbl unknown
---@param val unknown
---@return unknown
function add(tbl, val) end

--- DEL(TBL, VAL)
---
---         Delete the first instance of value VAL in table TBL. The remaining entries are shifted left
---         one index to avoid holes.
---
---         Note that VAL is the value of the item to be deleted, not the index into the table. (To
---         remove an item at a particular index, use DELI instead). DEL returns the deleted item, or
---         returns no value when nothing was deleted.
---
---             A={1,10,2,11,3,12}
---             FOR ITEM IN ALL(A) DO
---                 IF (ITEM < 10) THEN DEL(A, ITEM) END
---             END
---             FOREACH(A, PRINT) -- 10,11,12
---             PRINT(A[3])       -- 12
---
---
--- [View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#DEL)
---
---@param tbl unknown
---@param val unknown
---@return unknown
function del(tbl, val) end

--- DELI(TBL, [I])
---
---         Like @DEL(), but remove the item from table TBL at index I When I is not given, the last
---         element of the table is removed and returned.
---
---
--- [View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#DELI)
---
---@overload fun(tbl: unknown, i: unknown): unknown
---@param tbl unknown
---@return unknown
function deli(tbl) end

--- COUNT(TBL, [VAL])
---
---         Returns the length of table t (same as #TBL) When VAL is given, returns the number of
---         instances of VAL in that table.
---
---
--- [View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#COUNT)
---
---@overload fun(tbl: unknown, val: unknown): unknown
---@param tbl unknown
---@return unknown
function count(tbl) end

--- ALL(TBL)
---
---         Used in FOR loops to iterate over all items in a table (that have a 1-based integer index),
---         in the order they were added.
---
---             T = {11,12,13}
---             ADD(T,14)
---             ADD(T,"HI")
---             FOR V IN ALL(T) DO PRINT(V) END -- 11 12 13 14 HI
---             PRINT(#T) -- 5
---
---
--- [View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#ALL)
---
---@param tbl unknown
---@return unknown
function all(tbl) end

--- FOREACH(TBL, FUNC)
---
---         For each item in table TBL, call function FUNC with the item as a single parameter.
---
---             > FOREACH({1,2,3}, PRINT)
---
---
--- [View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#FOREACH)
---
---@param tbl unknown
---@param func unknown
---@return unknown
function foreach(tbl, func) end

--- PAIRS(TBL)
---
---         Used in FOR loops to iterate over table TBL, providing both the key and value for each
---         item. Unlike @ALL(), PAIRS() iterates over every item regardless of indexing scheme. Order
---         is not guaranteed.
---
---             T = {["HELLO"]=3, [10]="BLAH"}
---             T.BLUE = 5;
---             FOR K,V IN PAIRS(T) DO
---                 PRINT("K: "..K.."  V:"..V)
---             END
---
---         Output:
---
---             K: 10  v:BLAH
---             K: HELLO  v:3
---             K: BLUE  v:5
---
--- [View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#PAIRS)
---
---@param tbl unknown
---@return unknown
function pairs(tbl) end
