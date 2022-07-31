include("../src/PixelsProjector.jl")

using Colors
using Images
using .PixelsProjector

let
pixels = rand(values(Colors.JULIA_LOGO_COLORS), 50, 50)
projector = Projector(pixels);
zoom!(10, projector)

margin = 25

left_img = fill(RGB(colorant"grey15"), size(projector.large_image) .+ 2*margin)
xstart, ystart = Int.(size(left_img)./2 .+ 1 .- size(pixels)./2)
xend, yend = Int.(size(left_img)./2 .+ size(pixels)./2)
left_img[xstart:xend, ystart:yend] = pixels 

right_img = fill(RGB(colorant"grey15"), size(projector.large_image) .+ 2*margin)
right_img[margin+1:end-margin, margin+1:end-margin] = projector.large_image

logo = hcat(left_img, right_img)

save("logo/projection.png", logo)
end 