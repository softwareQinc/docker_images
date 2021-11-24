{
 "cells": [
  {
   "cell_type": "markdown",
   "id": "088a7960",
   "metadata": {},
   "source": [
    "### Import softwareQ packages"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 1,
   "id": "f8d02286",
   "metadata": {},
   "outputs": [],
   "source": [
    "import pystaq # staq quantum compiler\n",
    "import pyqpp  # Quantum++ simulation engine"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "c8c66f11",
   "metadata": {},
   "source": [
    "### Parse some QASM code and expand broadcasted operations"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 2,
   "id": "aa3a16b7",
   "metadata": {},
   "outputs": [
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "OPENQASM 2.0;\n",
      "include \"qelib1.inc\";\n",
      "\n",
      "qreg q[3];\n",
      "creg c[3];\n",
      "h q[0];\n",
      "cx q[0],q[1];\n",
      "cx q[0],q[2];\n",
      "measure q -> c;\n",
      "\n"
     ]
    }
   ],
   "source": [
    "circuit = pystaq.parse_file(\"GHZ.qasm\")\n",
    "print(circuit)"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "05c38d13",
   "metadata": {},
   "source": [
    "### Expand broadcasted operations"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 3,
   "id": "9038b1e2",
   "metadata": {},
   "outputs": [
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "OPENQASM 2.0;\n",
      "include \"qelib1.inc\";\n",
      "\n",
      "qreg q[3];\n",
      "creg c[3];\n",
      "h q[0];\n",
      "cx q[0],q[1];\n",
      "cx q[0],q[2];\n",
      "measure q[0] -> c[0];\n",
      "measure q[1] -> c[1];\n",
      "measure q[2] -> c[2];\n",
      "\n"
     ]
    }
   ],
   "source": [
    "pystaq.desugar(circuit)\n",
    "print(circuit)"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "72e4e61b",
   "metadata": {},
   "source": [
    "### Create a test linear QPU with 3 qubits and write it to a json file"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 4,
   "id": "ab30b988",
   "metadata": {},
   "outputs": [
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "{\n",
      "  \"couplings\": [\n",
      "    {\n",
      "      \"control\": 0,\n",
      "      \"target\": 1\n",
      "    },\n",
      "    {\n",
      "      \"control\": 1,\n",
      "      \"target\": 0\n",
      "    },\n",
      "    {\n",
      "      \"control\": 1,\n",
      "      \"target\": 2\n",
      "    },\n",
      "    {\n",
      "      \"control\": 2,\n",
      "      \"target\": 1\n",
      "    }\n",
      "  ],\n",
      "  \"name\": \"Custom Device\",\n",
      "  \"qubits\": [\n",
      "    {\n",
      "      \"id\": 0\n",
      "    },\n",
      "    {\n",
      "      \"id\": 1\n",
      "    },\n",
      "    {\n",
      "      \"id\": 2\n",
      "    }\n",
      "  ]\n",
      "}\n"
     ]
    }
   ],
   "source": [
    "device = pystaq.Device(3)\n",
    "device.add_edge(0, 1)\n",
    "device.add_edge(1, 2)\n",
    "\n",
    "\n",
    "with open(\"device.json\", \"w\") as file:\n",
    "    file.write(str(device))\n",
    "    \n",
    "print(device)"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "e5f4588e",
   "metadata": {},
   "source": [
    "### Map the circuit onto the QPU"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 5,
   "id": "da3afbba",
   "metadata": {},
   "outputs": [
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "OPENQASM 2.0;\n",
      "include \"qelib1.inc\";\n",
      "\n",
      "qreg q[3];\n",
      "creg c[3];\n",
      "U(pi/2,0,pi) q[0];\n",
      "CX q[0],q[1];\n",
      "CX q[0],q[1];\n",
      "CX q[1],q[0];\n",
      "CX q[0],q[1];\n",
      "CX q[1],q[2];\n",
      "measure q[1] -> c[0];\n",
      "measure q[0] -> c[1];\n",
      "measure q[2] -> c[2];\n",
      "\n"
     ]
    }
   ],
   "source": [
    "pystaq.map(circuit, \"linear\", \"swap\", device_json=\"device.json\")\n",
    "print(circuit)"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "35d73984",
   "metadata": {},
   "source": [
    "### Try again, with a better mapping algorithm"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 6,
   "id": "1f9466dd",
   "metadata": {},
   "outputs": [
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "OPENQASM 2.0;\n",
      "include \"qelib1.inc\";\n",
      "\n",
      "qreg q[3];\n",
      "creg c[3];\n",
      "U(pi/2,0,pi) q[0];\n",
      "CX q[1],q[0];\n",
      "CX q[0],q[1];\n",
      "CX q[1],q[2];\n",
      "measure q[1] -> c[0];\n",
      "measure q[0] -> c[1];\n",
      "measure q[2] -> c[2];\n",
      "\n"
     ]
    }
   ],
   "source": [
    "pystaq.map(circuit, \"linear\", \"steiner\", device_json=\"device.json\")\n",
    "print(circuit)"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "d270d990",
   "metadata": {},
   "source": [
    "### Write the circuit to file and run 100 simulations"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 7,
   "id": "cc3b96f4",
   "metadata": {},
   "outputs": [
    {
     "data": {
      "text/plain": [
       "[QNoisyEngine]\n",
       "<QCircuit nq: 3, nc: 3, d: 2>\n",
       "last probs: [0.5, 1, 1]\n",
       "last dits: [0, 1, 0]\n",
       "stats:\n",
       "\treps: 100\n",
       "\toutcomes: 6\n",
       "\t[0 0 0]: 55\n",
       "\t[0 0 1]: 1\n",
       "\t[0 1 0]: 2\n",
       "\t[1 0 1]: 1\n",
       "\t[1 1 0]: 1\n",
       "\t[1 1 1]: 40"
      ]
     },
     "execution_count": 7,
     "metadata": {},
     "output_type": "execute_result"
    }
   ],
   "source": [
    "with open(\"circuit.qasm\", \"w\") as file:\n",
    "    file.write(str(circuit))\n",
    "    \n",
    "qcircuit = pyqpp.qasm.read_from_file(\"circuit.qasm\")\n",
    "pyqpp.QNoisyEngine(qcircuit, pyqpp.QubitBitFlipNoise(0.01)).execute(100)"
   ]
  }
 ],
 "metadata": {
  "kernelspec": {
   "display_name": "Python 3 (ipykernel)",
   "language": "python",
   "name": "python3"
  },
  "language_info": {
   "codemirror_mode": {
    "name": "ipython",
    "version": 3
   },
   "file_extension": ".py",
   "mimetype": "text/x-python",
   "name": "python",
   "nbconvert_exporter": "python",
   "pygments_lexer": "ipython3",
   "version": "3.8.10"
  }
 },
 "nbformat": 4,
 "nbformat_minor": 5
}
