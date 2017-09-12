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
<script type="text/javaScript" language="javascript">
var resGrid;
var reqGrid;

var status;
var rescolumnLayout=[
						{dataField:"rnum" ,headerText:"rnum",width:120 ,height:30 , visible:false },
						{dataField:"whLocId" ,headerText:"Location ID",width:"20%" ,height:30 },
						{dataField:"whLocCode" ,headerText:"Location Code",width:"30%" ,height:30},
						{dataField:"whLocDesc" ,headerText:"Location Desc",width:"50%" ,height:30},
						{dataField:"whLocTel1" ,headerText:"whLocTel1",width:120 ,height:30 , visible:false},
						{dataField:"whLocTel2" ,headerText:"whLocTel2",width:120 ,height:30 , visible:false},
						{dataField:"whLocBrnchId" ,headerText:"whLocBrnchId",width:120 ,height:30 , visible:false},
						{dataField:"whLocTypeId" ,headerText:"whLocTypeId",width:120 ,height:30 , visible:false},
						{dataField:"whLocStkGrad" ,headerText:"whLocStkGrad",width:120 ,height:30 , visible:false},
						{dataField:"whLocStusId" ,headerText:"whLocStusId",width:120 ,height:30 , visible:false},
						{dataField:"whLocUpdUserId" ,headerText:"whLocUpdUserId",width:120 ,height:30 , visible:false},
						{dataField:"whLocUpdDt" ,headerText:"whLocUpdDt",width:120 ,height:30 , visible:false},
						{dataField:"code2" ,headerText:"code2",width:120 ,height:30 , visible:false},
						{dataField:"desc2" ,headerText:"desc2",width:120 ,height:30 , visible:false},
						{dataField:"whLocIsSync" ,headerText:"whLocIsSync",width:120 ,height:30 , visible:false},
						{dataField:"whLocMobile" ,headerText:"whLocMobile",width:120 ,height:30 , visible:false},
						{dataField:"areaId" ,headerText:"areaId",width:120 ,height:30 , visible:false},
						{dataField:"addrDtl" ,headerText:"addrDtl",width:120 ,height:30 , visible:false},
						{dataField:"street" ,headerText:"street",width:120 ,height:30 , visible:false},
						{dataField:"whLocBrnchId2" ,headerText:"whLocBrnchId2",width:120 ,height:30 , visible:false},
						{dataField:"whLocBrnchId3" ,headerText:"whLocBrnchId3",width:120 ,height:30 , visible:false},
						{dataField:"whLocGb" ,headerText:"whLocGb",width:120 ,height:30 , visible:false},
						{dataField:"serialPdChk" ,headerText:"serialPdChk",width:120 ,height:30 , visible:false},
						{dataField:"serialFtChk" ,headerText:"serialFtChk",width:120 ,height:30 , visible:false},
						{dataField:"serialPtChk" ,headerText:"serialPtChk",width:120 ,height:30 , visible:false},
						{dataField:"commonCrChk" ,headerText:"commonCrChk",width:120 ,height:30 , visible:false}
                    ];
                    
var reqcolumnLayout;

var resop = {rowIdField : "rnum", showRowCheckColumn : true 
		,usePaging : false
		//,useGroupingPanel : false 
		,Editable:false};
var reqop = {usePaging : false,useGroupingPanel : false , Editable:false};

//var uomlist = f_getTtype('42' , '');
//var paramdata;
$(document).ready(function(){
	searchHead();
    /**********************************
    * Header Setting
    ***********************************/
   // doGetCombo('/common/selectCodeList.do', '15', '','itemtype', 'M' , 'f_multiCombo');
    //$("#cancelTr").hide();
    /**********************************
     * Header Setting End
     ***********************************/
    
     reqcolumnLayout=[              
                             {dataField:"adjrnum" ,headerText:"rnum",width:120 ,height:30 , visible:false },
                             {dataField:"adjwhLocId" ,headerText:"Location ID",width:"20%" ,height:30 },
                             {dataField:"adjwhLocCode" ,headerText:"Location Code",width:"30%" ,height:30},
                             {dataField:"adjwhLocDesc" ,headerText:"Location Desc",width:"50%" ,height:30},
                             {dataField:"adjwhLocTel1" ,headerText:"whLocTel1",width:120 ,height:30 , visible:false},
                             {dataField:"adjwhLocTel2" ,headerText:"whLocTel2",width:120 ,height:30 , visible:false},
                             {dataField:"adjwhLocBrnchId" ,headerText:"whLocBrnchId",width:120 ,height:30 , visible:false},
                             {dataField:"adjwhLocTypeId" ,headerText:"whLocTypeId",width:120 ,height:30 , visible:false},
                             {dataField:"adjwhLocStkGrad" ,headerText:"whLocStkGrad",width:120 ,height:30 , visible:false},
                             {dataField:"adjwhLocStusId" ,headerText:"whLocStusId",width:120 ,height:30 , visible:false},
                             {dataField:"adjwhLocUpdUserId" ,headerText:"whLocUpdUserId",width:120 ,height:30 , visible:false},
                             {dataField:"adjwhLocUpdDt" ,headerText:"whLocUpdDt",width:120 ,height:30 , visible:false},
                             {dataField:"adjcode2" ,headerText:"code2",width:120 ,height:30 , visible:false},
                             {dataField:"adjdesc2" ,headerText:"desc2",width:120 ,height:30 , visible:false},
                             {dataField:"adjwhLocIsSync" ,headerText:"whLocIsSync",width:120 ,height:30 , visible:false},
                             {dataField:"adjwhLocMobile" ,headerText:"whLocMobile",width:120 ,height:30 , visible:false},
                             {dataField:"adjareaId" ,headerText:"areaId",width:120 ,height:30 , visible:false},
                             {dataField:"adjaddrDtl" ,headerText:"addrDtl",width:120 ,height:30 , visible:false},
                             {dataField:"adjstreet" ,headerText:"street",width:120 ,height:30 , visible:false},
                             {dataField:"adjwhLocBrnchId2" ,headerText:"whLocBrnchId2",width:120 ,height:30 , visible:false},
                             {dataField:"adjwhLocBrnchId3" ,headerText:"whLocBrnchId3",width:120 ,height:30 , visible:false},
                             {dataField:"adjwhLocGb" ,headerText:"whLocGb",width:120 ,height:30 , visible:false},
                             {dataField:"adjserialPdChk" ,headerText:"serialPdChk",width:120 ,height:30 , visible:false},
                             {dataField:"adjserialFtChk" ,headerText:"serialFtChk",width:120 ,height:30 , visible:false},
                             {dataField:"adjserialPtChk" ,headerText:"serialPtChk",width:120 ,height:30 , visible:false},
                             {dataField:"adjcommonCrChk" ,headerText:"commonCrChk",width:120 ,height:30 , visible:false}
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
            searchEventAjax();
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
            param.form = $("#popupForm").serializeJSON();
            //console.log(param);
            Common.ajax("POST", "/logistics/adjustment/adjustmentLocManual.do", param, function(result) {
                //Common.alert(result.message);
                AUIGrid.resetUpdatedItems(reqGrid, "all");
            },  function(jqXHR, textStatus, errorThrown) {
                try {
                } catch (e) {
                }
    
                Common.alert("Fail : " + jqXHR.responseJSON.message);
            });
    });
    $("#rightbtn").click(function(){
        checkedItems = AUIGrid.getCheckedRowItemsAll(resGrid);
        var bool = true;
        if (checkedItems.length > 0){
            var rowPos = "first";
            var item = new Object();
            var rowList = [];
            
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
		                		adjserialPdChk : checkedItems[i].serialPdChk,
		                		adjserialFtChk : checkedItems[i].serialFtChk,
		                		adjserialPtChk : checkedItems[i].serialPtChk,
		                		adjcommonCrChk : checkedItems[i].commonCrChk
                        }
                
                AUIGrid.addUncheckedRowsByIds(resGrid, checkedItems[i].rnum);
            }
            
            AUIGrid.addRow(reqGrid, rowList, rowPos);
        }
    });
});




function fn_itempopList(data){
    
    var rowPos = "first";
    var rowList = [];
    
    AUIGrid.removeRow(reqGrid, "selectedIndex");
    AUIGrid.removeSoftRows(reqGrid);
    for (var i = 0 ; i < data.length ; i++){
        rowList[i] = {
            itmid : data[i].item.itemid,
            itmcd : data[i].item.itemcode,
            itmname : data[i].item.itemname
        }
    }
    
    AUIGrid.addRow(reqGrid, rowList, rowPos);
    
}

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
    //alert(status);
    var url = "/logistics/adjustment/oneAdjustmentNo.do";
    Common.ajax("GET" , url , param , function(result){
    	var data = result.dataList;
	    fn_setVal(data,status);
	    $("#invntryNo").val(data[0].invntryNo);
	    $("#autoFlag").val(data[0].autoFlag);
	    $("#eventType").val(data[0].eventType);
	    $("#itmType").val(data[0].itmType);
	    
    });
}
function fn_setVal(data,status){
	//var status = "${rStatus }";
	$("#adjno").val(data[0].invntryNo);
	var tmp = data[0].eventType.split(',');
	var tmp2 = data[0].itmType.split(',');
	fn_eventSet(tmp);
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
	fn_itemSet(tmp2);
	
	
	
}
function fn_eventSet(tmp){
	for(var i=0; i<tmp.length;i++){
        if(tmp[i]=="1"){
            $("#cdc").attr("checked", true);
            $("#chcdc").attr("checked", true);
            $("#srchcdc").val("713");
        }else if (tmp[i]=="2") {
            $("#rdc").attr("checked", true);
            $("#chrdc").attr("checked", true);
            $("#srchrdc").val("277");
        } else if(tmp[i]=="30"){
            $("#ctcd").attr("checked", true);  
            $("#chctcd").attr("checked", true);  
            $("#srchctcd").val("278");  
        }
    } 
	
}

function fn_itemSet(tmp2){
    var url = "/logistics/adjustment/selectCodeList.do";
	$.ajax({
        type : "GET",
        url : url,
        data : {
            groupCode : 15
        },
        dataType : "json",
        contentType : "application/json;charset=UTF-8",
        success : function(data) {
           fn_itemChck(data,tmp2);
        },
        error : function(jqXHR, textStatus, errorThrown) {
        },
        complete : function() {
        }
    });
}
function  fn_itemChck(data,tmp2){
	var obj ="#itemtypetd";
	
	$.each(data, function(index,value) {
	            $('<label />',{id:data[index].code}).appendTo(obj);
	            $('<input />',  {type : 'checkbox',value : data[index].codeId, id : data[index].codeId}).appendTo("#"+data[index].code).attr("disabled","disabled");
	            $('<span />',  {text:data[index].codeName}).appendTo("#"+data[index].code);
	    });
			
		for(var i=0; i<tmp2.length;i++){
			$.each(data, function(index,value) {
				if(tmp2[i]==data[index].codeId){
					$("#"+data[index].codeId).attr("checked", "true");
					//$("#"+data[index].codeName).val("Y");
				}
			});
		}
}

function searchEventAjax(){
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
	    console.log(param);
    Common.ajax("POST" , url , param , function(result){
	    console.log(result);
    	
        AUIGrid.setGridData(resGrid, result.reslist);
        AUIGrid.setGridData(reqGrid, result.reqlist);
    });
}
</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>logistics</li>
    <li>New Adjustment Detail</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>New-Adjustment Detail</h2>
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
    <th scope="row">Adjustment Number</th>
    <td><input id="adjno" name="adjno" type="text" title=""  class="w100p" readonly="readonly" /></td>
    <th scope="row">Auto/Manual</th>
    <td> 
         <label><input type="radio" name="auto" id="auto"    disabled="disabled" /><span>Auto</span></label>
         <label><input type="radio" name="manual" id="manual"   disabled="disabled" /><span>Manual</span></label>        
    </td>
</tr>
<tr>
    <th scope="row">Event Type</th>
    <td>
    <!-- <select class="multy_select" multiple="multiple" id="eventtype" name="eventtype[]" /></select> -->
     <label><input type="checkbox" disabled="disabled" id="cdc" name="cdc"/><span>CDC</span></label>
     <label><input type="checkbox" disabled="disabled" id="rdc" name="rdc"/><span>RDC</span></label>
     <label><input type="checkbox" disabled="disabled" id="ctcd" name="ctcd"/><span>CT/CODY</span></label>
    </td>
  <!--   <th scope="row">Document Date</th>
    <td><input id="docdate" name="docdate" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></td>
</tr>
<tr> -->
    <th scope="row">Items Type</th>
    <td id="itemtypetd">
    <!-- <select class="multy_select" multiple="multiple" id="itemtype" name="itemtype[]" /></select> -->
    </td>
    <!-- <th scope="row">Based Adjustment Date</th>
    <td>
    <input id="bsadjdate" name="bsadjdate" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" />
    </td> -->
    <!-- <td colspan="2"/> -->
    </tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<aside class="title_line"><!-- title_line start -->
<h3>Location Info</h3>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form id="searchForm" name="searchForm" >
<input type="hidden" name="srchcdc" id="srchcdc" />  
<input type="hidden" name="srchrdc" id="srchrdc" />  
<input type="hidden" name="srchctcd" id="srchctcd" />  

<table class="type1"><!-- table start -->
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
    <th scope="row">Event Type</th>
    <td>
    <!-- <select class="w100p" id="srcheventype" name="srcheventype"></select> -->
     <label><input type="checkbox" disabled="disabled" id="chcdc" name="chcdc" value="cdc"/><span>CDC</span></label>
     <label><input type="checkbox" disabled="disabled" id="chrdc" name="chrdc" value="rdc"/><span>RDC</span></label>
     <label><input type="checkbox" disabled="disabled" id="chctcd" name="chctcd" value="ctcd"/><span>CT/CODY</span></label>
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
<h3>Adjustment Location</h3>
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
<form id='popupForm'>
    <input type="hidden" id="invntryNo" name="invntryNo">
    <input type="hidden" id="autoFlag" name="autoFlag">
    <input type="hidden" id="eventType" name="eventType">
    <input type="hidden" id="itmType" name="itmType">
</form>
<form id="listForm" name="listForm" method="POST">
<input type="hidden" id="retnVal"    name="retnVal"    value="R"/>
<%-- <input type="hidden" id="streq"     name="streq"     value="${searchVal.streq    }"/>
<input type="hidden" id="sttype"    name="sttype"    value="${searchVal.sttype   }"/>
<input type="hidden" id="smtype"    name="smtype"    value="${searchVal.smtype   }"/>
<input type="hidden" id="tlocation" name="tlocation" value="${searchVal.tlocation}"/>
<input type="hidden" id="flocation" name="flocation" value="${searchVal.flocation}"/>
<input type="hidden" id="crtsdt"    name="crtsdt"    value="${searchVal.crtsdt   }"/>
<input type="hidden" id="crtedt"    name="crtedt"    value="${searchVal.crtedt   }"/>
<input type="hidden" id="reqsdt"    name="reqsdt"    value="${searchVal.reqsdt   }"/>
<input type="hidden" id="reqedt"    name="reqedt"    value="${searchVal.reqedt   }"/>
<input type="hidden" id="sam"       name="sam"       value="${searchVal.sam      }"/>
<input type="hidden" id="sstatus"   name="sstatus"   value="${searchVal.sstatus  }"/> --%>
</form>
</section>
