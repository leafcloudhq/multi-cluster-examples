skupper init --enable-console --enable-flow-collector --console-user admin --console-password my-password-123  --timeout 600s

##cluster 1
skupper token create token1.yaml

##cluster 2
skupper link create token2.yaml --name cluster1
