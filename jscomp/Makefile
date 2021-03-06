ifdef WIN32
	EXE := .exe
endif
ifndef EXE
	EXE := # empty
endif
.SECONDARY:
NATIVE=ocamlopt.opt$(EXE)
BYTE=ocamlc.opt$(EXE)
OCAMLLEX=ocamllex.opt$(EXE)
CAMLP4OF=camlp4of
CAMLDEP=ocamldep.opt$(EXE)
COMPFLAGS=-g -w +6-40-30-23 -warn-error +a-40-30-23
# COMPFLAGS+= -S


.SUFFIXES: .mli .ml .cmi .cmx .mll .c .o .cmo

print-%  : ; @echo $* = $($*)

INCLUDES= -I +compiler-libs -I stubs -I ext -I common -I syntax -I depends -I core -I bsb -I ounit -I ounit_tests

.mli.cmi:
	$(NATIVE) $(INCLUDES) $(COMPFLAGS) -c $<
.ml.cmo:
	ocamlc.opt $(INCLUDES) $(COMPFLAGS) -c $<

.ml.cmx:
	$(NATIVE) $(INCLUDES) $(COMPFLAGS) -c $<

.mll.ml:
	$(OCAMLLEX) $< -o $@ || (rm $@ && exit 2)

ext/string_hash_set.ml: ext/hash_set.cppo.ml
	cppo -D TYPE_STRING $< -o $@
ext/int_hash_set.ml: ext/hash_set.cppo.ml
	cppo -D TYPE_INT $< -o $@
ext/ident_hash_set.ml: ext/hash_set.cppo.ml
	cppo -D TYPE_IDENT $< -o $@
ext/hash_set.ml: ext/hash_set.cppo.ml
	cppo -D TYPE_FUNCTOR $< -o $@
ext/hash_set_poly.ml: ext/hash_set.cppo.ml
	cppo -D TYPE_POLY $< -o $@

# ext/hash_set_ident_mask.ml: ext/hash_set.cppo.ml
# cppo -D TYPE_IDENT_MASK $< -o $@

ext/int_vec.ml: ext/vec.cppo.ml
	cppo -D TYPE_INT $< -o $@
ext/resize_array.ml: ext/vec.cppo.ml
	cppo -D TYPE_FUNCTOR $< -o $@
ext/string_set.ml : ext/set.cppo.ml
	cppo -D TYPE_STRING $< -o $@	
ext/set_int.ml : ext/set.cppo.ml
	cppo -D TYPE_INT $< -o $@
ext/ident_set.ml : ext/set.cppo.ml
	cppo -D TYPE_IDENT $< -o $@
ext/set_poly.ml : ext/set.cppo.ml
	cppo  -D TYPE_POLY $< -o $@


ext/string_map.ml : ext/map.cppo.ml
	cppo -D TYPE_STRING $< -o $@
ext/int_map.ml : ext/map.cppo.ml
	cppo -D TYPE_INT $< -o $@
ext/map_make.ml : ext/map.cppo.ml
	cppo -D TYPE_FUNCTOR $< -o $@
ext/ident_map.ml : ext/map.cppo.ml
	cppo -D TYPE_IDENT $< -o $@
# ext/map_poly.ml : ext/map.cppo.ml
# 	cppo -D TYPE_POLY $< -o $@

ext/ordered_hash_map_make.ml: ext/ordered_hash_map.cppo.ml
	cppo -D TYPE_FUNCTOR $< -o $@
ext/ordered_hash_map_local_ident.ml: ext/ordered_hash_map.cppo.ml
	cppo -D TYPE_LOCAL_IDENT $< -o $@

ext/ordered_hash_set_make.ml : ext/ordered_hash_set.cppo.ml
	cppo -D TYPE_FUNCTOR $< -o $@

ext/ordered_hash_set_string.ml:ext/ordered_hash_set.cppo.ml
	cppo -D TYPE_STRING $< -o $@

ext/ordered_hash_set_ident.ml:ext/ordered_hash_set.cppo.ml
	cppo -D TYPE_IDENT $< -o $@

ext/string_hashtbl.ml: ext/hashtbl.cppo.ml
	cppo -D TYPE_STRING $< -o $@	
ext/int_hashtbl.ml: ext/hashtbl.cppo.ml
	cppo -D TYPE_INT $< -o $@
ext/ident_hashtbl.ml: ext/hashtbl.cppo.ml	
	cppo -D TYPE_IDENT $< -o $@
ext/hashtbl_make.ml: ext/hashtbl.cppo.ml
	cppo -D TYPE_FUNCTOR $< -o $@
## Stubs 
.c.o:
	$(NATIVE) -ccopt -O2 -ccopt -o -ccopt $@ -c $< 

STUBS_OBJS=stubs/ext_basic_hash_stubs.o

dllbs_hash.so libbs_hash.a: $(STUBS_OBJS)
	ocamlmklib $(STUBS_OBJS) -o bs_hash

bs_hash.cmxa:stubs/bs_hash_stubs.ml libbs_hash.a
	$(NATIVE) -a $< -o $@ -cclib libbs_hash.a

bs_hash.cma:stubs/bs_hash_stubs.ml dllbs_hash.so
	$(BYTE) -a $< -o $@ -dllib dllbs_hash.so

## native plugin was not installed in opam..

## Beging Rules only make sense in dev mode
core/js_map.ml:core/js_map.mlp core/j.ml
	@echo "Regenrating j_map.ml"
	$(CAMLP4OF) -I core -filter map -filter trash -impl $< -printer o -o  $@

core/js_fold.ml:core/js_fold.mlp core/j.ml
	@echo "Regenrating j_fold.ml"
	$(CAMLP4OF) -I core -filter Camlp4FoldGenerator  -filter trash -impl $< -printer o -o $@
common/bs_version.ml: build_version.js ../package.json
	node $<







### list files
STUB_SRCS = bs_hash_stubs
OUNIT_SRCS = oUnit oUnitDiff oUnitLogger oUnitTypes oUnitUtils oUnitChooser
OUNIT_CMXS = $(addprefix ounit/, $(addsuffix .cmx, $(OUNIT_SRCS)))
OUNIT_TESTS_SRCS =  ounit_tests_util \
	ounit_array_tests ounit_list_test \
	ounit_bal_tree_tests ounit_path_tests \
	ounit_union_find_tests ounit_hash_stubs_test \
	ounit_hash_set_tests ounit_scc_tests \
	ounit_hashtbl_tests\
	ounit_json_tests ounit_map_tests \
	ounit_ordered_hash_set_tests \
	ounit_vec_test \
	ounit_data_random\
	ounit_string_tests\
	ounit_utf8_test\
	ounit_js_regex_checker_tests\
	ounit_topsort_tests\
	ounit_sexp_tests\
	ounit_int_vec_tests\
	ounit_ident_mask_tests\
	ounit_cmd_util\
	ounit_cmd_tests\
	ounit_ffi_error_debug_test\
	ounit_tests_main
OUNIT_TESTS_CMXS = $(addprefix ounit_tests/, $(addsuffix .cmx, $(OUNIT_TESTS_SRCS)))

EXT_SRCS = ext_util\
	ext_int\
	ext_array ext_bytes ext_char\
	vec_gen \
	resize_array \
	string_vec\
	int_vec\
	int_vec_util\
	int_vec_vec\
	set_gen\
	map_gen\
	map_make\
	ext_file_pp ext_format \
	hashtbl_gen \
	ext_string \
	ext_utf8\
	ext_js_regex\
	string_hashtbl\
	ext_list \
	ext_map \
	ext_marshal ext_option \
	ext_pervasives ext_pp ext_ref  ext_sys \
	hash_set_gen hash_set \
	string_hash_set \
	ext_ident\
	int_hash_set \
	hash_set_ident_mask\
	ordered_hash_set_gen\
	ordered_hash_set_string\
	ordered_hash_set_ident\
	ordered_hash_set_make\
	ordered_hash_map_gen\
	union_find \
	ident_map\
	ident_set\
	hashtbl_make\
	ordered_hash_map_local_ident\
	int_map\
	literals \
	string_map \
	string_set\
	set_int\
	set_poly\
	ext_scc \
	ext_topsort\
	ext_pp_scope\
	ext_io\
	ext_sexp\
	ext_json\
	ident_hash_set\
	hash_set_poly\
	ident_hashtbl\
	int_hashtbl\
	ext_filename

EXT_CMXS=$(addprefix ext/, $(addsuffix .cmx, $(EXT_SRCS)))
EXT_CMOS=$(addprefix ext/, $(addsuffix .cmo, $(EXT_SRCS)))
COMMON_SRCS= bs_version js_config bs_pkg ext_log bs_loc  bs_warnings  lam_methname  binary_cache
COMMON_CMXS= $(addprefix common/, $(addsuffix .cmx, $(COMMON_SRCS)))
SYNTAX_SRCS= ast_utf8_string\
	ast_derive_constructor \
	ast_derive_util \
	ast_exp \
	ast_external \
	ast_lift \
	ast_literal \
	ast_pat \
	ast_payload \
	ast_signature \
	ast_structure bs_ast_iterator bs_ast_invariant \
	ast_derive ast_comb ast_attributes ast_core_type ast_derive_dyn\
	 ast_derive_projector \
	 ast_ffi_types\
	 ast_external_attributes\
	 ast_util\
	 ppx_entry
# not a good name ast_util	 
SYNTAX_CMXS=$(addprefix syntax/, $(addsuffix .cmx, $(SYNTAX_SRCS)))
DEPENDS_SRCS= depends_post_process bs_exception ast_extract binary_ast  
DEPENDS_CMXS=$(addprefix depends/, $(addsuffix .cmx, $(DEPENDS_SRCS)))
CORE_SRCS= type_int_to_string type_util  ocaml_stdlib_slots bs_conditional_initial ocaml_options ocaml_parse\
	js_op\
	lam_module_ident\
	lam\
	lam_print lam_beta_reduce_util lam_inline_util lam_analysis\
	lam_closure\
	js_cmj_format js_fun_env js_call_info js_closure  js_number js_cmj_datasets\
	lam_exit_code j \
	lam_compile_util lam_stats config_util lam_compile_defs js_map js_fold js_fold_basic js_pass_scope\
	js_op_util js_analyzer js_shake js_exp_make js_long js_of_lam_exception js_of_lam_module js_of_lam_array js_of_lam_block js_of_lam_string\
	js_of_lam_tuple js_of_lam_record js_of_lam_float_record js_arr lam_compile_const \
	lam_inner \
	lam_util \
	lam_eta_conversion\
	lam_group \
	lam_pass_deep_flatten\
	js_stmt_make js_pass_flatten\
	js_pass_tailcall_inline js_of_lam_variant js_pass_flatten_and_mark_dead js_ast_util lam_dce lam_group_pass lam_compile_env lam_stats_util\
	lam_stats_export lam_pass_alpha_conversion lam_pass_collect js_program_loader js_dump js_pass_debug\
	js_of_lam_option js_output lam_compile_global lam_dispatch_primitive \
	lam_beta_reduce\
	lam_compile_external_call \
	lam_compile_external_obj\
	lam_compile_primitive lam_compile lam_pass_exits\
	lam_pass_count\
	lam_pass_eliminate_ref\
	lam_pass_lets_dce \
	lam_pass_remove_alias \
	lam_coercion \
	lam_compile_group\
	js_implementation ocaml_batch_compile
CORE_CMXS=$(addprefix core/, $(addsuffix .cmx, $(CORE_SRCS)))

OTHER_CORE_SRCS= bsppx_main bspack_main jsoo_main  bspp_main js_cmi_datasets \
		 js_main
OTHER_CORE_CMXS= $(addprefix core/, $(addsuffix .cmx, $(OTHER_CORE_SRCS)))
BSB_SRCS= bsb_config \
	bsb_exception\
	bsb_build_schemas \
	bsb_build_util \
	bsb_dir \
	bsb_ninja \
	bsb_build_ui \
	bsb_default\
	bsb_dep_infos\
	bsb_gen\
	bsb_file\
	bsb_config_types\
	bsb_config_parse\
	bsb_unix

BSB_CMXS=$(addprefix bsb/, $(addsuffix .cmx, $(BSB_SRCS)))
MAIN_SRCS= jsgen_main jscmj_main bsb/bsb_main bsb/bsb_helper_main
MAIN_CMXS=$(addsuffix .cmx, $(MAIN_SRCS))

ounit.cmxa: $(OUNIT_CMXS)
	ocamlopt.opt -a $^ -o $@
ext.cma: $(EXT_CMOS)
	ocamlc.opt -a $^ -o $@
ext.cmxa: $(EXT_CMXS)
	ocamlopt.opt -a $^ -o $@
common.cmxa:$(COMMON_CMXS)
	ocamlopt.opt -a $^ -o $@
syntax.cmxa:$(SYNTAX_CMXS)
	ocamlopt.opt -a $^ -o $@
depends.cmxa:$(DEPENDS_CMXS)
	ocamlopt.opt -a $^ -o $@
core.cmxa:$(CORE_CMXS)
	ocamlopt.opt -a $^ -o $@
bsb.cmxa:$(BSB_CMXS)
	ocamlopt.opt -a $^ -o $@

check:  $(EXT_CMXS) $(COMMON_CMXS) $(SYNTAX_CMXS) $(DEPENDS_CMXS) $(CORE_CMXS) $(BSB_CMXS) $(OTHER_CORE_CMXS) $(MAIN_CMXS) $(OUNIT_CMXS) $(OUNIT_TESTS_CMXS)

bin/bsb.exe: bs_hash.cmxa ext.cmxa common.cmxa  bsb.cmxa bsb/bsb_main.cmx
	$(NATIVE) -g  unix.cmxa str.cmxa $^ -o $@

# bin/bsc:  ext.cmxa common.cmxa  depends.cmxa syntax.cmxa core.cmxa
# 	$(NATIVE) -g -linkall -I +compiler-libs ocamlcommon.cmxa $^ -o $@

bin/bsc.exe: bs_hash.cmxa ext.cmxa common.cmxa syntax.cmxa depends.cmxa core.cmxa core/js_main.cmx
	@echo "Linking"
	$(NATIVE) -g -linkall -I +compiler-libs ocamlcommon.cmxa $^ -o $@
bin/jscmj.exe:ext.cmxa common.cmxa syntax.cmxa depends.cmxa core.cmxa  jscmj_main.cmx
	@echo "Linking js_pack.exe"
	$(NATIVE) -g -linkall -I +compiler-libs ocamlcommon.cmxa $^ -o $@

bin/jsgen.exe:ext.cmxa jsgen_main.cmx
	$(NATIVE) -g -linkall -I +compiler-libs ocamlcommon.cmxa $^ -o $@


.PHONY: check


depend:
	$(CAMLDEP) -native -I stubs -I ext -I common -I syntax -I depends -I core -I ounit -I ounit_tests -I bsb \
	$(addprefix stubs/, $(addsuffix .ml, $(STUB_SRCS))) \
	$(addprefix stubs/, $(addsuffix .mli, $(STUB_SRCS))) \
	$(addprefix ext/, $(addsuffix .ml, $(EXT_SRCS))) \
	$(addprefix ext/, $(addsuffix .mli, $(EXT_SRCS))) \
	$(addprefix common/, $(addsuffix .ml, $(COMMON_SRCS))) \
	$(addprefix common/, $(addsuffix .mli, $(COMMON_SRCS))) \
	$(addprefix syntax/, $(addsuffix .ml, $(SYNTAX_SRCS))) \
	$(addprefix syntax/, $(addsuffix .mli, $(SYNTAX_SRCS))) \
	$(addprefix depends/, $(addsuffix .mli, $(DEPENDS_SRCS))) \
	$(addprefix depends/, $(addsuffix .ml, $(DEPENDS_SRCS))) \
	$(addprefix core/, $(addsuffix .mli, $(CORE_SRCS))) \
	$(addprefix core/, $(addsuffix .ml, $(CORE_SRCS))) \
	$(addprefix core/, $(addsuffix .mli, $(OTHER_CORE_SRCS))) \
	$(addprefix core/, $(addsuffix .ml, $(OTHER_CORE_SRCS))) \
	$(addprefix ounit/, $(addsuffix .mli, $(OUNIT_SRCS))) \
	$(addprefix ounit/, $(addsuffix .ml, $(OUNIT_SRCS))) \
	$(addprefix ounit_tests/, $(addsuffix .mli, $(OUNIT_TESTS_SRCS))) \
	$(addprefix ounit_tests/, $(addsuffix .ml, $(OUNIT_TESTS_SRCS))) \
	bsb/*.ml bsb/*.mli *.ml *.mli > all.depend
	# $(addprefix bsb/, $(addsuffix .mli, $(BSB_SRCS))) \
	# $(addprefix bsb/, $(addsuffix .ml, $(BSB_SRCS))) \



SNAPSHOT_SRCS=$(addprefix bin/, $(addsuffix .ml, bsppx whole_compiler bsdep bsb bsb_helper bspp all_ounit_tests))
SNAPSHOT_DEPS=$(SNAPSHOT_SRCS:.ml=.d)

# this target  is used to make snapshotml
./bin/bspack.exe: bin/config_bspack.mli bin/config_bspack.ml bin/bspack.mli bin/bspack.ml
	$(MAKE) -C bin bspack.exe



# TODO
# enhace for Parser module, we only care about Parser.token
# files including Parsetree/Parser should be shaked

# It is really hard to `make snapshotml` work as expected
# if we generate `.d` file as below
#   bin/bsb.ml : bsb/bs_build_schemas.ml
# Then if we rename files `bsb/bs_build_schemas.ml`, it will *fail* to build, since pre-requisite is not found
# If we use empty recipies as below
#  bin/bsb.ml : bsb/bs_build_schemas.ml
#  bsb/bs_build_schemas.ml :
# When we rename files `bsb/bs_build_schemas.ml`, it will not rebuild, since Make will ignore non-exist files,
# But it will rebuild if the file is modified.
# What we really need is such semantics in between:
# if the file is modified or non-existent, trigger rebuild, when non-existent,
# alwasy rebuild (don't fail)

# The trick we have is that whenever the file is non-existent, we will touch the stamp of output, since the
# Make program does not verify the rule generate output or not (it only checks exit code)
# So this will force a snapshot
# This will not work if we have multiple snapshot and include them, they will cause a conflict

# bin/whole_compiler.d:2: warning: overriding commands for target `ext/ext_pervasives.ml'
# bin/bsppx.d:100: warning: ignoring old commands for target `ext/ext_pervasives.ml'

# To work around this problem, we should touch  a global stamp file , too complex to maintain..
# Gave up, make can not handle delete/adding new files correctly
# Let's make it still work and fail to build, delegating `make clean`
# Actually we can not make it correct by including..
# if we force it, then the initial build will fail
# if we don't force it, then if we remove bin/bsb.d
# The build will never be re-triggered -- ninja seems to have special support for this semantics 
# if we move files around, it will cause file failure
# Note the currently snapshot mode means if we don't
# generate ml files it will not be included


snapshotml:./bin/bspack.exe $(SNAPSHOT_SRCS)

force-snapshotml:
	rm -f $(SNAPSHOT_DEPS) $(SNAPSHOT_SRCS)
	make snapshotml


bin/bsppx.ml:./bin/bspack.exe
	unset BS_DEBUG; $< -bs-MD  -prelude-str 'module Config = Config_bsppx'  -bs-exclude-I config -I ../ocaml/utils/ -I ../ocaml/parsing/ -I stubs -I common -I ext -I syntax -I core -bs-main Bsppx_main -o $@

bin/whole_compiler.ml:./bin/bspack.exe
	unset BS_DEBUG; $< -bs-MD -prelude-str 'module Config = Config_whole_compiler' -bs-exclude-I config -o $@ -bs-main Js_main -I ../ocaml/utils/ -I ../ocaml/parsing/ -I ../ocaml/typing/ -I ../ocaml/bytecomp/ -I ../ocaml/driver/ -I stubs -I ext -I syntax -I depends -I common -I core

bin/bsdep.ml:./bin/bspack.exe
	unset BS_DEBUG; BS_OCAMLDEP=true $< -bs-MD  -prelude-str 'module Config = Config_bsdep'  -bs-exclude-I config -I ../ocaml/utils/ -I ../ocaml/parsing/ -I ../ocaml/driver -I ../ocaml/tools -I common -I ext -I syntax -I depends -I core -I stubs -bs-main Ocamldep -o $@

bin/bsb_helper.ml:./bin/bspack.exe
	unset BS_DEBUG; $< -bs-MD   -I stubs -I common -I ext -I syntax -I depends -I bsb  -bs-main Bsb_helper_main -o $@

bin/bsb.ml:./bin/bspack.exe
	unset BS_DEBUG; $< -bs-MD -I stubs -I common -I ext -I syntax -I depends -I bsb -I ext  -bs-main Bsb_main -o $@

bin/bspp.ml:./bin/bspack.exe
	unset BS_DEBUG; BS_MIN_LEX_DEPS=true $< -bs-MD -prelude-str 'module Config = Config_bspp'  -bs-exclude-I config -I ../ocaml/utils/ -I ../ocaml/parsing?parser  -I common -I ext -I syntax -I depends -I bspp -I core -bs-main Bspp_main -o $@

bin/js_compiler.ml:./bin/bspack.exe
	unset BS_DEBUG; BS_COMPILER_IN_BROWSER=true bspack.exe -bs-MD  -prelude-str 'module Config = Config_whole_compiler' -bs-exclude-I config -o $@ -bs-main Jsoo_main -I ../ocaml/utils/ -I ../ocaml/parsing/ -I ../ocaml/typing/ -I ../ocaml/bytecomp/ -I ../ocaml/driver/ -I ext -I syntax -I depends -I common -I core

bin/all_ounit_tests.ml:./bin/bspack.exe
	$< -bs-MD   -I ounit -I ounit_tests  -I stubs -I bsb -I common -I ext -I syntax -I depends -I bspp -I core -bs-main Ounit_tests_main -o $@
-include bin/all_ounit_tests.d



bin/all_ounit_tests.exe: stubs/ext_basic_hash_stubs.c bin/all_ounit_tests.mli bin/all_ounit_tests.ml
	ocamloptp -I +compiler-libs ocamlcommon.cmxa -P a -g -I bin -w -a unix.cmxa $^ -o $@

test:bin/all_ounit_tests.exe
	$^ && ocamlprof bin/all_ounit_tests.ml > bin/all_ounit_tests.i.ml &&	rm ocamlprof.dump


# bin/all_ounit_tests.i.exe: stubs/ext_basic_hash_stubs.c bin/all_ounit_tests.mli bin/all_ounit_tests.ml
# 	$(NATIVE) -ppx /Users/hzhang295/.opam/4.02.3+local-git-master/lib/bisect_ppx/bisect_ppx -g -I bin -w -a unix.cmxa $^ -o $@

.PHONY:ounit_test
# TODO: Fix Me use its own configuration
bin/js_compiler.byte:bin/js_compiler.mli bin/js_compiler.ml
	$(BYTE) -w -a -I bin bin/config_whole_compiler.mli bin/config_whole_compiler.ml $^ -no-check-prims -o $@



# git diff bin/bspack.ml
# bootbspack requires ../ocaml has parser, lexer processed by ocamlyacc and ocamllex


# bootbspack should not depend on bspack.exe
# if so, `make bootbspack` will cause `bspack.exe` to be rebuilt
# which may already be wrong


bootbspack:
	@echo "Bootstrap bspack.exe"
	./bin/bspack.exe -bs-MD -prelude-str 'module Config = Config_bspack '   -bs-exclude-I config  -I ../ocaml/parsing/ -I ../ocaml/utils/ -I stubs -I ext -I common -I depends -I core -bs-main Bspack_main -o bin/bspack.ml
	$(NATIVE) ./stubs/ext_basic_hash_stubs.c -w -40  unix.cmxa  -I bin bin/config_bspack.mli bin/config_bspack.ml bin/bspack.mli bin/bspack.ml -o bin/bspack.exe
	@echo "Using the bootstrapped bspack.exe to genreate new bspack.ml: `date`"
	./bin/bspack.exe -bs-MD  -prelude-str  'module Config = Config_bspack'   -bs-exclude-I config  -I ../ocaml/parsing/ -I ../ocaml/utils/ -I stubs -I ext -I common -I depends -I core -bs-main Bspack_main -o bin/bspack.ml
	@echo "Bootstrap seems finished, please check diffs in bspack.exe"
	@echo "Rebuilding bspack.exe"
	make -C bin -B bspack.exe
	@echo "Rebuilding bspack.exe finsihed"

libs:
	@echo "Making stdlib cmis"
	cd stdlib && $(MAKE) allcmis
	@echo "Making stdlib finished"

	@echo "Making runtime"
	cd runtime && $(MAKE) all
	@echo "Making runtime finished"


	@echo "Making stdlib"
	cd stdlib && $(MAKE) all
	@echo "Making stdlib finished"

	@echo "Making others"
	cd others && $(MAKE) all
	@echo "Making others finished"



release:bin/bspack.exe bin/jscmj.exe bin/jsgen.exe snapshotml
	@echo "Collecting cmj files"
	@echo "Generating cmj_datasets"
	bin/jscmj.exe # for cmj file up to date
	@echo "Generating preload.js"
	bin/jsgen.exe # for js file up to date
	$(MAKE) -C bin -j6 all
	$(MAKE) libs

# Note we should not do snapshotml here
# since, user may not have the sources available
# -B is not necessary in jenkins, however, when dir is not clean..
world:
	@echo "Making compiler"
	$(MAKE) -B -C bin -j 6 all
	@echo "Making compiler finished"
	BS_RELEASE_BUILD=1 $(MAKE) -j8 libs


travis-world-test:
	$(MAKE) world
	@echo "Making test"
	$(NATIVE) -g -I bin -I +compiler-libs -w -a ocamlcommon.cmxa unix.cmxa stubs/ext_basic_hash_stubs.c bin/all_ounit_tests.mli bin/all_ounit_tests.ml -o bin/all_ounit_tests.exe && bin/all_ounit_tests.exe
	$(MAKE) -C test all
	@echo "Making test finsihed"


DEST=../lib/ocaml
DEST_BIN=../bin
install:
	@echo "copy exe"
	mkdir -p $(DEST_BIN) $(DEST)
	cp  ./bin/*.js ./bin/*.exe  $(DEST_BIN)
	@echo "copy stdlib"
	cp ./runtime/*.cmt* ./runtime/*.cmj* ./stdlib/*.cm* ./others/*.ml ./others/*.mli  ./others/*.cm* \
	 ./runtime/js.ml  ./runtime/js.cmi ./runtime/js_unsafe.cmi ./runtime/js_null.ml ./runtime/js_null.cmi \
	./runtime/js_undefined.ml ./runtime/js_undefined.cmi   $(DEST)
	cp ./stdlib/*.ml ./stdlib/*.mli $(DEST)
# ./runtime/js_null_undefined.ml ./runtime/js_null_undefined.cmi
include all.depend
-include $(SNAPSHOT_DEPS)

clean:
	rm -f bsb/bs_json.ml ext/sexp_lexer.ml core/js_fold.ml core/js_map.ml
	rm -f common/bs_version.ml
	rm -rf bin/config_whole_compiler.ml
	git clean -dfx stubs ext common syntax depends core bsb

toplevel: bs_hash.cma ext.cma
.PHONY: release   releasebuild libs snapshotml force-snapshotml toplevel
