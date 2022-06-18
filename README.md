# CPS Model Thermostat

### Physical Component

Given a room that has a temperature whose dynamics are defined by the function $$T \in \mathbb{R}$$ and a device that can control this temperature, such as an HVAC System. We can model the physical component of this system by the following differential equation.

$$\dot{T} = (\alpha - \delta S) T + T_R$$

Where the parameter $$\alpha$$ is the rate of heat exchange given the thermal load in that specific space, the parameter $T_R$ is the rate of influence of the temperature outside that room and the $$\delta$$ is the capacity of heat exchange of the equipment in question, times the state of the equipment itself, where we are assuming two states, on $$(1)$$ and off $$(0)$$.

### Cyber Component

Now let's define the finite state machine model for a thermostat, where the set of state $$Q$$, is defined by the thermostat operating mode defined by: $$q \in Q = \{ On, Off\}$$, set from which the values of output $$\zeta$$ are also defined.
The input is defined by the continuous temperature variable, discretized by the analog-to-digital converter, and limited by the maximum and minimum temperature restrictions: $$v \in \Sigma = T \in [ T_{min},T_{ max}]$$.
Is a transition function $$\delta$$ that defines the rule for state transition for a specified combination of state and input.

$$\delta(v,q) =
\begin{cases}
ON & \text{$v \ge T^{max}$ and q=OFF}\\
OFF & \text{$v \le T^{Min}$ and q=ON}
\end{cases}$$