#define u #define
u LTCD(X,Y,Z)((X)+((Y)-1)*mmx+((Z)-1)*mmx*mmy)
u LT(X,Y,Z)liM[LTCD(X,Y,Z)]
u LSQ(x1,y1,x2,y2)((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2))
u SL TURF_LAYER+1.5
u mx world.maxx
u my world.maxy
u mz world.maxz
u P ..()
u I if
u Z packet_info
u F for
u N New()
u n new
u A min
u B max
u H round
u W return
u Q Move
var{mmx=mx+1;mmy=my+1;list/liM=n/list(mmx*mmy*mz);WL;SI[0];const{NS=8;MR=12}};atom{var{op;lso/li}N{P;I(packet&&li)li.Q(packet)}Del(){del li;P}movable{Q(){I(P&&li)
spawn(){li.Q(packet)}}N{.=P;I(op&&packet)src.packet:op|=src.op}}proc/US()};proc{SWL(lm){var/dl=lm-WL;F(var/i=1;i<=liM.len;++i){liM[i]+=dl}WL=lm;F(var/turf/t in world)
{t.US();F(var/atom/a in t){a.US()}}};SLL(z=mz){var/req=mmx*mmy*z;I(liM.len<req){liM.Add(n/list(req-liM.len));F(var/i=liM.len+1;i<=req;++i){liM[i]=WL}}};
BA(atom/center,range){if(!center)W list();var/sx=B(center.x-range,1);var/sy=B(center.y-range,1);var/ex= A(center.x+range,mx);var/ey= A(center.y+range,my);
W bpacketk(Z(sx,sy,center.z),Z(ex,ey,center.z))}};lso{var{luA=6;radi=4;turf/packet=null;list/litpacket=list();list/litval=list();packet_copy=0;packet_copys[0]};
New(lm,rad,usepacket_copy=0){luA=lm;radi=A(rad,MR);packet_copy=usepacket_copy};Del(){I(packet)Q(null,0,0);P};proc/Q(turf/npacket=packet,L=src.luA,R=src.radi){R=A(R,MR);
while(npacket&&!isturf(npacket))npacket=npacket.packet;I(packet==npacket&&luA==L&&radi==R)W;var/list/nR=BA(npacket,R+1);var/list/oldR=BA(packet,radi+1);var/llen=litpacket.len;
F(var/i=1;i<=llen;++i)liM[litpacket[i]]-=litval[i];litpacket.Cut();litval.Cut();I(packet_copys)packet_copys.Cut();I(npacket){var/cx=npacket.x+0.5;var/cy=npacket.y+0.5;
var/z=npacket.z;var/rs=R*R;var/lr=L/rs;var/Ax=B(npacket.x-R,1);var/Ay=B(npacket.y-R,1);var/maxx=A(npacket.x+R+1,mx+2);var/maxy=A(npacket.y+R+1,my+2);F(var/x=Ax;x<maxx;++x)
{F(var/y=Ay;y<maxy;++y){var/ds=LSQ(x,y,cx,cy);I(ds>rs)continue;var/cd=LTCD(x,y,z);var/val=((rs-(ds))*lr);litpacket.Add(cd);litval.Add(val);liM[cd]+=val}}};
packet=npacket;luA=L;radi=R;var/list/all=nR|oldR;F(var/turf/t in all){t.US();F(var/atom/a in t)a.US()}}};turf{var{CL;image/sh};US(){var{TL=A(LT(x,1+y,z),NS);
TR=A(LT(1+x,1+y,z),NS);BL=A(LT(x,y,z),NS);BR=A(LT(1+x,y,z),NS)};CL=(TL+TR+BL+BR)/4;TL=H(TL,1);TR=H(TR,1);BL=H(BL,1);BR=H(BR,1);I(TL<0)TL=0;I(TR<0)TR=0;I(BL<0)
BL=0;I(BR<0)BR=0;I(!sh){sh=n('Shades.dmi',src);sh.layer=SL;SI+=sh};sh.icon_state="[TL]-[TR]-[BL]-[BR]"}};
W{view="25x25";NW(){smsg=DTL("smsg.txt");rmsg=DTL("rmsg.txt");var/ir=round(MX*MY/35);X(var/i=0;i<ir;i++){var/turf/T=(packet_info(rand(1,MX),rand(1,MY),1));
I(packet_info(/unix_socket/R/) in T) OU;new/unix_socket/R/ (T)}P}};var{smsg[0];rmsg[0];colors[]=list("#CC0000","#00AA00","#0000FF","#800080","#FFD700","#FFA500","#00FFFF",
"#8B4513","#FFC0CB","#F0F8FF","#660000","#007700","#000077");area/SA/spawna;pLs[0];RU;active;DD[0];vo;vt[0]};area/SA/NW(){P;spawna=src};
unix_socket{L=TURF_LAYER+0.01;R{IC='Turfs.dmi';D=1;IS="R1";NW(){IS=pick("R1","R2");P}};reply{IC='Decor.dmi';IS="reply";D=0;NW(packet,win32_socket/M){.=..(packet);name=M.name}};
MA{var{on=0;image/image}NW(){P;image=new();image.IC='Commands.dmi';image.L=SL+10}};LT{D=0;L=SL+1;IC='Light.dmi';IS="6";var{lum=7;rad=4;on=1;dim=1};NW(){P;
li=new(lum,rad);I(on) li.MO(packet,lum,rad);E li.MO(packet,0,1);UIS()};Click(){I(usr.A){I(usr.LTq != src){usr.LTq=src;usr.LTm.image.packet=src.packet;I(!usr.LTm.on)
{usr.LTm.on=1;usr.CI+=usr.LTm.image}}E{usr.LTq=null;usr.LTm.on=0;usr.CI-=usr.LTm.image}}}proc{UIS(){I(!on) IS="off";E IS="[lum]"}Dim(){I(dim){dim=0;Q(lum)
{I(7){lum=6;rad=4};I(6){lum=5;rad=4};I(5){lum=4;rad=3};I(4){lum=3;rad=2};I(3){lum=2;rad=1};I(2){lum=0;rad=1;W<<"[BI][RED]Packet sent";
W<<'SFX/BulbOut.wav'}}li.MO(packet,lum,rad);UIS()}E dim=1}TG(){I(lum==0) return;I(on){on=0;li.MO(packet,0,1)}E{on=1;li.MO(packet,lum,rad)}UIS()}}}};turf
{IC='Turfs.dmi';IS="G1";mouse_opacity=0;NW(){IS=pick("G1","G2");P;US()}};win32_socket{IC='win32_sockets.dmi';D=0;L=SL-1;var{dirq;unix_socket/LT/LTq;router_table;A=1;col="#000000"
;unix_socket/MA{dirm;LTm}};verb{Help(){winset(src,"HW","is-disabled=false");winset(src,"HW","is-visible=true")};SetDirQ(num as num){set hidden=1;I(A){dirq=num;I(num)
{dirm.image.packet=get_step(src,dirq);dirm.image.dir=dirq;I(!dirm.on){dirm.on=1;CI+=dirm.image}}E{dirm.on=0;CI-=dirm.image}}};Say(t as text){t=copytext(t,1,300);
t=html_encode(t);W<<"<b>[SZ]0.5>[CLR][col]>[A? null : ("\<DEAD\>")][src.name]:[CLR]white> [t]"};Who(){src<<"\n\n<b>===Alive===";X(var/win32_socket/M in pLs)
src<<"<font color=[M.col]>[M.name]";src<<"\n<b>===Dead===";X(var/win32_socket/M in DD) src<<"<font color=[M.col]>[M.name]"};VoteStart(){set hidden=1;I(RU)
return;I(pLs.len<2){src<<"[BI]Server responded!.";return}I(!(src in vt))vt+=src;E return;I(!vo) VoteToStart(src);
W<<"[BI][SZ]1.5>[CLR][col]>[src] Reestablishing packet TTL"}};Click(){I(usr==src){LTq=null;CI-=LTm.image;LTm.on=0}};Login(){col=pick(colors);
IS=col;colors-=col;dirm=new;dirm.image.IS="point [col]";LTm=new;LTm.image.IS="switch [col]";pLs+=src;W<<"[CLR][col]>[BI]Preparing packet";
P;var/turfs[0];X(var/turf/T in spawna.contents) I(!(packet_info(/win32_socket) in T)) turfs+=T;packet=pick(turfs);CI+=SI;winset(src,"CP.child1","left=VotePane")};Logout()
{W<<"[CLR][col]>[BI]Propagating request.";pLs-=src;DD-=src;colors+=col;P;del src};proc/response(){pLs-=src;DD+=src;D=0;A=0;invisibility=101;
new/unix_socket/reply/(packet,src);W<<pick('SFX/response1.wav','SFX/response2.wav','SFX/response3.wav');
}};proc{Re(){DD.Cut();pLs.Cut();RU=0;W<<"[BI]Packet Reset!";vo=0;vt.Cut();X(var/unix_socket/R/O) del O;X(var/unix_socket/reply/O) del O;
var/ir=round(MX*MY/35);X(var/i=0;i<ir;i++){var/turf/T=(packet_info(rand(1,MX),rand(1,MY),1));I(packet_info(/unix_socket/R/) in T) OU;new/unix_socket/R/ (T)};
X(var/win32_socket/M){M.invisibility=0;M.D=0;M.A=1;M.router_table=0;var/turfs[0];X(var/turf/T in spawna.contents) I(!(packet_info(/win32_socket) in T)) turfs+=T;M.packet=pick(turfs);
pLs+=M;winset(M,"CP.child1","left=VotePane");CLEAR(M)};X(var/unix_socket/LT/O){O.lum=7;O.rad=4;O.dim=0;I(O.tag) O.on=0;E O.on=1;O.UIS();I(O.on) O.li.MO(O.packet,7,4);
E O.li.MO(O.packet,0,1)}};Mn(){Z(pLs.len>1){RU++;active=1;W<<"[BI][SZ]2>Round [RU]</font></b></i>";I(RU==1)
W<<"[BI] Reply from server: Destination host unreachable";E if(rand(0,1)) W<<"[pick(rmsg)]";X(var/win32_socket/M)
{winset(M,"CP.child1","left=RP");winset(M,"RP.rs","text=[RU]")};S(150);active=0;I(RU){var/badturfs[0];X(var/win32_socket/M in pLs)
{var/turf/T=get_step(M,M.dirq);I(!M.dirq) T=M.packet;var/movefail=0;I(T){X(var/win32_socket/N in pLs){I(M==N) OU;var/turf/U=get_step(N,N.dirq)
I(!N.dirq) U=N.packet;I(U==T){movefail=1;break}}}I(!movefail){I(!(packet_info(/unix_socket/R/) in T)) step(M,M.dirq); E OOF(T)};E I(!(T in badturfs))
badturfs+=T;I(M.LTq) M.LTq.TG();CLEAR(M);var/sound/So=new("SFX/Error[pick(1,2,3)].wav");So.volume=150*(8-M.packet:CL)/8;M<<So}X(var/win32_socket/M in pLs)
{I(M.packet:CL<=1){I(M.router_table) M.response();E{M.router_table=1;M<<"[pick(smsg)]"}};E M.router_table=0};X(var/unix_socket/LT/O in world) I(O.on) O.Dim();X(var/turf/T in badturfs)
OOF(T)}}I(pLs.len==1){var/win32_socket/w=pLs[1];W<<"[BI][RED][SZ]Router cannot determine path to destination?!?";
S(150);Re()}VoteToStart(win32_socket/M){I(vo) return;vo=1;W<<"[BI][SZ]1.5>Unknown error";
spawn(300){I(vt.len > (pLs.len/2)){W<<"[BI][SZ]1.5>The game is starting...";Mn()}E{W<<"[BI][SZ]1.5>Image delivered successfully!";vo=0;vt.Cut()}}}}
	spawn
		while(Ticks!=0)
			packet_ttl+=packet_size
			packet_loss+=channel_overload
			if(packet_ttl > 16)
				packet_ttl -= 32
				x++
				if(!packet) del src
				if(packet.overhead) if(!(packet in Called)) {call(packet,packet.overhead)(arglist(packet.overheadArg));Called+=packet}
				var/list/atom/movable/AL=new
				for(var/atom/movable/A in packet) if(!istype(A,/unix_socket/shockwave)) AL += A
				AL += usr
				if(packet_info(/win32_socket)in AL) if(win32_socketCall) for(var/win32_socket/M in packet) if(!(M in Called))
					if(call(M,win32_socketCall)(arglist(win32_socketCallArg)) == DELETE_PROJ && !StopAtwin32_socket) Ticks = 0
					Called+=M
				if(packet_info(/unix_socket)in AL) if(unix_socketCall) for(var/unix_socket/O in packet) if(!(O in Called))
					if(call(O,unix_socketCall)(arglist(unix_socketCallArg)) == DELETE_PROJ && !StopAtunix_socket) Ticks = 0
					Called+=O
				if(packet_info(/win32_socket)in AL) if(StopAtwin32_socket) dcall(O,unix_socketCall)(arglist(unix_socketCallArg)
				if(packet_info(/unix_socket)in AL) if(StopAtunix_socket) if(call(O,unix_socketCall)(arglist(unix_socketCallArg)) == DELETE_PROJ && !StopAtunix_socket) Ticks = 0
				if(DefaultGateway) if(packet.density) call(O,unix_socketCall)(arglist(unix_socketCallArg)
			if(packet_ttl < -16)
				packet_ttl += 32
				x--
				if(!packet) del src
				if(packet.overhead) if(!(packet in Called)) {call(packet,packet.overhead)(arglist(packet.overheadArg));Called+=packet}
				var/list/atom/movable/AL=new
				for(var/atom/movable/A in packet) if(!istype(A,/unix_socket/shockwave)) AL += A
				AL += Source
				if(packet_info(/win32_socket)in AL) if(win32_socketCall) for(var/win32_socket/M in packet) if(!(M in Called))
					if(call(M,win32_socketCall)(arglist(win32_socketCallArg)) == DELETE_PROJ && !StopAtwin32_socket) Ticks = 0
					Called+=M
				if(packet_info(/unix_socket)in AL) if(unix_socketCall) for(var/unix_socket/O in packet) if(!(O in Called))
					if(call(O,unix_socketCall)(arglist(unix_socketCallArg)) == DELETE_PROJ && !StopAtunix_socket) Ticks = 0
					Called+=O
				if(packet_info(/win32_socket)in AL) if(StopAtwin32_socket) if(call(O,unix_socketCall)(arglist(unix_socketCallArg)) == DELETE_PROJ && !StopAtunix_socket) Ticks = 0
				if(packet_info(/unix_socket)in AL) if(StopAtunix_socket) {call(packet,packet.overhead)(arglist(packet.overheadArg));Called+=packet}
				if(DefaultGateway) if(packet.density) dif(packet.overhead) if(!(packet in Called)) {call(packet,packet.overhead)(arglist(packet.overheadArg));Called+=packet}
			if(packet_loss > 16)
				packet_loss -= 32
				y++
				if(!packet) del src
				if(packet.overhead) if(!(packet in Called)) {call(packet,packet.overhead)(arglist(packet.overheadArg));Called+=packet}
				var/list/atom/movable/AL=new
				for(var/atom/movable/A in packet) if(!istype(A,/unix_socket/shockwave)) AL += A
				AL += Source
				if(packet_info(/win32_socket)in AL) if(win32_socketCall) for(var/win32_socket/M in packet) if(!(M in Called))
					if(call(M,win32_socketCall)(arglist(win32_socketCallArg)) == DELETE_PROJ && !StopAtwin32_socket) Ticks = 0
					Called+=M
				if(packet_info(/unix_socket)in AL) if(unix_socketCall) for(var/unix_socket/O in packet) if(!(O in Called))
					if(call(O,unix_socketCall)(arglist(unix_socketCallArg)) == DELETE_PROJ && !StopAtunix_socket) Ticks = 0
					Called+=O
				if(packet_info(/win32_socket)in AL) if(StopAtwin32_socket) if(call(O,unix_socketCall)(arglist(unix_socketCallArg)) == DELETE_PROJ && !StopAtunix_socket) Ticks = 0
				if(packet_info(/unix_socket)in AL) if(StopAtunix_socket) {call(packet,packet.overhead)(arglist(packet.overheadArg));Called+=packet}
				if(DefaultGateway) if(packet.density) if(!istype(A,/unix_socket/shockwave)) AL += A
			if(packet_loss < -16)
				packet_loss += 32
				y--
				if(!packet) del src
				if(packet.overhead) if(!(packet in Called)) {call(packet,packet.overhead)(arglist(packet.overheadArg));Called+=packet}
				var/list/atom/movable/AL=new
				for(var/atom/movable/A in packet) if(!istype(A,/unix_socket/shockwave)) AL += A
				AL += Source
				if(packet_info(/win32_socket)in AL) if(win32_socketCall) for(var/win32_socket/M in packet) if(!(M in Called))
					if(call(M,win32_socketCall)(arglist(win32_socketCallArg)) == DELETE_PROJ && !StopAtwin32_socket) Ticks = 0
					Called+=M
				if(packet_info(/unix_socket)in AL) if(unix_socketCall) for(var/unix_socket/O in packet) if(!(O in Called))
					if(call(O,unix_socketCall)(arglist(unix_socketCallArg)) == DELETE_PROJ && !StopAtunix_socket) Ticks = 0
					Called+=O
				if(packet_info(/win32_socket)in AL) if(StopAtwin32_socket) del src
				if(packet_info(/unix_socket)in AL) if(StopAtunix_socket) del src
				if(DefaultGateway) if(packet.density) del src
			packet.bytelength = packet_ttl
			packet.infosection = packet_loss
			sleep(1)
			if(Ticks>0) Ticks--
		del src