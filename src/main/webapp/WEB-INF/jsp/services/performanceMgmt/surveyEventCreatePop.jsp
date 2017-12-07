<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
var myGridID_Info;
var myGridID_Q;
var myGridID_Target;


var  CodeList = [];

var columnLayout_info=[             
 {dataField:"hcTypeId", headerText:'Event Type', width: 130, editable : true},
 {dataField:"evtTypeDesc", headerText:'Event Name', width: 170, editable : true},
 {dataField:"evtMemId", headerText:'In Charge of</br>the Event', width: 130, editable : true },
 {dataField:"evtDt", headerText:'Date for</br>the Event', width: 130, editable : true, editRenderer : {type : "CalendarRenderer", showEditorBtnOver : true, showExtraDays : true} },
 {dataField:"evtCompRqstDate", headerText:'Requested</br>Complete Date', width: 130, editable : true, editRenderer : {type : "CalendarRenderer", showEditorBtnOver : true, showExtraDays : true}  },
 {dataField:"evtCompRate", headerText:'Complete</br>Condition Rate', width: 130, editable : true },
 {dataField:"com", headerText:'Complete</br>Status', editable : false},
];

var columnLayout_q=[             
 {dataField:"q1", headerText:'Question</br>Number', width: 100, editable : false},
 {dataField:"codeName", headerText:'Feedback</br>Type', width: 200, editable : true,
	 renderer : {type : "DropDownListRenderer",listFunction : function(rowIndex, columnIndex, item, dataField) {return CodeList;},keyField : "codeName",valueField : "codeName"}},
	 //renderer : {type : "DropDownListRenderer", list : ["Standard", "Special"]}},
 {dataField:"q3", headerText:'Question', editable : true},
];

var columnLayout_target=[             
 {dataField:"t1", headerText:'Sales Order', width: 250, editable : true},
 {dataField:"t2", headerText:'Name', width: 250, editable : true},
 {dataField:"t3", headerText:'Contact Number', width: 250, editable : true },
 {dataField:"t4", headerText:'Calling Agent', editable : true},
];


var gridOptions = {
		headerHeight : 30,
        showStateColumn: false,
        showRowNumColumn: false,
        usePaging : false,
        pageRowCount : 20, //한 화면에 출력되는 행 개수 20(기본값:20)
        showFooter : false
};

var gridOptions_q = {
		headerHeight : 30,
	    selectionMode: "singleRow",
	    showStateColumn: false,
	    showRowNumColumn: false,
	    usePaging : true,
	    pageRowCount : 20, //한 화면에 출력되는 행 개수 20(기본값:20)
	    showFooter : false
};
  
var gridOptions2 = {
		selectionMode: "singleRow",
        showStateColumn: false,
        showRowNumColumn: false,
        usePaging : true,
        pageRowCount : 20, //한 화면에 출력되는 행 개수 20(기본값:20)
        showFooter : false
};


$(document).ready(function(){

	
    myGridID_Info = GridCommon.createAUIGrid("grid_wrap_info", columnLayout_info, "", gridOptions);
    myGridID_Q = GridCommon.createAUIGrid("grid_wrap_q", columnLayout_q, "", gridOptions_q);
    myGridID_Target = GridCommon.createAUIGrid("grid_wrap_target", columnLayout_target, "", gridOptions2);

    
    var item_info = { "hcTypeId" :  "2718", "evtTypeDesc" : "", "evtMemId" : "", "evtDt" :  "", "evtCompRqstDate" :  "", "evtCompRate" :  "", "com" :  ""}; //row 추가
    AUIGrid.addRow(myGridID_Info, item_info, "last");
    
    AUIGrid.bind(myGridID_Q, "removeRow_q", auiRemoveRowHandler);
    AUIGrid.bind(myGridID_Target, "removeRow_target", auiRemoveRowHandler);
    
    fn_getCodeSearch('');
    
    
    //두번째 grid 행 추가
     $("#addRow_q").click(function() { 
    	var item_q = { "q1" :  "", "codeName" : "", "q3" : ""}; //row 추가
    	AUIGrid.addRow(myGridID_Q, item_q, "last");
    });
    
     //세번째 grid 행 추가
     $("#addRow_target").click(function() { 
        var item_target = { "t1" :  "", "t2" : "", "t3" : "", "t4" : ""}; //row 추가
        AUIGrid.addRow(myGridID_Target, item_target, "last");
    });
     
     //세번째 grid의 excel Download
     $('#excelDown_target').click(function() {
    	 GridCommon.exportTo("grid_wrap_target", 'xlsx', "Survey Target and Calling Agent");
     });
   
     //save
     $("#save_create").click(function() {
         if (validation_info()) {
             Common.confirm("<spring:message code='sys.common.alert.save'/>",fn_saveGridData_create);
          }
     }); 
  
  
}); //Ready

//renderer list search
function fn_getCodeSearch(){
    Common.ajax("GET", "/services/performanceMgmt/getCodeNameList.do",{stusCodeId: 1}, function(result) {
        CodeList = result;
    }, null, {async : false});
}  

function fn_saveGridData_create(){
    Common.ajax("POST", "/services/performanceMgmt/saveSurveyEventCreate.do", GridCommon.getEditData(myGridID_Info), function(result) {
        // 공통 메세지 영역에 메세지 표시.
        Common.setMsg("<spring:message code='sys.msg.success'/>");
        $("#search").trigger("click");
        Common.alert("<spring:message code='sys.msg.success'/>");
    }, function(jqXHR, textStatus, errorThrown) {
        try {
            console.log("status : " + jqXHR.status);
            console.log("code : " + jqXHR.responseJSON.code);
            console.log("message : " + jqXHR.responseJSON.message);
            console.log("detailMessage : " + jqXHR.responseJSON.detailMessage);
        } catch (e) {
            console.log(e);
        }
        Common.alert("Fail : " + jqXHR.responseJSON.message);             
    });
} 


/*  validation */
function validation_info() {
    var result = true;
    var addList = AUIGrid.getAddedRowItems(myGridID_Info);
    
    if(!validationCom_info(addList)){
        return false;
   }      
    
    return result;
}  
function validationCom_info(list){
    var result = true;

    for (var i = 0; i < list.length; i++) {
           var v_hcTypeId = list[i].hcTypeId;
           var v_evtTypeDesc = list[i].evtTypeDesc;
           var v_evtMemId = list[i].evtMemId;
           var v_evtDt = list[i].evtDt;
           var v_evtCompRqstDate = list[i].evtCompRqstDate;
           var v_evtCompRate = list[i].evtCompRate;
           
           
           if (v_evtTypeDesc == "") {
               result = false;
               Common.alert("<spring:message code='sys.common.alert.validation' arguments='Event Name' htmlEscape='false'/>");
               break;
           } else if(v_evtMemId == ""){
               result = false;
               Common.alert("<spring:message code='sys.common.alert.validation' arguments='In Charge of the Event' htmlEscape='false'/>");
               break;
           } else if(v_evtDt == ""){
               result = false;
               Common.alert("<spring:message code='sys.common.alert.validation' arguments='Date for the Event' htmlEscape='false'/>");
               break;
           } else if(v_evtCompRqstDate == ""){
               result = false;
               Common.alert("<spring:message code='sys.common.alert.validation' arguments='Requested Complete Date' htmlEscape='false'/>");
               break;
           } else if(v_evtCompRate == ""){
               result = false;
               Common.alert("<spring:message code='sys.common.alert.validation' arguments='Complete Condition Rate' htmlEscape='false'/>");
               break;
           } else if(v_evtCompRate > 100){
        	   result = false;
        	   Common.alert("Please Enter Complete Condition Rate under 100");
               break;
           }
    }
    
    return result;
}


function removeRow_q(){
    AUIGrid.removeRow(myGridID_Q, "selectedIndex");
    AUIGrid.removeSoftRows(myGridID_Q);
}

function removeRow_target(){
    AUIGrid.removeRow(myGridID_Target, "selectedIndex");
    AUIGrid.removeSoftRows(myGridID_Target);
}

function auiRemoveRowHandler(){
}


</script>   

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Survey Event Create</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->


<section class="pop_body"><!-- pop_body start -->

<aside class="title_line"><!-- title_line start -->
<h2>Survey Event General Info</h2>
</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grid_wrap_info" style="width:100%; height:58px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

<aside class="title_line"><!-- title_line start -->
<h2>Survey Questionnaires</h2>
</aside><!-- title_line end -->

<ul class="right_btns">
    <li><p class="btn_grid"><a href="#" id="addRow_q">add</a></p></li>
    <li><p class="btn_grid"><a href="#" onclick="javascript:removeRow_q()">del</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grid_wrap_q" style="width:100%; height:120px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

<aside class="title_line"><!-- title_line start -->
<h2>Survey Target and Calling Agent</h2>
</aside><!-- title_line end -->

<ul class="right_btns">
    <li><p class="btn_grid"><a href="#" id="excelDown_target">EXCEL DW</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
    <li><p class="btn_grid"><a href="#" id="addRow_target">add</a></p></li>
    <li><p class="btn_grid"><a href="#" onclick="javascript:removeRow_target()">del</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grid_wrap_target" style="width:100%; height:120px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" id="save_create">Save</a></p></li>
</ul>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->