<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
var myGridID_InfoView;
var myGridID_QView;
var myGridID_TargetView;

var columnLayout_infoView=[             
 {dataField:"evtTypeId", headerText:'Event Type', width: 130, editable : false},
 {dataField:"evtTypeDesc", headerText:'Event Name', width: 170, editable : false},
 {dataField:"memCode", headerText:'In Charge of</br>the Event', width: 130, editable : false},
 {dataField:"evtDt", headerText:'Date for</br>the Event', width: 130, editable : false, dataType : "date", formatString : "dd/mm/yyyy"},
 {dataField:"evtCompRqstDate", headerText:'Requested</br>Complete Date', width: 130, editable : false, dataType : "date", formatString : "dd/mm/yyyy"},
 {dataField:"evtCompRate", headerText:'Complete</br>Condition Rate', width: 130, editable : false},
 {dataField:"com", headerText:'Complete</br>Status', editable : false}
];

var columnLayout_qView=[             
 {dataField:"hcDefCtgryId", headerText:'Feedback</br>Type', width: 200, editable : false},
 {dataField:"hcDefDesc", headerText:'Question', editable : false}
];

var columnLayout_targetView=[             
 {dataField:"salesOrdNo", headerText:'Sales Order', width: 250, editable : false},
 {dataField:"name", headerText:'Name', width: 250, editable : false},
 {dataField:"contNo", headerText:'Contact Number', width: 250, editable : false},
 {dataField:"callMem", headerText:'Calling Agent', editable : false}
];


var gridOptions_infoView = {
        headerHeight : 30,
        selectionMode: "singleRow",
        showStateColumn: false,
        showRowNumColumn: false,
        usePaging : false,
        pageRowCount : 20, //한 화면에 출력되는 행 개수 20(기본값:20)
        showFooter : false
};

var gridOptions_qView = {   
        headerHeight : 30,
        selectionMode: "singleRow",
        showStateColumn: false,
        usePaging : true,
        pageRowCount : 20, //한 화면에 출력되는 행 개수 20(기본값:20)
        showFooter : false,
        //showAutoNoDataMessage : false
};
  
var gridOptions_targetView = {
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


    myGridID_InfoView = GridCommon.createAUIGrid("grid_wrap_infoView", columnLayout_infoView, "", gridOptions_infoView);
    myGridID_QView = GridCommon.createAUIGrid("grid_wrap_qView", columnLayout_qView, "", gridOptions_qView);
    myGridID_TargetView = GridCommon.createAUIGrid("grid_wrap_targetView", columnLayout_targetView, "", gridOptions_targetView);
    

    //var cmbMemberTypeId22 = $("#popEvtDtView").val();
    //alert(cmbMemberTypeId22);

    //var item_infoView = { "hcTypeId" :  "2718", "evtTypeDesc" : "${popEvtTypeDesc}", "evtMemId" : "${popMemCode}", "evtDt" :  "${popEvtDt}", "evtCompRqstDate" :  "", "evtCompRate" :  "", "com" :  ""}; //row 추가
    //AUIGrid.addRow(myGridID_InfoView, item_infoView, "last");
    
      
    Common.ajax("GET","/services/performanceMgmt/selectSurveyEventDisplayInfoList",$("#listViewForm").serialize(),function(result) {
    	console.log("성공.");
    	console.log("data : "+ result);
    	AUIGrid.setGridData(myGridID_InfoView,result);
    });  
    
    Common.ajax("GET","/services/performanceMgmt/selectSurveyEventDisplayQList",$("#listViewForm").serialize(),function(result) {
        console.log("성공.");
        console.log("data : "+ result);
        AUIGrid.setGridData(myGridID_QView,result);
    });  
    
    Common.ajax("GET","/services/performanceMgmt/selectSurveyEventDisplayTargetList",$("#listViewForm").serialize(),function(result) {
        console.log("성공.");
        console.log("data : "+ result);
        AUIGrid.setGridData(myGridID_TargetView,result);
    });  
    
    
  
}); //Ready

</script>   

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Survey Event Display</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->


<section class="pop_body"><!-- pop_body start -->
<form action="#" id="listViewForm" name="listViewForm" method="post">
    <input type="hidden" id="popEvtTypeDescView" name="popEvtTypeDescView" /> 
    <input type="hidden" id="popMemCodeView" name="popMemCodeView" /> 
    <input type="hidden" id="popEvtDtView" name="popEvtDtView" /> 
    <input type="hidden" id="popEvtIdView" name="popEvtIdView" /> 
</form>

<form action="#" method="post" id="listDForm" name="listDForm">

<aside class="title_line"><!-- title_line start -->
<h2>Survey Event General Info</h2>
</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grid_wrap_infoView" style="width:100%; height:58px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

<aside class="title_line"><!-- title_line start -->
<h2>Survey Questionnaires</h2>
</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grid_wrap_qView" style="width:100%; height:130px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

<aside class="title_line"><!-- title_line start -->
<h2>Survey Target and Calling Agent</h2>
</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grid_wrap_targetView" style="width:100%; height:120px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</form>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->