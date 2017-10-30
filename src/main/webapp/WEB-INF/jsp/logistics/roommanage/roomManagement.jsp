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
<link rel="stylesheet" href="http://code.jquery.com/ui/1.11.1/themes/smoothness/jquery-ui.css">
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.blockUI.min.js"></script>


<script src="${pageContext.request.contextPath}/resources/js/daypilot-all.min.js" type="text/javascript"></script>

<script type="text/javaScript" language="javascript">


    // AUIGrid 생성 후 반환 ID
    var myGridID;
    
    var comboData = [{"codeId": "1","codeName": "Active"},{"codeId": "8","codeName": "Inactive"}];
    
    var url;
    var addmonth = 0;
    var dp = new DayPilot.Month("dp");
    // AUIGrid 칼럼 설정                                                                            visible : false
    var columnLayout = [{dataField:"rumId"      ,headerText:"Room Id"      ,width:"15%"  ,height:30 , visible:true},
                        {dataField:"rumCode"    ,headerText:"Room Code"    ,width:"20%" ,height:30 , visible:true},
                        {dataField:"rumName"    ,headerText:"Room Name"    ,width:"35%" ,height:30 , visible:true},
                        {dataField:"stusId"     ,headerText:"Status"       ,width:"15%" ,height:30 , visible:true
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
                        {dataField:"cpcty"      ,headerText:"Capacity"     ,width:"15%" ,height:30 , visible:true},
                        {dataField:"advTmInMin" ,headerText:"advTmInMin"   ,width:90 ,height:30 , visible:false},
                        {dataField:"brnchId"    ,headerText:"brnchId"      ,width:120 ,height:30 , visible:false},
                        {dataField:"advOptnId"  ,headerText:"advOptnId"    ,width:140 ,height:30 , visible:false},
                        {dataField:"hasImg"     ,headerText:"hasImg"       ,width:120 ,height:30 , visible:false}
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
    var gridoptions = {showStateColumn : false , editable : false, pageRowCount : 30, usePaging : true, useGroupingPanel : false };
    
    var subgridpros = {
            // 페이지 설정
            usePaging : true,                
            pageRowCount : 10,                
            editable : true,                
            noDataMessage : "<spring:message code='sys.info.grid.noDataMessage'/>",
            enableSorting : true,
            softRemoveRowMode:false
            };
    

    $(document).ready(function(){
        // masterGrid 그리드를 생성합니다.
        myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,"", gridoptions);
        
        doDefCombo(comboData, '' ,'searchstatus', 'A', '');
          
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
            	getListAjax();    
            });
            $("#clear").click(function(){
            });
            $("#closebtn").click(function(){
            	$("#openwindow").hide();
            });
            $("#add").click(function(){
            	 doGetComboSepa('/common/selectCodeList.do', '89' , '' , '','newOption', 'S' , ''); 
            	 doGetComboSepa('/common/selectBranchCodeList.do', '3' , ' - ' , '','newbranchid', 'S' , ''); 
            	$("#popup_wrap_new").show();
            });
            $("#bfmonth").click(function(){
            	var selectedItems = AUIGrid.getSelectedItems(myGridID);
            	console.log(selectedItems);
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
               
    });
    });
    
    
    function getListAjax() {
        var url = "/misc/room/roomManagementList.do";
        var param = $("#searchForm").serializeJSON();
        console.log(param);
        Common.ajax("POST" , url , param , function(data){
            var list= data.dataList
            console.log(list);
            AUIGrid.setGridData(myGridID, list);
        });
    }
    
    function searchRoomBooking(param){
    	var url = "/misc/room/roomBookingList.do";
    	
    	Common.ajax("GET" , url , param , function(data){
            var list= data.dataList
            console.log(list);
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
    <li><p class="btn_blue"><a id="clear"><span class="clear"></span>Clear</a></p></li>
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
    <input type="text" id="searchroomId" name=""searchroomId""   placeholder="" class="w100p" />
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
    <select id="searchstatus" name="searchstatus"   title="" placeholder="" class="w100p" >
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
                        <p class="short"><input type="text" title="" placeholder="" class="w100p" id="searchmin" name="searchmin" readonly="readonly"  /></p>
                        <span>To</span>
                        <p class="short"><input type="text" title="" placeholder="" class="w100p" id="searchmax" name="searchmax" readonly="readonly"/></p>
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
            <div class="note"> <p id="bfmonth"><<</p> <p id="now"></p> <p id="atmonth">>></p> </div>
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
  <table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
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
    <td><input id="newBookingTm" name="newBookingTm" type="text" title="" placeholder="" class="w100p" /></td>
</tr>
<tr>
    <th scope="row">Capacity</th>
    <td><input id="newCapacity" name="newCapacity" type="text" title="" placeholder="" class="w100p" /></td>
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
               <li><p class="btn_blue2 big"><a id="saveNew">SAVE</a></p></li> 
            </ul>
</section><!-- pop_body end -->
</div>


