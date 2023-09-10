# GMCS

The Geomaterial Morphological Characterization Software (GMCS) was adopted in the paper "[Evaluation of rock muck using image analysis and its application in the TBM tunneling](https://doi.org/10.1016/j.tust.2021.103974)"

![Main GUI of GMCS](./ui%20screenshot/ui%20-%20main%20-%201.png)

The morphological characteristics of rock muck produced in tunneling are closely related to the operation configurations of tunnel boring machine (TBM), on account of which adjusting TBM controlling parameters is practical in engineering projects. __GMCS__ was developed based on the Matlab software package, to process the point cloud data of collected rock blocks obtained from laser scanning and further analyze the generated alpha shape using bound box and spatial projection methods. Detailed information was presented in the related paper.

Kangyi Cai 2023 @ Missouri S&T

![min bound box](./example/example%20-%20min%20bound%20box.png)

![spatial projection](./example/example%20-%20spatial%20projection.png)

## Citing

If you use this software in your study, please cite the related paper:

```
Zhang, Xiao-Ping, Wei-Qiang Xie, Kang-Yi Cai, Quan-Sheng Liu, Jian Wu, and Wei-Wei Li. "Evaluation of rock muck using image analysis and its application in the TBM tunneling." Tunnelling and Underground Space Technology 113 (2021): 103974.
```

Or in the format of BibTex:

```
@article{zhang2021evaluation,
title={Evaluation of rock muck using image analysis and its application in the TBM tunneling},
author={Zhang, Xiao-Ping and Xie, Wei-Qiang and Cai, Kang-Yi and Liu, Quan-Sheng and Wu, Jian and Li, Wei-Wei},
journal={Tunnelling and Underground Space Technology},
volume={113},
pages={103974},
year={2021},
publisher={Elsevier}
issn = {0886-7798},
doi = {https://doi.org/10.1016/j.tust.2021.103974}
}
```

## Logs

Ver 0.9, 11/19/2020, source code

Ver 1.0, 09/09/2023, GUI

## Features

1. Shape point cloud into polyhedron and calculate its volume and surface area;
2. Search minimal and maximal bound boxes of the polyhedron, and output the length, width and height of the boxes, refer to minboundbox developed by Johannes Korsawe;
3. Project the polyhedron along evenly-distributed spatial directions (including x, y, and z axis), compute the area and perimeter of the projected shapes, as well as, the length and width of the corresponding bound rectangles.

## Usages

1. The point cloud data has to be pre-precessed by cleaning noise points;
2. Adjust the projection directions/vectors through the parameter intervals_of_theta and intervals_of_phi (spheric coordinate system);
3. output files includes:

- Projection vectors (text): spatial projection direction/vector coordinates;
- Min/Max bound box (image): minimal and maximal bound boxes with corresponding alpha shapes;
- Spatial projections (image): spatial projection directions with corresponding alpha shapes, as well as the projected shapes on projection planes;
- Results (text): summarize the name of point clouds, the volume and surface area of alpha shapes, the length, width and thickness of minimal and maximal bound boxes, the area and perimeter of all the projected shapes, as well as, the length and width of their bound rectangles.

## License

MIT
