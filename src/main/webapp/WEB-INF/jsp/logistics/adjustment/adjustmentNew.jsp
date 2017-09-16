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


var comboData = [{"codeId": "1","codeName": "CDC"},{"codeId": "2","codeName": "RDC"},{"codeId": "30","codeName": "CT/CODY"}];
var comboData = [{"codeId": "1","codeName": "CDC"},{"codeId": "2","codeName": "RDC"},{"codeId": "30","codeName": "CT/CODY"}];
var columnLayout=[
                     {dataField:"invntryNo" ,headerText:"Stock Audit No",width:120 ,height:30},
                     {dataField:"baseDt" ,headerText:"Base Date",width:120 ,height:30},
                     {dataField:"cnfm1" ,headerText:"cnfm1",width:120 ,height:30},
                     {dataField:"cnfm1Dt" ,headerText:"cnfm1Dt",width:120 ,height:30},
                     {dataField:"cnfm2" ,headerText:"cnfm2",width:120 ,height:30},
                     {dataField:"cnfm2Dt" ,headerText:"cnfm2Dt",width:120 ,height:30},
                     {dataField:"fileLoc" ,headerText:"fileLoc",width:120 ,height:30},
                     {dataField:"fileName" ,headerText:"fileName",width:120 ,height:30},
                     {dataField:"orgFileName" ,headerText:"orgFileName",width:120 ,height:30},
                     {dataField:"headTitle" ,headerText:"headTitle",width:120 ,height:30},
                     {dataField:"eventType" ,headerText:"eventType",width:120 ,height:30},
                     {dataField:"itmType" ,headerText:"itmType",width:120 ,height:30},
                     {dataField:"autoFlag" ,headerText:"autoFlag",width:120 ,height:30},
                     {dataField:"delFlag" ,headerText:"delFlag",width:120 ,height:30},
                     {dataField:"crtUser" ,headerText:"crtUser",width:120 ,height:30},
                     {dataField:"crtDate" ,headerText:"crtDate",width:120 ,height:30}
                    ];
var rescolumnLayout=[
                    {dataField:"invntryLocId" ,headerText:"invntryLocId",width:120 ,height:30},
                    {dataField:"invntryNo" ,headerText:"invntryNo",width:120 ,height:30},
                    {dataField:"docDt" ,headerText:"docDt",width:120 ,height:30},
                    {dataField:"locId" ,headerText:"locId",width:120 ,height:30},
                    {dataField:"serialPdChk" ,headerText:"serialPdChk",width:120 ,height:30},
                    {dataField:"serialFtChk" ,headerText:"serialFtChk",width:120 ,height:30},
                    {dataField:"serialPtChk" ,headerText:"serialPtChk",width:120 ,height:30},
                    {dataField:"saveYn" ,headerText:"saveYn",width:120 ,height:30},
                    {dataField:"seq" ,headerText:"seq",width:120 ,height:30},
                    {dataField:"itmId" ,headerText:"itmId",width:120 ,height:30},
                    {dataField:"itmNm" ,headerText:"itmNm",width:120 ,height:30},
                    {dataField:"itmType" ,headerText:"itmType",width:120 ,height:30},
                    {dataField:"serialChk" ,headerText:"serialChk",width:120 ,height:30},
                    {dataField:"sysQty" ,headerText:"sysQty",width:120 ,height:30},
                    {dataField:"cntQty" ,headerText:"cntQty",width:120 ,height:30},
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
//var reqcolumnLayout;

//var resop = {rowIdField : "rnum", showRowCheckColumn : true ,usePaging : true,useGroupingPanel : false , Editable:false};
//var reqop = {usePaging : true,useGroupingPanel : false , Editable:true};


var gridPros = {
        // 페이지 설정
        usePaging : false,               
       // pageRowCount : 1,              
        //fixedColumnCount : 1,
        // 편집 가능 여부 (기본값 : false)
        editable : false,                
        // 엔터키가 다음 행이 아닌 다음 칼럼으로 이동할지 여부 (기본값 : false)
        //enterKeyColumnBase : true,                
        // 셀 선택모드 (기본값: singleCell)
        // 컨텍스트 메뉴 사용 여부 (기본값 : false)
        //useContextMenu : true,                
        // 필터 사용 여부 (기본값 : false)
       // enableFilter : true,            
        // 그룹핑 패널 사용
        //useGroupingPanel : true,                
        // 상태 칼럼 사용
       // showStateColumn : true,                
        // 그룹핑 또는 트리로 만들었을 때 펼쳐지게 할지 여부 (기본값 : false)
       // displayTreeOpen : true,                
        noDataMessage : "<spring:message code='sys.info.grid.noDataMessage' />",                
        groupingMessage : "<spring:message code='sys.info.grid.groupingMessage' />"           
        //selectionMode : "multipleCells",
        //rowIdField : "stkid",
        //enableSorting : true,
        //showRowCheckColumn : true,'
          //  softRemoveRowMode:false

    };

var paramdata;
$(document).ready(function(){
    /**********************************
    * Header Setting
    ***********************************/
    doDefCombo(comboData, '' ,'eventtype', 'M', 'f_multiCombo');
    doDefCombo(comboData, '' ,'srch_eventtype', 'M', 'f_multiCombo');
    doGetCombo('/logistics/adjustment/selectCodeList.do', '15', '','itemtype', 'M' , 'f_multiCombo');
    doGetCombo('/logistics/adjustment/selectCodeList.do', '15', '','srch_itemtype', 'M' , 'f_multiCombo');
    //$("#cancelTr").hide();
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
    
    AUIGrid.bind(myGridID, "addRow", function(event){});
    AUIGrid.bind(myGridID, "cellEditBegin", function (event){});
    AUIGrid.bind(myGridID, "cellEditEnd", function (event){});
    AUIGrid.bind(myGridID, "cellClick", function( event ) {
        var invntryNo=AUIGrid.getCellValue(myGridID, event.rowIndex, "invntryNo");
        fn_subGrid(invntryNo);
    });
    
    AUIGrid.bind(myGridID, "cellDoubleClick", function(event){
           var invntryNo=AUIGrid.getCellValue(myGridID, event.rowIndex, "invntryNo");
          // var autoFlag=AUIGrid.getCellValue(myGridID, event.rowIndex, "autoFlag");

    
        fn_setLoc(invntryNo);
    });
    AUIGrid.bind(reqGrid, "cellDoubleClick", function(event){
           var invntryNo=AUIGrid.getCellValue(reqGrid, event.rowIndex, "invntryNo");
           var locId=AUIGrid.getCellValue(reqGrid, event.rowIndex, "locId");
          // var autoFlag=AUIGrid.getCellValue(myGridID, event.rowIndex, "autoFlag");
           $("#rAdjcode").val(invntryNo);
           $("#rAdjlocId").val(locId);
           //$("#rStatus").val("V");
           document.searchForm.action = '/logistics/adjustment/AdjustmentCounting.do';
           document.searchForm.submit(); 
    
    });
    
    AUIGrid.bind(myGridID, "ready", function(event) {});
    
    
});

//btn clickevent
$(function(){
    $("#create").click(function(){
        $("#popup_wrap").show();
        //$("#eventtype").hide()
    });
    
    $('#search').click(function() {
        searchAjax();
   
    });
    $('#save').click(function() {
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
            //$("#rAdjcode").val(AUIGrid.getCellValue(reqGrid,  selectedItem[0], "invntryNo"));
            //$("#rAdjlocId").val(AUIGrid.getCellValue(reqGrid,  selectedItem[0], "locId"));
            $("#rAdjcode").val(invntryNo);
            $("#rAdjlocId").val(locId);
            //$("#rStatus").val("V");
            document.searchForm.action = '/logistics/adjustment/AdjustmentCounting.do';
            document.searchForm.submit(); 
        } 
    });
     $('#confirm').click(function() {
            var selectedItem = AUIGrid.getSelectedIndex(myGridID);
            var invntryNo = AUIGrid.getCellValue(myGridID,  selectedItem[0], "invntryNo");
            //var invntryLocId = AUIGrid.getCellValue(reqGrid,  selectedItem[0], "invntryLocId");
        if(selectedItem[0] < 0 ){
            Common.alert('Please select Stock Audit Number.');
            return false;
        }else{
            //$("#rAdjcode").val(AUIGrid.getCellValue(reqGrid,  selectedItem[0], "invntryNo"));
            //$("#rAdjlocId").val(AUIGrid.getCellValue(reqGrid,  selectedItem[0], "locId"));
            $("#rAdjcode").val(invntryNo);
            //$("#rAdjlocId").val(invntryLocId);
            //$("#rStatus").val("V");
            document.searchForm.action = '/logistics/adjustment/AdjustmentApproval.do';
            document.searchForm.submit(); 
        } 
    });
     $('#approval').click(function() {
            var selectedItem = AUIGrid.getSelectedIndex(myGridID);
            var invntryNo = AUIGrid.getCellValue(myGridID,  selectedItem[0], "invntryNo");
            //var invntryLocId = AUIGrid.getCellValue(reqGrid,  selectedItem[0], "invntryLocId");
        if(selectedItem[0] < 0 ){
            Common.alert('Please select Stock Audit Number.');
            return false;
        }else{
            //$("#rAdjcode").val(AUIGrid.getCellValue(reqGrid,  selectedItem[0], "invntryNo"));
            //$("#rAdjlocId").val(AUIGrid.getCellValue(reqGrid,  selectedItem[0], "locId"));
            $("#rAdjcode").val(invntryNo);
            //$("#rAdjlocId").val(invntryLocId);
            //$("#rStatus").val("V");
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
               fn_setLoc(invntryNo);
               //fn_subGrid(invntryNo);
                   //$("#grid_wrap_sub_asi").show();
                   $("#count").show(); 
           } 
    });  
});


function searchAjax() {
    var url = "/logistics/adjustment/adjustmentList.do";
    var param = $('#searchForm').serializeJSON();
    console.log(param);
    Common.ajax("POST" , url , param , function(result){
        AUIGrid.setGridData(myGridID, result.dataList);
        $("#detail").show();
        $("#grid_wrap_sub_asi").show();
    });
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
        $('#srch_eventtype').change(function() {
        }).multipleSelect({
            selectAll : true
        });       
        $('#srch_itemtype').change(function() {

        }).multipleSelect({
            selectAll : true
        });       
    });
}


function fn_newAdjustment(){    
    var url = "/logistics/adjustment/createAdjustment.do";
    var param = $("#popform").serializeJSON();
    $.extend(param,{'auto_manual':'M'});//강제세팅함 
    console.log(param);
    Common.ajax("POST" , url , param , function(data){
        $("#popup_wrap").hide();
        searchAjax();
    });
    }
    
 function fn_setLoc(invntryNo){
    var url = "/logistics/adjustment/checkAdjustmentNo.do";
    var param = "invntryNo="+invntryNo;
    console.log("param");
    console.log(param);
    Common.ajax("GET" , url , param , function(data){
        console.log(data);
        var  data = data.data;
        var v="";
        if(data == "0"){
            v="N";
            fn_popSet(v);
        }else{
            v="Y";
            fn_popSet(v);
        }
        
        $("#popup_wrap2").show();
    });
    } 

function fn_popSet(v){
        var selectedItem = AUIGrid.getSelectedIndex(myGridID);
        var invntryNo = AUIGrid.getCellValue(myGridID ,selectedItem[0],'invntryNo');
        var autoFlag = AUIGrid.getCellValue(myGridID ,selectedItem[0],'autoFlag');
        var eventType = AUIGrid.getCellValue(myGridID ,selectedItem[0],'eventType');
        var itmType = AUIGrid.getCellValue(myGridID ,selectedItem[0],'itmType');
        var tmp = eventType.split(',');
        var tmp2 = itmType.split(',');
        
        $("#adjno2").val(invntryNo);
        
    if(v=="Y"){
        $("#popup_title2").text("View");
            $("#autobtn").hide();
            $("#manualbtn").hide();
            $("#view").show();
            //$("#count").show();
            
            if(autoFlag == "A"){
                $("#popup_title2").text("Auto");
                $("input[name='auto']").prop('checked', true);
                $("input[name='manual']").prop('checked', false);
            }else if(autoFlag == "M"){
                $("#popup_title2").text("Manual");
                $("input[name='auto']").prop('checked', false);
                $("input[name='manual']").prop('checked', true);
            }
            
            $("input[name='cdc']").prop('checked', false);
            $("input[name='rdc']").prop('checked', false);
            $("input[name='ctcd']").prop('checked', false);
            
            for(var i=0; i<tmp.length;i++){
                if(tmp[i]=="1"){
                     $("input[name='cdc']").prop('checked', true);
                }else if (tmp[i]=="2") {
                    $("input[name='rdc']").prop('checked', true);
                } else if(tmp[i]=="30"){
                    $("input[name='ctcd']").prop('checked', true);
                }
            }
            fn_itemSet(tmp2);
    }else if(v=="N"){
        
        if(autoFlag == "A"){
            $("#popup_title2").text("Auto");
            $("input[name='auto']").prop('checked', true);
            $("input[name='manual']").prop('checked', false);
            $("#autobtn").show();
            $("#manualbtn").hide();
            $("#view").hide();
            //$("#count").hide();
        }else if(autoFlag == "M"){
            $("#popup_title2").text("Manual");
            $("input[name='auto']").prop('checked', false);
            $("input[name='manual']").prop('checked', true);
            $("#autobtn").hide();
            $("#manualbtn").show();
            $("#view").hide();
            //$("#count").hide();
        }
        
        $("input[name='cdc']").prop('checked', false);
        $("input[name='rdc']").prop('checked', false);
        $("input[name='ctcd']").prop('checked', false);
        
        for(var i=0; i<tmp.length;i++){
            if(tmp[i]=="1"){
                 $("input[name='cdc']").prop('checked', true);
            }else if (tmp[i]=="2") {
                $("input[name='rdc']").prop('checked', true);
            } else if(tmp[i]=="30"){
                $("input[name='ctcd']").prop('checked', true);
            }
        }
        fn_itemSet(tmp2);
    }
    $("#popup_wrap2").show();
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
    var obj ="itemtypetd";
    $.each(data, function(index,value) {
               $("#"+data[index].code).remove();
    });
    obj= '#'+obj;
    $.each(data, function(index,value) {
                $('<label />',{id:data[index].code}).appendTo(obj);
                $('<input />',  {type : 'checkbox',value : data[index].codeId, id : data[index].codeId}).appendTo("#"+data[index].code).attr("disabled","disabled");
                $('<span />',  {text:data[index].codeName}).appendTo("#"+data[index].code);
        });
            
        for(var i=0; i<tmp2.length;i++){
            $.each(data, function(index,value) {
                if(tmp2[i]==data[index].codeId){
                    $("#"+data[index].codeId).attr("checked", "true");
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
    
    var url = "/logistics/adjustment/adjustmentAuto.do";
    $.ajax({
        type : "GET",
        url : url,
        data : {
            invntryNo    : invntryNo,
            autoFlag     : autoFlag,
            eventType   : eventType,
            itmType      : itmType
        },
        dataType : "json",
        contentType : "application/json;charset=UTF-8",
        success : function(data) {
            console.log(data);
           //fn_itemChck(data,tmp2);
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
        console.log("param");
        console.log(param);
        Common.ajax("GET" , url , param , function(data){
            console.log(data);
            AUIGrid.setGridData(reqGrid, data.dataList);
          $("#grid_wrap_sub_art").show();
        });
}

</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>logistics</li>
    <li>New Stock Audit Main</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>New-Stock Audit Main</h2>
</aside><!-- title_line end -->

<aside class="title_line"><!-- title_line start -->
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<aside class="title_line"><!-- title_line start -->
<ul class="right_btns">
    <li><p class="btn_blue"><a id="create">Create</a></p></li>
    <li><p class="btn_blue"><a id="edit">Edit</a></p></li>
    <li><p class="btn_blue"><a id="detail">Detail</a></p></li> 
    <li><p class="btn_blue"><a id="approval">Approval</a></p></li> 
    <li><p class="btn_blue"><a id="confirm">Confirm</a></p></li> 
    <li><p class="btn_blue"><a id="view">View</a></p></li> 
    <li><p class="btn_blue"><a id="search">Search</a></p></li>
</ul>
</aside><!-- title_line end -->
<form id="searchForm" name="searchForm" method="post"  onsubmit="return false;">
<input type="hidden" name="rAdjcode" id="rAdjcode" />  
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
    <td><input id="srch_adjno" name="adjno" type="text" title=""  class="w100p" /></td>
    <th scope="row">Event Type</th>
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
    <select class="multy_select" multiple="multiple" id="srch_catagorutype" name="srch_catagorutype[]" /></select>
    </td>
</tr>
<tr>
    <th scope="row">Stock Audit Date</th>
    <td>
    <input id="srch_bsadjdate" name="ssrch_bsadjdate" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" />
    </td>
    <td colspan="2">
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
   <!--  <li><p class="btn_blue"><a id="detail">Detail</a></p></li> -->
    <li><p class="btn_blue"><a id="count">Count</a></p></li>
</ul>
<section class="search_result"><!-- search_result start -->
<article class="grid_wrap" id="grid_wrap_sub_art"><!-- grid_wrap start -->
        <div id="grid_wrap_sub"></div>
</article>
<%-- <ul class="btns">
    <li><a id="rightbtn"><img src="${pageContext.request.contextPath}/resources/images/common/btn_right2.gif" alt="right" /></a></li>
</ul> --%>
<!-- <ul class="center_btns mt20">
    <li><p class="btn_blue2 big"><a id="list">List</a></p></li>&nbsp;&nbsp;<li><p class="btn_blue2 big"><a id="save">Save</a></p></li>
</ul> -->

</section><!-- search_result end -->
<form id='popupForm'>
    <input type="hidden" id="sUrl" name="sUrl">
    <input type="hidden" id="svalue" name="svalue">
</form>
</section>

<div id="popup_wrap" class="popup_wrap" style="display:none"><!-- popup_wrap start -->

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
    <td><input id="adjno" name="adjno" type="text" title="" placeholder="Automatic billing" class="readonly w100p" readonly="readonly" /></td>
     <th scope="row">Auto/Manual</th>
    <td id="automantd"> 
         <label><input type="radio" name="auto_manual" id="auto_manual" value="A" disabled="disabled"/><span>Auto</span></label>
         <label><input type="radio" name="auto_manual" id="auto_manual" value="M" disabled="disabled" checked /><span>Manual</span></label>        
    </td>
</tr>
<tr>
    <th scope="row">Event Type</th>
    <td>
   <select class="multy_select" multiple="multiple" id="eventtype" name="eventtype[]" /></select>
    </td>
    <!-- <th scope="row">Document Date</th>
    <td><input id="docdate" name="docdate" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></td> -->
    <th scope="row">Stock Audit Date</th>
    <td>
    <input id="bsadjdate" name="bsadjdate" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" />
    </td>
</tr>
<tr>
    <th scope="row">Items Type</th>
    <td>
    <select class="multy_select" multiple="multiple" id="itemtype" name="itemtype[]" /></select>
    </td>
    <!-- <td colspan="2"/> -->
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
                <li><p class="btn_blue2 big"><a id="cancel">CANCEL</a></p></li>
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
    <th scope="row">Event Type</th>
    <td>
   <!-- <select class="multy_select" multiple="multiple" id="eventtype" name="eventtype[]" /></select> -->
        <label><input type="checkbox" disabled="disabled" id="cdc" name="cdc"/><span>CDC</span></label>
     <label><input type="checkbox" disabled="disabled" id="rdc" name="rdc"/><span>RDC</span></label>
     <label><input type="checkbox" disabled="disabled" id="ctcd" name="ctcd"/><span>CT/CODY</span></label>
    </td>
    <!-- <th scope="row">Document Date</th>
    <td><input id="docdate" name="docdate" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></td> -->
<!--     <th scope="row">Based Stock Audit Date</th>
    <td>
    <input id="bsadjdate" name="bsadjdate" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" />
    </td>
</tr>
<tr> -->
    <th scope="row">Items Type</th>
    <td id="itemtypetd">
   <!--  <select class="multy_select" multiple="multiple" id="itemtype" name="itemtype[]" /></select> -->
    </td>
   <!-- <td colspan="2"/> -->
    </tr>
<!--     <tr>    
         <th scope="row">Remarks</th>
         <td colspan='3'><input type="text" name="doctext" id="doctext" class="w100p"/></td>
     </tr> -->
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