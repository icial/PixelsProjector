include("../src/PixelsProjector.jl")

using Colors
using Images
using .PixelsProjector

# zoom on a small image
pixels = rand(values(Colors.JULIA_LOGO_COLORS), 100, 100)
projector = Projector(pixels);
zoom!(10, projector)

# change color of individual pixels and propagate to tiles in the enlarged image
pixels = zeros(RGB{Float64}, 50, 50);
projector = Projector(pixels);
colorpixel!(14, 42, colorant"red", projector)
colorpixel!(37, 21, colorant"green", projector)
colorpixel!(17, 18, colorant"blue", projector)
zoom!(20, projector; display_projection = false)
projector.small_image
projector.large_image

# performance evaluation 
using BenchmarkTools
using Colors.FixedPointNumbers: N0f8

function coloring_speed_test(xs, ys, cs, projector)
    @assert length(xs) == length(ys) == length(cs)
    for i in eachindex(xs)
        colorpixel!(xs[i], ys[i], cs[i], projector; project = false)
    end
    project!(projector)
end

function run_speed_test(smalldims, zoom, ncoloring; T=RGB)
    pixels = zeros(T, smalldims)
    projector = Projector(pixels)
    zoom!(zoom, projector)
    xs = rand(1:size(pixels,1), ncoloring)
    ys = rand(1:size(pixels,2), ncoloring)
    cs = rand(T, ncoloring)
    coloring_speed_test(xs, ys, cs, projector)
    return projector
end

@time projector =  run_speed_test((500, 500), 4, 1_000_000);
projector.large_image

@benchmark project!(5, 5, projector) # project one pixel
@benchmark project!(projector) # project every pixels

# evaluating performance traps
using Traceur
@trace project!(5, 5, projector)
# I do not understand the remaining warnings thrown by @trace : 
# ┌ Warning:  is assigned as Union{Nothing, Tuple{Int64, Int64}}
# └ @ ~/Documents/PixelsProjector/PixelsProjector.jl:55
# ...