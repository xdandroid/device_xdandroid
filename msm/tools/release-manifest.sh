#!/bin/bash

OLDIFS=${IFS}
IFS=$'\n'
for CIDLINE in `repo forall -c "echo -n \"\\$REPO_PROJECT \" ; git rev-parse --verify HEAD"`
do
	PROJECT=${CIDLINE%% *}
	COMMIT=${CIDLINE##* }
	SED="${SED} -e \"s:name=\\\"${PROJECT}\\\":name=\\\"${PROJECT}\\\" revision=\\\"${COMMIT}\\\":\""
done

eval sed -e "s:revision=\\\"[^[:space:]]*\\\"::" ${SED} .repo/manifest.xml

IFS=${OLDIFS}
