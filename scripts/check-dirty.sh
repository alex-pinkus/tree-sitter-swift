#!/bin/bash

set -e

git diff-index --quiet HEAD -- || echo 'The local index is dirty after build. Did you forget to commit `src/`?'
