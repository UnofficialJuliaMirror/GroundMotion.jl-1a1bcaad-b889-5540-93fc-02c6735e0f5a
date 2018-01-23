## VS30 data point
"""
Mutable type for fill vs30 grid (Array).

  Point_vs30(lon,lat,vs30).

Latitude and longitude assumes degrees for WGS84 ellipsoid. vs30 in meters per second. All fields are ::Float64.
"""
mutable struct Point_vs30
  lon::Float64
  lat::Float64
  vs30::Float64
end
## Output PGA data point after GMPE calculations
"""
Mutable type for output PGA data from GMPE modeling funtions

  Fields:

  lon   :: Float64 
  lat   :: Float64 
  g     :: Float64 

Latitude and longitude assumes degrees for WGS84 ellipsoid. r_rup in km.
g is Acceleration of gravity in percent rounded to ggg.gg.
"""
mutable struct Point_pga_out
  lon::Float64
  lat::Float64
  g::Float64 #Acceleration of gravity in percent rounded to ggg.gg
end
## earthquake location data
"""
Mutable type for earthquake location data.

  Earthquake(lat,lon,depth,local_mag,moment_mag)

Latitude and longitude assumes degrees for WGS84 ellipsoid. Depth in km.
Mw=0 in case of moment magnitude is not specified. 
All fields are ::Float64.
"""
mutable struct Earthquake
  lon::Float64 
  lat::Float64
  depth::Float64
  local_mag::Float64
  moment_mag::Float64
end
Earthquake(x,y,z,k) = Earthquake(x,y,z,k,0) # Mw usually not ready right after earthquake 
## AS2008 GMPE parameters
mutable struct Params_as2008
  a1::Float64
  a2::Float64
  a3::Float64
  a4::Float64
  a5::Float64
  a8::Float64
  a10::Float64
  a18::Float64
  b::Float64
  c::Float64
  c1::Float64
  c4::Float64
  n::Float64
  vlin::Float64
  v1::Float64
  vs30_1100::Float64
end
## Si-Midorikawa 1999 GMPE parameters
mutable struct Params_simidorikawa1999
  a::Float64
  h::Float64
  d1::Float64
  d2::Float64
  d3::Float64
  e_::Float64
  k::Float64
  S1::Float64
  S2::Float64
  S3::Float64
end

