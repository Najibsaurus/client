import element.OnekeyController;
import element.Devinedialog;
import element.QuickControl;
import element.PlantControl;
import element.UpdateControl;
import element.SoldierControl;
import element.Warningdialog;
import element.Saledialog;
import element.Nestpetchange;
import element.Nestpetchange2;
import element.Nestpetdialog;
import element.WoodControl;
import element.StoneControl;
class BuildControl extends ContextObject{
    var place;
    var placeObj;
    var mode;
    var timelabel;
    var buttons;
    function BuildControl(m,f){
        contextname = "control-build";
        mode = m;
        contextNode = null;
        place = f;
        if(mode >= 0) placeObj = place.baseobj;
        else placeObj = place;
        timelabel = null;
    }

    function paintNode(){
        buttons = new Array(0);
        contextNode = sprite().pos(400,240);
        
        var beginx;
        if(placeObj.buildcontextname!="obj"){
            var back = sprite("buildcontrolback2.png").anchor(50,100).pos(0,9);
            contextNode.add(back,0,111);
            var bl=90;
            if(placeObj.contextid == 3){
                bl = 60;
                if(mode == 3 && place.state==3){
                    bl=100;
                }
                if(placeObj.objectid>171 && placeObj.objectid<200){
                    bl=50;
                }
            }
            else if(placeObj.buildcontextname == "god"){
                bl = 35;
                if(place.bid>=20){
                    bl=40;
                }
            }
            else if(mode==6){
                bl=50;
            }
            if(placeObj.buildcontextname!="nest"){
                back.addsprite(place.gettexture()).anchor(50,50).pos(107,55).scale(bl);
                var namelabel = back.addlabel(global.getname(placeObj.buildcontextname,placeObj.objectid%100),null,20).anchor(50,50).pos(107,123).color(0,0,0,100);
                if(place.state == 1 || place.state == 3){
                    if((mode!=4&&mode!=6) || place.state!=3 ){
                        buttons.append(0);
                    }
                    timelabel = back.addlabel("",null,20).anchor(100,50).pos(197,158).color(0,0,0,100);
                    timelabel.addaction(repeat(callfunc(updatetime),delaytime(1000)));
                    var labelstr = "建筑中";
                    if(place.state == 3){
                        if(mode == 0) labelstr = "招募中";
                        else if(mode == 1) labelstr = "生产中";
                        else if(mode == 2) labelstr = "训练中";
                        else if(mode == 3){
                            if(place.bid<5){
                                labelstr = "种植中";
                                namelabel.text(global.getname("plant",place.objid));
                            }
                            else if(place.bid == 5){
                                labelstr = "砍伐中";
                                namelabel.text(global.getname("wood",place.objid));
                            }
                            else{
                                labelstr = "开采中";
                                namelabel.text(global.getname("stone",place.objid));
                            }
                        }
                        else if(mode == 6){
                            labelstr = "生产城防中";
                        }
                        else {
                            labelstr = "祝福中";
                            buttons.append(-10);
                        }
                    }
                    back.addlabel(labelstr,null,20).anchor(0,50).pos(18,158).color(56,1,1);
                }
                else{
                    if(mode== 0){
                        buttons.append(6);
                    }
                    else if(mode == 2){
                        buttons.append(place.bid/3+7);
                    }
                    else if(mode == 3){
                        if(place.bid<5){
                            buttons.append(3);
                        }
                        else if(place.bid==5){
                            buttons.append(4);
                        }
                        else if(place.bid==6){
                            buttons.append(5);
                        }
                    }
                    else if(mode == 4){
                        buttons.append(10);
                    }
                    back.addlabel("空闲中",null,20).anchor(0,50).pos(18,158).color(1,17,56);
                }
                if(place.state>=2 && mode != 3 && mode!=6 && ((mode!=4 &&place.bid%3!=2) ||(mode==4 && (place.bid<16||place.bid>=20&&place.bid%5!=4)))){
                    buttons.append(1);
                }
                else if(mode==4 &&place.state>=2 && (place.bid==16||place.bid==18||place.bid==24)){
                    buttons.append(17);
                }
                beginx = -119;
            }
            else{
                namelabel = back.addlabel(global.data.getbuild(place.bid).get("name"),null,20).anchor(50,50).pos(107,123).color(0,0,0,100);
                if(place.state>=3){
                    //var maxs = hmax;
                    //var hmaxs=[3,5,7];
                    var max;
                    if((place.state - 3) < len(hmax))
                        max = hmax[place.state-3];
                    else
                        max = hmax[len(hmax)-1];
                    //var hmax;
                    var add;
                    if((place.state-3) < len(hmaxs))
                        add = hmaxs[place.state-3];
                    else
                        add = hmaxs[len(hmaxs)-1];
                    var stt = place.health/(max/3);
                    if(stt>2) stt=2;
                    if(place.state==3){
                        back.add(sprite("egg-"+str(stt+1)+".png").anchor(50,0).pos(107,7),1,111);
                        back.addlabel("孵化中",null,18).anchor(100,50).pos(197,123).color(1,17,56);
                    }
                    else if(place.state==4){
                        var pstr = EXTEND_NAME[place.extendid]+"-";
                        back.add(sprite(pstr+"7.png").anchor(50,0).pos(107,7).scale(70),1,111);
                        back.addlabel("成长中",null,18).anchor(100,50).pos(197,123).color(1,17,56);
                    }
                    else if(place.state >= 5){
                        pstr = EXTEND_NAME[place.extendid]+"-";
                        back.add(sprite(pstr+"1-1.png").anchor(50,50).pos(107,57).scale(70),1,111);
                        back.addlabel("成长中",null,18).anchor(100,50).pos(197,123).color(1,17,56);
                    }
                    var l=back.addlabel(str(place.attack),null,20).anchor(100,50).pos(197,94).color(0,0,0,100);
                    l.prepare();
                    back.addsprite("power.png").anchor(100,50).pos(195-l.size()[0],94);
                    namelabel.anchor(0,50).pos(18,123).text(place.petname).scale(90);
                    buttons.append(23);
                    if(global.context[0].flagfriend == 1){
                        if(place.health>=max||len(place.helpfriends)>=add||place.helpfriends.index(ppy_userid())!=-1||global.user.getValue("food")<20){
                            buttons[0] = -23;
                        }
                    }
                    else{
                        if(place.feeded==1 || global.user.getValue("food")<20*add){
                            buttons[0] = -23;
                        }
                        if(place.state==5&&place.health<285){
                            buttons.append(-21);
                        }
                        else{
                            buttons.append(21);
                        }
                    }
                    buttons.append(19);
                        //buttons.append(21);
                    if(place.health>=max){
                        back.addsprite("nestpetfiller2.png",ARGB_8888).pos(11,146).size(190,24);
                        timelabel = back.addlabel("MAX",null,20).anchor(50,50).pos(107,158).color(0,0,0,100);
                    }
                    else{
                        back.addsprite("nestpetfiller"+str(stt)+".png",ARGB_8888).pos(11,146).size(190*place.health/max,24);
                        timelabel = back.addlabel(str(place.health)+"/"+str(max),null,20).anchor(50,50).pos(107,158).color(0,0,0,100);
                    }
                }
                else{
                    back.addsprite(place.gettexture()).anchor(50,50).pos(107,55).scale(bl);
                    buttons.append(25);
                    back.addlabel("空闲中",null,20).anchor(0,50).pos(18,158).color(1,17,56);
                }
                beginx = -119;
            }
        }
        else{
            back = contextNode.addsprite("buildcontrolback1.png").anchor(50,100).pos(0,9);
            back.addlabel(global.getname("obj",placeObj.objectid-500),null,20).anchor(50,50).pos(71,123).color(0,0,0,100);
            bl=100;
            if(placeObj.objectid==541){
                bl=50;
            }
            else if(placeObj.contextid==2){
                bl=75;
            }
            back.addsprite("object"+str(placeObj.objectid-500)+".png").anchor(50,50).pos(71,55).scale(bl);
            beginx = -83;
        }
        if(placeObj.objectid<1000&&mode!=4)
            buttons.append(2);
        for(var k=0;k<len(buttons);k++){
            var filter = NORMAL;
            var buttonid = buttons[k];
            if(buttonid>16&&buttonid%2==0){
                trace("wrong buttonid",buttonid);
                buttons[k]=1-buttonid;
                buttonid = buttons[k];
            }
            if(buttonid<0){
                buttonid=-buttonid;
                filter = GRAY;
            }
            var bt = contextNode.addsprite("buttontab0.png",filter).pos(73*k+beginx,0);
            bt.addsprite("opbutton"+str(buttonid)+".png",filter).anchor(50,50).pos(46,46);
            bt.setevent(EVENT_TOUCH,buttonclicked,k);
            bt.setevent(EVENT_UNTOUCH,buttonclicked,k);
        }
    }

    function buttonclicked(n,e,p){
        var filter = NORMAL;
        if(buttons[p]>16&&buttons[p]%2==0){
            filter = GRAY;
        }
        if(global.currentLevel == contextLevel){
            if(e==EVENT_TOUCH)
                n.texture("buttontab1.png",filter);
            else{
                n.texture("buttontab0.png",filter);
                if(buttons[p] != 6)
                    global.popContext(null);
                if(buttons[p] == 0)
                    global.pushContext(place,new QuickControl(),NonAutoPop);
                else if(buttons[p] == 1){
                    global.pushContext(place,new UpdateControl(),NonAutoPop);
                }
                else if(buttons[p] == 2)
                    global.pushContext(self,new Saledialog(placeObj),NonAutoPop);
                else if(buttons[p] == 3)
                    global.pushContext(place,new PlantControl(),NonAutoPop);
                else if(buttons[p] == 4)
                    global.pushContext(place,new WoodControl(),NonAutoPop);
                else if(buttons[p] == 5)
                    global.pushContext(place,new StoneControl(),NonAutoPop);
                else if(buttons[p] == 6)
                    global.popContext(1);
                else if(buttons[p] == 10)
                    global.pushContext(place,new Devinedialog(),NonAutoPop);
                else if(buttons[p] == -10){
                    global.pushContext(place,new Warningdialog([global.getStaticString("god_bless_over"),null,5]),NonAutoPop);
                }
                else if(buttons[p] == 17){
                    var tmp=[0,0,1,0,2];
                    var btype = place.bid%4;
                    if(place.bid>=20){
                        btype=place.bid/5;
                    }
                    global.pushContext(null,new OnekeyController(tmp[btype]),NonAutoPop);
                }
                else if(buttons[p] == -17){
                    global.pushContext(null,new Warningdialog([global.getStaticString(14),null,4]),NonAutoPop);
                }
                else if(buttons[p] == 23){
                    global.http.addrequest(1,"feed",["uid","gid","cid"],[global.userid,placeObj.posi[0]*RECTMAX+placeObj.posi[1],global.context[0].ccid],place,"feed");
                }
                else if(buttons[p] == -23){
                    var maxs=[51,201,831];
                    var hmaxs=[3,5,7];
                    var max = maxs[place.state-3];
                    var hmax= hmaxs[place.state-3];
                    if(global.context[0].flagfriend == 1){
                        if(len(place.helpfriends)>=hmax){
                            global.pushContext(null,new Warningdialog([global.getFormatString(39,["[NAME]",global.getfriend(global.context[0].cpid).get("name"),"[NUM]",str(hmax)]),null,5]),NonAutoPop);
                        }
                        else if(place.helpfriends.index(ppy_userid())!=-1){
                            global.pushContext(null,new Warningdialog([global.getStaticString(38),null,5]),NonAutoPop);
                        }
                        else if(place.health>=max){
                            global.pushContext(null,new Warningdialog([global.getStaticString(37),null,5]),NonAutoPop);
                        }
                        else{
                            global.user.testCost(dict([["food",20]]));
                        }
                    }
                    else{
                        if(place.feeded==1){
                            global.pushContext(null,new Warningdialog([global.getStaticString(36),null,5]),NonAutoPop);
                        }
                        else{
                            global.user.testCost(dict([["food",hmax*20]]));
                        }
                    }
                }
                else if(buttons[p] == 19){
                    place.istrain=1;
                    place.executeAnimate();
                    place.istrain=0;
                }
                else if(buttons[p] == -21){
                    global.pushContext(null,new Warningdialog([global.getStaticString("nest_style_cannotchange"),null,5]),NonAutoPop);
                }
                else if(buttons[p] == 21){
                    if(place.state==3){
                        global.pushContext(place,new Nestpetchange(place),NonAutoPop);
                    }
                    else if(place.state>=4){
                        global.pushContext(place,new Nestpetchange2(place),NonAutoPop);
                    }
                }
                else if(buttons[p] == 25){
                    global.pushContext(place,new Nestpetdialog(),NonAutoPop);
                }
                else
                    global.pushContext(place,new SoldierControl(buttons[p]-7,place.bid%3),NonAutoPop);
            }
        }
    }

    function updatetime(){
        var lefttime = place.lefttime;
        timelabel.text(global.gettimestr(lefttime));
        if(lefttime == 0){
            global.popContext(null);
        }
    }

    function reloadNode(re){
        if(re==1){
            placeObj.reloadNode(1);
        }
    }


    function deleteContext(){
        contextNode.addaction(stop());
        contextNode.removefromparent();
        if(timelabel!=null){
            timelabel.addaction(stop());
            timelabel.removefromparent();
        }
    }
}
