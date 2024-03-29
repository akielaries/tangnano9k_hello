synthesize:
	yosys -D LEDS_NR=6 -p "read_verilog blinky2.v; synth_gowin -json blinky.json"
	nextpnr-gowin --json blinky.json --write pnrblinky.json --device GW1NR-LV9QN88PC6/I5 --family GW1N-9C --cst tangnano9k.cst
	gowin_pack -d GW1N-9C -o pack.fs pnrblinky.json
flash:
	openFPGALoader -v -b tangnano9k pack.fs

clean:
	rm -f *.fs *.json
