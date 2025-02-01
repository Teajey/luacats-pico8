---@meta

--- ----------------------------------------------------------------------------------------------------
---     Math
--- ----------------------------------------------------------------------------------------------------
---
---

--- MAX(X, Y)
---
--- [View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#MAX)
---
---@param x unknown
---@param y unknown
---@return unknown
function max(x, y) end

--- MIN(X, Y)
---
--- [View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#MIN)
---
---@param x unknown
---@param y unknown
---@return unknown
function min(x, y) end

--- MID(X, Y, Z)
---
---         Returns the maximum, minimum, or middle value of parameters
---
---         > ?MID(7,5,10) -- 7
---
---
--- [View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#MID)
---
---@param x unknown
---@param y unknown
---@param z unknown
---@return unknown
function mid(x, y, z) end

--- FLR(X)
---
---         > ?FLR ( 4.1) -->  4
---         > ?FLR (-2.3) --> -3
---
---
--- [View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#FLR)
---
---@param x unknown
---@return unknown
function flr(x) end

--- CEIL(X)
---
---         Returns the closest integer that is equal to or below x
---
---         > ?CEIL( 4.1) -->  5
---         > ?CEIL(-2.3) --> -2
---
---
--- [View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#CEIL)
---
---@param x unknown
---@return unknown
function ceil(x) end

--- COS(X)
---
--- [View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#COS)
---
---@param x unknown
---@return unknown
function cos(x) end

--- SIN(X)
---
---         Returns the cosine or sine of x, where 1.0 means a full turn. For example, to animate a
---         dial that turns once every second:
---
---         FUNCTION _DRAW()
---             CLS()
---             CIRC(64, 64, 20, 7)
---             X = 64 + COS(T()) * 20
---             Y = 64 + SIN(T()) * 20
---             LINE(64, 64, X, Y)
---         END
---
---         PICO-8's SIN() returns an inverted result to suit screenspace (where Y means "DOWN", as
---         opposed  to mathematical diagrams where Y typically means "UP").
---
---         > SIN(0.25) -- RETURNS -1
---
---         To get conventional radian-based trig functions without the y inversion,  paste the
---         following snippet near the start of your program:
---
---         P8COS = COS FUNCTION COS(ANGLE) RETURN P8COS(ANGLE/(3.1415*2)) END
---         P8SIN = SIN FUNCTION SIN(ANGLE) RETURN -P8SIN(ANGLE/(3.1415*2)) END
---
---
--- [View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#SIN)
---
---@param x unknown
---@return unknown
function sin(x) end

--- ATAN2(DX, DY)
---
---         Converts DX, DY into an angle from 0..1
---
---         As with cos/sin, angle is taken to run anticlockwise in screenspace. For example:
---
---             > ?ATAN(0, -1) -- RETURNS 0.25
---
---         ATAN2 can be used to find the direction between two points:
---
---             X=20 Y=30
---             FUNCTION _UPDATE()
---                 IF (BTN(0)) X-=2
---                 IF (BTN(1)) X+=2
---                 IF (BTN(2)) Y-=2
---                 IF (BTN(3)) Y+=2
---             END
---
---             FUNCTION _DRAW()
---                 CLS()
---                 CIRCFILL(X,Y,2,14)
---                 CIRCFILL(64,64,2,7)
---
---                 A=ATAN2(X-64, Y-64)
---                 PRINT("ANGLE: "..A)
---                 LINE(64,64,
---                     64+COS(A)*10,
---                     64+SIN(A)*10,7)
---             END
---
---
--- [View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#ATAN2)
---
---@param dx unknown
---@param dy unknown
---@return unknown
function atan2(dx, dy) end

--- SQRT(X)
---
---         Return the square root of x
---
---
--- [View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#SQRT)
---
---@param x unknown
---@return unknown
function sqrt(x) end

--- ABS(X)
---
---         Returns the absolute (positive) value of x
---
---
--- [View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#ABS)
---
---@param x unknown
---@return unknown
function abs(x) end

--- RND(X)
---
---         Returns a random number n, where 0 <= n < x
---
---         If you want an integer, use flr(rnd(x)). If x is an array-style table, return a random
---         element between table[1] and table[#table].
---
---
--- [View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#RND)
---
---@param x unknown
---@return unknown
function rnd(x) end

--- SRAND(X)
---
---         Sets the random number seed. The seed is automatically randomized on cart startup.
---
---         FUNCTION _DRAW()
---             CLS()
---             SRAND(33)
---             FOR I=1,100 DO
---                 PSET(RND(128),RND(128),7)
---             END
---         END
---
---     :: Bitwise Operations
---
---         Bitwise operations are similar to logical expressions, except that they work at the bit
---         level.
---
---         Say you have two numbers (written here in binary using the "0b" prefix):
---
---             X = 0b1010
---             Y = 0b0110
---
---         A bitwise AND will give you bits set when the corresponding bits in X /and/ Y are both set
---
---         > PRINT(BAND(X,Y)) -- RESULT:0B0010 (2 IN DECIMAL)
---
---         There are 9 bitwise functions available in PICO-8:
---
---             BAND(X, Y) -- BOTH BITS ARE SET
---             BOR(X, Y)  -- EITHER BIT IS SET
---             BXOR(X, Y) -- EITHER BIT IS SET, BUT NOT BOTH OF THEM
---             BNOT(X)    -- EACH BIT IS NOT SET
---             SHL(X, N)  -- SHIFT LEFT N BITS (ZEROS COME IN FROM THE RIGHT)
---             SHR(X, N)  -- ARITHMETIC RIGHT SHIFT (THE LEFT-MOST BIT STATE IS DUPLICATED)
---             LSHR(X, N) -- LOGICAL RIGHT SHIFT (ZEROS COMES IN FROM THE LEFT)
---             ROTL(X, N) -- ROTATE ALL BITS IN X LEFT BY N PLACES
---             ROTR(X, N) -- ROTATE ALL BITS IN X RIGHT BY N PLACES
---
---         Operator versions are also available: & | ^^ ~ << >> >>> <<> >><
---
---         For example: PRINT(67 & 63) -- result:3  equivalent to BAND(67,63)
---
---         Operators are slightly faster than their corresponding functions. They behave exactly the
---         same, except that if any operands are not numbers the result is a runtime error (the
---         function versions instead default to a value of 0).
---
---     :: Integer Division
---
---         Integer division can be performed with a \
---
---         > PRINT(9\2) -- RESULT:4  EQUIVALENT TO FLR(9/2)
---
--- [View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#SRAND)
---
---@param x unknown
---@return unknown
function srand(x) end
