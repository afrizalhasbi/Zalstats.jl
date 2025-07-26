function cohens_d(sample_m::Float64, target_m::Float64, sample_sd::Float64)
    (sample_m - target_m) / sample_sd
end
