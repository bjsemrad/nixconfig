#!/bin/sh

if pgrep -x wf-recorder >/dev/null; then
	printf '{"text":" ","class":"enabled"}';
else
	printf '{"text":" "}';
fi
