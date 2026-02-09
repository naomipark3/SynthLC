#!/bin/bash
# Setup script for Ibex formal verification
# Run from: ~/SynthLC/fv

IBEXDIR=$(realpath ~/ibex)
echo "====================== [SETUP_FILES - IBEX]  ========================="
echo "IBEXDIR: $IBEXDIR"

# Copy Ibex-specific files into place
echo "[SETUP] Copying Ibex FV files..."
cp ibex_fv/ibex_topsim.sv src/topsim.sv
cp ibex_fv/ibex_header_fv.sv src/header_fv.sv
cp ibex_fv/ibex_header_fv_nia.sv src/header_fv_nia.sv
cp ibex_fv/ibex_header_fv_subset.sv src/header_fv_subset.sv
cp ibex_fv/annotation_pcr_ufsms_ibex.txt annotation_pcr_ufsms.txt

echo "[SETUP] Preparing hdl.f.test..."
sed "s~IBEXDIR~${IBEXDIR}~g" ibex_fv/ibex_hdl.f.template > hdl.f.test

echo "[SETUP] Preparing jg_base.tcl.test..."
sed "s~DESIGNDIR~${IBEXDIR}~g" src/jg_base.tcl.template > jg_base.tcl.test
sed -i "s~HDLDIR~${IBEXDIR}/rtl~g" jg_base.tcl.test
# Change bbox from CVA6 frontend to Ibex IF stage
sed -i "s~bbox_m {frontend}~bbox_m {ibex_if_stage}~g" jg_base.tcl.test

echo "[SETUP] Done. Files generated:"
echo "  hdl.f.test"
echo "  jg_base.tcl.test"
echo "  src/topsim.sv"
echo "  src/header_fv.sv"
echo "  annotation_pcr_ufsms.txt"
echo ""
echo "Next: cd synthlc && source env_ibex.sh && cd ../"
echo "Then: mkdir xSanity; touch xSanity/xSanity.sv; ./RUN_JG.sh -j xSanity -s xSanity/xSanity.sv -g 0"
