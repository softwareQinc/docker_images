# docker_images

Docker images for our tools

# Installation

```bash
git clone https://github.com/softwareqinc/docker_images
cd docker_images
docker build -t softwareq .
docker run -p8888:8888 softwareq
```

Launch a browser at http://localhost:8888

and use the token provided by the `docker run` command above, i.e., the one in the hyperlink that looks like the **bolded** one below

> To access the notebook, open this file in a browser:
> 
> file:///root/.local/share/jupyter/runtime/nbserver-1-open.html
> 
> Or copy and paste one of these URLs:
> 
> http://a16168cc7fdd:8888/?token=d9651cb8726cdc87b6093e43d7411d9a234cd43377a93019
> 
> or 
> 
> **http://127.0.0.1:8888/?token=d9651cb8726cdc87b6093e43d7411d9a234cd43377a93019**

## Example

### Import pyqpp, pystaq and numpy into the scope


```python
from pystaq import *
from pyqpp import *
import numpy as np
```

### Build a quantum circuit and apply gates


```python
circuit = QCircuit(1, 1)  # qubit quantum circuit with one qubit, one classical bit
circuit.gate(gates.H, 0); # Hadamard gate on the first qubit
```

### Measure the qubit and store the result in the first classical bit


```python
circuit.measureZ(0, 0);
```

### Construct an engine


```python
engine = QEngine(circuit)
```

### Execute the circuit repeatedly and display the statistics


```python
engine.execute(100)
```




    [QEngine]
    <QCircuit nq: 1, nc: 1, d: 2>
    last probs: [0.5]
    last dits: [0]
    stats:
    	reps: 100
    	outcomes: 2
    	[0]: 54
    	[1]: 46



How cool is this! 😊
