class ChargeMagic extends ContextObject{
    var timelabel;
    var lock;
    var qlabel;
    var qfiller;
    var element;
    var flagquick;
    var moneylabel;
    var moneylabel1;
    var costcae;
    function ChargeMagic(){
        contextname = "dialog-charge-magic";
        contextNode = null;
        element = null;
        lock =0;
        flagquick = 0;
    }

    function getelement(){
        if(element == null){
            element = node();
            element.addlabel("充满魔法值", null, 24, FONT_BOLD).color(0, 0, 0, 100).pos(225, 58);
            element.addsprite("objectblock.png").anchor(50,50).pos(109, 121);
            element.addsprite("chargeLeft.jpg").anchor(50, 50).pos(109, 121);


            var qback = element.addsprite("chargeBack.png").anchor(0, 0).pos(210,110);
            qfiller = element.addsprite("magic_bar.png").anchor(0, 0).pos(214,113).size(0,18);
            qlabel = qfiller.addlabel("0",null,20).color(0,0,0,100).anchor(50,50).pos(75,12);

            timelabel = element.addlabel("", null, 18).color(0, 0, 0, 100).anchor(50, 50).pos(285, 151);
            global.timer.addlistener(global.timer.currenttime+999999,self);
        }
        return element;
    }
    
    function paintNode(){
        var dialog = new Simpledialog(1,self);
        dialog.init(dialog,global);
        contextNode = dialog.getNode();
        dialog.usedefaultbutton(2,["充满","取消"]);
        var cae = sprite("caesars_big.png").anchor(50,50).pos(56,228).size(40,40);
        moneylabel1 = cae.addlabel("",null,30,FONT_BOLD).pos(22,13).color(0,0,0,100);
        moneylabel = cae.addlabel("",null,24,FONT_BOLD).pos(25,16).color(100,100,100,100);
        contextNode.add(cae,4);
        timerefresh();
    }

    function excute(p){
        if(lock == 0){
            var cost = dict();
            cost.update("caesars",costcae);
            if(global.user.testCost(cost)==0){
                return 0;
            }
            lock = 1;
            contextNode.get(1).setevent(EVENT_UNTOUCH,null);
            var mana = global.user.getValue("mana");
            var boundary = global.user.getValue("boundary");
            if(mana < boundary)
                global.http.addrequest(1,"buymana",["userid"],[global.userid],self,"speedbegin");
            else
                global.popContext(null);
        }
    }
    
    function useaction(p,rc,c){
        if(p=="speedbegin"){
            speedbegin(0,rc,c);
        }
    }

    function speedbegin(r,rc,c){
        trace("buymana",rc,c);
        if(rc != 0){
            flagquick = 1;
            var mana = global.user.getValue("mana");
            var boundary = global.user.getValue("boundary");
            global.user.changeValue("mana", boundary-mana);
            qlabel.removefromparent();
            qfiller.addaction(sizeto(600,144,18));
        }
        else
            lock=0;
    }

    var timeisend=0;
    function timeend(){
        global.popContext(null);
    }
    function timerefresh(){
        if(flagquick == 0){
            var mana = global.user.getValue("mana");
            var boundary = global.user.getValue("boundary");
            costcae = (boundary-mana+2)/3;
            moneylabel.text(str(costcae));
            moneylabel1.text(str(costcae));
            qlabel.text(str(mana)+"/"+str(boundary));
            trace("charge mana", mana, boundary);
            qfiller.size(mana * 144/boundary,18);
            var lefttime = (boundary - mana)*300;
            timelabel.text("剩余时间 "+global.gettimestr(lefttime));
        }
        else if(flagquick < 2){
            flagquick++;
        }
        else if(flagquick == 2){
            global.user.changeValueAnimate2(global.context[0].moneyb,"caesars",-costcae,0);
            global.popContext(null);
            //global.timer.removelistener(self);
            lock = 0;
            timeisend=1;
        }
    }

    function reloadNode(re){
    }

    function deleteContext(){
        timeisend = 1;
        contextNode.addaction(stop());
        contextNode.removefromparent();
    }
}
