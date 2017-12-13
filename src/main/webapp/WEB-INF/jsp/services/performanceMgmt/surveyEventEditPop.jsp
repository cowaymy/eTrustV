<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
var myGridID_InfoEdit;
var myGridID_QEdit;
var myGridID_TargetEdit;

var columnLayout_infoEdit=[             
 {dataField:"evtTypeId", headerText:'Event Type', width: 130, editable : false},
 {dataField:"evtTypeDesc", headerText:'Event Name', width: 170, editable : true},
 {dataField:"memCode", headerText:'In Charge of</br>the Event', width: 130, editable : true},
 {dataField:"evtDt", headerText:'Date for</br>the Event', width: 130, editable : true, dataType : "date", formatString : "dd/mm/yyyy"},
 {dataField:"evtCompRqstDate", headerText:'Requested</br>Complete Date', width: 130, editable : true, dataType : "date", formatString : "dd/mm/yyyy"},
 {dataField:"evtCompRate", headerText:'Complete</br>Condition Rate', width: 130, editable : true},
 {dataField:"com", headerText:'Complete</br>Status', editable : false},
];

var columnLayout_qEdit=[             
 {dataField:"hcDefCtgryId", headerText:'Feedback</br>Type', width: 200, editable : false},
 {dataField:"hcDefDesc", headerText:'Question', editable : true},
];

var columnLayout_targetEdit=[             
 {dataField:"salesOrdNo", headerText:'Sales Order', width: 250, editable : true},
 {dataField:"name", headerText:'Name', width: 250, editable : true},
 {dataField:"contNo", headerText:'Contact Number', width: 250, editable : true},
 {dataField:"callMem", headerText:'Calling Agent', editable : true},
];


var gridOptions_infoEdit = {
        headerHeight : 30,
        selectionMode: "singleRow",
        showStateColumn: false,
        showRowNumColumn: false,
        usePaging : false,
        pageRowCount : 20, //한 화면에 출력되는 행 개수 20(기본값:20)
        showFooter : false
};

var gridOptions_qEdit = {   
        headerHeight : 30,
        selectionMode: "singleRow",
        showStateColumn: false,
        usePaging : true,
        pageRowCount : 20, //한 화면에 출력되는 행 개수 20(기본값:20)
        showFooter : false
};
  
var gridOptions_targetEdit = {
        selectionMode: "singleRow",
        showStateColumn: false,
        usePaging : true,
        pageRowCount : 20, //한 화면에 출력되는 행 개수 20(기본값:20)
        showFooter : false
};


$(document).ready(function(){
	
    $("#popEvtTypeDescView").val("${popEvtTypeDesc}");
    $("#popMemCodeView").val("${popMemCode}");
    $("#popEvtDtView").val("${popEvtDt}"); 
    $("#popEvtIdView").val("${popEvtId}"); 


    myGridID_InfoEdit = GridCommon.createAUIGrid("grid_wrap_infoEdit", columnLayout_infoEdit, "", gridOptions_infoEdit);
    myGridID_QEdit = GridCommon.createAUIGrid("grid_wrap_qEdit", columnLayout_qEdit, "", gridOptions_qEdit);
    myGridID_TargetEdit = GridCommon.createAUIGrid("grid_wrap_targetEdit", columnLayout_targetEdit, "", gridOptions_targetEdit);
    

    //var cmbMemberTypeId22 = $("#popEvtDtView").val();
    //alert(cmbMemberTypeId22);

    //var item_infoView = { "hcTypeId" :  "2718", "evtTypeDesc" : "${popEvtTypeDesc}", "evtMemId" : "${popMemCode}", "evtDt" :  "${popEvtDt}", "evtCompRqstDate" :  "", "evtCompRate" :  "", "com" :  ""}; //row 추가
    //AUIGrid.addRow(myGridID_InfoView, item_infoView, "last");
    
      
     Common.ajax("GET","/services/performanceMgmt/selectSurveyEventDisplayInfoList",$("#listEditForm").serialize(),function(result) {
    	console.log("성공.");
    	console.log("data : "+ result);
    	AUIGrid.setGridData(myGridID_InfoEdit,result);
    });  
    
     Common.ajax("GET","/services/performanceMgmt/selectSurveyEventDisplayQList",$("#listEditForm").serialize(),function(result) {
        console.log("성공.");
        console.log("data : "+ result);
        AUIGrid.setGridData(myGridID_QEdit,result);
    });  
    
    Common.ajax("GET","/services/performanceMgmt/selectSurveyEventDisplayTargetList",$("#listEditForm").serialize(),function(result) {
        console.log("성공.");
        console.log("data : "+ result);
        AUIGrid.setGridData(myGridID_TargetEdit,result);
    });   
    
    
  //두번째 grid 행 추가
    $("#addRow_qEdit").click(function() { 
       var item_qEdit = {"hcDefCtgryId" : "", "hcDefDesc" : ""}; //row 추가
       AUIGrid.addRow(myGridID_QEdit, item_qEdit, "last");
   });
   
    //세번째 grid 행 추가
    $("#addRow_targetEdit").click(function() { 
       var item_targetEdit = { "salesOrdNo" :  "", "name" : "", "contNo" : "", "callMem" : ""}; //row 추가
       AUIGrid.addRow(myGridID_TargetEdit, item_targetEdit, "last");
       
       //var rowCount22 = AUIGrid.getRowCount(myGridID_Target);
       //alert("rowCount"+rowCount22);
   });
    
  
}); //Ready

function removeRow_qEdit(){
    var selectedItems_q = AUIGrid.getSelectedItems(myGridID_QEdit);
    if(selectedItems_q.length <= 0) {
        Common.alert("<spring:message code='expense.msg.NoData'/> ");
        return;
    }
    AUIGrid.removeRow(myGridID_QEdit, "selectedIndex");
    AUIGrid.removeSoftRows(myGridID_QEdit);
}

function removeRow_targetEdit(){
    var selectedItems_t = AUIGrid.getSelectedItems(myGridID_TargetEdit);
    if(selectedItems_t.length <= 0) {
        Common.alert("<spring:message code='expense.msg.NoData'/> ");
        return;
    }
    AUIGrid.removeRow(myGridID_TargetEdit, "selectedIndex");
    AUIGrid.removeSoftRows(myGridID_TargetEdit);
}

</script>   

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Survey Event Edit</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->


<section class="pop_body"><!-- pop_body start -->
<form action="#" id="listEditForm" name="listEditForm" method="post">
    <input type="hidden" id="popEvtTypeDescView" name="popEvtTypeDescView" /> 
    <input type="hidden" id="popMemCodeVeiw" name="popMemCodeVeiw" /> 
    <input type="hidden" id="popEvtDtView" name="popEvtDtView" /> 
    <input type="hidden" id="popEvtIdView" name="popEvtIdView" /> 
</form>

<form action="#" method="post" id="listDForm" name="listDForm">

<aside class="title_line"><!-- title_line start -->
<h2>Survey Event General Info</h2>
</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grid_wrap_infoEdit" style="width:100%; height:58px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

<aside class="title_line"><!-- title_line start -->
<h2>Survey Questionnaires</h2>
</aside><!-- title_line end -->

<ul class="right_btns">
    <li><p class="btn_grid"><a href="#" id="addRow_qEdit">add</a></p></li>
    <li><p class="btn_grid"><a href="#" onclick="javascript:removeRow_qEdit()">del</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grid_wrap_qEdit" style="width:100%; height:130px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

<aside class="title_line"><!-- title_line start -->
<h2>Survey Target and Calling Agent</h2>
</aside><!-- title_line end -->

<ul class="right_btns">
    <li><p class="btn_grid"><a href="#" id="addRow_targetEdit">add</a></p></li>
    <li><p class="btn_grid"><a href="#" onclick="javascript:removeRow_targetEdit()">del</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grid_wrap_targetEdit" style="width:100%; height:120px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</form>
<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" id="save_edit">Save</a></p></li>
</ul>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->