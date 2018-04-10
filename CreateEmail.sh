#!/bin/bash
# Collects data from differents sources, and creates an email from a template to
# send a useful status message.

OUTPUT=$1
DATE=$(date)

envsubst < email_template.txt > $OUTPUT
