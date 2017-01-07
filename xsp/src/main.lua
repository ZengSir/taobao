
step = 1;

function main ()
  require("util");
  
  sysLog("开始任务");
  toast("开始任务");
  
  --设置需要开始操作的时间
  local beginTimeStamp = os.time({day=7, month=1, year=2017, hour=15, min =20, sec=0});
  
  init("0", 0);
  
  while true do
    
    local netTime = getNetTime();
		--[[
		local localTime = os.time();
    sysLog("网络时间："..netTime.."     "..os.date("%c",netTime));
    sysLog("本地时间："..localTime.."     "..os.date("%c",localTime));
		sysLog("任务时间："..beginTimeStamp.."     "..os.date("%c",beginTimeStamp));
		
		
		netTime = getNetTime();
		localTime = os.time();
		sysLog("网络时间："..netTime.."     "..os.date("%c",netTime));
    sysLog("本地时间："..localTime.."     "..os.date("%c",localTime));
		sysLog("任务时间："..beginTimeStamp.."     "..os.date("%c",beginTimeStamp));
    --]]
		
    --判断是否到了开始时间
    if netTime >= beginTimeStamp then
      sysLog("到了指定时间，开始执行任务");
      doTask();
      break;
    end
    
    --开始执行操作
    sysLog("循环等待0.01秒")
    mSleep(10);
  end
  
end



function doTask ()
	local beginClock = os.clock();
  sysLog("任务开始时间："..beginClock);
  while true do
    
    sysLog("step = :"..step);
    --判断是否是需要秒杀的商品
    if step == 1 then
      if isRightProduct() then
        tap(600, 635);
        step = 2;
        
      else
        dialogRet("该页面没有检测到指定商品信息", "确定", "", "", 5);
        mSleep(1000);
        lua_exit();
      end
    end
    
    --判断是否可以立即购买
    if step == 2 then
      
      if isCanBuy() then
				local canBuyClock = os.clock();
				sysLog("识别出购买按钮时间："..canBuyClock);
				sysLog("相差时间："..(canBuyClock - beginClock))
			
        tap(1056, 2133);
        step = 3;
        
      end
    end
    
    --判断是否可以提交订单
    if step == 3 then
		
      if isCanSubmit() then
        tap(1079,2149);
        step = 4;
					local submitClock = os.clock();
					sysLog("点击提交按钮时间："..submitClock);
					sysLog("距离开始时间："..(submitClock - beginClock));
      end
    end
    
    
    if step == 4 then
      if isSucced() then
				local endClock = os.clock();
				sysLog("识别出订单提交成功时间："..endClock);
				sysLog("总计时间："..(endClock - beginClock))
				
        dialogRet("已经成功提交订单，请自行确认并支付", "确定", "", "", 5);
        mSleep(1000);
        lua_exit();
      end
    end
    
		mSleep(100);
  end
end


function isRightProduct () 
  
  local lines = {};
  --太平鸟  061b27-111111
  lines[1] = "002004008010020040080100200400801002004008031FEFFDF9801002004008010020040080100200400801002004008010000000000000000000080100200410871062004008010020040080100200400FF1FE20040080100200400801002004008310E208400801000000000000000000000000000000000000001F83F040080100200C0F87F0F6004008010020040080100200400801003F07E$太平鸟$0.6.615$38";
  lines[2] = "300600600600E00E00C0000000000000100E0783C3F07E00400801002004008010020040080100200400801F03E0000000000000000000000180300600C0180300600C0180303FC7F8180300600C0180318630C0180300600C0FF1FE0600C0180300600C0180300600C0000000000000000000007E0FC18020040080100200400801002004008010620FC07803002004008010020040080100200400801003007E0FC000000000000000000001C0F8FC3F04C0080100200401C3FF7FE0400801002004008010020000000000000FC1F83F00000000000000001FFBFF$泡芙定制$1.0.1248$38";
  
  --加载自定义字库
  local dic = createOcrDict(lines);
  local results = ocrText(dic,378,448,1193,702, {"0x061b27-0x111111"}, 95,0,0);
  sysLog("识别出来的文字是："..results);
  if results == "太平鸟" or results == "泡芙定制" then
    return true;
  end
  
  return false;
end

function isCanBuy () 
  
  local lines = {};
  --立即购买  f4eedc-444444
  lines[1] = "01E03C0780F01E03C0780F01E03C0780F01E03C0780F71EFFFFFFFFFFE3FC0780F01E03C0780F01E03C0780F01E03C0780F01E03C0780F00000000000000000000003FE7FCFF9FF3FE700E01C0380700E01C0380700F01FF3FE7FCFF800000000000003FE7FCFF9FF3E0780F01E03C0780F01E03FE7FCFF9FF00000000000000000000003FE7FCFF9F03C0780F19E33C678CF01E03E07FCFF9FF0000000000303E3FFFFFFFFFFF7C0780F01E03C0780F01E03C0780F01E03C0780F01E0000000000000000000000780F01E03C0780F01E33C678CF09E13C2780F01E03C0780F01E03C078CF19E33C6780F01E03C0780F01E03C67FCFF9FF3FC7C0$立即购买$2.3.3042$44";
  
  --加载自定义字库
  local dic = createOcrDict(lines);
  local results = ocrText(dic,883,2065,1239,2203, {"0xf4eedc-0x444444"}, 95,0,0);
  sysLog("识别出来的文字是："..results);
  if results == "立即购买" then
    return true;
  end
  
  return false;
end

function isCanSubmit () 
  
  local lines = {};
  --提交订单  f4eedc-444444
  lines[1] = "00600C0180300600FFFFFFFFE00C0180300600C00000000000FF9FF3FE60CC198330660CC198330660CC198330660CC19FF3FE7FC0000000000000000000000000000380700E01C0380700E01C0380700E01C0380700E01C0390738E7FCFF87F03E03C0380700E01C0380700E01C0380700E01C0380700E01C038070000000000000000000000000100700F00F00F01F01F01F01C010000000001C0380700E01C0380700E01C0380700E01C03807F8FF1FE380700E01C0380700E01C038070000000000000000000000000000003C0780F01E0390778EF9CFB8FF07E05C0380700F01E03C0780E01C0783F1FEFFDF3BC720E01C03C0780F01E$提交订单$1.5.2199$44";
  
  --加载自定义字库
  local dic = createOcrDict(lines);
  local results = ocrText(dic,883,2065,1239,2203, {"0xf4eedc-0x444444"}, 95,0,0);
  sysLog("识别出来的文字是："..results);
  if results == "提交订单" then
    return true;
  end
  
  return false;
end

function isSucced ()
  
  local lines = {};
  --确认付款  f4eedc-444444
  lines[1] = "1E03C0780F01E03C0798FF1FE3FC7C0F01E03C0780F01E03C0780F00000000000300E03C1F87E3F9FE3F87F0EE01C0380700E01C0380710E61FC3F87F0F81E00000000000000000000000000000000000000000000000000300F01F01F01E01E03E03E03E03C0300000000000000000000000000000000000000000000000000007FFFFFFFFFFC000000000000000000000000000000000000000000000000000000000000000000000000000000000100E07C7FBFFFF9FC1C0000000000000000000000000000000000000000000000000000000000000000000000FFFFFFFFFFF000000000000000000000000000000000000000000380700E01C0380700E01C0380700E01C03CFFFFFFFFFFF0700E01C0380700E01C0380700E00C000000000000071FFFFFFFBF300600C0180300600C0180300600C0180300600C018$确认付款$1.2.3338$54";
  --加载自定义字库
  local dic = createOcrDict(lines);
  local results = ocrText(dic,339,2023,853,2147, {"0xf4eedc-0x444444"}, 95,0,0);
  sysLog("识别出来的文字是："..results);
  if results == "确认付款" then
    return true;
  end
  
  return false;
end

-- lua异常捕捉
function error(msg)
  local errorMsg = "[Lua error]"..msg
  printFunction(errorMsg)    
end

--退出时隐藏HUD
function beforeUserExit()
  hideHUD(runing)
  hideHUD(troopsDonated)
end

main();
--xpcall(main, error)