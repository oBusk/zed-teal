#!/usr/bin/env tl run
-- Sample Teal file for eyeballing syntax highlighting.

local MAX_ITEMS <const> = 10

local enum Color
   "red"
   "green"
   "blue"
end

local interface Shape
   area: function(self): number
end

local record Point is Shape
   x: number
   y: number
   label: string | nil
   metamethod __add: function(Point, Point): Point
end

function Point.new(x: number, y: number): Point
   return setmetatable({ x = x, y = y }, { __index = Point }) as Point
end

function Point:area(): number
   return 0
end

local function sum<T>(items: {T}, f: function(T): number): number
   local total: number = 0
   for _, item in ipairs(items) do
      total = total + f(item)
   end
   return total
end

global type Callback = function(string): boolean

local p = Point.new(1, 2)
if p.x > 0 and not (p.y == 0) then
   print(string.format("point: %d, %d\n", p.x, p.y))
elseif p.x < 0 then
   print([[negative]])
else
   repeat
      p.x = p.x + 1
   until p.x >= MAX_ITEMS
end
