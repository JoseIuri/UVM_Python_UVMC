class tr_out extends uvm_sequence_item;
    rand integer data;

    `uvm_object_utils_begin(tr_out)
        `uvm_field_int(data, UVM_ALL_ON|UVM_HEX)
    `uvm_object_utils_end

    function new(string name="tr_out");
        super.new(name);
    endfunction: new
endclass: tr_out