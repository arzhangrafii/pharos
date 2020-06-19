all: monitorizer

monitorizer: scripts/monitorizer.tcl
	rm -rf monitorizer
	vivado -mode tcl -source  scripts/monitorizer.tcl -nolog -nojournal

clean:
	rm -rf monitorizer
