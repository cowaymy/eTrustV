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
<script type="text/javaScript" language="javascript">
var resGrid;
var reqGrid;

var status;
var rescolumnLayout=[
							{dataField: "rnum",headerText :"<spring:message code='log.head.rnum'/>" ,width:120 ,height:30 , visible:false },                        
							{dataField: "whLocId",headerText :"<spring:message code='log.head.locationid'/>"    ,width: "15%"    ,height:30 },                  
							{dataField: "whLocGb",headerText :"<spring:message code='log.head.whlocgb'/>"   ,width:120 ,height:30 , visible:false},                         
							{dataField: "code",headerText :"<spring:message code='log.head.code'/>" ,width:120 ,height:30 , visible:false},                         
							{dataField: "codeName",headerText :"<spring:message code='log.head.locationtype'/>" ,width: "15%"   ,height:30 },               
							{dataField: "whLocCode",headerText :"<spring:message code='log.head.locationcode'/>"    ,width: "20%"    ,height:30},               
							{dataField: "whLocDesc",headerText :"<spring:message code='log.head.locationdesc'/>"    ,width: "50%"    ,height:30},               
							{dataField: "whLocTel1",headerText :"<spring:message code='log.head.whloctel1'/>"   ,width:120 ,height:30 , visible:false},                         
							{dataField: "whLocTel2",headerText :"<spring:message code='log.head.whloctel2'/>"   ,width:120 ,height:30 , visible:false},                         
							{dataField: "whLocBrnchId",headerText :"<spring:message code='log.head.whlocbrnchid'/>" ,width:120 ,height:30 , visible:false},                         
							{dataField: "whLocTypeId",headerText :"<spring:message code='log.head.whloctypeid'/>"   ,width:120 ,height:30 , visible:false},                         
							{dataField: "whLocStkGrad",headerText :"<spring:message code='log.head.whlocstkgrad'/>" ,width:120 ,height:30 , visible:false},                         
							{dataField: "whLocStusId",headerText :"<spring:message code='log.head.whlocstusid'/>"   ,width:120 ,height:30 , visible:false},                         
							{dataField: "whLocUpdUserId",headerText :"<spring:message code='log.head.whlocupduserid'/>" ,width:120 ,height:30 , visible:false},                         
							{dataField: "whLocUpdDt",headerText :"<spring:message code='log.head.whlocupddt'/>" ,width:120 ,height:30 , visible:false},                         
							{dataField: "code2",headerText :"<spring:message code='log.head.code2'/>"   ,width:120 ,height:30 , visible:false},                         
							{dataField: "desc2",headerText :"<spring:message code='log.head.desc2'/>"   ,width:120 ,height:30 , visible:false},                         
							{dataField: "whLocIsSync",headerText :"<spring:message code='log.head.whlocissync'/>"   ,width:120 ,height:30 , visible:false},                         
							{dataField: "whLocMobile",headerText :"<spring:message code='log.head.whlocmobile'/>"   ,width:120 ,height:30 , visible:false},                         
							{dataField: "areaId",headerText :"<spring:message code='log.head.areaid'/>" ,width:120 ,height:30 , visible:false},                         
							{dataField: "addrDtl",headerText :"<spring:message code='log.head.addrdtl'/>"   ,width:120 ,height:30 , visible:false},                         
							{dataField: "street",headerText :"<spring:message code='log.head.street'/>" ,width:120 ,height:30 , visible:false},                         
							{dataField: "whLocBrnchId2",headerText :"<spring:message code='log.head.whlocbrnchid2'/>"   ,width:120 ,height:30 , visible:false},                         
							{dataField: "whLocBrnchId3",headerText :"<spring:message code='log.head.whlocbrnchid3'/>"   ,width:120 ,height:30 , visible:false},                         
							{dataField: "serialPdChk",headerText :"<spring:message code='log.head.serialpdchk'/>"   ,width:120 ,height:30 , visible:false},                         
							{dataField: "serialFtChk",headerText :"<spring:message code='log.head.serialftchk'/>"   ,width:120 ,height:30 , visible:false},                         
							{dataField: "serialPtChk",headerText :"<spring:message code='log.head.serialptchk'/>"   ,width:120 ,height:30 , visible:false},                         
							{dataField: "commonCrChk",headerText :"<spring:message code='log.head.commoncrchk'/>"   ,width:120 ,height:30 , visible:false} 
                    ];
                    
var reqcolumnLayout;

var resop = {rowIdField : "rnum", showRowCheckColumn : true 
		,usePaging : false
		,Editable:false};
var reqop = {usePaging : false,useGroupingPanel : false , Editable:false};

$(document).ready(function(){
	searchHead();
    /**********************************
    * Header Setting
    ***********************************/
    /**********************************
     * Header Setting End
     ***********************************/
    
     reqcolumnLayout=[              
							{dataField: "adjrnum",headerText :"<spring:message code='log.head.rnum'/>"  ,width:120 ,height:30 , visible:false },                        
							{dataField: "adjwhLocId",headerText :"<spring:message code='log.head.locationid'/>" ,width: "15%"    ,height:30 },                  
							{dataField: "adjwhLocGb",headerText :"<spring:message code='log.head.whlocgb'/>"    ,width:120 ,height:30 , visible:false},                         
							{dataField: "adjcode",headerText :"<spring:message code='log.head.code'/>"  ,width:120 ,height:30 , visible:false},                         
							{dataField: "adjcodeName",headerText :"<spring:message code='log.head.locationtype'/>"  ,width: "15%"    ,height:30 },                  
							{dataField: "adjwhLocCode",headerText :"<spring:message code='log.head.locationcode'/>" ,width: "20%"    ,height:30},               
							{dataField: "adjwhLocDesc",headerText :"<spring:message code='log.head.locationdesc'/>" ,width: "50%"    ,height:30},               
							{dataField: "adjwhLocTel1",headerText :"<spring:message code='log.head.whloctel1'/>"    ,width:120 ,height:30 , visible:false},                         
							{dataField: "adjwhLocTel2",headerText :"<spring:message code='log.head.whloctel2'/>"    ,width:120 ,height:30 , visible:false},                         
							{dataField: "adjwhLocBrnchId",headerText :"<spring:message code='log.head.whlocbrnchid'/>"  ,width:120 ,height:30 , visible:false},                         
							{dataField: "adjwhLocTypeId",headerText :"<spring:message code='log.head.whloctypeid'/>"    ,width:120 ,height:30 , visible:false},                         
							{dataField: "adjwhLocStkGrad",headerText :"<spring:message code='log.head.whlocstkgrad'/>"  ,width:120 ,height:30 , visible:false},                         
							{dataField: "adjwhLocStusId",headerText :"<spring:message code='log.head.whlocstusid'/>"    ,width:120 ,height:30 , visible:false},                         
							{dataField: "adjwhLocUpdUserId",headerText :"<spring:message code='log.head.whlocupduserid'/>"  ,width:120 ,height:30 , visible:false},                         
							{dataField: "adjwhLocUpdDt",headerText :"<spring:message code='log.head.whlocupddt'/>"  ,width:120 ,height:30 , visible:false},                         
							{dataField: "adjcode2",headerText :"<spring:message code='log.head.code2'/>"    ,width:120 ,height:30 , visible:false},                         
							{dataField: "adjdesc2",headerText :"<spring:message code='log.head.desc2'/>"    ,width:120 ,height:30 , visible:false},                         
							{dataField: "adjwhLocIsSync",headerText :"<spring:message code='log.head.whlocissync'/>"    ,width:120 ,height:30 , visible:false},                         
							{dataField: "adjwhLocMobile",headerText :"<spring:message code='log.head.whlocmobile'/>"    ,width:120 ,height:30 , visible:false},                         
							{dataField: "adjareaId",headerText :"<spring:message code='log.head.areaid'/>"  ,width:120 ,height:30 , visible:false},                         
							{dataField: "adjaddrDtl",headerText :"<spring:message code='log.head.addrdtl'/>"    ,width:120 ,height:30 , visible:false},                         
							{dataField: "adjstreet",headerText :"<spring:message code='log.head.street'/>"  ,width:120 ,height:30 , visible:false},                         
							{dataField: "adjwhLocBrnchId2",headerText :"<spring:message code='log.head.whlocbrnchid2'/>"    ,width:120 ,height:30 , visible:false},                         
							{dataField: "adjwhLocBrnchId3",headerText :"<spring:message code='log.head.whlocbrnchid3'/>"    ,width:120 ,height:30 , visible:false},                         
							{dataField: "adjserialPdChk",headerText :"<spring:message code='log.head.serialpdchk'/>"    ,width:120 ,height:30 , visible:false},                         
							{dataField: "adjserialFtChk",headerText :"<spring:message code='log.head.serialftchk'/>"    ,width:120 ,height:30 , visible:false},                         
							{dataField: "adjserialPtChk",headerText :"<spring:message code='log.head.serialptchk'/>"    ,width:120 ,height:30 , visible:false},                         
							{dataField: "adjcommonCrChk",headerText :"<spring:message code='log.head.commoncrchk'/>"    ,width:120 ,height:30 , visible:false}  
                             ];
    
    resGrid = GridCommon.createAUIGrid("res_grid_wrap", rescolumnLayout,"", resop);
    reqGrid = GridCommon.createAUIGrid("req_grid_wrap", reqcolumnLayout,"", reqop);
    
    AUIGrid.bind(resGrid, "addRow", function(event){});
    AUIGrid.bind(reqGrid, "addRow", function(event){});
    
    AUIGrid.bind(resGrid, "cellEditBegin", function (event){});
    AUIGrid.bind(reqGrid, "cellEditBegin", function (event){
        
    });
    
    AUIGrid.bind(resGrid, "cellEditEnd", function (event){});
    AUIGrid.bind(reqGrid, "cellEditEnd", function (event){
        
        if(event.dataField == "itmcd"){
            $("#svalue").val(AUIGrid.getCellValue(reqGrid, event.rowIndex, "itmcd"));
            $("#sUrl").val("/logistics/material/materialcdsearch.do");
            Common.searchpopupWin("popupForm", "/common/searchPopList.do","stocklist");
        }
        
        if(event.dataField == "rqty"){
            if(AUIGrid.getCellValue(reqGrid, event.rowIndex, "rqty") > AUIGrid.getCellValue(reqGrid, event.rowIndex, "aqty")){
                Common.alert('The requested quantity is up to '+AUIGrid.getCellValue(reqGrid, event.rowIndex, "aqty")+'.');
                AUIGrid.setCellValue(reqGrid, event.rowIndex, "rqty", 0);
                return false;
            }
        }
    });
    
    AUIGrid.bind(resGrid, "cellClick", function( event ) {});
    AUIGrid.bind(reqGrid, "cellClick", function( event ) {});
    
    AUIGrid.bind(resGrid, "cellDoubleClick", function(event){});
    AUIGrid.bind(reqGrid, "cellDoubleClick", function(event){});
    
    AUIGrid.bind(resGrid, "ready", function(event) {});
    AUIGrid.bind(reqGrid, "ready", function(event) {});
    
});

//btn clickevent
$(function(){
    $('#search').click(function() {
            searchAjax();
    });
    
    $('#list').click(function() {
        document.listForm.action = '/logistics/adjustment/NewAdjustmentRe.do';
        document.listForm.submit();
    });
    
    $('#reqdel').click(function(){
        AUIGrid.removeRow(reqGrid, "selectedIndex");
        AUIGrid.removeSoftRows(reqGrid);
    });
    
    $('#save').click(function() {
    	var param = GridCommon.getEditData(reqGrid);
            param.form = $("#searchForm").serializeJSON();
            Common.ajax("POST", "/logistics/adjustment/adjustmentLocManual.do", param, function(result) {
                //Common.alert(result.message);
                AUIGrid.resetUpdatedItems(reqGrid, "all");
                $('#list').click();
            },  function(jqXHR, textStatus, errorThrown) {
                try {
                } catch (e) {
                }
    
                Common.alert("Fail : " + jqXHR.responseJSON.message);
            });
    });
    $("#rightbtn").click(function(){
    	var sortingInfo = [];
        // 차례로 Country, Name, Price 에 대하여 각각 오름차순, 내림차순, 오름차순 지정.
        sortingInfo[0] = { dataField : "adjwhLocId", sortType : 1 };
        checkedItems = AUIGrid.getCheckedRowItemsAll(resGrid);
        var addedItems = AUIGrid.getColumnValues(reqGrid,"adjwhLocId");
         
        
        var bool = true;
        if (checkedItems.length > 0){
            var rowPos = "first";
            var item = new Object();
            var rowList = [];
            if (addedItems.length > 0){
	            for (var i = 0 ; i < addedItems.length ; i++){
	            	for (var j = 0 ; j < checkedItems.length ;j++){
	            	if(addedItems[i] == checkedItems[j].whLocId){
	            		Common.alert("Loaction Id :"+checkedItems[j].whLocId+" is already exist.");
	            		return false;
	            	}
	            	}		
	            }
            }
            for (var i = 0 ; i < checkedItems.length ; i++){
                
                rowList[i] = {
		                		adjwhLocId : checkedItems[i].whLocId,
		                		adjwhLocCode : checkedItems[i].whLocCode,
		                		adjwhLocDesc : checkedItems[i].whLocDesc,
		                		adjwhLocTel1 : checkedItems[i].whLocTel1,
		                		adjwhLocTel2 : checkedItems[i].whLocTel2,
		                		adjwhLocBrnchId : checkedItems[i].whLocBrnchId,
		                		adjwhLocTypeId : checkedItems[i].whLocTypeId,
		                		adjwhLocStkGrad : checkedItems[i].whLocStkGrad,
		                		adjwhLocStusId : checkedItems[i].whLocStusId,
		                		adjwhLocUpdUserId : checkedItems[i].whLocUpdUserId,
		                		adjwhLocUpdDt : checkedItems[i].whLocUpdDt,
		                		adjcode2 : checkedItems[i].code2,
		                		adjdesc2 : checkedItems[i].desc2,
		                		adjwhLocIsSync : checkedItems[i].whLocIsSync,
		                		adjwhLocMobile : checkedItems[i].whLocMobile,
		                		adjareaId : checkedItems[i].areaId,
		                		adjaddrDtl : checkedItems[i].addrDtl,
		                		adjstreet : checkedItems[i].street,
		                		adjwhLocBrnchId2 : checkedItems[i].whLocBrnchId2,
		                		adjwhLocBrnchId3 : checkedItems[i].whLocBrnchId3,
		                		adjwhLocGb : checkedItems[i].whLocGb,
		                		adjcode : checkedItems[i].code,
		                		adjcodeName: checkedItems[i].codeName,
		                		adjserialPdChk : checkedItems[i].serialPdChk,
		                		adjserialFtChk : checkedItems[i].serialFtChk,
		                		adjserialPtChk : checkedItems[i].serialPtChk,
		                		adjcommonCrChk : checkedItems[i].commonCrChk
                        }
                
                AUIGrid.addUncheckedRowsByIds(resGrid, checkedItems[i].rnum);
            }
            
            AUIGrid.addRow(reqGrid, rowList, rowPos);
            AUIGrid.setSorting(reqGrid, sortingInfo);
        }
    });
});




function f_multiCombo() {
    $(function() {
        $('#eventtype').change(function() {
        }).multipleSelect({
            selectAll : true
        });       
        $('#itemtype').change(function() {

        }).multipleSelect({
            selectAll : true
        });       
    });
}


function searchHead(){
	var param = "adjNo=${rAdjcode }";
    status = "${rStatus }";
    var url = "/logistics/adjustment/oneAdjustmentNo.do";
    Common.ajax("GET" , url , param , function(result){
    	var data = result.dataList;
	    fn_setVal(data,status);
	    $("#invntryNo").val(data[0].invntryNo);
	    $("#autoFlag").val(data[0].autoFlag);
	    $("#eventType").val(data[0].eventType);
	    $("#itmType").val(data[0].itmType);
	    $("#ctgryType").val(data[0].ctgryType);
	    
    });
}
function fn_setVal(data,status){
	$("#adjno").val(data[0].invntryNo);
	var tmp = data[0].eventType.split(',');
	var tmp2 = data[0].itmType.split(',');
	var tmp3 = data[0].ctgryType.split(',');
	if(status=="V"){
		$("#search_table").hide();
	}
	fn_itemSet(tmp,"event");
	fn_eventSet(tmp,status);
    fn_itemSet(tmp2,"item");
    fn_itemSet(tmp3,"catagory");
    
	if(data[0].autoFlag == "A"){
		$("#auto").attr("checked", true);
		$("#save").hide();
		$("#reqdel").hide();
		$("#rightbtn").hide();
		$("#search").hide();
		fn_ReqAdjLocList();
	}else if(data[0].autoFlag == "M"){
			$("#manual").attr("checked", true);
		if(status=="V"){
		    $("#save").hide();
	        $("#reqdel").hide();
	        $("#rightbtn").hide();
	        $("#search").hide();
	        fn_ReqAdjLocList();
		}else{
			$("#save").show();
			$("#reqdel").show();
			$("#rightbtn").show();
			$("#search").show();
		}
	}
	
	
	
}
 function fn_eventSet(tmp,status){
	        	$("input[name='chcdc']").prop('disabled', true);
	        	$("input[name='chrdc']").prop('disabled', true);
	        	$("input[name='chct']").prop('disabled', true);
	        	$("input[name='chcody']").prop('disabled', true);
	        	$("input[name='chcdcrdc']").prop('disabled', true);
	for(var i=0; i<tmp.length;i++){
	        if(tmp[i]=="2456"){
	        	//$("input[name='chcdc']").prop('disabled', false);
	            $("#chcdc").attr("checked", true);
	            $("#srchcdc").val("01");
	        }else if (tmp[i]=="2457") {
	        	//$("input[name='chrdc']").prop('disabled', false);
	            $("#chrdc").attr("checked", true);
	            $("#srchrdc").val("02");
	        }else if (tmp[i]=="2458") {
	        	//$("input[name='chct']").prop('disabled', false);
	            $("#chct").attr("checked", true);
	            $("#srchct").val("03");
	        }else if (tmp[i]=="2459") {
	        	//$("input[name='chcody']").prop('disabled', false);
	            $("#chcody").attr("checked", true);
	            $("#srchcody").val("04");
	        } else if(tmp[i]=="2460"){
	        	//$("input[name='chcdcrdc']").prop('disabled', false);
	            $("#chcdcrdc").attr("checked", true);  
	            $("#srchcdcrdc").val("05");  
	        }
    } 
	
} 

function fn_itemSet(tmp,str){
	   var no;
	     if(str=="event"){
	         no=339;
	     }else if(str=="item"){
	         no=15;
	     }else if(str=="catagory"){
	         no=11;
	     }   
    var url = "/logistics/adjustment/selectCodeList.do";
	$.ajax({
        type : "GET",
        url : url,
        data : {
            groupCode : no
        },
        dataType : "json",
        contentType : "application/json;charset=UTF-8",
        success : function(data) {
           fn_itemChck(data,tmp,str);
        },
        error : function(jqXHR, textStatus, errorThrown) {
        },
        complete : function() {
        }
    });
}
function  fn_itemChck(data,tmp2,str){
    var obj;
    if(str=="event" ){
        obj ="eventtypetd";
    }else if(str=="item"){
        obj ="itemtypetd";
    }else if(str=="catagory"){
        obj ="catagorytypetd";
    }
    obj= '#'+obj;
	$.each(data, function(index,value) {
	            $('<label />',{id:data[index].code}).appendTo(obj);
	            $('<input />',  {type : 'checkbox',value : data[index].codeId, id : data[index].codeId}).appendTo('#'+data[index].code).attr("disabled","disabled");
	            $('<span />',  {text:data[index].codeName}).appendTo('#'+data[index].code);
	    });
			
		for(var i=0; i<tmp2.length;i++){
			$.each(data, function(index,value) {
				if(tmp2[i]==data[index].codeId){
					$('#'+data[index].codeId).attr("checked", "true");
				}
			});
		}
}

function searchAjax(){
    var url = "/logistics/adjustment/adjustmentLocationList.do";
    var param = $('#searchForm').serializeJSON();
    
    Common.ajax("POST" , url , param , function(result){
        AUIGrid.setGridData(resGrid, result.dataList);
    });
}

function fn_ReqAdjLocList(){
    var url = "/logistics/adjustment/adjustmentLocationListView.do";
    var param = $('#headForm').serializeJSON();
    param.form = $('#searchForm').serializeJSON();
    Common.ajax("POST" , url , param , function(result){
    	
        AUIGrid.setGridData(resGrid, result.reslist);
        AUIGrid.setGridData(reqGrid, result.reqlist);
    });
}
</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>logistics</li>
    <li>Stock Audit Detail</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Stock Audit Detail</h2>
</aside><!-- title_line end -->

<aside class="title_line"><!-- title_line start -->
<h3>Header Info</h3>
<ul class="right_btns">
    <li><p class="btn_blue"><a id="list"><span class="list"></span>List</a></p></li>
</ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form id="headForm" name="headForm" method="POST">
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
    <th scope="row">Stock Audit Number</th>
    <td><input id="adjno" name="adjno" type="text" title=""  class="w100p" readonly="readonly" /></td>
    <th scope="row">Auto/Manual</th>
    <td> 
         <label><input type="radio" name="auto" id="auto"    disabled="disabled" /><span>Auto</span></label>
         <label><input type="radio" name="manual" id="manual"   disabled="disabled" /><span>Manual</span></label>        
    </td>
</tr>
<tr>
    <th scope="row">Location Type</th>
    <td id="eventtypetd">
    </td>
    <th scope="row">Items Type</th>
    <td id="itemtypetd">
    </td>
    </tr>
     <tr>
         <th scope="row">Category Type</th>
    <td id="catagorytypetd" colspan="3">
     </tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->


<section class="search_table" id="search_table"><!-- search_table start -->
<aside class="title_line"><!-- title_line start -->
<h3>Location Info</h3>
</aside><!-- title_line end -->
<form id="searchForm" name="searchForm" >
<input type="hidden" name="rAdjcode" id="rAdjcode" />  
<input type="hidden" name="rStatus" id="rStatus" />  
<input type="hidden" name="rAdjlocId" id="rAdjlocId" />  
<input type="hidden" name="srchcdc" id="srchcdc" />  
<input type="hidden" name="srchrdc" id="srchrdc" />  
<input type="hidden" name="srchcdcrdc" id="srchcdcrdc" />  
<input type="hidden" name="srchct" id="srchct" />  
<input type="hidden" name="srchcody" id="srchcody" />  
<input type="hidden" id="invntryNo" name="invntryNo">
<input type="hidden" id="autoFlag" name="autoFlag">
<input type="hidden" id="eventType" name="eventType">
<input type="hidden" id="itmType" name="itmType">
<input type="hidden" id="ctgryType" name="ctgryType">
<table class="type1" ><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:100px" />
    <col style="width:*" />
    <col style="width:90px" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Location Type</th>
<td>
     <label><input type="checkbox"  id="chcdc" name="chcdc" value="01"/><span>CDC</span></label>
     <label><input type="checkbox"  id="chcdcrdc" name="chcdcrdc" value="05"/><span>CDC&RDC</span></label>
     <label><input type="checkbox"  id="chcody" name="chcody" value="04"/><span>CODY</span></label>
     <label><input type="checkbox"  id="chct" name="chct" value="03"/><span>CT</span></label>
     <label><input type="checkbox"  id="chrdc" name="chrdc" value="02"/><span>RDC</span></label>
    </td>
    <td>
    <ul class="left_btns">
        <li><p class="btn_blue2"><a id="search">Search</a></p></li>
    </ul>
    </td><td colspan="2"/>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<div class="divine_auto type2"><!-- divine_auto start -->

<div style="width:50%"><!-- 50% start -->

<aside class="title_line"><!-- title_line start -->
<h3>Location</h3>
</aside><!-- title_line end -->

<div class="border_box" style="height:340px;"><!-- border_box start -->

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="res_grid_wrap"></div>
</article><!-- grid_wrap end -->

</div><!-- border_box end -->

</div><!-- 50% end -->

<div style="width:50%"><!-- 50% start -->


<aside class="title_line"><!-- title_line start -->
<h3>Stock Audit Location</h3>
</aside><!-- title_line end -->

<div class="border_box" style="height:340px;"><!-- border_box start -->

<ul class="right_btns">
    <!--<li><p class="btn_grid"><a id="reqadd">ADD</a></p></li> -->
    <li><p class="btn_grid"><a id="reqdel">DELETE</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="req_grid_wrap" ></div>
</article><!-- grid_wrap end -->

<ul class="btns">
    <li><a id="rightbtn"><img src="${pageContext.request.contextPath}/resources/images/common/btn_right2.gif" alt="right" /></a></li>
</ul>

</div><!-- border_box end -->

</div><!-- 50% end -->

</div><!-- divine_auto end -->

 <ul class="center_btns mt20">
    <li><p class="btn_blue2 big"><a id="save">Save</a></p></li>
</ul> 

</section><!-- search_result end -->
<form id="listForm" name="listForm" method="POST">
<input type="hidden" id="retnVal"    name="retnVal"    value="R"/>
</form>
</section>
