#!/usr/bin/env bash
docker exec fox /bin/sh \
  -c "echo '{\"service\": {\"name\": \"counting\", \"tags\": [\"go\"], \"port\": 9001}}' >> /consul/config/counting.json"



