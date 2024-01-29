# Documentation
Comment docs are a great way to document your code, but they serve as a double edged sword. They become a problem when you are documenting like this:
```lua
--[=[
	@function Add
	Adds two numbers together

	@param a The first number
	@param b The second number
	@return number
]=]
local function Add(A: number, B: number)
	return A + B
end
```

There is legitimately no reason to document this, because what the function does is implied by the name and parameters. You're better off not documenting this function at all.

## Block Comments
Block comments are used to document code blocks that are not immediately obvious or to tell a reader about a potential internal problem / structural choice. For example:
```lua
local function Foo(IsCondition: boolean)
	-- We need to check for this specific condition
	-- due to an issue with the way this function is called
	if IsCondition then
		-- ...
	end
end
```

## Line Comments
The most simple of the comments to understand. If something doesn't make sense or there is a weird / hacky solution to a problem that occurs on a single line then you should use a line comment. For example:
```lua
local function IsValid(TableToCheck: Dictionary<string>): boolean
	for _, Value in SomeModulesTable do
		if not table.find(TableToCheck, Value) then --> Check if the 'Value' is not going to be in this list of set values "Joe", "Bob", "Steve", "John"
			continue
		end

		return true
	end

	return false
end
```

## Comment Tags
The following tags should be used when certain situations arise:
1. 'TODO:' is used when something needs to be done but you don't have the time to do it immediately.
2. 'FIX:' is used when something is completely broken and needs to be fixed.
3. 'BUG:' is used when a behavior is not intended and needs to be fixed.
4. 'NOTE:' Useful information for maintainers that might be needed at a later date.