
function loop1(max)
vals=Int64[];
for i2 in 1:1:log(2,max )
  for i3 in 0:1:log(3,max)
    for i5 in 0:1:log(5,max)
      val =  2^i2*3^i3*5^i5
      if val <= max
        push!(vals, val)
      end
    end
    end 
  end
  sort!(vals)
end