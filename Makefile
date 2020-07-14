PROG := count_timer
SRCS := main
EXTENTION := .obj

ENV_PATH := /mnt/d/make_data/Programming/aviutl/AviUtl/

# 実行環境
AVIUTL := $(ENV_PATH)/aviutl.exe

# distpath
OUTDIR := $(ENV_PATH)/plugins/script/minfia

.PHONY: all run debug clean

all : $(PROG)

$(PROG) : 
	@cp ./$(SRCS).lua $(OUTDIR)/$(PROG)$(EXTENTION)

run :
	@cp ./$(SRCS).lua $(OUTDIR)/$(PROG)$(EXTENTION)
	@$(AVIUTL)

clean:
	@rm $(OUTDIR)/$(PROG)$(EXTENTION)

