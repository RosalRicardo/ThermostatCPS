using DifferentialEquations, Plots

u0 = 0
Tmax = 30
Tmin = 18
α = -1.65
state = []

thermostat(u,p,t) = p[1]*u+p[2]

function guard(u,t,integrator)
    ((integrator.p[4] == 0 && u[1] >= Tmax) || (integrator.p[4] == 1 && u[1] <= Tmin)) ? 0 : 1
end

function output!(integrator)
    if integrator.p[4] == 0
        integrator.p[4] = 1
        integrator.p[1] = α-2
    else
        integrator.p[1] = α
        integrator.p[4] = 0
    end
    push!(state,integrator.p[4])
end

cp_cb = ContinuousCallback(guard,output!)

# parameters vector (α, Tr, δ e c)
p = [α, 50, 2, 0]

tspan = (0.0,10)
prob = ODEProblem(f,u0,tspan, p, callback=cp_cb)
sol = solve(prob, Tsit5(), reltol=1e-8, abstol=1e-8)


plot(sol,linewidth=3,title="Room Temperatura Control",
     xaxis="Time (t)",yaxis="Zone Temperature (T)",label="ZN-T") # legend=false
scatter!(twinx(),[state],markershape=:cross,markercolor="red",labels="state")
    