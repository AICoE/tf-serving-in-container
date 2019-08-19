# Tensorflow Serving Images

Tensorflow Serving in container  
Kubeflow compatible Images  


Tensorflow Serving rpms are available here below
[tensorflow_model_server 1.14](https://github.com/AICoE/tensorflow-wheels/releases/tag/tensorflow_serving_api-r1.14-cpu-2019-08-14_132212)
[tensorflow_model_server 1.13](https://github.com/AICoE/tensorflow-wheels/releases/tag/tensorflow_serving_api-r1.13-cpu-2019-08-13_184316)
[tensorflow_model_server 1.12](https://github.com/AICoE/tensorflow-wheels/releases/tag/tensorflow_serving_api-r1.12-cpu-2019-08-13_200846)


### Build Tensorflow Serving Images
```
docker build -f Dockerfile.ubi7  -t quay.io/sub_mod/aicoe/tensorflow_serving:1.14 .
docker push quay.io/sub_mod/aicoe/tensorflow_serving:1.14
```


### Use Tensorflow Serving Images
```
---
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  labels:
    app: tf-serving
  name: tf-serving
spec:
  template:
    metadata:
      labels:
        app: tf-serving
        version: v1
    spec:
      containers:
      - image: quay.io/submod/tensorflow_serving:1.14
        imagePullPolicy: IfNotPresent
        name: tf-serving
        args:
        - --port=9000
        - --rest_api_port=8500
        - --model_name=mnist
        - --model_base_path=s3://kubeflow/inception/export
#        - --monitoring_config_file=/var/config/monitoring_config.txt
        command:
        - /usr/local/bin/tensorflow_model_server
        env:
        - name: AWS_ACCESS_KEY_ID
          value: minio
        - name: AWS_SECRET_ACCESS_KEY
          value: minio123
        - name: AWS_REGION
          value: us-west-1
        - name: S3_REGION
          value: us-east-1
        - name: S3_USE_HTTPS
          value: "0"
        - name: S3_VERIFY_SSL
          value: "0"
        - name: S3_ENDPOINT
          value: minio-service.kubeflow.svc:9000
        - name: TF_CPP_MIN_LOG_LEVEL
          value: "1"
        livenessProbe:
          initialDelaySeconds: 30
          periodSeconds: 30
          tcpSocket:
            port: 9000
        ports:
        - containerPort: 9000
        - containerPort: 8500
        resources:
          limits:
            cpu: "4"
            memory: 4Gi

```

### FAQs
Q:I see below error between client and serving endpoint.What is the issue?
``` 
Check whether your GraphDef-interpreting binary is up to date with your GraphDef-generating binary
``` 
A: This is due to difference in the tensorflow binary used in training and the serving binary used for serving.


### Test Tensorflow Serving Images you built.
```
docker run -it -v $PWD:/models/ -e MODEL_NAME=mnist submod/tf_serving_centos7_1.9  
```

```
$ docker run -it -v $PWD:/models/ -e MODEL_NAME=mnist submod/tf_serving_centos7_1.9 
2019-08-19 18:42:18.505085: I tensorflow_serving/model_servers/server.cc:82] Building single TensorFlow model file config:  model_name: mnist model_base_path: /models/mnist
2019-08-19 18:42:18.505564: I tensorflow_serving/model_servers/server_core.cc:462] Adding/updating models.
2019-08-19 18:42:18.505620: I tensorflow_serving/model_servers/server_core.cc:561]  (Re-)adding model: mnist
2019-08-19 18:42:18.620206: I tensorflow_serving/core/basic_manager.cc:739] Successfully reserved resources to load servable {name: mnist version: 1}
2019-08-19 18:42:18.620257: I tensorflow_serving/core/loader_harness.cc:66] Approving load for servable version {name: mnist version: 1}
2019-08-19 18:42:18.620289: I tensorflow_serving/core/loader_harness.cc:74] Loading servable version {name: mnist version: 1}
2019-08-19 18:42:18.620986: I external/org_tensorflow/tensorflow/contrib/session_bundle/bundle_shim.cc:363] Attempting to load native SavedModelBundle in bundle-shim from: /models/mnist/1
2019-08-19 18:42:18.621042: I external/org_tensorflow/tensorflow/cc/saved_model/reader.cc:31] Reading SavedModel from: /models/mnist/1
2019-08-19 18:42:18.625625: I external/org_tensorflow/tensorflow/cc/saved_model/reader.cc:54] Reading meta graph with tags { serve }
2019-08-19 18:42:18.626320: I external/org_tensorflow/tensorflow/core/platform/cpu_feature_guard.cc:142] Your CPU supports instructions that this TensorFlow binary was not compiled to use: SSE4.1 SSE4.2 AVX AVX2 FMA
2019-08-19 18:42:18.644152: I external/org_tensorflow/tensorflow/cc/saved_model/loader.cc:202] Restoring SavedModel bundle.
2019-08-19 18:42:18.663428: I external/org_tensorflow/tensorflow/cc/saved_model/loader.cc:151] Running initialization op on SavedModel bundle at path: /models/mnist/1
2019-08-19 18:42:18.667314: I external/org_tensorflow/tensorflow/cc/saved_model/loader.cc:311] SavedModel load for tags { serve }; Status: success. Took 46282 microseconds.
2019-08-19 18:42:18.668710: I tensorflow_serving/servables/tensorflow/saved_model_warmup.cc:103] No warmup data file found at /models/mnist/1/assets.extra/tf_serving_warmup_requests
2019-08-19 18:42:18.679869: I tensorflow_serving/core/loader_harness.cc:86] Successfully loaded servable version {name: mnist version: 1}
2019-08-19 18:42:18.683342: I tensorflow_serving/model_servers/server.cc:324] Running gRPC ModelServer at 0.0.0.0:8500 ...
[warn] getaddrinfo: address family for nodename not supported
2019-08-19 18:42:18.685615: I tensorflow_serving/model_servers/server.cc:344] Exporting HTTP/REST API at:localhost:8501 ...
[evhttp_server.cc : 239] RAW: Entering the event loop ...
```
