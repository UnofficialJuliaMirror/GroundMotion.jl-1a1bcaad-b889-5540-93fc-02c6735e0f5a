## LICENSE
##   Copyright 2018 GEOPHYSTECH LLC
##
##   Licensed under the Apache License, Version 2.0 (the "License");
##   you may not use this file except in compliance with the License.
##   You may obtain a copy of the License at
##
##       http://www.apache.org/licenses/LICENSE-2.0
##
##   Unless required by applicable law or agreed to in writing, software
##   distributed under the License is distributed on an "AS IS" BASIS,
##   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
##   See the License for the specific language governing permissions and
##   limitations under the License.

## initial release by Andrey Stepnov a.stepnov@geophsytech.ru

## Si-Midorikawa (1999) PGA modeling
function pga_simidorikawa1999(eq::Earthquake,grid::Array{Point_vs30},config::Params_simidorikawa1999,min_pga::Number=0)
  vs30_row_num = length(grid[:,1])
  eq.moment_mag == 0 ? magnitude = eq.local_mag : magnitude = eq.moment_mag
  epicenter = LatLon(eq.lat, eq.lon)
  
  # define g_global
  g_global = 9.81
  # define \sum{d_i S_i}
  sum_di_si = config.d1*config.S1 + config.d2*config.S2 + config.d3*config.S3
  # define b = aMw + hD + \sum{d_i S_i} +e
  b = config.a*magnitude + config.h + sum_di_si + config.e_
  # define c
  c = 0.006*10^(0.5*magnitude)
  # init output_data
  output_data = Array{Point_pga_out}(0)
  
  # main cycle by grid points
  for i=1:vs30_row_num
    # rrup the same as X in Si-Midorikawa (1999) formulae
    # eq.depth the same as D in in Si-Midorikawa (1999) formulae
    current_point = LatLon(grid[i].lat,grid[i].lon)
    r_rup = sqrt((distance(current_point,epicenter)/1000)^2 + eq.depth^2)
    
    # \logARA for VS30
    log_ARA = 1.35 - 0.47*log10(grid[i].vs30)

    # A in cm/s^2
    if eq.depth <= 30
      A = 10^(b - log10(r_rup + c) - config.k*r_rup + log_ARA)
    else
      A = 10^(b + 0.6*log10(1.7*eq.depth + c) - 
              1.6*log10(r_rup + c) - config.k*r_rup + log_ARA)
    end

    g = round(((A/100)/g_global * 100),2)
    if g >= min_pga
      output_data = push!(output_data, Point_pga_out(grid[i].lon,grid[i].lat,g))
    end
    # debug
    println(hcat(grid[i].vs30,r_rup,log_ARA,A,g))
  end
  
  return output_data
end

