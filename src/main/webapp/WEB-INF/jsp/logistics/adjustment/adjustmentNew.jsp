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
var myGridID;
var reqGrid;


var columnLayout=[
                     {dataField:"invntryNo" ,headerText:"Stock Audit No",width:"20%" ,height:30},
                     {dataField:"baseDt" ,headerText:"Base Date",width:"20%" ,height:30},
                     {dataField:"cnfm1" ,headerText:"cnfm1",width:120 ,height:30, visible:false},
                     {dataField:"cnfm1Dt" ,headerText:"cnfm1Dt",width:120 ,height:30, visible:false},
                     {dataField:"cnfm2" ,headerText:"cnfm2",width:120 ,height:30, visible:false},
                     {dataField:"cnfm2Dt" ,headerText:"cnfm2Dt",width:120 ,height:30, visible:false},
                     {dataField:"fileLoc" ,headerText:"fileLoc",width:120 ,height:30, visible:false},
                     {dataField:"fileName" ,headerText:"fileName",width:120 ,height:30, visible:false},
                     {dataField:"orgFileName" ,headerText:"orgFileName",width:120 ,height:30, visible:false},
                     {dataField:"headTitle" ,headerText:"headTitle",width:120 ,height:30, visible:false},
                     {dataField:"eventType" ,headerText:"eventType",width:120 ,height:30, visible:false},
                     {dataField:"itmType" ,headerText:"itmType",width:120 ,height:30, visible:false},
                     {dataField:"ctgryType" ,headerText:"ctgryType",width:120 ,height:30, visible:false},
                     {dataField:"autoFlag" ,headerText:"autoFlag",width:120 ,height:30, visible:false},
                     {dataField:"delFlag" ,headerText:"Status",width:"20%" ,height:30},
                     {dataField:"crtUser" ,headerText:"Create User",width:"20%" ,height:30},
                     {dataField:"crtDate" ,headerText:"Create Date",width:"20%" ,height:30}
                    ];
var rescolumnLayout=[
                    {dataField:"invntryLocId" ,headerText:"invntryLocId",width:120 ,height:30, visible:false},
                    {dataField:"invntryNo" ,headerText:"Stock Audit No",width:120 ,height:30},
                    {dataField:"docDt" ,headerText:"Doc. Date",width:90 ,height:30},
                    {dataField:"whLocId" ,headerText:"Location ID",width:90 ,height:30, visible:false },
                    {dataField:"whLocCode" ,headerText:"Location Code",width:100 ,height:30, visible:false},
                    {dataField:"whLocDesc" ,headerText:"Location Desc",width:340 ,height:30},
                    /*                   {dataField:"locId" ,headerText:"Loc. ID",width:120 ,height:30},
                     {dataField:"serialPdChk" ,headerText:"serialPdChk",width:120 ,height:30},
                    {dataField:"serialFtChk" ,headerText:"serialFtChk",width:120 ,height:30},
                    {dataField:"serialPtChk" ,headerText:"serialPtChk",width:120 ,height:30}, */
                    {dataField:"saveYn" ,headerText:"Count Status",width:100 ,height:30},
                    {dataField:"seq" ,headerText:"Seq.",width:60 ,height:30},
                    {dataField:"itmId" ,headerText:"Item ID",width:100 ,height:30 , visible:false},
                    {dataField:"itmNm" ,headerText:"Item Name",width:340 ,height:30},
                    {dataField:"itmType" ,headerText:"Item Type",width:100 ,height:30 , visible:false},
                    {dataField:"itmTypeName" ,headerText:"Item Type",width:100 ,height:30},
                     {dataField:"ctgryType" ,headerText:"Catagory Type",width:100 ,height:30 , visible:false},
                     {dataField:"ctgryTypeName" ,headerText:"Catagory Type",width:100 ,height:30},
                    {dataField:"serialChk" ,headerText:"Serial Check",width:100 ,height:30},
                    {dataField:"sysQty" ,headerText:"System Qty",width:120 ,height:30},
                    {dataField:"cntQty" ,headerText:"Count Qty",width:120 ,height:30},
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



var gridPros = {
        usePaging : false,               
        editable : false,                
        noDataMessage : "<spring:message code='sys.info.grid.noDataMessage' />",                
        groupingMessage : "<spring:message code='sys.info.grid.groupingMessage' />"           

    };

var paramdata;
$(document).ready(function(){
    /**********************************
    * Header Setting
    ***********************************/
    //doGetCombo('/logistics/adjustment/selectCodeList.do', '339', '','srch_eventtype', 'M' , 'f_multiCombo');
    //doGetCombo('/logistics/adjustment/selectCodeList.do', '15', '','srch_itemtype', 'M' , 'f_multiCombo');
    //doGetCombo('/logistics/adjustment/selectCodeList.do', '11', '','srch_catagorytype', 'M' , 'f_multiCombo');
    /**********************************
     * Header Setting End
     ***********************************/
    fromView();
    myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,"", gridPros);
    reqGrid = GridCommon.createAUIGrid("grid_wrap_sub", rescolumnLayout,"", gridPros);
   $("#grid_wrap_sub_art").hide();
   $("#grid_wrap_sub_asi").hide();
   $("#detail").hide(); 
   $("#count").hide(); 
   $("#approval").hide(); 
   $("#list").hide(); 
   $("#view").hide(); 
   $("#close").hide(); 
    
    AUIGrid.bind(myGridID, "addRow", function(event){});
    AUIGrid.bind(myGridID, "cellEditBegin", function (event){});
    AUIGrid.bind(myGridID, "cellEditEnd", function (event){});
    AUIGrid.bind(myGridID, "cellClick", function( event ) {
        var invntryNo=AUIGrid.getCellValue(myGridID, event.rowIndex, "invntryNo");
        var delFlag=AUIGrid.getCellValue(myGridID, event.rowIndex, "delFlag");
        if("C"==delFlag){
        	$("#count").hide();
        }else{
        	$("#count").show();
        	
        }
        
        fn_subGrid(invntryNo);
    });
    
    AUIGrid.bind(myGridID, "cellDoubleClick", function(event){});
    AUIGrid.bind(reqGrid, "cellDoubleClick", function(event){
    /*        var invntryNo=AUIGrid.getCellValue(reqGrid, event.rowIndex, "invntryNo");
           var locId=AUIGrid.getCellValue(reqGrid, event.rowIndex, "locId");
           $("#rAdjcode").val(invntryNo);
           $("#rAdjlocId").val(locId);
           document.searchForm.action = '/logistics/adjustment/AdjustmentCounting.do';
           document.searchForm.submit();  */
    
    });
    
    AUIGrid.bind(myGridID, "ready", function(event) {});
    
    
});

//btn clickevent
$(function(){
    $("#create").click(function(){
        doGetCombo('/logistics/adjustment/selectCodeList.do', '339', '','eventtype', 'M' , 'f_multiCombo');
        doGetCombo('/logistics/adjustment/selectCodeList.do', '15', '','itemtype', 'M' , 'f_multiCombo');
        doGetCombo('/logistics/adjustment/selectCodeList.do', '11', '','catagorytype', 'M' , 'f_multiCombo');
        $("#doctext").val("");
        $("#popup_wrap").show();
        doSysdate(0 , 'bsadjdate');
    });
    $("#close").click(function(){
    	   fn_close();
    });
    
    $('#search').click(function() {
        searchAjax();
   
    });
    $('#save').click(function() {
    	if(""==$('#eventtype').val() || null==$('#eventtype').val()){
    	      Common.alert("Please select the Location Type.");
              $("#eventtype").focus();
              return false;
    	}
    	if(""==$('#catagorytype').val() || null==$('#catagorytype').val()){
    	      Common.alert("Please select the Catagory Type.");
              $("#catagorytype").focus();
              return false;
    	}
    	if(""==$('#itemtype').val() || null==$('#itemtype').val()){
    	      Common.alert("Please select the Item Type.");
              $("#itemtype").focus();
              return false;
    	}
    	if(""==$('#doctext').val()  || null== $('#doctext').val()){
    	      Common.alert("Please input Remarks.");
              $("#doctext").focus();
              return false;
    	}
        fn_newAdjustment();
    });
    $('#autobtn').click(function() {
        fn_auto();
        var selectedItem = AUIGrid.getSelectedIndex(myGridID);
        $("#rAdjcode").val(AUIGrid.getCellValue(myGridID,  selectedItem[0], "invntryNo"));
        document.searchForm.action = '/logistics/adjustment/AdjustmentRegisterView.do';
        document.searchForm.submit(); 
    });
    $('#manualbtn').click(function() {
         var selectedItem = AUIGrid.getSelectedIndex(myGridID);
        $("#rAdjcode").val(AUIGrid.getCellValue(myGridID, selectedItem[0], "invntryNo"));
        document.searchForm.action = '/logistics/adjustment/AdjustmentRegisterView.do';
        document.searchForm.submit(); 
    });
        
    $('#view, #viewbtn').click(function() {
        var selectedItem = AUIGrid.getSelectedIndex(myGridID);
        $("#rAdjcode").val(AUIGrid.getCellValue(myGridID,  selectedItem[0], "invntryNo"));
        $("#rStatus").val("V");
        document.searchForm.action = '/logistics/adjustment/AdjustmentRegisterView.do';
        document.searchForm.submit(); 
    });
     $('#count').click(function() {
            var selectedItem = AUIGrid.getSelectedIndex(reqGrid);
            var invntryNo = AUIGrid.getCellValue(reqGrid,  selectedItem[0], "invntryNo");
            var locId = AUIGrid.getCellValue(reqGrid,  selectedItem[0], "locId");
             AUIGrid.resize(reqGrid); 
        if(selectedItem[0] < 0 ){
            Common.alert('Please select Stock Audit Number.');
            return false;
        }else{
            $("#rAdjcode").val(invntryNo);
            $("#rAdjlocId").val(locId);
            document.searchForm.action = '/logistics/adjustment/AdjustmentCounting.do';
            document.searchForm.submit(); 
        } 
    });
     $('#list').click(function() {
            var selectedItem = AUIGrid.getSelectedIndex(myGridID);
            var invntryNo = AUIGrid.getCellValue(myGridID,  selectedItem[0], "invntryNo");
        if(selectedItem[0] < 0 ){
            Common.alert('Please select Stock Audit Number.');
            return false;
        }else{
            $("#rAdjcode").val(invntryNo);
            document.searchForm.action = '/logistics/adjustment/AdjustmentApprovalList.do';
            document.searchForm.submit(); 
        } 
    });
     $('#approval').click(function() {
            var selectedItem = AUIGrid.getSelectedIndex(myGridID);
            var invntryNo = AUIGrid.getCellValue(myGridID,  selectedItem[0], "invntryNo");
        if(selectedItem[0] < 0 ){
            Common.alert('Please select Stock Audit Number.');
            return false;
        }else{
            $("#rAdjcode").val(invntryNo);
            document.searchForm.action = '/logistics/adjustment/AdjustmentApprovalSteps.do';
            document.searchForm.submit(); 
        } 
    });
      $('#detail').click(function() {
        var selectedItem = AUIGrid.getSelectedIndex(myGridID);
        var invntryNo = AUIGrid.getCellValue(myGridID,  selectedItem[0], "invntryNo");
           if(selectedItem[0] < 0 ){
               Common.alert('Please select Stock Audit Number.');
           }else{
               fn_checkDetailAuthority(invntryNo);
           } 
    });  
});


function fn_close() {
    var selectedItem = AUIGrid.getSelectedIndex(myGridID);
    var invntryNo = AUIGrid.getCellValue(myGridID ,selectedItem[0],'invntryNo');
    var delFlag = AUIGrid.getCellValue(myGridID ,selectedItem[0],'delFlag');
    if("C"==delFlag){
    	Common.alert("Can't Close selected Stock Audit No.");
    	return false
    }
    
    var url = "/logistics/adjustment/closeAudit.do";
    var param = {
    		adjNo: invntryNo
    };
    Common.ajax("GET" , url , param , function(result){
    	searchAjax();
    });
}
function searchAjax() {
    var url = "/logistics/adjustment/adjustmentList.do";
    var param = $('#searchForm').serializeJSON();
    $.extend(param,{'oderby':'desc'});
    Common.ajax("POST" , url , param , function(result){
        AUIGrid.setGridData(myGridID, result.dataList);
        $("#detail").show();
        $("#grid_wrap_sub_asi").show();
        $("#approval").show(); 
        $("#list").show(); 
        $("#view").show(); 
        $("#close").show(); 
    });
}

function f_multiCombo() {
    $(function() {
        $('#eventtype, #itemtype, #catagorytype').change(function() {
        }).multipleSelect({
            selectAll : true
        });       
        $('#srch_eventtype, #srch_itemtype , #srch_catagorytype').change(function() {
        }).multipleSelect({
            selectAll : true
        });       
    });
}


function fn_newAdjustment(){    
    var url = "/logistics/adjustment/createAdjustment.do";
    var param = $("#popform").serializeJSON();
    $.extend(param,{'auto_manual':'M'});//강제세팅함 
    
    Common.ajax("POST" , url , param , function(data){
        $("#popup_wrap").hide();
        searchAjax();
    });
    }
    
 function fn_checkDetailAuthority(invntryNo){
    var url = "/logistics/adjustment/checkAdjustmentNo.do";
    var param = "invntryNo="+invntryNo;
    Common.ajax("GET" , url , param , function(data){
        var  data = data.data;
        var v="";
        if(data == "0"){
            v="N";
            fn_popSet(v);
        }else{
            v="Y";
            fn_popSet(v);
        }
        
    });
    } 

function fn_popSet(v){
        var selectedItem = AUIGrid.getSelectedIndex(myGridID);
        var invntryNo = AUIGrid.getCellValue(myGridID ,selectedItem[0],'invntryNo');
        var autoFlag = AUIGrid.getCellValue(myGridID ,selectedItem[0],'autoFlag');
        var eventType = AUIGrid.getCellValue(myGridID ,selectedItem[0],'eventType');
        var itmType = AUIGrid.getCellValue(myGridID ,selectedItem[0],'itmType');
        var ctgryType = AUIGrid.getCellValue(myGridID ,selectedItem[0],'ctgryType');
        var tmp = eventType.split(',');
        var tmp2 = itmType.split(',');
        var tmp3 = ctgryType.split(',');
        
        $("#adjno2").val(invntryNo);
        
    if(v=="Y"){
        $("#popup_title2").text("View");
            $("#autobtn").hide();
            $("#manualbtn").hide();
            $("#viewbtn").show();
            $("#count").show();
            
            if(autoFlag == "A"){
                $("#popup_title2").text("Auto");
                $("input[name='auto']").prop('checked', true);
                $("input[name='manual']").prop('checked', false);
            }else if(autoFlag == "M"){
                $("#popup_title2").text("Manual");
                $("input[name='auto']").prop('checked', false);
                $("input[name='manual']").prop('checked', true);
            }
            
            fn_itemSet(tmp,"event");
            fn_itemSet(tmp2,"item");
            fn_itemSet(tmp3,"catagory");
    }else if(v=="N"){
        
        if(autoFlag == "A"){
            $("#popup_title2").text("Auto");
            $("input[name='auto']").prop('checked', true);
            $("input[name='manual']").prop('checked', false);
            $("#autobtn").show();
            $("#manualbtn").hide();
            $("#viewbtn").hide();
        }else if(autoFlag == "M"){
            $("#popup_title2").text("Manual");
            $("input[name='auto']").prop('checked', false);
            $("input[name='manual']").prop('checked', true);
            $("#autobtn").hide();
            $("#manualbtn").show();
            $("#viewbtn").hide();
        }
        
        fn_itemSet(tmp,"event");
        fn_itemSet(tmp2,"item");
        fn_itemSet(tmp3,"catagory");
    }
    $("#popup_wrap2").show();
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
	    if(str=="event"){
		    obj ="eventtypetd";
	    }else if(str=="item"){
		    obj ="itemtypetd";
	    }else if(str=="catagory"){
		    obj ="catagorytypetd";
	    }
    $.each(data, function(index,value) {
               $('#'+data[index].code).remove();
    });
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

function fn_auto(){
    var selectedItem = AUIGrid.getSelectedIndex(myGridID);
    var invntryNo = AUIGrid.getCellValue(myGridID ,selectedItem[0],'invntryNo');
    var autoFlag = AUIGrid.getCellValue(myGridID ,selectedItem[0],'autoFlag');
    var eventType = AUIGrid.getCellValue(myGridID ,selectedItem[0],'eventType');
    var itmType = AUIGrid.getCellValue(myGridID ,selectedItem[0],'itmType');
    var ctgryType = AUIGrid.getCellValue(myGridID ,selectedItem[0],'ctgryType');
    var url = "/logistics/adjustment/adjustmentAuto.do";
    $.ajax({
        type : "GET",
        url : url,
        data : {
            invntryNo    : invntryNo,
            autoFlag     : autoFlag,
            eventType   : eventType,
            ctgryType   : ctgryType,
            itmType      : itmType
        },
        dataType : "json",
        contentType : "application/json;charset=UTF-8",
        success : function(data) {
             $("#popup_wrap2").hide();
             searchAjax();
        },
        error : function(jqXHR, textStatus, errorThrown) {
        },
        complete : function() {
        }
    });
}
function fromView(){
    var re ="${retnVal }";
    if(re){
        searchAjax();
    }
}
function fn_subGrid(invntryNo){
     var url = "/logistics/adjustment/adjustmentDetailLoc.do";
        var param = "invntryNo="+invntryNo;
        Common.ajax("GET" , url , param , function(data){
        	var list= data.dataList
        	
            AUIGrid.setGridData(reqGrid, list);
          $("#grid_wrap_sub_art").show();
          
        });
}

</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>logistics</li>
    <li>Main - Stock Audit</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Main - Stock Audit</h2>
</aside><!-- title_line end -->

<aside class="title_line"><!-- title_line start -->
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<aside class="title_line"><!-- title_line start -->
<ul class="right_btns">
    <li><p class="btn_blue"><a id="create">Create</a></p></li>
    <li><p class="btn_blue"><a id="close">Close</a></p></li>
    <li><p class="btn_blue"><a id="detail">Detail</a></p></li> 
    <li><p class="btn_blue"><a id="approval">Approval</a></p></li> 
    <li><p class="btn_blue"><a id="list">List</a></p></li> 
    <!-- <li><p class="btn_blue"><a id="view">View</a></p></li>  -->
    <li><p class="btn_blue"><a id="search">Search</a></p></li>
</ul>
</aside><!-- title_line end -->
<form id="searchForm" name="searchForm" method="post"  onsubmit="return false;">
<input type="hidden" name="rAdjcode" id="rAdjcode" />  
<input type="hidden" name="rStatus" id="rStatus" />  
<input type="hidden" name="rAdjlocId" id="rAdjlocId" />  
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
    <td><input id="srch_adjno" name="srch_adjno" type="text" title=""  class="w100p" /></td>
    <th scope="row">Stock Audit Date</th>
    <td>
    <input id="srch_bsadjdate" name="srch_bsadjdate" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" />
    </td>
    <!-- <th scope="row">Location Type</th>
    <td>
    <select class="multy_select" multiple="multiple" id="srch_eventtype" name="srch_eventtype[]"  style="display: none;"/></select>
    </td>
</tr>
<tr>
    
    <th scope="row">Items Type</th>
    <td>
    <select class="multy_select" multiple="multiple" id="srch_itemtype" name="srch_itemtype[]" /></select>
    </td>
    <th scope="row">Category Type</th>
    <td>
    <select class="multy_select" multiple="multiple" id="srch_catagorytype" name="srch_catagorytype[]" /></select>
    </td>
</tr>
<tr>
    <th scope="row">Stock Audit Date</th>
    <td>
    <input id="srch_bsadjdate" name="ssrch_bsadjdate" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" />
    </td>
    <td colspan="2"> -->
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<article class="grid_wrap"><!-- grid_wrap start -->
        <div id="grid_wrap"></div>
</article>
<aside class="title_line" id="grid_wrap_sub_asi"><!-- title_line start -->
<h3>Stock Audit Location Detail</h3>
</aside><!-- title_line end -->
<ul class="right_btns">
    <li><p class="btn_blue"><a id="count">Count</a></p></li>
</ul>
<section class="search_result"><!-- search_result start -->
<article class="grid_wrap" id="grid_wrap_sub_art"><!-- grid_wrap start -->
        <div id="grid_wrap_sub"></div>
</article>

</section><!-- search_result end -->
</section>

<div id="popup_wrap" class="size_big popup_wrap" style="display:none"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1 id="popup_title">New Stock Audit Main</h1>
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
    <th scope="row">Stock Audit Number</th>
    <td><input id="adjno" name="adjno" type="text" title="" placeholder="Automatic" class="readonly w100p" readonly="readonly" /></td>
     <th scope="row">Auto/Manual</th>
    <td id="automantd"> 
         <label><input type="radio" name="auto_manual" id="auto_manual" value="A" disabled="disabled"/><span>Auto</span></label>
         <label><input type="radio" name="auto_manual" id="auto_manual" value="M" disabled="disabled" checked /><span>Manual</span></label>        
    </td>
</tr>
<tr>
    <th scope="row">Location Type</th>
    <td>
    <select class="multy_select" multiple="multiple" id="eventtype" name="eventtype[]" /></select>
    </td>
    <!-- <th scope="row">Document Date</th>
    <td><input id="docdate" name="docdate" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></td> -->
    <th scope="row">Category Type</th>
    <td>
    <select class="multy_select" multiple="multiple" id="catagorytype" name="catagorytype[]" /></select>
    </td>
</tr>
<tr>
    <th scope="row">Items Type</th>
    <td>
    <select class="multy_select" multiple="multiple" id="itemtype" name="itemtype[]" /></select>
    </td>
    <th scope="row">Stock Audit Date</th>
    <td>
    <input id="bsadjdate" name="bsadjdate" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" />
    </td>
    </tr>
    <tr>    
         <th scope="row">Remarks</th>
         <td colspan='3'><input type="text" name="doctext" id="doctext" class="w100p"/></td>
     </tr>
</tbody>
</table>
</form>
            <ul class="center_btns">
               <li><p class="btn_blue2 big"><a id="save">SAVE</a></p></li> 
               <!--  <li><p class="btn_blue2 big"><a id="cancel">CANCEL</a></p></li> -->
            </ul>
</section><!-- pop_body end -->
<form id='popupForm'>
    <input type="hidden" id="sUrl" name="sUrl">
    <input type="hidden" id="svalue" name="svalue">
</form>
</div>


<div id="popup_wrap2" class="popup_wrap" style="display:none"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1 id="popup_title2">New Stock Audit</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->
<section class="pop_body"><!-- pop_body start -->
<form id="pop2form">
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
    <td><input id="adjno2" name="adjno" type="text" title=""  class="w100p" readonly="readonly" /></td>
    <th scope="row">Auto/Manual</th>
    <td> 
         <label><input type="radio" name="auto" id="auto"    disabled="disabled" /><span>Auto</span></label>
         <label><input type="radio" name="manual" id="manual"   disabled="disabled" /><span>Manual</span></label>
    </td>
</tr>
<tr>
    <th scope="row">Location Type</th>
    <td id="eventtypetd">
    <th scope="row">Items Type</th>
    <td id="itemtypetd">
    </td>
    </tr>
     <tr>
         <th scope="row">Category Type</th>
    <td id="catagorytypetd" colspan="3">
     </tr>
</tbody>
</table>
</form>
            <ul class="center_btns">
                <li><p class="btn_blue2 big"><a id="autobtn">Auto</a></p></li>
                <li><p class="btn_blue2 big"><a id="manualbtn">Manual</a></p></li>
                <li><p class="btn_blue2 big"><a id="viewbtn">View</a></p></li> 
                <!-- <li><p class="btn_blue2 big"><a id="count">Count</a></p></li> --> 
            </ul> 
</section><!-- pop_body end -->
<form id='popupForm'>
    <input type="hidden" id="sUrl" name="sUrl">
    <input type="hidden" id="svalue" name="svalue">
</form>
</div>