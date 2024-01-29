# Style Guide
## Naming
- Use `PascalCase` for any defined variables, functions, and modules, etc.
- Use `UPPER_SNAKE_CASE` for any constants.
- For files that are not within the source folder, use `kebab-case` for the file name.

## Typing
- When using types, you must consider whether it is actually necessary to have. Something like:
```lua
type MyType = string
```
is not necessary and should not be used. However, something like:
```lua
type MyType = "Foo" | "Bar"
```
is acceptable. This is because the latter is a type that defines explicit values that can be used in place of the type. The former is just a type alias and does not provide any additional value.

## Formatting
If you are using vscode, you can use the [Stylua](https://marketplace.visualstudio.com/items?itemName=JohnnyMorganz.stylua) extension by JohnnyMorganz. Alternatively, you can use the [stylua](https://github.com/JohnnyMorganz/StyLua) cli tool.

## General
- There should never be any global variables or functions. This is not referencing `_G` but that should be avoided as well.
- When creating a service that has fields there needs to be separation between those fields and the methods. This is to make it easier for the reader to understand what is what. For example:
```lua
local MyService = {}
MyService.__index = MyService

function MyService:Foo()
	print(self.Message)
end

local Fields = {
	Message = "Hello World!"
}

return setmetatable(Fields, MyService)
```
- When creating a member function that does not require `self` to be used, instead of having a `:` use a `.`. This is for a couple of reasons but the main one is that it help the reader understand the arguments that are required to call a function
- When creating a member function that does require `self` then use a `:`.

## Functions
Function parameters need to have associated types. This is not to just satisfy the linter but to also reduce confusion in the future. For example:
```lua
local function Add(A: number, A: number)
	return A + B
end
```
In the case that a function returns `any` and that is not the intended return type then you need to specify the return type.

## Nesting
Nesting is a VERY common thing to do when creating any sort of project. However, nesting can be a huge problem for any who wants to read your code in any capacity. For example:
```lua
local a = true
local b = false
local message = "Hello World!"

if a then
	if message:sub(1, 5) == "Hello" then
		if message == "Hello World!" then
			if b then
				print(message)
			elseif not b then
				print("Goodbye World!")
			end
		end
	end
end
```

This code is very hard to read and understand (hurts my eyes physically). This is partially due to the abbreviated variables but can also be attributed to the nesting and the quality of said nesting. I'm not saying never nest but you should try to avoid it as much as possible. For example:
```lua
local a = true
local b = false
local message = "Hello World!"

if a then
	if message ~= "Hello World!" then
		return
	end

	if b then
		print(message)
	else
		print("Goodbye World!")
	end
end
```

This code while being longer vertically is a fair bit easier to comprehend. This is because most of the time when nesting takes place there is usually failure to acknowledge that certain checks like:
```lua
if message:sub(1, 5) == "Hello" then
	if message == "Hello World!" then
		-- ...
	end
end
```
They either don't need to be nested or don't need to exist at all. In this case, the first check doesn't matter because the second check takes the first into account already by checking for the exact message we're looking for.