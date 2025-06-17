module Zalstats

function include_dir(dir::AbstractString)
    jl_files = filter(p -> isfile(p) && endswith(p, ".jl"),
        readdir(dir; join=true))
    for f in jl_files
        include(f)
    end
end

function include_submodules(root::AbstractString=pwd())
    subdirs = filter(p -> isdir(p),
        readdir(root; join=true))

    for d in subdirs
        @info "Including from directory: $d"
        include_dir(d)
    end
end

include_submodules()

end
