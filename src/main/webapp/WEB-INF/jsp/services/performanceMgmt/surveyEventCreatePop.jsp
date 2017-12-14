<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
var myGridID_Info;
var myGridID_Q;
var myGridID_Target;

var nullCount = 0;
var notNullCount = 0;
var duplicatedCount = 0;
var salesOrderListLength = 0;
//var duplicationChkList = new Array();


var  CodeList = [];

var columnLayout_info=[             
 {dataField:"hcTypeId", headerText:'Event Type', width: 130, editable : false},
 {dataField:"evtTypeDesc", headerText:'Event Name', width: 170, editable : true},
 {dataField:"evtMemId", headerText:'In Charge of</br>the Event', width: 130, editable : true},
 {dataField:"evtDt", headerText:'Date for</br>the Event', width: 130, editable : true, editRenderer : {type : "CalendarRenderer", showEditorBtnOver : true, showExtraDays : true} },
 {dataField:"evtCompRqstDate", headerText:'Requested</br>Complete Date', width: 130, editable : true, editRenderer : {type : "CalendarRenderer", showEditorBtnOver : true, showExtraDays : true}  },
 {dataField:"evtCompRate", headerText:'Complete</br>Condition Rate', width: 130, editable : true},
 {dataField:"com", headerText:'Complete</br>Status', editable : false},
];

var columnLayout_q=[             
 //{dataField:"q1", headerText:'Question</br>Number', width: 100, editable : false},
 {dataField:"hcDefCtgryId", headerText:'Feedback</br>Type', width: 200, editable : true,
     renderer : {type : "DropDownListRenderer",listFunction : function(rowIndex, columnIndex, item, dataField) {return CodeList;},keyField : "codeName",valueField : "codeName"}},
     //renderer : {type : "DropDownListRenderer", list : ["Standard", "Special"]}},
 {dataField:"hcDefDesc", headerText:'Question', editable : true},
];

var columnLayout_target=[             
 {dataField:"salesOrdNo", headerText:'Sales Order', width: 250, editable : true},
 {dataField:"name", headerText:'Name', width: 250, editable : true},
 {dataField:"contNo", headerText:'Contact Number', width: 250, editable : true },
 {dataField:"callMem", headerText:'Calling Agent', editable : true},
];


var gridOptions = {
        headerHeight : 30,
        selectionMode: "singleRow",
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
        //showRowNumColumn: false,
        usePaging : true,
        pageRowCount : 20, //한 화면에 출력되는 행 개수 20(기본값:20)
        showFooter : false
};
  
var gridOptions2 = {
        selectionMode: "singleRow",
        showStateColumn: false,
        //showRowNumColumn: false,
        usePaging : true,
        pageRowCount : 20, //한 화면에 출력되는 행 개수 20(기본값:20)
        showFooter : false
};


$(document).ready(function(){

    
    myGridID_Info = GridCommon.createAUIGrid("grid_wrap_info", columnLayout_info, "", gridOptions);
    myGridID_Q = GridCommon.createAUIGrid("grid_wrap_q", columnLayout_q, "", gridOptions_q);
    myGridID_Target = GridCommon.createAUIGrid("grid_wrap_target", columnLayout_target, "", gridOptions2);
    
    //var rowCount = AUIGrid.getRowPosition(myGridID_Q);

    var item_info = { "hcTypeId" :  "Event Survey", "evtTypeDesc" : "", "evtMemId" : "", "evtDt" :  "", "evtCompRqstDate" :  "", "evtCompRate" :  "", "com" :  ""}; //row 추가
    AUIGrid.addRow(myGridID_Info, item_info, "last");
    
    AUIGrid.bind(myGridID_Q, "removeRow_q", auiRemoveRowHandler);
    AUIGrid.bind(myGridID_Target, "removeRow_target", auiRemoveRowHandler);
    
    fn_getCodeSearch('');
    
    
    //두번째 grid 행 추가
     $("#addRow_q").click(function() { 
        var item_q = {"hcDefCtgryId" : "", "hcDefDesc" : ""}; //row 추가
        AUIGrid.addRow(myGridID_Q, item_q, "last");
    });
    
     //세번째 grid 행 추가
     $("#addRow_target").click(function() { 
        var item_target = { "salesOrdNo" :  "", "name" : "", "contNo" : "", "callMem" : ""}; //row 추가
        AUIGrid.addRow(myGridID_Target, item_target, "last");
        
        //var rowCount22 = AUIGrid.getRowCount(myGridID_Target);
        //alert("rowCount"+rowCount22);
    });
     
     //세번째 grid의 excel Download
     $('#excelDown_target').click(function() {
         GridCommon.exportTo("grid_wrap_target", 'xlsx', "Survey Target and Calling Agent");
     });
   
     //save
     $("#save_create").click(function() {
         if (validation_info()) {
             
             var addList_info = AUIGrid.getAddedRowItems(myGridID_Info);
             var v_evtMemId = addList_info[0].evtMemId;

             Common.ajax("GET", "/services/performanceMgmt/selectEvtMemIdList.do", {memId : v_evtMemId}, function(result) {
                 if(result.length == 0){
                     result = false;
                     Common.alert("'In Charge of the Event' is a wrong member code.");
                 } else {
                     
                     var rowCount_t = AUIGrid.getRowCount(myGridID_Target);
                     
                     if(rowCount_t > 0) {
                    	 
                    	 var salesOrdNo= AUIGrid.getColumnValues(myGridID_Target, "salesOrdNo");
                         var addList_t = AUIGrid.getAddedRowItems(myGridID_Target);
                         salesOrderListLength = addList_t.length;
                         nullCount = 0;
                         notNullCount = 0;
                         duplicatedCount = 0;
                         var duplicationChkList = new Array();
                         var i = 0;
                         var j = 0;
                         
                         for ( i; i < addList_t.length; i++) {
                             var v_salesOrdNo = addList_t[i].salesOrdNo;
                             if(v_salesOrdNo != ""){
                            	 notNullCount ++;
                            	 if (i == 0){
                            		 duplicationChkList[0] = v_salesOrdNo;
                            	 }
                                 //duplication Check
                                 for(j; j < i; j++){
                                	 //alert("두번째i::"+i +"::duplicationChkList ["+duplicationChkList +"]");
                                	 if(duplicationChkList[j] != v_salesOrdNo){
                                		 //alert("안에서v_salesOrdNo"+v_salesOrdNo);
                                		 //alert("안에서duplicationChkList[j]"+duplicationChkList[j]);
                                		 duplicationChkList[i] = v_salesOrdNo;
                                	 }else{
                                		 duplicatedCount ++;
                                		 break;
                                	 }
                                 }
                             }else if(v_salesOrdNo == ""){
                            	 nullCount ++;
                             }
                         } 
                         //alert("중복안된값들"+duplicationChkList);
                         Common.ajax("GET", "/services/performanceMgmt/selectSalesOrdNotList.do", {salesOrdNo : salesOrdNo} , function(result) {
                             //if(result.length == 0 || salesOrderListLength != (result.length+duplicatedCount)){
                             if((nullCount == 0 && notNullCount != (result.length+duplicatedCount)) || (nullCount == 0 && result.length == 0)){
                            	 //alert("보내는길이::"+salesOrderListLength);
                            	 //alert("받는길이"+result.length);
                            	 //alert("중복길이"+duplicatedCount);
                            	 //alert("총길이"+(result.length+duplicatedCount));
                            	  
                                 result = false;
                                 Common.alert("'Sales Order' is a wrong Order Number.");
                             } else if(notNullCount != salesOrderListLength && nullCount != salesOrderListLength){
  
                            	 //alert("salesOrderListLength::"+salesOrderListLength);
                            	 
                            	 result = false;
                            	 Common.alert("<spring:message code='sys.common.alert.validation' arguments='Sales Order' htmlEscape='false'/>");
                             } else {
                            	 //alert("보내는길이::"+salesOrderListLength);
                                 //alert("받는길이"+result.length);
                                 //alert("중복길이"+duplicatedCount);
                                 //alert("총길이"+(result.length+duplicatedCount));
                            	 
                                 Common.confirm("<spring:message code='sys.common.alert.save'/>",fn_saveGridData_create);
                             }
                         });
                    	 
                     }else{
                    	 Common.confirm("<spring:message code='sys.common.alert.save'/>",fn_saveGridData_create);
                     }
                 }
             });
             
          }
     }); 
  
  
}); //Ready

//renderer list search
function fn_getCodeSearch(){
    Common.ajax("GET", "/services/performanceMgmt/getCodeNameList.do",{codeId: 102}, function(result) {
        CodeList = result;
    }, null, {async : false});
}  

function fn_saveGridData_create(){
    
    /*Target grid에서 addrow가 있다면 saveSurveyEventTarget.do를 실행*/
    var rowCount_target = AUIGrid.getRowCount(myGridID_Target);
    var rowCount_q = AUIGrid.getRowCount(myGridID_Q);
    
    
    var params = {
            aGrid : GridCommon.getEditData(myGridID_Info),
            bGrid : GridCommon.getEditData(myGridID_Target),
            cGrid : GridCommon.getEditData(myGridID_Q)
    };
    
    
    if(rowCount_target > 0 || rowCount_q > 0) {
        Common.ajax("POST", "/services/performanceMgmt/saveSurveyEventTarget.do", params, 
       //Common.ajax("POST", "/services/performanceMgmt/saveSurveyEventTarget.do", $("#listGForm").serialize(), 
        function(result) {
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
        
    }/*Info grid 값만 저장하고 싶다면 saveSurveyEventCreate.do를 실행*/
    else{
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
    
} 


/*  validation */
function validation_info() {
    var result = true;
    
    
    var addList_q = AUIGrid.getAddedRowItems(myGridID_Q);
    var validation_q = AUIGrid.getRowCount(myGridID_Q);
    
    //Questionnaires validation 
    if(validation_q > 0) {
         if(!validationCom_q(addList_q)){
                return false;
           }      
    }
    
    var addList_target = AUIGrid.getAddedRowItems(myGridID_Target);
    var validation_target = AUIGrid.getRowCount(myGridID_Target);
    
    //target validation 
    if(validation_target > 0) {
         if(!validationCom_target(addList_target)){
                return false;
           }      
    }
     
    var addList = AUIGrid.getAddedRowItems(myGridID_Info);
    
    //info validation
    if(!validationCom_info(addList)){
        return false;
    }       
    
    return result;
}  


function validationCom_q(list){
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


function validationCom_target(list){
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
           } else if(v_evtMemId  % 1 != 0){
               result = false;
               Common.alert("Please Enter 'In Charge of the Event' with numbers");
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



function removeRow_q(){
    var selectedItems_q = AUIGrid.getSelectedItems(myGridID_Q);
    if(selectedItems_q.length <= 0) {
        Common.alert("<spring:message code='expense.msg.NoData'/> ");
        return;
    }
    AUIGrid.removeRow(myGridID_Q, "selectedIndex");
    AUIGrid.removeSoftRows(myGridID_Q);
}

function removeRow_target(){
    var selectedItems_t = AUIGrid.getSelectedItems(myGridID_Target);
    if(selectedItems_t.length <= 0) {
        Common.alert("<spring:message code='expense.msg.NoData'/> ");
        return;
    }
    AUIGrid.removeRow(myGridID_Target, "selectedIndex");
    AUIGrid.removeSoftRows(myGridID_Target);
}

function auiRemoveRowHandler(){
}

/* function fn_uploadFile() 
{
   var formData = new FormData();
   console.log("read_file: " + $("input[name=uploadfile]")[0].files[0]);
   formData.append("excelFile", $("input[name=uploadfile]")[0].files[0]);
   
   var radioVal = $("input:radio[name='name']:checked").val();
   formData.append("radioVal", radioVal );

   //alert('read');
   
   if( radioVal == 1 ){
       Common.ajaxFile("/services/serviceGroup/excel/updateCTSubGroupByExcel.do"
               , formData
               , function (result) 
                {
                     //Common.alert(result.data  + "<spring:message code='sys.msg.savedCnt'/>");
                     if(result.code == "99"){
                         Common.alert(" ExcelUpload "+DEFAULT_DELIMITER + result.message);
                     }else{
                         Common.alert(result.message);
                     }
            });
   } else {
       Common.ajaxFile("/services/serviceGroup/excel/updateCTAreaByExcel.do"
               , formData
               , function (result) 
                {
                    //Common.alert(result.data  + "<spring:message code='sys.msg.savedCnt'/>");
                    if(result.code == "99"){
                        Common.alert(" ExcelUpload "+DEFAULT_DELIMITER + result.message);
                    }else{
                        Common.alert(result.message);
                    }
            });
   }

} */


</script>   

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Survey Event Create</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->


<section class="pop_body"><!-- pop_body start -->

<form action="#" method="post" id="listGForm" name="listGForm">

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
    <div id="grid_wrap_q" style="width:100%; height:130px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

<aside class="title_line"><!-- title_line start -->
<h2>Survey Target and Calling Agent</h2>
</aside><!-- title_line end -->

<ul class="right_btns">
     <!-- <li>
        <div class="auto_file">
            <form id="fileUploadForm" method="post" enctype="multipart/form-data" action="">
                 <input title="file add" type="file" id="uploadfile" name="uploadfile">
                 <label><span class="label_text"><a href="#">File</a></span><input class="input_text" type="text" readonly="readonly"></label>
            </form>
         </div>
    </li>
    <li><p class="btn_grid"><a href="#" onclick="javascript:fn_uploadFile();">ExcelUpLoad</a></p></li> -->
    <li><p class="btn_grid"><a href="#" id="excelDown_target">ExcelDownLoad</a></p></li>
    <li><p class="btn_grid"><a href="#" id="addRow_target">add</a></p></li>
    <li><p class="btn_grid"><a href="#" onclick="javascript:removeRow_target()">del</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grid_wrap_target" style="width:100%; height:120px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</form>

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" id="save_create">Save</a></p></li>
</ul>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->