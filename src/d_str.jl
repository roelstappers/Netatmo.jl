"""
    @d_str
String macro used to parse a string to a DateTime
    
# Examples
```jldoctest
julia> d"2018010100"
2018-01-01T00:00:00
```

"""
macro d_str(v) 
    Dates.DateTime(v,"yyyymmddHH")
end