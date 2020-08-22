@info "Testing CustomDataset..."
@testset "CustomDataset" begin
    x = rand(100, 8)
    getdata(idx) = x[idx, :]
    dset = CustomDataset(size(x, 1), getdata)

    @test size(dset) == (size(x, 1),)
    @test length(dset) == size(x, 1)
    @test firstindex(dset) == 1
    @test lastindex(dset) == size(x, 1)
    @test lastindex(dset) == size(x, 1)
    @test dset[1] == x[1, :]
    @test dset[3:8] == [x[i, :] for i = 3:8]
    @test dset[:] == [x[i, :] for i = 1:size(x, 1)]
end

@info "Testing ModelNet..."
@testset "ModelNet10" begin
    _categories = ["sofa","table"]
    _root = joinpath(@__DIR__,"./assets")
    for (split, train) in [("train", true), ("test", false)]
        dset = ModelNet10(root=_root, train=train, categories=_categories)
        @test dset isa Flux3D.Dataset.AbstractDataset
        @test dset.root == normpath(_root)
        @test dset.path ==
              normpath(_root, "ModelNet10")
        @test dset.train == train
        @test dset.transform isa Nothing

        @test dset.length == 2
        @test size(dset) == (2,)
        @test length(dset) == 2

        dpoint = dset[1]
        @test dpoint isa Flux3D.Dataset.DataPoint
        @test dpoint.data isa TriMesh{Float32,UInt32}
        @test dpoint.category_name in _categories

        points = 32
        t = Chain(TriMeshToPointCloud(points))
        dset = ModelNet10(
            root=_root,
            train = train,
            categories=_categories,
            transform = t,
        )
        @test dset.transform isa Chain
        dpoint2 = dset[2]
        @test dpoint2 isa Flux3D.Dataset.DataPoint
        @test dpoint2.data isa PointCloud{Float32}
        @test dpoint2.category_name in _categories
    end
end

@info "Testing ModelNet..."
@testset "ModelNet40" begin
    _categories = ["desk","monitor"]
    _root = joinpath(@__DIR__,"./assets")
    for (split, train) in [("train", true), ("test", false)]
        dset = ModelNet40(root=_root, train=train, categories=_categories)
        @test dset isa Flux3D.Dataset.AbstractDataset
        @test dset.root == normpath(_root)
        @test dset.path ==
              normpath(_root, "ModelNet40")
        @test dset.train == train
        @test dset.transform isa Nothing

        @test dset.length == 2
        @test size(dset) == (2,)
        @test length(dset) == 2

        dpoint = dset[1]
        @test dpoint isa Flux3D.Dataset.DataPoint
        @test dpoint.data isa TriMesh{Float32,UInt32}
        @test dpoint.category_name in _categories

        points = 32
        t = Chain(TriMeshToPointCloud(points))
        dset = ModelNet40(
            root=_root,
            train = train,
            categories=_categories,
            transform = t,
        )
        @test dset.transform isa Chain
        dpoint2 = dset[2]
        @test dpoint2 isa Flux3D.Dataset.DataPoint
        @test dpoint2.data isa PointCloud{Float32}
        @test dpoint2.category_name in _categories
    end
end
