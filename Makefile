INKSCAPEDIR = /usr/share/inkscape/extensions/
DXF_OUTLINES = $(INKSCAPEDIR)/dxf_outlines.py
OPENSCAD = openscad

SCADFILES = hsgkeyfob.scad
STLFILES = $(SCADFILES:.scad=.stl)
DEPFILES = $(addsuffix deps,$(SCADFILES))

all: $(STLFILES)

hsgkeyfob.stl: hsgkeyfob.scad hsg.dxf

%.dxf: %.svg
	$(DXF_OUTLINES) --units='25.4/90' --encoding=latin1 $< > $@

%.stl: %.scad
	$(OPENSCAD) -d $<deps -m $(MAKE) -o $@ $<

clean:
	rm $(STLFILES) $(DEPFILES)

-include $(DEPFILES)
