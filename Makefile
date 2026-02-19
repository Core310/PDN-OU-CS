# Root Makefile for Project 3

SUBDIRS = Project_3_Problems/Khor_Arika_Project_3/Problem_2 \
          Project_3_Problems/Khor_Arika_Project_3/Problem_3 \
          Project_3_Problems/Khor_Arika_Project_3/Problem_4

.PHONY: all clean $(SUBDIRS)

all: $(SUBDIRS)

$(SUBDIRS):
	$(MAKE) -C $@ all

clean:
	for dir in $(SUBDIRS); do \
		$(MAKE) -C $$dir clean; \
	done
