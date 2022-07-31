# PixelsProjector
zoom on a small grid of pixels while keeping HQ rendering

![PixelsProjector.jl](https://github.com/icial/PixelsProjector/blob/main/logo/projection.png?raw=true)

```julia
pixels = rand(RGB, 50, 50)
projector = Projector(pixels)
zoom!(10, projector)

using GLMakie
image!(projector.large_image)
```

## Motivations
- cellular automata & agent based modelling
- put in practice what I learned from the [GoodScientificCodeWorkShop](https://github.com/JuliaDynamics/GoodScientificCodeWorkshop) 