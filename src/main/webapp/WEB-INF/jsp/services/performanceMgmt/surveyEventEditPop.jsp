<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
var myGridID_InfoEdit;
var myGridID_QEdit;
var myGridID_TargetEdit;

var undefCount = 0;


var columnLayout_infoEdit=[             
 {dataField:"evtTypeId", headerText:'Event Type', width: 130, editable : false},
 {dataField:"evtTypeDesc", headerText:'Event Name', width: 170, editable : false},
 {dataField:"memCode", headerText:'In Charge of</br>the Event', width: 130, editable : false},
 {dataField:"evtDt", headerText:'Date for</br>the Event', width: 130, editable : false, dataType : "date", formatString : "dd/mm/yyyy"},
 {dataField:"evtCompRqstDate", headerText:'Requested</br>Complete Date', width: 130, editable : true, editRenderer : {type : "CalendarRenderer", showEditorBtnOver : true, showExtraDays : true} , dataType : "date", formatString : "dd/mm/yyyy" },
 {dataField:"evtCompRate", headerText:'Complete</br>Condition Rate', width: 130, editable : true},
 {dataField:"com", headerText:'Complete</br>Status', editable : false},
 {dataField:"evtId", headerText:'EVT_ID(CCR0012M)', editable : false, visible: false}
];

var columnLayout_qEdit=[             
 {dataField:"hcDefCtgryId", headerText:'Feedback</br>Type', width: 200, editRenderer : {type : "DropDownListRenderer",showEditorBtnOver : true, listFunction : function(rowIndex, columnIndex, item, dataField) {return CodeList;},keyField : "codeName",valueField : "codeName"}},
 {dataField:"hcDefDesc", headerText:'Question'},
 {dataField:"hcDefId", headerText:'HC_DEF_ID(CCR0003M)', visible: false},
 {dataField:"evtId", headerText:'EVT_ID(CCR0012M)', editable : false, visible: false}
];



var columnLayout_targetEdit=[             
 {dataField:"salesOrdNo", headerText:'Sales Order', width: 250},
 {dataField:"name", headerText:'Name', width: 250,editable : false},
 {dataField:"contNo", headerText:'Contact Number', width: 250,editable : false},
 {dataField:"callMem", headerText:'Calling Agent', editable : true},
 {dataField:"evtContId", headerText:'EVT_CONT_ID(CCR0013M)', visible: false},
 {dataField:"evtId", headerText:'EVT_ID(CCR0012M)', editable : false, visible: false}
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
        showStateColumn: true,
        usePaging : true,
        pageRowCount : 20, //한 화면에 출력되는 행 개수 20(기본값:20)
        showFooter : false
};
  
var gridOptions_targetEdit = {
        selectionMode: "singleRow",
        showStateColumn: true,
        usePaging : true,
        useGroupingPanel : false,
        pageRowCount : 20, //한 화면에 출력되는 행 개수 20(기본값:20)
        showFooter : false
};


$(document).ready(function(){
	
    $("#popEvtTypeDescView").val("${popEvtTypeDesc}");
    $("#popMemCodeView").val("${popMemCode}");
    $("#popEvtDtView").val("${popEvtDt}"); 
    $("#popEvtIdView").val("${popEvtId}"); 


    myGridID_InfoEdit = GridCommon.createAUIGrid("grid_wrap_infoEdit", columnLayout_infoEdit, "", gridOptions_infoEdit);
    myGridID_QEdit = GridCommon.createAUIGrid("grid_wrap_qEdit", columnLayout_qEdit, "hcDefId", gridOptions_qEdit);
    myGridID_TargetEdit = GridCommon.createAUIGrid("grid_wrap_targetEdit", columnLayout_targetEdit, "evtContId", gridOptions_targetEdit);
    
    
    /*ADD한 ROW만 수정_Q*/
    //AUIGrid.bind(myGridID_QEdit, "addRow", function(event){});
    AUIGrid.bind(myGridID_QEdit, "cellEditBegin", function (event){
        if (event.columnIndex == 0){
            if(AUIGrid.isAddedById(myGridID_QEdit, event.item.hcDefId)) {
                return true;
            }else{
                return false;
            }
        }       
    });
    
    /*ADD한 ROW만 수정_Target*/
    //AUIGrid.bind(myGridID_TargetEdit, "addRow", function(event){});
    AUIGrid.bind(myGridID_TargetEdit, "cellEditBegin", function (event){
        if (event.columnIndex == 0 || event.columnIndex == 1 || event.columnIndex == 2 || event.columnIndex == 3){
        	if(AUIGrid.isAddedById(myGridID_TargetEdit, event.item.evtContId)) {
                return true;
            }else{
                return true;
            }
        }       
    });
    
      
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
    

    
    fn_getCodeSearch('');
    
    
  //두번째 grid 행 추가
    $("#addRow_qEdit").click(function() { 
       var item_qEdit = {"hcDefCtgryId" : "", "hcDefDesc" : ""}; //row 추가
       AUIGrid.addRow(myGridID_QEdit, item_qEdit, "last");
   });
   
    //세번째 grid 행 추가
    $("#addRow_targetEdit").click(function() { 
       var item_targetEdit = { "salesOrdNo" :  "", "name" : "", "contNo" : "", "callMem" : ""}; //row 추가
       AUIGrid.addRow(myGridID_TargetEdit, item_targetEdit, "last");
       
   });
    
    AUIGrid.bind(myGridID_TargetEdit, "cellEditEnd", function( event ) {
    	var rowCount1 = AUIGrid.getRowCount(myGridID_TargetEdit);
    
	    if(event.columnIndex ==0){
	        var salesOrdNo = event.value;
	        
	        Common.ajax("Get", "/services/performanceMgmt/selectSalesOrdNotList2.do?salesOrdNo="+ salesOrdNo +"", '' , function(result) {
	            if(result!=null){
	                console.log("성공.");
	                console.log("data : "+ result);
	                AUIGrid.addRow(myGridID_TargetEdit, result, "last");
	                var rowCount2 = AUIGrid.getRowCount(myGridID_TargetEdit);
	                AUIGrid.removeRow(myGridID_TargetEdit, rowCount2-2);
	                AUIGrid.removeSoftRows(myGridID_TargetEdit);
	               //AUIGrid.setGridData(myGridID_TargetEdit, result );
	            }else{
	                Common.alert("<spring:message code='sys.common.alert.sys.common.alert.NoSuch' arguments='branch' htmlEscape='false'/>");
	                var rowCount2 = AUIGrid.getRowCount(myGridID_TargetEdit);
	                AUIGrid.removeRow(myGridID_TargetEdit, rowCount2-1);
	                AUIGrid.removeSoftRows(myGridID_TargetEdit);
	            }
	            
	       });
	    }
    });
    
    //save
    $("#save_edit").click(function() {
    	
        if (validation_infoEdit()) {
            var rowCount_t = AUIGrid.getRowCount(myGridID_TargetEdit);
            
            if(rowCount_t > 0) {
                
            	var salesOrdNo = AUIGrid.getColumnValues(myGridID_TargetEdit, "salesOrdNo");
                salesOrderListLength = rowCount_t;
                nullCount = 0;
                notNullCount = 0;
                duplicatedCount = 0;
                undefCount = 0;
                var duplicationChkList = new Array();
                var i = 0;
                var j = 0;
                
                //for ( i; i < addList_t.length; i++) {
                for (i; i < salesOrderListLength; i++){
                    //var v_salesOrdNo = addList_t[i].salesOrdNo;
                    var v_salesOrdNo = salesOrdNo[i];
                    if(v_salesOrdNo != "" && typeof v_salesOrdNo != 'undefined'){
                        notNullCount ++;
                        if (i == 0){
                            duplicationChkList[0] = v_salesOrdNo;
                        }
                        //duplication Check
                        for(j; j < i; j++){
                            if(duplicationChkList[j] != v_salesOrdNo){
                                duplicationChkList[i] = v_salesOrdNo;
                            }else{
                                duplicatedCount ++;
                                break;
                            }
                        }
                    }else if(v_salesOrdNo == "" || typeof v_salesOrdNo == 'undefined'){
                        nullCount ++;
                        if(typeof v_salesOrdNo == 'undefined'){
                        	undefCount ++;
                        }
                    }
                    
                } 
                
                if( salesOrderListLength == undefCount ){
                	Common.confirm("<spring:message code='sys.common.alert.save'/>",fn_saveGridData_edit);
                }else{
	                Common.ajax("GET", "/services/performanceMgmt/selectSalesOrdNotList.do", {salesOrdNo : salesOrdNo} , function(result) {
	                    if((nullCount == 0 && notNullCount != (result.length+duplicatedCount)) || (nullCount == 0 && result.length == 0)){
	                    	result = false;
	                        Common.alert("'Sales Order' is a wrong Order Number.");
	                    } else if(notNullCount != salesOrderListLength && nullCount != salesOrderListLength){
	                        result = false;
	                        Common.alert("<spring:message code='sys.common.alert.validation' arguments='Sales Order' htmlEscape='false'/>");
	                    } else {
	                        Common.confirm("<spring:message code='sys.common.alert.save'/>",fn_saveGridData_edit);
	                    }
	                });
                }
                
            }else{
                Common.confirm("<spring:message code='sys.common.alert.save'/>",fn_saveGridData_edit);
            }

            
         }
    }); 
    
  
}); //Ready

function removeRow_qEdit(){
    var selectedItems_q = AUIGrid.getSelectedItems(myGridID_QEdit);
    if(selectedItems_q.length <= 0) {
        Common.alert("<spring:message code='expense.msg.NoData'/> ");
        return;
    }
    AUIGrid.removeRow(myGridID_QEdit, "selectedIndex");
    //AUIGrid.removeSoftRows(myGridID_QEdit);
}

function removeRow_targetEdit(){
    var selectedItems_t = AUIGrid.getSelectedItems(myGridID_TargetEdit);
    if(selectedItems_t.length <= 0) {
        Common.alert("<spring:message code='expense.msg.NoData'/> ");
        return;
    }
    AUIGrid.removeRow(myGridID_TargetEdit, "selectedIndex");
    //AUIGrid.removeSoftRows(myGridID_TargetEdit);
}

/* function auiRemoveRowHandler(){
}
 */
 
//renderer list search(Special or Standard)
function fn_getCodeSearch(){
    Common.ajax("GET", "/services/performanceMgmt/getCodeNameList.do",{codeId: 102}, function(result) {
        CodeList = result;
    }, null, {async : false});
}  

 
 /*SAVE*/
function fn_saveGridData_edit(){
    
    /*Target grid에서 addrow가 있다면 saveSurveyEventTarget.do를 실행*/
    var rowCount_target = AUIGrid.getRowCount(myGridID_TargetEdit);
    var rowCount_q = AUIGrid.getRowCount(myGridID_QEdit);
    
    
    var params = {
            aGrid : GridCommon.getGridData(myGridID_InfoEdit),
            bGrid : GridCommon.getEditData(myGridID_TargetEdit),
            cGrid : GridCommon.getEditData(myGridID_QEdit)
    };
    
    
    //if(rowCount_target > 0 || rowCount_q > 0) {
        Common.ajax("POST", "/services/performanceMgmt/saveEditedSurveyEventTarget.do", params, 
        function(result) {
            // 공통 메세지 영역에 메세지 표시.
            Common.setMsg("<spring:message code='sys.msg.success'/>");
            $("#search").trigger("click");
            Common.alert("<spring:message code='sys.msg.success'/>");
            $("#popClose").click(); 
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
        
    //}
    
} 


/*  validation */
function validation_infoEdit() {
    var result = true;
    
    
    var addList_q = AUIGrid.getAddedRowItems(myGridID_QEdit);
    var validation_q = AUIGrid.getRowCount(myGridID_QEdit);
    
    var addList_target = AUIGrid.getAddedRowItems(myGridID_TargetEdit);
    var validation_target = AUIGrid.getRowCount(myGridID_TargetEdit);
    
    

    //Questionnaires validation 
    if(validation_q > 0) {
         if(!validationCom_qEdit(addList_q)){
                return false;
           }      
    }
    
    
    //target validation 
    if(validation_target > 0) {
         if(!validationCom_targetEdit(addList_target)){
                return false;
           }      
    }
     
    var addList = AUIGrid.getAddedRowItems(myGridID_InfoEdit);
    
    //info validation
    if(!validationCom_infoEdit(addList)){
        return false;
    }       
    
    return result;
}  


function validationCom_infoEdit(list){
    var result = true;

    for (var i = 0; i < list.length; i++) {
           var v_evtCompRqstDate = list[i].evtCompRqstDate;
           var v_evtCompRate = list[i].evtCompRate;
           
           
          if(v_evtCompRqstDate == ""){
               result = false;
               Common.alert("<spring:message code='sys.common.alert.validation' arguments='Requested Complete Date' htmlEscape='false'/>");
               break;
           } else if(v_evtCompRate == ""){
               result = false;
               Common.alert("<spring:message code='sys.common.alert.validation' arguments='Complete Condition Rate' htmlEscape='false'/>");
               break;
           } else if(v_evtCompRate  % 1 != 0){
               result = false;
               Common.alert("Please Enter 'Complete Condition Rate' with numbers");
               break;
           } else if(v_evtCompRate > 100){
               result = false;
               Common.alert("Please Enter 'Complete Condition Rate' under 100");
               break;
           } 
           
    }
    
    return result;
}


function validationCom_qEdit(list){
    var result = true;

    for (var i = 0; i < list.length; i++) {
           var v_hcDefCtgryId = list[i].hcDefCtgryId;
           var v_hcDefDesc = list[i].hcDefDesc;

           
           if(v_hcDefCtgryId == ""){
               result = false;
               Common.alert("<spring:message code='sys.common.alert.validation' arguments='Feedback Type' htmlEscape='false'/>");
               break;
           } else if(v_hcDefDesc == ""){
               result = false;
               Common.alert("<spring:message code='sys.common.alert.validation' arguments='Question' htmlEscape='false'/>");
               break;
           }
    }
    
    return result;
}


function validationCom_targetEdit(list){
    var result = true;

    for (var i = 0; i < list.length; i++) {
           var v_salesOrdNo = list[i].salesOrdNo;
           var v_name = list[i].name;
           var v_contNo = list[i].contNo;
           var v_callMem = list[i].callMem;
           
           
           if(v_name == ""){
               result = false;
               Common.alert("<spring:message code='sys.common.alert.validation' arguments='Name' htmlEscape='false'/>");
               break;
           } else if(v_contNo == ""){
               result = false;
               Common.alert("<spring:message code='sys.common.alert.validation' arguments='Contact Number' htmlEscape='false'/>");
               break;
           } else if(v_callMem == ""){
               result = false;
               Common.alert("<spring:message code='sys.common.alert.validation' arguments='Calling Agent' htmlEscape='false'/>");
               break;
           } else if(v_contNo  % 1 != 0){
               result = false;
               Common.alert("Please Enter 'Contact Number' with numbers");
               break;
           } 
    }
    
    return result;
}

</script>   

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Survey Event Edit</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="popClose">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->


<section class="pop_body"><!-- pop_body start -->
<form action="#" id="listEditForm" name="listEditForm" method="post">
    <input type="hidden" id="popEvtTypeDescView" name="popEvtTypeDescView" /> 
    <input type="hidden" id="popMemCodeVeiw" name="popMemCodeVeiw" /> 
    <input type="hidden" id="popEvtDtView" name="popEvtDtView" /> 
    <input type="hidden" id="popEvtIdView" name="popEvtIdView" /> 
    <input type="hidden" id="popEvtCompRqstDate" name="popEvtCompRqstDate"/>
    
    <input type="hidden" id="popHcDefIdView" name="popHcDefIdView" /> 
    <input type="hidden" id="popEvtContIdView" name="popEvtContIdView" /> 
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
    <li><p class="btn_grid"><a href="#" id="addRow_qEdit">Add</a></p></li>
    <li><p class="btn_grid"><a href="#" onclick="javascript:removeRow_qEdit()">Del</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grid_wrap_qEdit" style="width:100%; height:130px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

<aside class="title_line"><!-- title_line start -->
<h2>Survey Target and Calling Agent</h2>
</aside><!-- title_line end -->

<ul class="right_btns">
    <li><p class="btn_grid"><a href="#" id="addRow_targetEdit">Add</a></p></li>
    <li><p class="btn_grid"><a href="#" onclick="javascript:removeRow_targetEdit()">Del</a></p></li>
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