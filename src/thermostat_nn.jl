using Flux
using Statistics
using DifferentialEquations
using Plots

# defining the heat transfer in a room
u0 = 0
Tmax = 30
Tmin = 18
α = -1.65
state = Int[]
thermostat(u,p,t) = p[1]*u+p[2]

tspan = (0.0,10)
p = [α, 50, 2, 1]
prob = ODEProblem(thermostat,u0,tspan, p)
sol = solve(prob)
plot(sol,label="Temperature")

t = 0:1:10
plot_t = 0:0.01:10
data_plot = sol(plot_t)
temperature_plot = [thermostat(state,p,t) for state in data_plot]

# Generate the dataset
dataset = sol(t)
temperature = [state[1] for state in sol(t)]
temperature_data = [thermostat(state,p,t) for state in sol(t)]

plot(plot_t,temperature_plot,xlabel="t",label="True Temperature")
scatter!(t,temperature_data,label="Temperature Measurements")

# neural network of pinn
NNTemp = Chain(Dense( 1 => 32,tanh),
               Dense(32 => 32,tanh),
               Dense(32 => 1))

# defining the pinn loss function
loss() = sum(abs2(NNTemp([temperature[i]])[1] - temperature_data[i]) for i in 1:length(temperature))

# defining the optmizer
opt = Flux.Descent(0.01)

# generating the "empty dataset" to run the trainer
data = Iterators.repeated((), 10000)
iter = 0

# defining the callback function to observe training
cb = function () #callback function to observe training
  global iter += 1
  if iter % 500 == 0
    display(loss())
  end
end
display(loss())
Flux.train!(loss, Flux.params(NNTemp), data, opt; cb=cb)
