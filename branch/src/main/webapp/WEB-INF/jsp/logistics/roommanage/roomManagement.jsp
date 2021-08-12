<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>

<style type="text/css">

/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-left {
    text-align:left;
}

/* 커스컴 disable 스타일*/
.mycustom-disable-color {
    color : #cccccc;
}

/* 그리드 오버 시 행 선택자 만들기 */
.aui-grid-body-panel table tr:hover {
    background:#D9E5FF;
    color:#000;
}
.aui-grid-main-panel .aui-grid-body-panel table tr td:hover {
    background:#D9E5FF;
    color:#000;
}


</style>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.blockUI.min.js"></script>


<script src="${pageContext.request.contextPath}/resources/js/daypilot-all.min.js" type="text/javascript"></script>

<script type="text/javaScript" language="javascript">


    // AUIGrid 생성 후 반환 ID
    var myGridID;
    
    var comboData = [{"codeId": "1","codeName": "Active"},{"codeId": "8","codeName": "Inactive"}];
    
    var url;
    var addmonth = 0;
    var dp = new DayPilot.Month("dp");
    var addOrEditChck;
    var newRoomId;
    // AUIGrid 칼럼 설정                                                                            visible : false
    var columnLayout = [
		{dataField:   "rumId",headerText :"<spring:message code='log.head.roomid'/>"        ,width:   "15%"     ,height:30 , visible:true},               
		{dataField: "rumCode",headerText :"<spring:message code='log.head.roomcode'/>"      ,width: "20%"    ,height:30 , visible:true},                
		{dataField: "rumName",headerText :"<spring:message code='log.head.roomname'/>"      ,width: "35%"    ,height:30 , visible:true},                
		{dataField: "stusId",headerText :"<spring:message code='log.head.status'/>"        ,width:  "15%"    ,height:30 , visible:true  
                        	,labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) { 
                                var retStr = value;
                                for(var i=0,len=comboData.length; i<len; i++) {
                                    if(comboData[i]["codeId"] == value) {
                                        retStr = comboData[i]["codeName"];
                                        break;
                                    }
                                }
                                return retStr;
                            }},
                            {dataField: "cpcty",headerText :"<spring:message code='log.head.capacity'/>"         ,width:    "15%"    ,height:30 , visible:true},                
                            {dataField: "advTmInMin",headerText :"<spring:message code='log.head.advtminmin'/>"    ,width:90 ,height:30 , visible:false},                       
                            {dataField: "brnchId",headerText :"<spring:message code='log.head.brnchid'/>"         ,width:120 ,height:30 , visible:false},                       
                            {dataField: "advOptnId",headerText :"<spring:message code='log.head.advoptnid'/>"       ,width:140 ,height:30 , visible:false},                         
                            {dataField: "hasImg",headerText :"<spring:message code='log.head.hasimg'/>"        ,width:120 ,height:30 , visible:false}  
                       ];
    
    
 /* 그리드 속성 설정
  usePaging : true, pageRowCount : 30,  fixedColumnCount : 1,// 페이지 설정
  editable : false,// 편집 가능 여부 (기본값 : false) 
  enterKeyColumnBase : true,// 엔터키가 다음 행이 아닌 다음 칼럼으로 이동할지 여부 (기본값 : false)
  selectionMode : "multipleCells",// 셀 선택모드 (기본값: singleCell)                
  useContextMenu : true,// 컨텍스트 메뉴 사용 여부 (기본값 : false)                
  enableFilter : true,// 필터 사용 여부 (기본값 : false)            
  useGroupingPanel : true,// 그룹핑 패널 사용
  showStateColumn : true,// 상태 칼럼 사용
  displayTreeOpen : true,// 그룹핑 또는 트리로 만들었을 때 펼쳐지게 할지 여부 (기본값 : false)
  noDataMessage : "출력할 데이터가 없습니다.",
  groupingMessage : "여기에 칼럼을 드래그하면 그룹핑이 됩니다.",
  rowIdField : "stkid",
  enableSorting : true,
  showRowCheckColumn : true,
  */
    var gridoptions = {showStateColumn : false , 
		                     editable : false,
		                     noDataMessage : "<spring:message code='sys.info.grid.noDataMessage'/>", 
		                     pageRowCount : 20, 
		                     usePaging : true, 
		                     useGroupingPanel : false,
		                     enableSorting : true,
		                     softRemoveRowMode:false};
    
    

    $(document).ready(function(){
        // masterGrid 그리드를 생성합니다.
        myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,"", gridoptions);
        
        doDefCombo(comboData, 1 ,'searchstatus', 'A', '');
          
        doGetComboSepa('/common/selectBranchCodeList.do', '3' , ' - ' , '','searchbranchid', 'S' , ''); //청구처 리스트 조회
                
        
        AUIGrid.bind(myGridID, "cellClick", function( event )  
        {
            
        });
        
        // 셀 더블클릭 이벤트 바인딩
        AUIGrid.bind(myGridID, "cellDoubleClick", function(event) 
        {
        	var param = {roomid    : event.item.rumId , addmonth:addmonth};
        	searchRoomBooking(param);
        	$("#openwindow").show();
        });
       
        $(function(){
            //all select 값 주기
            $("#search").click(function(){
	           var min = $("#searchmin").val().trim(); 
	           var max = $("#searchmax").val().trim();
            	if("" != min || "" != max){
            		if("" == min){
	            		Common.alert("Please Check From Capacity.");	
	                    $("#searchmin").focus();   
	                    return false;
            		}
            		if("" == max){
	            		Common.alert("Please Check To Capacity.");	
	                    $("#searchmax").focus();   
	                    return false;
            		}
	            	 if(min  >  max){
	            		Common.alert("From Capacity Can't be larger than To Capacity.");	
	                    $("#searchmin").focus();   
	                    return false;
	            	 }
	            	 if(min  ==  max){
	            		Common.alert("From Capacity and To Capacity are Same.");	
	                    $("#searchmin").focus();   
	                    return false;
	            	 }
            	}
            	getListAjax();    
            });
            $("#clear").click(function(){
            });
            $("#closebtn").click(function(){
            	$("#openwindow").hide();
            });
            $("#add").click(function(){
            	addOrEditChck="add";
            	 doGetComboSepa('/common/selectCodeList.do', '89' , '' , '','newOption', 'S' , ''); 
            	 doGetComboSepa('/common/selectBranchCodeList.do', '3' , ' - ' , '','newbranchid', 'S' , ''); 
            	 $("#popup_title").text("Conference Room Management - New Conference Room");
            	 $("#editTr").hide();
            	 $("#deActive").hide();
            	 $("#popup_wrap_new").show();
            	 $("#roomId").val("NEW");
                 $("#RoomStatus").val(""); 
                 $("#newRoomCd").val(""); 
                 $("#newRoomNm").val(""); 
                 $("#newCapacity").val(""); 
                 $("#description").val(""); 
                 $("#newBookingTm").val("");   
            	 
            });
            $("#edit").click(function(){
            	addOrEditChck="edit";
            	  var selectedItem = AUIGrid.getSelectedIndex(myGridID);
            	  if(0>selectedItem[0]){
            		   Common.alert("Please select a data.");
            		 return false; 
            	  }
            	   var rumId =AUIGrid.getCellValue(myGridID ,selectedItem[0],'rumId');
            	   var stusId =AUIGrid.getCellValue(myGridID ,selectedItem[0],'stusId');
            	   if(1==stusId){
            		   $("#deActive").text("DeActivate");
            	   }else{
            		   $("#deActive").text("Activate");
            	   }
            	   fn_getRoomData(rumId,"E");
            	 $("#popup_title").text("Conference Room Management - Edit Conference Room");
            	 $("#editTr").show();
            	 $("#deActive").show();
            	 $("#popup_wrap_new").show();
            });
            $("#picture").click(function(){
            	 var selectedItem = AUIGrid.getSelectedIndex(myGridID);
                if(0>selectedItem[0]){
                    Common.alert("Please select a data.");
                  return false; 
               }
                var rumId =AUIGrid.getCellValue(myGridID ,selectedItem[0],'rumId');
                fn_getRoomData(rumId,"P");
            	 $("#popup_wrap_picture").show();
            });
            $("#view").click(function(){
            	 var selectedItem = AUIGrid.getSelectedIndex(myGridID);
                if(0>selectedItem[0]){
                    Common.alert("Please select a data.");
                  return false; 
               }
                var rumId =AUIGrid.getCellValue(myGridID ,selectedItem[0],'rumId');
                fn_getRoomData(rumId,"V");
            	 $("#popup_wrap_view").show();
            });
            
            
            $("#bfmonth").click(function(){
            	var selectedItems = AUIGrid.getSelectedItems(myGridID);
            	addmonth = addmonth-1;
            	var param = {roomid    : selectedItems[0].item.rumId , addmonth:addmonth};
            	var url = "/misc/room/roomBookingList.do";
            	
                Common.ajax("GET" , url , param , function(data){
                    var list= data.dataList
                    
                    dp.startDate = list[0].nowdate;
                    dp.update();
                });
            	
                
            });
            $("#atmonth").click(function(){
            	var selectedItems = AUIGrid.getSelectedItems(myGridID);
                console.log(selectedItems);
            	addmonth = addmonth+1;
                var param = {roomid    : selectedItems[0].item.rumId , addmonth:addmonth};
                
                var url = "/misc/room/roomBookingList.do";
                Common.ajax("GET" , url , param , function(data){
                    var list= data.dataList
                    
                    dp.startDate = list[0].nowdate;
                    dp.update();
                });
            });
            $("#now").click(function(){
            	var selectedItems = AUIGrid.getSelectedItems(myGridID);
                console.log(selectedItems);
                addmonth = 0;
                var param = {roomid    : selectedItems[0].item.rumId , addmonth:addmonth};
                var url = "/misc/room/roomBookingList.do";
                Common.ajax("GET" , url , param , function(data){
                    var list= data.dataList
                    
                    dp.startDate = list[0].nowdate;
                    dp.update();
                });
            });
           $("#saveNew").click(function(){
        	   
        	   var str="";
        	   if(""==$("#newRoomCd").val()){
        		   Common.alert("Please Check Room Code.");
        		    return false;        		   
        	   }
        	   if(""==$("#newRoomNm").val()){
        		   Common.alert("Please Check Room Name.");
        		    return false;      
        	   }
        	   if(""==$("#newOption").val()){
        		   Common.alert("Please Check Advance Booking Option.");
        		    return false;        		   
        	   }
        	   if(""==$("#newBookingTm").val()){
        		   Common.alert("Please Check Advance Booking Time.");
        		    return false;        		   
        	   }
        	   if(""==$("#newCapacity").val()){
        		   Common.alert("Please Check Capacity.");
        		    return false;        		   
        	   }
        	   if(""==$("#newbranchid").val()){
        		   Common.alert("Please Check Branch.");
        		    return false;        		   
        	   }
        	   
        	   fn_saveNewEdit();
           });    
           $("#deActive").click(function(){
        	    fn_deActive();
           });    
    });
    });
    
    
    function getListAjax() {
        var url = "/misc/room/roomManagementList.do";
        var param = $("#searchForm").serializeJSON();
        Common.ajax("POST" , url , param , function(data){
            var list= data.dataList
            AUIGrid.setGridData(myGridID, list);
        });
    }
    
    function searchRoomBooking(param){
    	var url = "/misc/room/roomBookingList.do";
    	
    	Common.ajax("GET" , url , param , function(data){
            var list= data.dataList
            schedulerfunc(list);
        });
    	
    }
    
    function schedulerfunc(data){
    	//$("#dp").empty();
    	dp.cellMarginBottom = 20;
//        dp.bubble = new DayPilot.Bubble({
//            onLoad: function(args) {
//                var ev = args.source;
//                args.html = "testing bubble for: " + ev.text();
//            }
//        });

        // view
        dp.startDate = data[0].nowdate;
        $("#now").html(data[0].nowdate);

        // generate and load events
        for (var i = 0; i < data.length; i++) {
            var e = new DayPilot.Event({
                start: new DayPilot.Date(data[i].bookfrom),
                end: new DayPilot.Date(data[i].bookto),
                id: DayPilot.guid(),
                text: data[i].bookTitle,
                tags: {
                    url: "myurl"
                }
            });
            dp.events.add(e);
        }

        // event moving
        dp.onEventMoved = function (args) {
            console.log("Moved: " + args.e.text());
        };

        // event resizing
        dp.onEventResized = function (args) {
            console.log(args);
            console.log("Resized: " + args.e.text());
        };

        dp.onBeforeHeaderRender = function(args) {

        };

        dp.onBeforeEventRender = function(args) {
            //args.data.fontColor = "red";
        };

        // event creating
        dp.onTimeRangeSelected = function (args) {
            var name = prompt("New event name:", "Event");
            dp.clearSelection();
            if (!name) return;
            var e = new DayPilot.Event({
                start: args.start,
                end: args.end,
                id: DayPilot.guid(),
                text: name
            });
            dp.events.add(e);
            console.log("Created");
        };
        
        dp.onEventClicked = function(args) {
            alert("clicked: " + args.e.tag("url"));
        };
        
        dp.onHeaderClicked = function(args) {
            alert("day: " + args.header.dayOfWeek);
        };

        dp.init();
    }

    function  fn_getRoomData(rumId,str){
        var url = "/misc/room/getEditData.do";
        var param = { rumId:rumId };
        Common.ajax("GET" , url , param , function(data){
            var data= data.dataList;
            fn_DateSet(data,str);
        });
    	
    }
       
    function fn_DateSet(data,str){
        var time;
        var viewTime;
        if (data[0].advOptnId == 707)//newBookingTm
         {
             //MONTH
             time = data[0].advTmInMin / 60 / 24 / 30;
             viewTime = time+" [ Month(s) ] ";
         }
         else if (data[0].advOptnId == 708)
         {
             //DAY
             time = data[0].advTmInMin / 60 / 24;
             viewTime = time+" [ Day(s) ] ";
         }
         else if (data[0].advOptnId == 709)
         {
             //HOUR
             time = data[0].advTmInMin / 60;
             viewTime = time+" [ Hour(s) ] ";
         }
         else if (data[0].advOptnId == 710)
         {
             //MINUTE
             time = data[0].advTmInMin;
             viewTime = time+" [ Minute(s) ] ";
         }
        if(str=="E"){
	    	$("#roomId").val(data[0].rumId);
	    	$("#RoomStatus").val(data[0].code);
	    	$("#newRoomCd").val(data[0].rumCode);
	    	$("#newRoomNm").val(data[0].rumName);
	    	$("#newCapacity").val(data[0].cpcty);
	    	$("#description").val(data[0].rumDesc);
	        doGetComboSepa('/common/selectCodeList.do', '89' , '' ,data[0].advOptnId,'newOption', 'S' , ''); 
	        doGetComboSepa('/common/selectBranchCodeList.do', '3' , ' - ' , data[0].brnchId,'newbranchid', 'S' , ''); 
	        $("#newBookingTm").val(time);	
        }else if(str=="V"){
	    	$("#viewRoomStatus").val(data[0].code);
	    	$("#viewRoomCd").val(data[0].rumCode);
	    	$("#viewRoomNm").val(data[0].rumName);
	    	$("#viewBranch").val(data[0].c3);
	    	$("#viewBookTm").val(viewTime);
	    	$("#viewCapacity").val(data[0].cpcty);
	    	$("#viewDescription").val(data[0].rumDesc);
        }else if(str=="P"){
	    	$("#picRoomId").val(data[0].rumId);
	    	$("#picRoomStatus").val(data[0].code);
	    	$("#picRoomCd").val(data[0].rumCode);
	    	$("#picRoomNm").val(data[0].rumName);
	    	$("#picBranch").val(data[0].c3);
	    	$("#picBookTm").val(viewTime);
	    	$("#picCapacity").val(data[0].cpcty);
	    	$("#picDescription").val(data[0].rumDesc);
        }
        	
    }
    
    function fn_saveNewEdit(){
    	var tmp = $("#newBookingTm").val();
    	var newAdvTimeInMinute;
        if ($("#newOption").val() == 707)
        {
            //MONTH
            newAdvTimeInMinute =  $("#newBookingTm").val().trim()  * 60 * 24 * 30;
        }
        else if ($("#newOption").val() == 708)
        {
            //DAY
            newAdvTimeInMinute = $("#newBookingTm").val().trim() * 60 * 24;
        }
        else if ($("#newOption").val() == 709)
        {
            //HOUR
            newAdvTimeInMinute = $("#newBookingTm").val().trim() * 60;
        }
        else if ($("#newOption").val() == 710)
        {
            //MINUTE
            newAdvTimeInMinute = $("#newBookingTm").val().trim();
        }
        
        
        
        var url = "/misc/room/saveNewEditData.do";
        var param = $("#popform").serializeJSON();
        $.extend(param,{'newAdvTimeInMinute':newAdvTimeInMinute });
        console.log(param);
        Common.ajax("POST" , url , param , function(data){
	        console.log(data);
	        newRoomId=data.data;
        	 $("#popup_wrap_new").hide();
        	if("add"==addOrEditChck){
	        	 Common.confirm("New conference room successfully saved.<br>Are you want to upload room picture ?",goPic,getListAjax);
        	}else{
	        	 Common.alert("Conference room successfully updated.");
	        	 getListAjax();
        	}
        });
        
    }
    function goPic(){
    	 fn_getRoomData(newRoomId,"P");
    	 $("#popup_wrap_picture").show();
    }
    function fn_deActive(){
       var status = $("#RoomStatus").val()
        var url = "/misc/room/updateDeActive.do";
        var param = $("#popform").serializeJSON();
        console.log(param);
        Common.ajax("POST" , url , param , function(data){
        	if("ACT"==status){
        	 Common.alert("Conference room has been deactivated.");
        	}else{
        	 Common.alert("Conference room has been re-activated.");
        	}
        	 $("#popup_wrap_new").hide();
            getListAjax();
        });
    	
    }
</script>
</head>
<div id="SalesWorkDiv" class="SalesWorkDiv" style="width: 100%; height: 960px; position: static; zoom: 1;">
<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Room Management</li>
    <li>List</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Room Management</h2>
<ul class="right_btns">
    <li><p class="btn_blue"><a id="search"><span class="search"></span>Search</a></p></li>
    <!-- <li><p class="btn_blue"><a id="clear"><span class="clear"></span>Clear</a></p></li> -->
</ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form id="searchForm" name="searchForm" method="post">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Room ID</th>
    <td>
    <input type="text" id="searchroomId" name="searchroomId"   placeholder="" class="w100p" />
    </td>
    <th scope="row">Room Code</th>
    <td>
     <input type="text" id="searchroomCd" name="searchroomCd"placeholder=""  class="w100p" />
    </td>
    <th scope="row">Room Name</th>
    <td>
    <input type="text" id="searchroomNm" name="searchroomNm" placeholder=""  class="w100p" />
    </td>
</tr>
<tr>
    <th scope="row">Status</th>
    <td>
    <select id="searchstatus" name="searchstatus"   title=""  class="w100p" >
    </select>
    </td>
    <th scope="row">Branch</th>
    <td>
    <select id="searchbranchid" name="searchbranchid" class="w100p" >
    </select>
    </td>
    <th scope="row">Capacity</th>
                    <td>
                    <div class="itemPriceDate w100p">
                        <p class="short"><input type="text" title="" placeholder="" class="w100p" id="searchmin" name="searchmin" /></p>
                        <span>To</span>
                        <p class="short"><input type="text" title="" placeholder="" class="w100p" id="searchmax" name="searchmax" /></p>
                    </div>
 </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
<dl class="link_list">
    <dt>Link</dt>
    <dd>
    <ul class="btns">
        <li><p class="link_btn"><a id="edit">Edit Conference Room</a></p></li>
        <li><p class="link_btn"><a id="picture">Upload New Conference Room Picture</a></p></li>
        <li><p class="link_btn"><a id="view">View Conference Room</a></p></li>
        <li><p class="link_btn"><a id="viewschedule">View Booking Schedule</a></p></li>
        <li><p class="link_btn"><a id="book">Book Conference Room</a></p></li>
        <li><p class="link_btn"><a id="viewbook">View Room Booking</a></p></li>
        <li><p class="link_btn"><a id="editbook">Edit Room Booking</a></p></li>
    </ul>
    <ul class="btns">
        <li><p class="link_btn type2"><a  id="add">Add New Conference Room</a></p></li>
        <li><p class="link_btn type2"><a  id="gobook">Go To Booking Management</a></p></li>
    </ul>
    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
    </dd>
</dl>
</aside><!-- link_btns_wrap end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->
<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grid_wrap"></div>
</article><!-- grid_wrap end -->

</section><!-- content end -->

<div class="popup_wrap" id="openwindow" style="display:none;height:300px"><!-- popup_wrap start -->
        <header class="pop_header"><!-- pop_header start -->
            <h1 id="dataTitle">Room Booking List</h1>
            <ul class="right_opt">
                <li><p class="btn_blue2"><a id="closebtn">CLOSE</a></p></li>
            </ul>
        </header><!-- pop_header end -->
        
        <section class="pop_body"><!-- pop_body start -->
            <div class="note"> <p id="bfmonth"></p> <p id="now"></p> <p id="atmonth"></p> </div>
            <div id="dp"></div>        
        </section>
    </div>
</section>
</div>

<div id="popup_wrap_new" class="size_big popup_wrap" style="display:none"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1 id="popup_title">Conference Room Management - New Conference Room</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->
<section class="pop_body"><!-- pop_body start -->
<form id="popform">
<input type="hidden" id="roomId" name="roomId">
  <table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr id="editTr"  style="display:none">
    <th scope="row">Room Status</th>
    <td colspan="3"><input id="RoomStatus" name="RoomStatus" type="text" title="" placeholder="" class="w100p" readonly="readonly"/></td>
</tr>
<tr>
    <th scope="row">Room Code</th>
    <td><input id="newRoomCd" name="newRoomCd" type="text" title="" placeholder="" class="w100p" /></td>
     <th scope="row">Room Name</th>
    <td><input id="newRoomNm" name="newRoomNm" type="text" title="" placeholder="" class="w100p" /></td>

</tr>
<tr>
    <th scope="row">Advance Booking Option</th>
    <td>
     <select id="newOption" name="newOption" class="w100p" >
     </select>
    </td>
    <th scope="row">Advance Booking Time</th>
    <td><input id="newBookingTm" name="newBookingTm" type="number" title="" placeholder="" class="w100p" /></td>
</tr>
<tr>
    <th scope="row">Capacity</th>
    <td><input id="newCapacity" name="newCapacity" type="number" title="" placeholder="" class="w100p" /></td>
    <th scope="row">Branch</th>
      <td>
    <select id="newbranchid" name="newbranchid" class="w100p" >
    </select>
    </td>
    </tr>
    <tr>    
         <th scope="row">Description</th>
         <td colspan='3'><input type="text" name="description" id="description" class="w100p"/></td>
     </tr>
</tbody>
</table>
</form>
            <ul class="center_btns">
                <li><p class="btn_blue2 big"><a  id="saveNew">SAVE</a></p></li> 
               <li><p class="btn_blue2 big" ><a  id="deActive">Deactivate</a></p></li>  
            </ul>
</section><!-- pop_body end -->
</div>

<div id="popup_wrap_picture" class="popup_wrap" style="display: none;"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Conference Room Management - Upload Picture</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<form id="picform">
<input type="hidden" id="picRoomId" name="picRoomId">
<div class="divine_auto"><!-- divine_auto start -->

<div style="width:33.33333%;">
    <div class="conf_img">
        <img src="" alt="이미지" />
    </div>
</div>

<div style="width:66.666666%;">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
      <th scope="row">Room Status</th>
      <td><input id="picRoomStatus" name="picRoomStatus" type="text" title="" placeholder="" class="w100p" readonly="readonly"/></td>
</tr>
<tr>
      <th scope="row">Room Code</th>
      <td><input id="picRoomCd" name="picRoomCd" type="text" title="" placeholder="" class="w100p" readonly="readonly"/></td>
</tr>
<tr>
      <th scope="row">Room Name</th>
      <td><input id="picRoomNm" name="picRoomNm" type="text" title="" placeholder="" class="w100p" readonly="readonly"/></td>
</tr>
<tr>
      <th scope="row">Branch</th>
      <td><input id="picBranch" name="picBranch" type="text" title="" placeholder="" class="w100p" readonly="readonly"/></td>
</tr>
<tr>
      <th scope="row">Advance Booking Time</th>
      <td><input id="picBookTm" name="picBookTm" type="text" title="" placeholder="" class="w100p" readonly="readonly"/></td>
</tr>
<tr>
      <th scope="row">Capacity</th>
      <td><input id="picCapacity" name="picCapacity" type="text" title="" placeholder="" class="w100p" readonly="readonly"/></td>
</tr>
<tr>
      <th scope="row">Description</th>
      <td><input id="picDescription" name="picDescription" type="text" title="" placeholder="" class="w100p" readonly="readonly"/></td>
</tr>
<tr>
    <th scope="row">Piture</th>
    <td>
        <div class="auto_file"><!-- auto_file start -->
        <input type="file" title="file add" />
        </div><!-- auto_file end -->
    </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="bottom_msg_box"><!-- bottom_msg_box start -->
<p>* Max image size : 1MB * Only allow .jpg file * Recommended Landscape Picture</p>
</aside><!-- bottom_msg_box end -->

</div>

</div><!-- divine_auto end -->

<ul class="center_btns">
    <li><p class="btn_blue2"><a href="#">Update Picture</a></p></li>
    <li><p class="btn_blue2"><a href="#">Remove Picture</a></p></li>
</ul>
</form>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->


<div id="popup_wrap_view" class="popup_wrap" style="display: none;"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Conference Room Management - View</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<div class="divine_auto"><!-- divine_auto start -->

<div style="width:33.33333%;">
    <div class="conf_img">
        <img src="" alt="이미지" />
    </div>
</div>

<div style="width:66.666666%;">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
      <th scope="row">Room Status</th>
      <td><input id="viewRoomStatus" name="viewRoomStatus" type="text" title="" placeholder="" class="w100p" readonly="readonly"/></td>
</tr>
<tr>
      <th scope="row">Room Code</th>
      <td><input id="viewRoomCd" name="viewRoomCd" type="text" title="" placeholder="" class="w100p" readonly="readonly"/></td>
</tr>
<tr>
      <th scope="row">Room Name</th>
      <td><input id="viewRoomNm" name="viewRoomNm" type="text" title="" placeholder="" class="w100p" readonly="readonly"/></td>
</tr>
<tr>
      <th scope="row">Branch</th>
      <td><input id="viewBranch" name="viewBranch" type="text" title="" placeholder="" class="w100p" readonly="readonly"/></td>
</tr>
<tr>
      <th scope="row">Advance Booking Time</th>
      <td><input id="viewBookTm" name="viewBookTm" type="text" title="" placeholder="" class="w100p" readonly="readonly"/></td>
</tr>
<tr>
      <th scope="row">Capacity</th>
      <td><input id="viewCapacity" name="viewCapacity" type="text" title="" placeholder="" class="w100p" readonly="readonly"/></td>
</tr>
<tr>
      <th scope="row">Description</th>
      <td><input id="viewDescription" name="viewDescription" type="text" title="" placeholder="" class="w100p" readonly="readonly"/></td>
</tr>
</tbody>
</table><!-- table end -->
</div>

</div><!-- divine_auto end -->

<aside class="title_line"><!-- title_line start -->
<h4>Upcoming Booking</h4>
</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
텍스트 영역
</article><!-- grid_wrap end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
