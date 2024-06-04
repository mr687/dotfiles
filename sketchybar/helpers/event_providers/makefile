OBIN=./bin
BINARY_NAME=dynamicislandhelper
PROCESS_NAME=git.crissnb.islandhelper

all: run

run: build
	${OBIN}/${BINARY_NAME} ${PROCESS_NAME}

run_background: build
	killall ${BINARY_NAME} || true
	${OBIN}/${BINARY_NAME} ${PROCESS_NAME} &
	sleep 0.5

build: clean dynamicislandhelper.c dynamicisland.h sketchybar.h notificationhelper.h
	mkdir -p ${OBIN}
	clang -std=c99 -O3 dynamicislandhelper.c -o ${OBIN}/${BINARY_NAME} -l sqlite3 -framework CoreFoundation

clean:
	rm -rf ${OBIN}
