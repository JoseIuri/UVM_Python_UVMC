class tr_in extends uvm_sequence_item;
    rand integer A;
    rand integer B;

    `uvm_object_utils_begin(tr_in)
        `uvm_field_int(A, UVM_ALL_ON|UVM_HEX)
        `uvm_field_int(B, UVM_ALL_ON|UVM_HEX)
    `uvm_object_utils_end

    function new(string name="tr_in");
        super.new(name);
    endfunction: new
endclass: tr_in