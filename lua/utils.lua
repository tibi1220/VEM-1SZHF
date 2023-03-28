local M = {}
local V = require 'lua.variables'

M.round = function(num, numDecimalPlaces)
  return tonumber(string.format('%.' .. (numDecimalPlaces or 0) .. 'f', num))
end

M.prinTeX = function(num, unit, dec)
  if (dec or dec == 0) and dec ~= '' then num = M.round(num, dec) end
  tex.sprint([[\SI{]] .. num .. [[}{]] .. unit .. [[}]])
end

M.silv = function(name, unit, dec) M.prinTeX(V[name], unit, dec) end
M.silv1D = function(name, unit, i, dec)
  M.prinTeX(V[name][tonumber(i)], unit, dec)
end
M.silv2D = function(name, unit, i, j, dec)
  M.prinTeX(V[name][tonumber(i)][tonumber(j)], unit, dec)
end
M.silv3D = function(name, unit, i, j, k, dec)
  M.prinTeX(V[name][tonumber(i)][tonumber(j)][tonumber(k)], unit, dec)
end

M.lv = function(name) tex.sprint(V[name]) end
M.lv2D = function(name, i, j) tex.sprint(V[name][tonumber(i)][tonumber(j)]) end
M.lv2DTD = function(name, i, j, dec, mult, th)
  th = tonumber(th) or 1e-10
  mult = tonumber(mult) or 1

  local var = V[name][tonumber(i)][tonumber(j)] * mult

  if math.abs(var) < th then
    tex.sprint(0)
  else
    M.prinTeX(var, '', dec)
  end
end

M.printMatrix = function(matrix, th, mult)
  local cols = #matrix
  local rows = #matrix[1]
  th = th or 1e-16
  mult = mult or 1

  for i = 1, cols do
    for j = 1, rows do
      local num = matrix[i][j] * mult

      if math.abs(num) < th then
        tex.sprint(0)
      else
        M.prinTeX(num, '', '')
      end

      if j == rows then
        tex.sprint '\\\\'
      else
        tex.sprint '&'
      end
    end
  end
end

M.fullKei = function()
  for i = 1, 7 do
    tex.sprint([[\rmat{K}_]] .. i .. [[&=\begin{bmatrix}]])
    M.printMatrix(V.Ke[i], 1e-16)
    tex.sprint [[\end{bmatrix}\mathrm{\dfrac{N}{m}}]]
    if i == 7 then
      tex.sprint [[\text{.}]]
    else
      tex.sprint [[\text{,}\\]]
    end
  end
end

M.fullUei = function()
  for i = 1, 7 do
    tex.sprint([[\rvec{U}_]] .. i .. [[&=&\begin{bmatrix}]])
    tex.sprint(
      'U_'
        .. V.eDOF[i][1]
        .. '\\\\V_'
        .. V.eDOF[i][2]
        .. '\\\\U_'
        .. V.eDOF[i][3]
        .. '\\\\V_{'
        .. V.eDOF[i][4]
        .. '}\\\\'
    )
    tex.sprint [[\end{bmatrix} &=& \begin{bmatrix}]]
    M.printMatrix(V.Ue[i], 1e-16)
    tex.sprint [[\end{bmatrix}\mathrm{m} &=& 
      \sisetup{exponent-mode = fixed, round-precision = 3} 
      \begin{bmatrix}]]
    M.printMatrix(V.Ue[i], 1e-16, 1000)
    tex.sprint [[\end{bmatrix}\mathrm{mm}]]
    if i == 7 then
      tex.sprint [[\text{.}]]
    else
      tex.sprint [[\text{,}\\]]
    end
  end
end

M.printDOFMatrix = function()
  tex.sprint(
    [[ \begin{array}{r c c} ]]
      .. [[ & \textcolor{gray}{\left(\begin{array}{*{4}{x{5mm}}} $u_1$ & $v_1$ & $u_2$ & $v_2$ \end{array}\right)} \\[2mm] ]]
      .. [[ \rmat{DOF} \; =  & \left[\begin{array}{*{4}{x{5mm}}} ]]
  )
  for i = 1, 7 do
    for j = 1, 4 do
      tex.sprint(V.eDOF[i][j])

      if j == 4 then
        tex.sprint '\\\\'
      else
        tex.sprint '&'
      end
    end
  end
  tex.sprint [[ \end{array}\right] & \textcolor{gray}{
    \begin{pmatrix}
      1 \\ 2 \\ 3 \\ 4 \\ 5 \\ 6 \\ 7
    \end{pmatrix}
  } \end{array} ]]
end

M.printK = function() M.printMatrix(V.K) end

M.printKkond = function() M.printMatrix(V.Kkond) end
M.printInverted = function() M.printMatrix(V.inverted) end
M.printFkond = function() M.printMatrix(V.Fkond) end
M.printF = function(mult) M.printMatrix(V.F, 1e-3, mult) end
M.printFcalc = function(mult) M.printMatrix(V.Fcalc, 1e-3, mult) end
M.printFreacc = function(mult) M.printMatrix(V.Freacc, 1e-3, mult) end
M.printUkond = function(mult) M.printMatrix(V.Ukond, 1e-16, mult) end
M.printUcalc = function(mult) M.printMatrix(V.Ucalc, 1e-16, mult) end

return M
