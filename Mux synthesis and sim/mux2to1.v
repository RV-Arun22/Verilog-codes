//2:1 mux model, intitially behavioural, now written in structural design flow
module mux2to1 (out,sel,in);
    input [1:0] in;
    input sel;
    output out;
    wire sel_bar, x, y;

    not n1 (sel_bar, sel);
    and a0 (x,sel_bar,in[0]);
    and a1 (y,sel,in[1]);
    or o1 (out,x,y);

endmodule