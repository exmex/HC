local edpAdd = function(a, b)
	return {
		a[1] + b[1],
		a[2] + b[2]
	}
end
ed.edpAdd = edpAdd

local edpSub = function(a, b)
	return {
		a[1] - b[1],
		a[2] - b[2]
	}
end
ed.edpSub = edpSub

local edpMult = function(a, s)
	return {
		a[1] * s,
		a[2] * s
	}
end
ed.edpMult = edpMult

local edpLengthSQ = function(a)
	local x = a[1]
	local y = a[2]
	return x * x + y * y
end
ed.edpLengthSQ = edpLengthSQ

local edpDistanceSQ = function(a, b)
	local x = a[1] - b[1]
	local y = a[2] - b[2]
	return x * x + y * y
end
ed.edpDistanceSQ = edpDistanceSQ

local edpNormalize = function(a)
	local x = a[1]
	local y = a[2]
	local u = (x * x + y * y) ^ -0.5
	return {
		x * u,
		y * u
	}
end
ed.edpNormalize = edpNormalize

local edpCompMult = function(a, b)
	return {
		a[1] * b[1],
		a[2] * b[2]
	}
end
ed.edpCompMult = edpCompMult

local edpCross = function(a, b)
	return a[1] * b[2] - a[2] * b[1]
end
ed.edpCross = edpCross

local edpMid = function(a, b)
	return {
		(a[1] + b[1]) * 0.5,
		(a[2] + b[2]) * 0.5
	}
end
ed.edpMid = edpMid

ed.edpZero = {0, 0}
