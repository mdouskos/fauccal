function q_state=st_quantize(state,distance,inc_c,inc_a)

q_state=zeros(6,1);
c1=distance;
c2=state(i,5)+(sign(state(i,5)))*((inc_c/2)-mod(abs(state(i,5))+(inc_c/2),inc_c));
c3=state(i,6)+(sign(state(i,6)))*((inc_c/2)-mod(abs(state(i,6))+(inc_c/2),inc_c))-Ph(1);
q_state(1:3)=[c1,c2,c3];

a1=state(i,3)*180/pi();
a1=a1+(sign(a1))*((inc_a/2)-mod(abs(a1)+(inc_a/2),inc_a));
a2=state(i,2)*180/pi();
a2=a2+(sign(a2))*((inc_a/2)-mod(abs(a2)+(inc_a/2),inc_a));
a3=state(i,1)*180/pi();
a3=a3+(sign(a3))*((inc_a/2)-mod(abs(a3)+(inc_a/2),inc_a));
q_state(4:6)=[a1,a2,a3];
%q_state(4:7)=etoqconv([a1,a2,a3]);
