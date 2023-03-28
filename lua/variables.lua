-- Local variables from packages
local PI = math.pi
local sqrt = math.sqrt
local sin = math.sin
local cos = math.cos
local atan2 = math.atan

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
  if n == 1 then return m[1][1] end

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
  if det == 0 then error 'Matrix is singular and cannot be inverted' end

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
  if #m1[1] ~= n2 then error 'Cannot multiply matrices of different sizes' end

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
      io.write(m[i][j] .. '\t')
    end
    io.write '\n'
  end
end

-- Codes
local code_1 = 1
local code_2 = 1
local code_3 = 1
local code_4 = 2

-- Base params
local E = 150000 -- MPa
local a = 3 -- mm
local d = 50 -- mm
local b = 1.3 -- m

local F_1 = 130000 -- N
local c = 6 -- m

-- local F_1 = 210000 -- N
-- local c = 4 -- m

function Kef(Ai, Ei, Li, ai)
  local C = math.cos
  local S = math.sin

  local M = {
    { C(ai) ^ 2, C(ai) * S(ai), -C(ai) ^ 2, -C(ai) * S(ai) },
    { C(ai) * S(ai), S(ai) ^ 2, -C(ai) * S(ai), -S(ai) ^ 2 },
    { -C(ai) ^ 2, -C(ai) * S(ai), C(ai) ^ 2, C(ai) * S(ai) },
    { -C(ai) * S(ai), -S(ai) ^ 2, C(ai) * S(ai), S(ai) ^ 2 },
  }

  for i = 1, 4 do
    for j = 1, 4 do
      M[i][j] = M[i][j] * Ai * Ei / Li
    end
  end

  return M
end

-- Area
local A = ((1.3 * d) ^ 2 - d ^ 2) * PI / 4

-- Length
local L = {
  { a },
  { b },
  { c },
  { sqrt(a ^ 2 + b ^ 2) },
  { sqrt((c - a) ^ 2 + b ^ 2) },
  { sqrt(a ^ 2 + b ^ 2) },
  { c },
}

-- Elem - Csomopont
local ecs = {
  { 1, 2 },
  { 1, 4 },
  { 2, 3 },
  { 2, 4 },
  { 2, 5 },
  { 3, 5 },
  { 4, 5 },
}

-- Elem DOF
local eDOF = {
  { 1, 2, 3, 4 },
  { 1, 2, 7, 8 },
  { 3, 4, 5, 6 },
  { 3, 4, 7, 8 },
  { 3, 4, 9, 10 },
  { 5, 6, 9, 10 },
  { 7, 8, 9, 10 },
}

-- Angle
local alpha = {
  { atan2(0, a) },
  { atan2(-b, 0) },
  { atan2(0, c) },
  { atan2(-b, -a) },
  { atan2(-b, c - a) },
  { atan2(-b, -a) },
  { atan2(0, c) },
}

local beta = zeros(7, 1)
for i = 1, 7 do
  beta[i][1] = alpha[i][1] / PI * 180
end

-- Elem merevsegi
local Ke = {}
for i = 1, 7 do
  Ke[i] = Kef(A, E, L[i][1], alpha[i][1])
end

-- Globalis merevsegi
local K = zeros(10, 10)
for i = 1, 7 do
  K = MatrixAddition(K, ExtMatrix(Ke[i], eDOF[i], 10))
end

-- Globalis erok
local F = {
  { 0 },
  { 0 },
  { 0 },
  { -3 * F_1 },
  { 0 },
  { F_1 },
  { 0 },
  { 0 },
  { 0 },
  { F_1 },
}

-- Globalis elmozdulas
local U = zeros(10, 1)

-- Szabad szabadsagi fokok
local szabadDOF = { 1, 3, 4, 6, 9, 10 }

-- Kondenzalt merevsegi
local Kkond = SubMatrix(K, szabadDOF)

-- Kondenzalt ero
local Fkond = SubVector(F, szabadDOF)

local inverted = MatrixInversion(Kkond)

-- Kondenzalt elmozdulas
Ukond = zeros(6, 1)

for i = 1, 6 do
  for j = 1, 6 do
    Ukond[i][1] = Ukond[i][1] + inverted[j][i] * Fkond[j][1]
  end
end

-- Szamitott elmozdulas
local Ucalc = ExtVector(Ukond, szabadDOF, 10)

-- Szamitott ero
local Fcalc = zeros(10, 1)
local Freacc = zeros(10, 1)

for i = 1, 10 do
  for j = 1, 10 do
    Fcalc[i][1] = Fcalc[i][1] + K[j][i] * Ucalc[j][1]
  end

  Freacc[i][1] = F[i][1] - Fcalc[i][1]
end

-- Elem elmozdulas
local Ue = {}

for i = 1, 7 do
  Ue[i] = SubVector(Ucalc, eDOF[i])
end

local function Be(Li, ai)
  return {
    { -cos(ai) / Li },
    { -sin(ai) / Li },
    { cos(ai) / Li },
    { sin(ai) / Li },
  }
end

-- Alakvaltozas es feszultseg
local epsilon = {}
local sigma = {}

for i = 1, 7 do
  epsilon[i] = 0
  local Bei = Be(L[i][1], alpha[i][1])

  for j = 1, 4 do
    epsilon[i] = epsilon[i] + Bei[j][1] * Ue[i][j][1]
  end

  sigma[i] = E * epsilon[i]
end

-- Elem erok, normalfeszultseg
local Fe = {}
local Ne = {}

for i = 1, 7 do
  Fe[i] = zeros(4, 1)

  for j = 1, 4 do
    for k = 1, 4 do
      Fe[i][j][1] = Fe[i][j][1] + Ke[i][j][k] * Ue[i][k][1]
    end
  end

  Ne[i] = Fe[i][3][1] * cos(alpha[i][1]) + Fe[i][4][1] * sin(alpha[i][1])
end

-- Return variables
return {
  -- Codes
  code_1 = code_1,
  code_2 = code_2,
  code_3 = code_3,
  code_4 = code_4,

  -- Base params
  E = E,
  F_1 = F_1,
  a = a,
  b = b,
  c = c,
  d = d,

  -- Matrices
  A = A,
  L = L,
  ecs = ecs,
  eDOF = eDOF,
  alpha = alpha,
  beta = beta,
  Ke = Ke,

  K = K,
  F = F,
  U = U,

  Kkond = Kkond,
  Fkond = Fkond,
  Ukond = Ukond,

  inverted = inverted,

  Fcalc = Fcalc,
  Freacc = Freacc,
  Ucalc = Ucalc,

  Ue = Ue,
  Fe = Fe,
  Ne = Ne,

  epsilon = epsilon,
  sigma = sigma,
}
