# include("linreg.jl")
# include("../common/common.jl")

# """
#     linreg_kfold(vars::regvars; CI::Number=0.99, method::String="OLS", loss::String="RMSE", K::Int=4, runs::Int=10)

# Implementation of a K-fold linear regression based on  de Rooij and Weeda (2020) https://doi.org/10.1177/2515245919898466.

# It goes like this:
#   - Randomize our dataset
#   - We divide our dataset into K folds
#   - For each fold, we compute a linear regression model
#   - We use the model from each chunk to predict the y values of each of the other folds (for each folds, we make K-1 predictions)
#   - We compute the mean loss of each folds (in this case, RMSE) and retain the model with the lowest loss value
#   - We repeat this process `runs` times.
#   - Return the output of the best model from all repetitions

# Function args (1-3 are passed to `linreg`)
#   1. vars::regvars   ==> A regression variable struct. Instantiate with regvars(y,hcat(x1, x2, ..xn)).
#   2. CI::Number      ==> Confidence interval percentages, select between 0 and 1. Mandatory variable for best practices!
#   3. method::String  ==> Coefficient estimation method. Currently only supports OLS
#   4. test::          ==> Test set
#   5. loss::String    ==> loss function to use to compared folds
#   6. K::Int          ==> The number of folds (splits) in the dataset
#   7. runs::Int       ==> How many times to randomize the dataset. Set to 0 for no repetitions.
# """
# function linreg_kfold(vars::regvars; CI::Number=0.99, method::String="OLS",
#     test::Union{regvars,Nothing}=nothing, loss::String="RMSE", K::Int=4, runs::Int=10)
#     @assert K > 1 && runs >= 1 && loss in ["MSE", "RMSE", "MAE",]

#     all_output = []
#     N = length(vars.Y)

#     @inbounds for i in ProgressBar(1:runs)
#         try
#             seed = i * 111
#             fold_output = []
#             _Y, _X = randvars(hcat(vars.Y, vars.X), seed=seed, pop_first=true)
#             _Y, _X = chunkvect(_Y, K), chunkmatrix(_X, K)
#             losses = []
#             """
#             _Y and _X are now an array of vectors, and we index them in the for-loop with `k`
#             """
#             @inbounds for k in 1:K
#                 fvars = regvars(_Y[k], hcat(_X[k]))
#                 fold_coeff = _compute_coeff_rg(fvars, method)
#                 X_targ = vcat([x for x in _X if x != _X[k]]...)
#                 Y_targ = vcat([y for y in _Y if y != _Y[k]]...)

#                 fvars = regvars(Y_targ, X_targ)
#                 l = _regfn(fvars, fold_coeff.B, CI, false)
#                 push!(all_output, (l, fold_coeff))
#             end
#             """
#             We push the following variables as a tuple to all_output:
#                 [1] loss function
#                 [2] the model weights
#             Then, we use the weights of the best model to compute the metrics and
#             hypothesis test of the undivided dataset
#             """
#         catch e
#             run(`clear`)
#             println("Error detected while computing one of the runs, most likely related to linear algebra operations.\nPrematurely ending the process at run $(i)")
#             break
#         end
#     end
#     n, p = size(vars.X)
#     sort!(all_output, by=x -> getproperty(x[1], Symbol(loss)), rev=false)
#     bmetrics, bweights = first(all_output)
#     o = [m[1].(Symbol(loss)) for m in all_output]

#     if test !== nothing
#         tmetrics = _regfn(test, bweights.B, CI, true)
#         hypout = _hypothesis_rg(bweights, tmetrics, CI, n, p)
#         gui(plot(o; legend=nothing, plot_title="$(loss) of $(K)*$(runs) folds", plot_titlesize=16))
#         println("EVALUATING MODEL FIT ON A SEPARATE TEST SET")
#         _table_rg(bweights, tmetrics, hypout, CI, p)
#         return tmetrics, hypout
#     else
#         hypout = _hypothesis_rg(bweights, bmetrics, CI, n, p)
#         gui(plot(o; legend=nothing, plot_title="$(loss) of $(K)*$(runs) folds", plot_titlefont="Cantarell, Thin", plot_titlesize=16))
#         _table_rg(bweights, bmetrics, hypout, CI, p)
#         return bmetrics, hypout
#     end
# end
