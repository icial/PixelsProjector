module PixelsProjector

using Colors

export Projector, zoom!, project!, colorpixel!

mutable struct Projector{C}
    zoom::Int
    small_image::Matrix{C}
    large_image::Matrix{C}
    function Projector(small_image::Matrix{C}; zoom = 1) where {C<:Colorant}
        large_image = zeros(C, size(small_image) .* zoom)
        new{C}(zoom, small_image, large_image)
    end
end

"""
    zoom!(zoom::Int, projector::Projector; display_projection = true)
The original grid of pixels (`projector.small_image`) is magnified by `zoom`. The previous
`projector.large_image` is replaced by this new one.
"""
function zoom!(zoom::Int, projector::Projector; display_projection = true)
    @assert zoom > 0
    T = eltype(projector.small_image)
    projector.zoom = zoom
    projector.large_image = zeros(T, size(projector.small_image) .* zoom)
    project!(projector; display_projection)
end

"""
    project!(projector::Projector; display_projection = false)
Project every pixels of `projector.small_image` onto the tiles of `projector.large_image`.
"""
function project!(projector::Projector; display_projection = false)
    xmax, ymax = size(projector.small_image)
    for x = 1:xmax, y = 1:ymax
        project!(x, y, projector)
    end
    if display_projection
        return projector.large_image
    end
    return
end

"""
    project!(x, y, projector::Projector; display_projection = false)
Project pixel `(x, y)` from  `projector.small_image` onto the the corresponding tile of 
`projector.large_image`.
"""
function project!(x::Int, y::Int, projector::Projector; display_projection = false)
    # tile indexing
    xs = (1 + (x - 1)*projector.zoom:x*projector.zoom)
    ys = (1 + (y - 1)*projector.zoom:y*projector.zoom)
    for xx in xs, yy in ys
        projector.large_image[xx, yy] = projector.small_image[x, y]
    end
    if display_projection
        return projector.large_image
    end
    return
end

"""
    colorpixel!(x, y, color::C, projector::Projector{C} where {C<:Colorant}
Color pixel `(x, y)` of `projector.small_image` with `color` and propagate the change to
`projector.large_image` if `project = true`.
"""
function colorpixel!(x, y, color::Colorant, projector::Projector{C}
        ; project = true, display_projection = false) where {C<:Colorant}
    color::C = color
    projector.small_image[x, y] = color
    project && project!(x, y, projector; display_projection)
    return
end

end