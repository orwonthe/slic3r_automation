all: factory_all gcodes

clean:
	rm -f -r printables
	rm -f -r factory
	rm -f factory_tree
	rm -f factory_sources
	rm -f printables_tree
	rm -f factory_makefiles
	rm -f factory_printer_configs
	rm -f factory_printing_configs
	rm -f factory_filament_configs
	rm -f factory_all
	rm -f factory_outputs

# Find all the category and filament names and folders.
current_folder = $(shell pwd)

category_folders = $(wildcard categories/*)
category_names = $(notdir $(category_folders))

filament_files = $(wildcard recipes/filaments/*.ini)
filament_names = $(notdir $(basename $(basename $(filament_files))))

printing_files = $(wildcard recipes/printing/*.ini)
printing_names = $(notdir $(basename $(basename $(printing_files))))

printer_files = $(wildcard recipes/printers/*.ini)
printer_names = $(notdir $(basename $(basename $(printer_files))))

factory_printer_folders = $(foreach printer_name,$(printer_names),factory/$(printer_name))
factory_printing_folders = $(foreach printer_folder,$(factory_printer_folders),$(foreach printing_name,$(printing_names),$(printer_folder)/$(printing_name)))
factory_filament_folders = $(foreach printing_folder,$(factory_printing_folders),$(foreach filament_name,$(filament_names),$(printing_folder)/$(filament_name)))
factory_category_folders = $(foreach factory_filament_folder,$(factory_filament_folders),$(foreach category_name,$(category_names),$(factory_filament_folder)/$(category_name)))

.PHONY: all gcodes clean $(factory_category_folders)

factory_all: factory_tree factory_sources factory_printer_configs factory_printing_configs factory_filament_configs factory_outputs factory_makefiles printables_tree

# Create printables output folder tree with leaf folder for every printer, category and filament triple.
printables_tree : $(category_folders) $(filament_files)
	for printer in  $(printer_names) ; do \
	  for filament in  $(filament_names) ; do \
	    for category in $(category_names) ; do \
	      mkdir --parents printables/$$printer/$$filament/$$category ; \
	    done \
	  done \
	done
	touch printables_tree

# Create a factory output folder used to build everything.
factory_tree: $(category_folders) $(filament_files) $(printer_files) $(printing_files)
	for category_folder in $(factory_category_folders) ; do \
	  mkdir --parents $$category_folder ; \
	done
	touch factory_tree

# In the factory add a source links back to the matching category folder.
factory_sources: factory_tree $(filament_files)
	for printer in  $(printer_names) ; do \
	  for printing in  $(printing_names) ; do \
	    for filament in  $(filament_names) ; do \
	      for category in $(category_names) ; do \
	        # Create sources input folder linked to matching category folder. \
	        if [ -d $(current_folder)/categories/$$category/$$printing ]; then ln --force --symbolic -T $(current_folder)/categories/$$category/$$printing factory/$$printer/$$printing/$$filament/$$category/sources ; fi ; \
	      done \
	    done \
	  done \
	done
	touch factory_sources

# In the factory add gcodes links to the matching folder in the printables tree.
factory_outputs: factory_tree printables_tree
	for printer in  $(printer_names) ; do \
	  for printing in  $(printing_names) ; do \
	    for filament in  $(filament_names) ; do \
	      for category in $(category_names) ; do \
	        # Create gcodes output folder linked to matching printables folder. \
	        if [ -d $(current_folder)/categories/$$category/$$printing ]; then ln --force --symbolic -T $(current_folder)/printables/$$printer/$$filament/$$category factory/$$printer/$$printing/$$filament/$$category/gcodes ; fi ; \
	      done \
	    done \
	  done \
	done
	touch factory_outputs


# In the factory add printier configurations back to the matching printer recipe.
factory_printer_configs: factory_tree $(printing_files)
	for printer in  $(printer_names) ; do \
	  # Create a print.ini file that is a Link to the printing ini file. \
	  ln --force --symbolic -T $(current_folder)/recipes/printers/$${printer}.ini factory/$$printer/printer.ini ; \
	done
	touch factory_printer_configs

# In the factory add printing configurations back to the matching printing recipe.
factory_printing_configs: factory_tree $(printing_files)
	for printer in  $(printer_names) ; do \
	  for printing in  $(printing_names) ; do \
	    # Create a print.ini file that is a Link to the printing ini file. \
	    ln --force --symbolic -T $(current_folder)/recipes/printing/$${printing}.ini factory/$$printer/$$printing/print.ini ; \
	  done \
	done
	touch factory_printing_configs


# In the factory add filament configurations back to the matching filament recipe.
factory_filament_configs: factory_tree $(filament_files)
	for printer in  $(printer_names) ; do \
	  for printing in  $(printing_names) ; do \
	    for filament in  $(filament_names) ; do \
	      # Create a filament.ini file that is a Link to the filament ini file. \
	      ln --force --symbolic -T $(current_folder)/recipes/filaments/$${filament}.ini factory/$$printer/$$printing/$$filament/filament.ini ; \
	      done \
	    done \
	  done
	touch factory_filament_configs


# In the factory add makefiles at the filament and category levels.
factory_makefiles: factory_tree printables_tree
	for printer in  $(printer_names) ; do \
	  for printing in  $(printing_names) ; do \
	    for filament in  $(filament_names) ; do \
	      for category in $(category_names) ; do \
	        # Create a makefile that is a Link to the category make file. \
	        ln --force --symbolic -T $(current_folder)/category_level_makefile factory/$$printer/$$printing/$$filament/$$category/Makefile ; \
	      done \
	    done \
	  done \
	done
	touch factory_makefiles

# Force a walk through all the factory folders, doing a make at each level.
gcodes: $(factory_category_folders) factory_all

$(factory_category_folders) : factory_all
	$(MAKE) -C $@
	


