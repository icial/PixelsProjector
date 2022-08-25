# PixelsProjector
zoom on a small grid of pixels while keeping HQ rendering

![PixelsProjector.jl](https://github.com/icial/PixelsProjector/blob/main/logo/projection.png?raw=true)

```julia
using PixelsProjector
pixels = rand(RGB, 50, 50)
projector = Projector(pixels)
zoom!(10, projector)

using Images
display(projector.large_image)
```

## Motivations
- cellular automata & agent based modelling
- put in practice what I learned from the [GoodScientificCodeWorkShop](https://github.com/JuliaDynamics/GoodScientificCodeWorkshop)

> My bad ! This functionality is integrated and works very well in Makie, simply passing the pixels to the `heatmap` function !
