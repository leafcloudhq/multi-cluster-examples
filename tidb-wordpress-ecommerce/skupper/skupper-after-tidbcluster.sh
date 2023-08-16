#!/bin/sh

skupper expose statefulset leaf-tikv --headless  --port 20160
skupper expose statefulset cluster1-pd --headless --port 2379 --port 2380

