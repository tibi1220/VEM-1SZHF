-- User defined functions
local function zeros(rows, cols)
	local matrix = {}
	for i = 1, rows do
		matrix[i] = {}
		for j = 1, cols do
			matrix[i][j] = 0
		end
	end
	return matrix
end

function SubMatrix(Mx, rows)
	local n = #rows
	local mx = zeros(n, n)

	for i = 1, n do
		for j = 1, n do
			mx[i][j] = Mx[rows[i]][rows[j]]
		end
	end

	return mx
end

function ExtMatrix(mx, rows, size)
	local n = #rows
	local Mx = zeros(size, size)

	for i = 1, n do
		for j = 1, n do
			Mx[rows[i]][rows[j]] = mx[i][j]
		end
	end

	return Mx
end

function SubVector(Mx, rows)
	local n = #rows
	local mx = zeros(n, 1)

	for i = 1, n do
		mx[i][1] = Mx[rows[i]][1]
	end

	return mx
end

function ExtVector(mx, rows, size)
	local n = #rows
	local Mx = zeros(size, 1)

	for i = 1, n do
		Mx[rows[i]][1] = mx[i][1]
	end

	return Mx
end

function MatrixAddition(m1, m2)
	local rows = #m1
	local cols = #m1[1]

	local result = {}
	for i = 1, rows do
		result[i] = {}
		for j = 1, cols do
			result[i][j] = m1[i][j] + m2[i][j]
		end
	end

	return result
end

function MatrixTranspose(m)
	local n, mT = #m, {}
	for i = 1, #m[1] do
		mT[i] = {}
		for j = 1, n do
			mT[i][j] = m[j][i]
		end
	end
	return mT
end

local function matrixMinor(m, i, j)
	local minor = {}
	local n = #m
	local row, col = 1, 1

	for k = 1, n do
		if k ~= i then
			col = 1
			minor[row] = {}
			for l = 1, n do
				if l ~= j then
					minor[row][col] = m[k][l]
					col = col + 1
				end
			end
			row = row + 1
		end
	end

	return minor
end

local function matrixDeterminant(m)
	local n = #m
	if n == 1 then
		return m[1][1]
	end

	local det = 0
	for j = 1, n do
		local sign = ((1 + j) % 2 == 0) and 1 or -1
		local minor = matrixMinor(m, 1, j)
		det = det + sign * m[1][j] * matrixDeterminant(minor)
	end

	return det
end

function MatrixInversion(m)
	-- Calculate the determinant of the matrix
	local det = matrixDeterminant(m)
	if det == 0 then
		error("Matrix is singular and cannot be inverted")
	end

	local n = #m
	local adj = {}

	-- Calculate the adjugate matrix
	for i = 1, n do
		adj[i] = {}
		for j = 1, n do
			local sign = ((i + j) % 2 == 0) and 1 or -1
			adj[i][j] = sign * matrixDeterminant(matrixMinor(m, i, j))
		end
	end

	-- Calculate the inverse of the matrix
	local inv = {}
	for i = 1, n do
		inv[i] = {}
		for j = 1, n do
			inv[i][j] = adj[j][i] / det
		end
	end

	return inv
end

function MatrixMultiplication(m1, m2)
	local n1, n2, n3 = #m1, #m2[1], #m2
	if #m1[1] ~= n2 then
		error("Cannot multiply matrices of different sizes")
	end

	local prod = {}
	for i = 1, n1 do
		prod[i] = {}
		for j = 1, n3 do
			prod[i][j] = 0
			for k = 1, n2 do
				prod[i][j] = prod[i][j] + m1[i][k] * m2[k][j]
			end
		end
	end

	return prod
end

function PrintMatrix(m)
	for i = 1, #m do
		for j = 1, #m[1] do
			io.write(m[i][j] .. "\t")
		end
		io.write("\n")
	end
end
