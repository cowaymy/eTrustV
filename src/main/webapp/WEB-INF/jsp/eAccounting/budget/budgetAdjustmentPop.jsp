<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<style type="text/css">
/* 커스텀 칼럼 스타일 정의 */
.my-right-style {
    text-align:right;
}
.aui-grid-user-custom-left {
    text-align:left;
}

/* 커스텀 행 스타일 */
.my-row-style {
    background:#9FC93C;
    font-weight:bold;
    color:#22741C;
}
</style>
<script  type="text/javascript">

var adjPGridID;
var rowid;

var fileList = new Array();
<c:forEach var="file" items="${fileList}">
var obj = {
        atchFileGrpId : "${file.atchFileGrpId}"
        ,atchFileId : "${file.atchFileId}"
        ,atchFileName : "${file.atchFileName}"
        ,fileSubPath : "${file.fileSubPath}"
        ,physiclFileName : "${file.physiclFileName}"
};
fileList.push(obj);
</c:forEach>

$(document).ready(function(){  
	
	var adjustmentList;
		
	 if('${adjustmentList}'=='' || '${adjustmentList}' == null){
	}else{
		adjustmentList = JSON.parse('${adjustmentList}');
		
		
	} 	

     // TODO View
	console.log("${fileList}");
    if(fileList.length == 0 && "${budgetStatus}" ==  'Y') {
         setInputFile2();
    }
    
//console.log(fileList);
		
    CommonCombo.make("pAdjustmentType", "/common/selectCodeList.do", {groupCode:'347', orderValue:'CODE'}, "", {
        id: "code",
        name: "codeName",
        type:"S",
        isShowChoose:false
    });
	
	$("#btnAdd").click(fn_AddRow);
	$("#btnDel").click(fn_RemoveRow); 
    
    $("#sendYearMonth").change(function(){
    	if($("#pAdjustmentType").val() != "01" && $("#pAdjustmentType").val() != "02" 
    			&& $("#pAdjustmentType").val() != "06" && $("#pAdjustmentType").val() != "07" ){

            $("#recvYearMonth").val($("#sendYearMonth").val());
        }
    });
    
    $("#sendAmount").keydown(function (event) { 
    	
    	 var code = window.event.keyCode;
    	 
    	 if ((code > 34 && code < 41) || (code > 47 && code < 58) || (code > 95 && code < 106) ||code==110 ||code==190 ||code == 8 || code == 9 || code == 13 || code == 46)
    	 {
    	  window.event.returnValue = true;
    	  return;
    	 }
    	 window.event.returnValue = false;

    	 return false;
    });
    
    $("#sendAmount").click(function () { 
    	var str = $("#sendAmount").val().replace(/,/gi, "");
        $("#sendAmount").val(str);    	
   });
    
    $("#sendAmount").blur(function () { 
    	var str = $("#sendAmount").val().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
        $("#sendAmount").val(str);  
   });
    
     $("#sendAmount").change(function(){
        var str =""+ Math.floor($("#sendAmount").val() * 100)/100;
               
        var str2 = str.split(".");
       
        if(str2.length == 1){        	
        	str2[1] = "00";
        }
        
       	if(str2[0].length > 11){
       		Common.alert("<spring:message code='budget.msg.inputAmount' />");
               str = "";
        }else{               
            str = str2[0].substr(0, 11)+"."+str2[1] + "00".substring(str2[1].length, 2);   
        }
        str = str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
                        
    	if($("#pAdjustmentType").val() != "01" && $("#pAdjustmentType").val() != "02"){
            $("#recvAmount").val(str);
    	}
    	$("#sendAmount").val(str);
    	
    }); 
    
    //기본 콤보 셋팅
    fn_chnCombo('01');
  
    //파일 다운
    $(".input_text").dblclick(function() {
    	
        var oriFileName = $(this).val();
        var atchFileName;
        var fileSubPath;
        var physiclFileName;
        for(var i = 0; i < fileList.length; i++) {
            if(fileList[i].atchFileName == oriFileName) {
            	atchFileName = fileList[i].atchFileName;
                fileSubPath = fileList[i].fileSubPath;
                physiclFileName = fileList[i].physiclFileName;
            }
        }
        
        fn_atchViewDown(atchFileName, fileSubPath, physiclFileName);
    });
    
    var adjPLayout = [{
        dataField : "budgetDocNo",
        headerText : '',
        editable : false,
        visible : false,
        cellMerge : true ,
        width : 150
    }, {
        dataField : "budgetDocSeq",
        headerText : '',
        editable : false,
        visible : false,
        width : 150
    },{
        dataField : "budgetAdjType",
        headerText : '<spring:message code="budget.AdjustmentType" />',
        editable : false,
        visible : false,
        cellMerge : true ,
        width : 150
    },{
        dataField : "signal",
        headerText : '',
        visible : false
    },{
        dataField : "costCentr",
        headerText : '<spring:message code="budget.CostCenter" />',
        editable : false,
        cellMerge : true ,
        mergeRef : "budgetAdjType", // 이전 칼럼(대분류) 셀머지의 값을 비교해서 실행함. (mergePolicy : "restrict" 설정 필수)
        mergePolicy : "restrict", 
        width : 130
    },{
        dataField : "adjYearMonth",
        headerText : '<spring:message code="budget.Month" />/<spring:message code="budget.Year" />',
        editable : false,
        cellMerge : true ,
        mergeRef : "budgetAdjType", // 이전 칼럼(대분류) 셀머지의 값을 비교해서 실행함. (mergePolicy : "restrict" 설정 필수)
        mergePolicy : "restrict",
        width : 100
    },{
        dataField : "budgetCode",
        headerText : '<spring:message code="expense.Activity" />',
        editable : false,
        cellMerge : true ,
        mergeRef : "budgetAdjType", // 이전 칼럼(대분류) 셀머지의 값을 비교해서 실행함. (mergePolicy : "restrict" 설정 필수)
        mergePolicy : "restrict", 
        width : 130
    },{
        dataField : "budgetCodeText",
        headerText : '<spring:message code="expense.ActivityName" />',
        editable : false,
        cellMerge : true ,
        mergeRef : "budgetAdjType", // 이전 칼럼(대분류) 셀머지의 값을 비교해서 실행함. (mergePolicy : "restrict" 설정 필수)
        mergePolicy : "restrict", 
        width : 130
    },{
        dataField : "glAccCode",
        headerText : '<spring:message code="expense.GLAccount" />',
        editable : false,
        cellMerge : true ,
        mergeRef : "budgetAdjType", // 이전 칼럼(대분류) 셀머지의 값을 비교해서 실행함. (mergePolicy : "restrict" 설정 필수)
        mergePolicy : "restrict", 
        width : 130
    },{
        dataField : "glAccDesc",
        headerText : '<spring:message code="expense.GLAccountName" />',
        editable : false,
        cellMerge : true ,
        mergeRef : "budgetAdjType", // 이전 칼럼(대분류) 셀머지의 값을 비교해서 실행함. (mergePolicy : "restrict" 설정 필수)
        mergePolicy : "restrict", 
        width : 130
    },{
        dataField : "budgetAdjTypeName",
        headerText : '<spring:message code="budget.AdjustmentType" />',
        editable : false,
        width : 150
    },{
        dataField : "adjAmt",
        headerText : '<spring:message code="budget.Amount" />',
        dataType : "numeric",
        formatString : "#,##0.00",
        editable : true,
        style : "my-right-style",
        width : 100,
        editRenderer : {
            type : "InputEditRenderer",
            onlyNumeric : true,
            autoThousandSeparator : true, // 천단위 구분자 삽입 여부 (onlyNumeric=true 인 경우 유효)
            allowPoint : true // 소수점(.) 입력 가능 설정
        }
    },{
        dataField : "adjRem",
        headerText : '<spring:message code="budget.Remark" />',
        style : "aui-grid-user-custom-left ",
        editable : true,
        cellMerge : true ,
        mergeRef : "budgetAdjType", // 이전 칼럼(대분류) 셀머지의 값을 비교해서 실행함. (mergePolicy : "restrict" 설정 필수)
        mergePolicy : "restrict", 
        width : 200
    },{
        dataField : "overBudgetFlag",
        headerText : '',
        visible : false,
    },{
        dataField : "atchFileGrpId",
        headerText : '',
        visible : false,
    }];
         
    var adjPOptions = {
            enableCellMerge : true,
            showStateColumn:true,
            showRowNumColumn : true,
//            selectionMode       : "singleRow",
            selectionMode       : "singleCell", 
            usePaging : false,
            editable :true,
            softRemovePolicy : "exceptNew" //사용자추가한 행은 바로 삭제
      }; 
    
    adjPGridID = GridCommon.createAUIGrid("#adjPGridID", adjPLayout, "budgetDocSeq", adjPOptions);

    if(adjustmentList != '' ){
        AUIGrid.setGridData(adjPGridID, adjustmentList);
    } 
       
    $("#pBudgetDocNo").val("${budgetDocNo}");
    $("#pAtchFileGrpId").val("${atchFileGrpId}");
    
    // cellClick event.
    AUIGrid.bind(adjPGridID, "cellClick", function( event )
    {
        rowid = event.rowIndex;

    });
    
});

function  fn_clearData(){    
    fn_resetForm();

    //기본 콤보 셋팅
    fn_chnCombo('01');
}   

function fn_RemoveRow(){
	 AUIGrid.removeRow(adjPGridID, rowid);
}

//리스트 조회.
function fn_selectPopListAjax() {        
    Common.ajax("GET", "/eAccounting/budget/selectAdjustmentPopList", $("#pAdjForm").serialize(), function(result) {
        
         console.log("성공.");
         console.log( result);
         
        AUIGrid.setGridData(adjPGridID, result.adjustmentList);
        
        if(result.fileList <= 0){
        	setInputFile2();
        }
        
    });
} 


function setInputFile2(){//인풋파일 세팅하기
    $(".auto_file2").append("<label><input type='text' class='input_text' readonly='readonly' /><span class='label_text'><a href='#'>File</a></span></label><span class='label_text'><a href='#'>Add</a></span><span class='label_text'><a href='#'>Delete</a></span>");
}
function fn_mon(str){

	if(str == "hide"){
	    $("#sendYearMonth").prop("disabled", false); 	    
	    $("#recvYearMonth").prop("disabled", true);  
	}else{
        $("#sendYearMonth").prop("disabled", false); 
        $("#recvYearMonth").prop("disabled", false);
	}    
}

function fn_Cost(str){
	if( str=="hide" ){
		$("#recvCost").hide();
	    
	    //$("#recvCostCenterName").prop("readonly", true);
	    //$("#recvCostCenterName").attr("class", "readonly");
        $("#recvCostCenter").prop("readonly", true);
	    $("#recvCostCenter").attr("class", "readonly");
	}else if ( str=="show" ){
		$("#recvCost").show();
	    
	    //$("#recvCostCenterName").prop("readonly", false);
	    //$("#recvCostCenterName").attr("class", "");
        $("#recvCostCenter").prop("readonly", false);
	    $("#recvCostCenter").attr("class", "");
	}
}
function fn_budget(str){
	if( str=="hide" ){
		$("#recvBudget").hide();
        
       // $("#recvBudgetCodeName").prop("readonly", true);
       //$("#recvBudgetCodeName").attr("class", "readonly");
        $("#recvBudgetCode").prop("readonly", true);
        $("#recvBudgetCode").attr("class", "readonly");
	}else if ( str=="show" ){
		$("#recvBudget").show();
	    
	   // $("#recvBudgetCodeName").prop("readonly", false);
	   // $("#recvBudgetCodeName").attr("class", "");
        $("#recvBudgetCode").prop("readonly", false);
	    $("#recvBudgetCode").attr("class", "");
	}
}
function fn_glAcc(str){
	
	if( str=="hide" ){
        $("#recvGlAcc").hide();
        
        //$("#recvGlAccCodeName").prop("readonly", true);
        //$("#recvGlAccCodeName").attr("class", "readonly");
        $("#recvGlAccCode").prop("readonly", true);
        $("#recvGlAccCode").attr("class", "readonly");
	}else if ( str=="show" ){
		$("#recvGlAcc").show();
	    
	   // $("#recvGlAccCodeName").prop("readonly", false);
	   // $("#recvGlAccCodeName").attr("class", "");
	    $("#recvGlAccCode").prop("readonly", false);
	    $("#recvGlAccCode").attr("class", "");
	}
}


 var budgetStr ;
//Budget Code Pop 호출
function fn_pBudgetCodePop(str){
  budgetStr = str;

  $("#pBudgetCode").val("");
  $("#pBudgetCodeName").val("");
  
//add jgkim
  var obj = {pop : 'pop'};
  
  if(budgetStr == "send"){
      
      $("#sendBudgetCode").val("");
      $("#sendBudgetCodeName").val("");
      
      if($("#pAdjustmentType").val() != "04"){
          if($("#pAdjustmentType").val() != "01" && $("#pAdjustmentType").val() != "02"){

              $("#recvBudgetCode").val("");
              $("#recvBudgetCodeName").val("");
          }
      }
      
   // add jgkim
      if("${mgrYn}" == "Y") {
          obj.call = 'budgetAdj';
      }
  }else{
      $("#recvBudgetCode").val("");
      $("#recvBudgetCodeName").val("");
      
      if($("#pAdjustmentType").val() == "04"){
          obj.call = 'budgetAdj';
      }
  }
  
  Common.popupDiv("/eAccounting/expense/budgetCodeSearchPop.do", obj, null, true, "budgetCodeSearchPop");
}  


function  fn_setPopBudgetData(){
  if(budgetStr == "send"){
	  
	  $("#sendBudgetCode").val($("#pBudgetCode").val());
      $("#sendBudgetCodeName").val( $("#pBudgetCodeName").val());
	  
	  if($("#pAdjustmentType").val() != "04"){
		  if($("#pAdjustmentType").val() != "01" && $("#pAdjustmentType").val() != "02"){

	          $("#recvBudgetCode").val($("#pBudgetCode").val());
	          $("#recvBudgetCodeName").val( $("#pBudgetCodeName").val());
          }
	      
	  }
  }else{
      $("#recvBudgetCode").val($("#pBudgetCode").val());
      $("#recvBudgetCodeName").val( $("#pBudgetCodeName").val());
  }
  
} 

 //Gl Account Pop 호출
var glStr ;
function fn_pGlAccountSearchPop(str){
  glStr = str;

  $("#pGlAccCode").val("");
  $("#pGlAccCodeName").val("");
  
//add jgkim
  var obj = {pop : 'pop'};
  
  if(glStr =="send"){
      $("#sendGlAccCode").val("");
      $("#sendGlAccCodeName").val("");
      
      if($("#pAdjustmentType").val() != "05"){
          if($("#pAdjustmentType").val() != "01" && $("#pAdjustmentType").val() != "02"){

              $("#recvGlAccCode").val("");
              $("#recvGlAccCodeName").val("");
          }         
      }
      
   // add jgkim
      if("${mgrYn}" == "Y") {
          obj.call = 'budgetAdj';
      }
  }else{
      $("#recvGlAccCode").val("");
      $("#recvGlAccCodeName").val("");
      
      if($("#pAdjustmentType").val() == "05"){
          obj.call = 'budgetAdj';
      }
  }
  
  Common.popupDiv("/eAccounting/expense/glAccountSearchPop.do", obj, null, true, "glAccountSearchPop");
}

function fn_setPopGlData(){
  
  if(glStr =="send"){
      $("#sendGlAccCode").val($("#pGlAccCode").val());
      $("#sendGlAccCodeName").val( $("#pGlAccCodeName").val());
      
      if($("#pAdjustmentType").val() != "05"){
    	  if($("#pAdjustmentType").val() != "01" && $("#pAdjustmentType").val() != "02"){

    		  $("#recvGlAccCode").val($("#pGlAccCode").val());
              $("#recvGlAccCodeName").val( $("#pGlAccCodeName").val());
          }
         
      }
  }else{
      $("#recvGlAccCode").val($("#pGlAccCode").val());
      $("#recvGlAccCodeName").val( $("#pGlAccCodeName").val());
  }
      
} 

//Cost Center
var costStr ;
function fn_pCostCenterSearchPop(str) {
  costStr = str;

  $("#search_costCentr").val("");
  $("#search_costCentrName").val("");
  
  // add jgkim
var obj = {pop : 'pop'};
  
 if(costStr =="send"){
      
      $("#sendCostCenter").val("");
      $("#sendCostCenterName").val("");
      
      if($("#pAdjustmentType").val() != "03"){
          if($("#pAdjustmentType").val() != "01" && $("#pAdjustmentType").val() != "02"){

              $("#recvCostCenter").val("");
              $("#recvCostCenterName").val("");
          }
      } 
      
   // add jgkim
      if("${mgrYn}" == "Y") {
          obj.call = 'budgetAdj';
      }
  }else{
      $("#recvCostCenter").val("");
      $("#recvCostCenterName").val("");
  }
 
 Common.popupDiv("/eAccounting/webInvoice/costCenterSearchPop.do", obj, null, true, "costCenterSearchPop");
}

function fn_setPopCostCenter (){

  if(costStr =="send"){
	  
      $("#sendCostCenter").val($("#search_costCentr").val());
      $("#sendCostCenterName").val( $("#search_costCentrName").val());
	  
	  if($("#pAdjustmentType").val() != "03"){
		  if($("#pAdjustmentType").val() != "01" && $("#pAdjustmentType").val() != "02"){

	          $("#recvCostCenter").val($("#search_costCentr").val());
	          $("#recvCostCenterName").val( $("#search_costCentrName").val());
	      }
	  } 
  }else{
      $("#recvCostCenter").val($("#search_costCentr").val());
      $("#recvCostCenterName").val( $("#search_costCentrName").val());
  }
      
} 

function fn_getCodeName(str, value){
    
    Common.ajax("POST", "/eAccounting/budget/selectCodeName", {"codeType":str, "code" : value} , function(result)    {
        console.log("성공." + JSON.stringify(result));
        console.log("data : " + result.data);
        
        if(str == "SC"){
            $("#sendCostCenterName").val(result.data);   
            
             if($("#pAdjustmentType").val() != "03"){
                 if($("#pAdjustmentType").val() != "01" && $("#pAdjustmentType").val() != "02"){

                     $("#recvCostCenter").val($("#sendCostCenter").val());
                     $("#recvCostCenterName").val( $("#sendCostCenterName").val());
                 }
             } 
            
        }else if(str == "SB"){
            $("#sendBudgetCodeName").val(result.data);
            
            if($("#pAdjustmentType").val() != "04"){
                if($("#pAdjustmentType").val() != "01" && $("#pAdjustmentType").val() != "02"){

                    $("#recvBudgetCode").val($("#sendBudgetCode").val());
                    $("#recvBudgetCodeName").val( $("#sendBudgetCodeName").val());
                }
                
            }
            
        }else if(str == "SG"){
            $("#sendGlAccCodeName").val(result.data);            

            if($("#pAdjustmentType").val() != "05"){
                if($("#pAdjustmentType").val() != "01" && $("#pAdjustmentType").val() != "02"){

                    $("#recvGlAccCode").val($("#sendGlAccCode").val());
                    $("#recvGlAccCodeName").val( $("#sendGlAccCodeName").val());
                }
               
            }
        }else if(str == "RC"){
            $("#recvCostCenterName").val(result.data);            
        }else if(str == "RB"){
            $("#recvBudgetCodeName").val(result.data);            
        }else if(str == "RG"){
            $("#recvGlAccCodeName").val(result.data);            
        }
        
    });
         
}


function fn_resetForm(){
    $("#recvCostCenter").val("");
    $("#recvYearMonth").val("");
    $("#recvBudgetCode").val("");
    $("#recvBudgetCodeName").val("");
    $("#recvGlAccCode").val("");
    $("#recvGlAccCodeName").val("");
    $("#pAdjustmentType").val("01");
    $("#recvAmount").val("")
    $("#remark").val("");
    
    $("#sendCostCenter").val("");
    $("#sendYearMonth").val("");
    $("#sendBudgetCode").val("");
    $("#sendBudgetCodeName").val("");
    $("#sendGlAccCode").val("");
    $("#sendGlAccCodeName").val("");
    $("#sendAmount").val("");
}

function fn_chnCombo(str){
	
    fn_resetForm();
    $("#pAdjustmentType").val(str);
    
	if( str =="01" || str =="02"){
        
        fn_mon("hide");
        fn_Cost("hide");
        fn_budget("hide");
        fn_glAcc("hide");               
        
    }else if( str =="03"){

        fn_mon("hide");
        fn_Cost("show");
        fn_budget("hide");
        fn_glAcc("hide");   
        
    }else if( str =="04"){

        fn_mon("hide");
        fn_Cost("hide");
        fn_budget("show");
        fn_glAcc("hide");   
        
    }else if( str =="05"){

        fn_mon("hide");
        fn_Cost("hide");
        fn_budget("hide");
        fn_glAcc("show");   
        
    }else if( str =="06"){

        fn_mon("all");
        fn_Cost("hide");
        fn_budget("hide");
        fn_glAcc("hide");   
        
    }else if( str =="07"){

        fn_mon("all");
        fn_Cost("show");
        fn_budget("show");
        fn_glAcc("show");   
    }

    console.log("period_values: " + str);
}


//MstGrid 행 추가, 삽입
function fn_AddRow()
{
    var item = new Object();

    if ( $("#sendYearMonth").val() == "") {
        var msg = '<spring:message code="budget.Month" />/<spring:message code="budget.Year" />';
        Common.alert("<spring:message code='sys.common.alert.validation' arguments='"+msg+"' htmlEscape='false'/>", function(){
        	
	        $("#sendYearMonth").focus();
        });
        return false;
    }
    if ( $("#sendCostCenter").val() == "") {
        var msg = '<spring:message code="budget.CostCenter" />';
        Common.alert("<spring:message code='sys.common.alert.validation' arguments='"+msg+"' htmlEscape='false'/>", function(){
        	
	        $("#sendCostCenterName").focus();
        });
        return false;
    }
    
    if ( $("#sendBudgetCode").val() == "") {
        var msg = '<spring:message code="expense.Activity" />';
        Common.alert("<spring:message code='sys.common.alert.validation' arguments='"+msg+"' htmlEscape='false'/>", function(){
        	
	        $("#sendBudgetCodeName").focus();
        });
        return false;
    }
    if ( $("#sendGlAccCode").val() == "") {
        var msg = '<spring:message code="expense.GLAccount" />';
        Common.alert("<spring:message code='sys.common.alert.validation' arguments='"+msg+"' htmlEscape='false'/>", function(){
        	
            $("#sendGlAccCodeName").focus();
        });
        return false;
    }
    if ( $("#sendAmount").val() == "") {
        var msg = '<spring:message code="budget.Sender" /> <spring:message code="budget.Amount" />';
        Common.alert("<spring:message code='sys.common.alert.validation' arguments='"+msg+"' htmlEscape='false'/>", function(){

            $("#sendAmount").focus();
        });
        return false;
    }
        
    item.budgetDocNo = $("#pBudgetDocNo").val();
    item.costCentr = $("#sendCostCenter").val();
    item.adjYearMonth = $("#sendYearMonth").val();
    item.budgetCode  = $("#sendBudgetCode").val();
    item.budgetCodeText  = $("#sendBudgetCodeName").val();
    item.glAccCode  = $("#sendGlAccCode").val();
    item.glAccDesc  = $("#sendGlAccCodeName").val();
    item.budgetAdjType  =$("#pAdjustmentType").val();
    item.budgetAdjTypeName  =$("#pAdjustmentType option:selected").text();
    item.adjAmt  = $("#sendAmount").val().replace(/,/gi, "");
    item.adjRem  = $("#remark").val();
    
    if($("#pAdjustmentType").val() == '01' ){
        item.signal  = '+';
    }else{
    	item.signal  = '-';
    }
    
    if($("#pAdjustmentType").val() != '01' && $("#pAdjustmentType").val() != '02' && $("#pAdjustmentType").val() !=''){
    	var item2 = new Object();
    	
        if ( $("#recvYearMonth").val() == "") {
            var msg = '<spring:message code="budget.Month" />/<spring:message code="budget.Year" />';
            Common.alert("<spring:message code='sys.common.alert.validation' arguments='"+msg+"' htmlEscape='false'/>", function(){
            	$("#recvYearMonth").focus();
            });
            //
            return false;
        }
        if ( $("#recvCostCenter").val() == "") {
            var msg = '<spring:message code="budget.CostCenter" />';
            Common.alert("<spring:message code='sys.common.alert.validation' arguments='"+msg+"' htmlEscape='false'/>", function(){
                $("#recvCostCenterName").focus();
            });
            return false;
        }
        
        if ( $("#recvBudgetCode").val() == "") {
            var msg = '<spring:message code="expense.Activity" />';
            Common.alert("<spring:message code='sys.common.alert.validation' arguments='"+msg+"' htmlEscape='false'/>",  function(){

                $("#recvBudgetCodeName").focus();
            });
            return false;
        }
        if ( $("#recvGlAccCode").val() == "") {
            var msg = '<spring:message code="expense.GLAccount" />';
            Common.alert("<spring:message code='sys.common.alert.validation' arguments='"+msg+"' htmlEscape='false'/>", function(){
                $("#recvGlAccCodeName").focus();
            });
            return false;
        }
        if ( $("#recvAmount").val() == "") {
            var msg = '<spring:message code="budget.Receiver" /> <spring:message code="budget.Amount" />';
            Common.alert("<spring:message code='sys.common.alert.validation' arguments='"+msg+"' htmlEscape='false'/>", function(){
                $("#recvAmount").focus();
            });
            return false;
        }

        item2.budgetDocNo = $("#pBudgetDocNo").val();
        item2.costCentr = $("#recvCostCenter").val();
        item2.adjYearMonth   =$("#recvYearMonth").val();
        item2.budgetCode  = $("#recvBudgetCode").val();
        item2.budgetCodeText  = $("#recvBudgetCodeName").val();
        item2.glAccCode  = $("#recvGlAccCode").val();
        item2.glAccDesc  = $("#recvGlAccCodeName").val();
        item2.budgetAdjType  =$("#pAdjustmentType").val();
        item2.budgetAdjTypeName  =$("#pAdjustmentType option:selected").text();
        item2.adjAmt  = $("#recvAmount").val().replace(/,/gi, "");
        item2.adjRem  = $("#remark").val();
        item2.signal  = '+';
    }
    
 /*    if($("#pAdjustmentType").val() == '01' ){ */
	    Common.ajax("POST", "/eAccounting/budget/selectPlanMaster",  $("#pAdjForm").serializeJSON() , function(result)    {
	    	console.log("성공." + JSON.stringify(result));
	        console.log("data : " + result.data);
	        
	        if($("#pAdjustmentType").val() != '01' && $("#pAdjustmentType").val() != '02' && $("#pAdjustmentType").val() !=''){
	        	
	        	if(result.data.send == "N" && result.data.recv == "N"){ 
	                Common.alert("<spring:message code="budget.msg.addMaster" />" +" : "+ "<spring:message code="budget.Sender" />"+ ", " + "<spring:message code="budget.Receiver" />");
	            }else if(result.data.send == "N" && result.data.recv == "Y"){	                 
	                Common.alert("<spring:message code="budget.msg.addMaster" />" +" : "+ "<spring:message code="budget.Sender" />");
	            }else if(result.data.send == "Y" && result.data.recv == "N"){
	            	Common.alert("<spring:message code="budget.msg.addMaster" />" +" : "+ "<spring:message code="budget.Receiver" />");
	            }else{
	                AUIGrid.addRow(adjPGridID, item, 'last');                    
	                AUIGrid.addRow(adjPGridID, item2, 'last'); 
	            }
	        	
	        	
	        }else{
	        	
	        	if(result.data.send == "N"){
	        		Common.alert('<spring:message code="budget.msg.NoPlan" />');
	        	}else{
	                AUIGrid.addRow(adjPGridID, item, 'last');          
	            }
	        }
	    	
	    },"", {async: false});
 /* 
    }else{

        AUIGrid.addRow(adjPGridID, item, 'last');                    
        AUIGrid.addRow(adjPGridID, item2, 'last'); 
    } */
    
   
	    fn_clearData();
                
}  

function fn_uploadFile(str) {
   
    var formData = Common.getFormData("pAdjForm");

    $("#type").val(str);
    
    var idx = AUIGrid.getRowCount(adjPGridID);
    
    if(idx == 0){
    	Common.alert("<spring:message code='budget.msg.noData' />");
    	return;
    }
        
    if(Common.confirm("<spring:message code='sys.common.alert.save'/>", function(){

        	if(AUIGrid.getCellValue(adjPGridID, 1, "atchFileGrpId") != "" &&AUIGrid.getCellValue(adjPGridID, 1, "atchFileGrpId") != null ){
        		formData.append("pAtchFileGrpId", AUIGrid.getCellValue(adjPGridID, 1, "atchFileGrpId") );
        	}
        	
	        Common.ajaxFile("/eAccounting/budget/uploadFile.do", formData, function(result) {//  첨부파일 정보를 공통 첨부파일 테이블 이용 : 웹 호출 테스트
	
	            console.log(result);
	        
	            if(result.data) {
	            	$("#pAtchFileGrpId").val(result.data);
	            }
	            
	            if($("#pAtchFileGrpId").val() == ""){
	            	 Common.alert("<spring:message code="budget.msg.fileRequir" />");
	            	 return;
	            }
	            
	            fn_saveAdjustement();
	            
	        }); 
	  }));
}


function fn_saveAdjustement(){
    var obj = $("#pAdjForm").serializeJSON();    
    var gridData = GridCommon.getEditData(adjPGridID);
    obj.gridData = gridData;
        	
   	Common.ajax("POST", "/eAccounting/budget/saveAdjustmentList", obj , function(result)    {
           
           console.log("성공." + JSON.stringify(result));
           console.log("data : " + result.data);
           
           $("#pBudgetDocNo").val(result.data.budgetDocNo);
         
           if($("#type").val() == "approval"){
        	   
        	    if(result.data.overbudget == "Y"){     
        	    	
        	    	var arryList = result.data.resultAmtList;
                    
                    var idx = arryList.length;
                    
                    for(var i = 0; i < idx; i++){
                     var costCentr = arryList[i].costCentr;
                        var budgetCode = arryList[i].budgetCode;
                        var glAccCode = arryList[i].glAccCode;
                        var adjYearMonth = arryList[i].budgetAdjMonth + "/"+ arryList[i].budgetAdjYear;
                        
                        for(var j=0; j < AUIGrid.getRowCount(adjPGridID); j++){
                         
                            var gridCostCentr = AUIGrid.getCellValue(adjPGridID, j, "costCentr"); 
                            var gridBudgetCode = AUIGrid.getCellValue(adjPGridID, j, "budgetCode"); 
                            var gridGlAccCode = AUIGrid.getCellValue(adjPGridID, j, "glAccCode"); 
                            var gridAdjYearMonth = AUIGrid.getCellValue(adjPGridID, j, "adjYearMonth"); 
                            var gridBudgetAdjType = AUIGrid.getCellValue(adjPGridID, j, "budgetAdjType"); 
                            
                             if(gridCostCentr == costCentr && gridBudgetCode == budgetCode 
                                        && gridGlAccCode == glAccCode && gridAdjYearMonth == adjYearMonth && gridBudgetAdjType !='01') {
                                 AUIGrid.setCellValue(adjPGridID, j, "overBudgetFlag","Y"); 
                             }
                         
                        }
                     
                    }
                    
                    AUIGrid.setProp(adjPGridID, "rowStyleFunction", function(rowIndex, item) {
                     if(item.overBudgetFlag == "Y") {
                            return "my-row-style";
                        }
                        return "";

                    }); 

                    // 변경된 rowStyleFunction 이 적용되도록 그리드 업데이트
                    AUIGrid.update(adjPGridID);
                 
                     Common.alert("<spring:message code="budget.exceeded" />"); 

                     $("#pBudgetDocNo").val("");
                 
                }else{                   
                    Common.alert("<spring:message code="budget.BudgetAdjustment" />"+ DEFAULT_DELIMITER +"<spring:message code="budget.msg.budgetDocNo" />" + result.data.budgetDocNo);
                    $("#pBudgetDocNo").val("");
                    AUIGrid.clearGridData(adjPGridID);
                    $("#pAdjForm")[0].reset();
                    //fn_selectPopListAjax();
                }
           }else{
               Common.alert("<spring:message code="budget.BudgetAdjustment" />"+ DEFAULT_DELIMITER +"<spring:message code="budget.msg.budgetDocNo" />" + result.data.budgetDocNo);

               fn_selectPopListAjax();
               
           }
           
        }
        , function(jqXHR, textStatus, errorThrown){
               try {
                   console.log("Fail Status : " + jqXHR.status);
                   console.log("code : "        + jqXHR.responseJSON.code);
                   console.log("message : "     + jqXHR.responseJSON.message);
                   console.log("detailMessage : "  + jqXHR.responseJSON.detailMessage);
             }
             catch (e)
             {
               console.log(e);
             }
             Common.alert("Fail : " + jqXHR.responseJSON.message);
       });
}

function fn_atchViewDown(atchFileName, fileSubPath, physiclFileName) {
	
    	
	var file = atchFileName.split(".");
	
	   if(file[1] == "jpg" || file[1] == "png") {
           // TODO View
           var fileSubPath = fileSubPath;
           fileSubPath = fileSubPath.replace('\', '/'');
           console.log(DEFAULT_RESOURCE_FILE + fileSubPath + '/' + physiclFileName);
           window.open(DEFAULT_RESOURCE_FILE + fileSubPath + '/' + physiclFileName);
       } else {
           var fileSubPath = fileSubPath;
           fileSubPath = fileSubPath.replace('\', '/'');
           console.log("/file/fileDown.do?subPath=" + fileSubPath
                   + "&fileName=" + physiclFileName + "&orignlFileNm=" + atchFileName);
           window.open("/file/fileDown.do?subPath=" + fileSubPath
               + "&fileName=" + physiclFileName + "&orignlFileNm=" + atchFileName);
       }
}

function fn_popBudgetApproval(value){
	
	if(value == "appv"){ //approval 처리

        $("#popAppvStus").val("C"); // adjustment Close
        $("#popAppvPrcssStus").val("A"); //Approval 
        $("#popRejectMsg").val("");
        
        fn_savePopApprove(value);
        
    }else{  //reject 처리
                
        var option = {
                title : "<spring:message code="budget.RejectTitle" />" ,
                textId : "promptText",
                textName : "promptText"
            }; 
        
        
         Common.prompt("<spring:message code="budget.msg.reject" /> ", "", function(){
            
             $("#popRejectMsg").val($("#promptText").val());
             
             fn_savePopApprove(value);
             
         }, null, option);
            
        $("#popAppvStus").val("T"); // adjustment Close
        $("#popAppvPrcssStus").val("J"); //Approval 
    }

}


function fn_savePopApprove(value){	
    
    if(Common.confirm("<spring:message code='sys.common.alert.save'/>", function(){
        
        Common.ajax("POST", "/eAccounting/budget/savePopBudgetApproval", $("#pAdjForm").serializeJSON()    , function(result){
            console.log("성공." + JSON.stringify(result));
            console.log("data : " + result.data);
            
            if(value == "appv"){ //approval 처리
                Common.alert("<spring:message code='sales.msg.ApprovedComplete' />");
            } else {
                Common.alert("<spring:message code='budget.msg.rejected' />");
            }
            $("#btnRej").hide();
            $("#btnApp").hide();
                      
      }
      , function(jqXHR, textStatus, errorThrown){
             try {
                 console.log("Fail Status : " + jqXHR.status);
                 console.log("code : "        + jqXHR.responseJSON.code);
                 console.log("message : "     + jqXHR.responseJSON.message);
                 console.log("detailMessage : "  + jqXHR.responseJSON.detailMessage);
           }
           catch (e)
           {
             console.log(e);
           }
           Common.alert("Fail : " + jqXHR.responseJSON.message);
     });
    }));
}

function fn_closeMonChk(obj){
	var str = obj.value;
	
	Common.ajax("GET", "/eAccounting/budget/selectCloseMonth?yearMonth="+ str, null, function(result) {
        
        console.log("성공.");
        console.log( result);
        
        if(result.data == "Y") {
        	Common.alert("Closed" + DEFAULT_DELIMITER + "Month : "+str+ " - The month is closed.");
            $("#" + obj.id).val("");
        }
       
   });
}
		

</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="budget.BudgetAdjustment" /></h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#"><spring:message code="expense.CLOSE" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body" style="min-height:540px;"><!-- pop_body start -->

<form action="#" method="post" id="pAdjForm" name="pAdjForm" enctype="multipart/form-data">
<section class="search_table"><!-- search_table start -->    
    <input type="hidden" id = "pBudgetDocNo" name="pBudgetDocNo" />
    <input type="hidden" id = "pAtchFileGrpId" name="pAtchFileGrpId" />
    <input type="hidden" id = "type" name="type" />
    <input type="hidden" id = "requestAmt" name="requestAmt" />
    <input type="hidden" id = "saveType" name="saveType" value="appv"/>
    
    <input type="hidden" id = "popRejectMsg" name="rejectMsg" />
    <input type="hidden" id = "popAppvStus" name="appvStus" />
    <input type="hidden" id = "popAppvPrcssStus" name="appvPrcssStus" />

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:130px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row"><spring:message code="budget.AdjustmentType" /></th>
	<td>
	<select class="" id="pAdjustmentType" name="pAdjustmentType" onchange="javascript:fn_chnCombo(this.value);">
	</select>
	</td>
</tr>
</tbody>
</table><!-- table end -->

</section><!-- search_table end -->

<div class="divine_auto"><!-- divine_auto start -->

<div style="width:50%;">

<aside class="title_line budget"><!-- title_line start -->
<h3><spring:message code="budget.Sender" /></h3>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:130px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row"><spring:message code="budget.Month" />/<spring:message code="budget.Year" /></th>
<%-- 	<td><input type="text" title="" placeholder="" class="" /><a href="#" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td> --%>
	<td><input type="text" id="sendYearMonth" name="sendYearMonth" title="" placeholder="MM/YYYY" class="j_date2" onchange="fn_closeMonChk(this);"/></td>
</tr>
<tr>
	<th scope="row"><spring:message code="budget.CostCenter" /></th>
	<td>
		<input type="text" id="sendCostCenter" name="sendCostCenter" onchange="javascript:fn_getCodeName('SC', this.value);" title="" placeholder="" class="" />
	    <input type="hidden" id="sendCostCenterName" name="sendCostCenterName" title="" placeholder="" class="" readonly="readonly"/>
	    <a href="#" class="search_btn"  onclick="javascript:fn_pCostCenterSearchPop('send')">
	        <img  id="sendCost"   src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" />
	    </a>
    </td>
</tr>
<tr>
	<th scope="row"><spring:message code="expense.Activity" /></th>
	<td>
		<input type="text" id="sendBudgetCode" name="sendBudgetCode" onchange="javascript:fn_getCodeName('SB', this.value);" title="" placeholder="" class="" />
		<input type="hidden" id="sendBudgetCodeName" name="sendBudgetCodeName" title="" placeholder="" class="" readonly="readonly"/>
		<a href="#" id="sendBudget" class="search_btn" onclick="javascript:fn_pBudgetCodePop('send')">
		   <img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" />
		</a>
	</td>
</tr>
<tr>
	<th scope="row"><spring:message code="expense.GLAccount" /></th>
	<td>
		<input type="text" id="sendGlAccCode" name="sendGlAccCode" onchange="javascript:fn_getCodeName('SG', this.value);" title="" placeholder="" class="" />
		<input type="hidden" id="sendGlAccCodeName" name="sendGlAccCodeName"  title="" placeholder="" class="" readonly="readonly"/>
		<a href="#" id="sendGlAcc" class="search_btn" onclick="javascript:fn_pGlAccountSearchPop('send')">
		   <img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" />
		</a>
	</td>
</tr>
<tr>
	<th scope="row"><spring:message code="budget.Sender" /> <spring:message code="budget.Amount" /></th>
	<td><input type="text" id="sendAmount" name="sendAmount" title="" placeholder="" class="al_right" /></td>
</tr>
</tbody>
</table><!-- table end -->

</div>

<div style="width:50%;">

<aside class="title_line budget"><!-- title_line start -->
<h3><spring:message code="budget.Receiver" /></h3>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:140px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row"><spring:message code="budget.Month" />/<spring:message code="budget.Year" /></th>
<%-- 	<td><input type="text" title="" placeholder="" class="" /><a href="#" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td> --%>
	<td><input type="text" id="recvYearMonth" name="recvYearMonth" title="" placeholder="MM/YYYY" class="j_date2" onchange="fn_closeMonChk(this);" /></td>
</tr>
<tr>
	<th scope="row"><spring:message code="budget.CostCenter" /></th>
	<td>
        <input type="text" id="recvCostCenter" name="recvCostCenter" onchange="javascript:fn_getCodeName('RC', this.value);" title="" placeholder="" class="" />
		<input type="hidden" id="recvCostCenterName" name="recvCostCenterName" title="" placeholder="" class="" readonly="readonly"/>
		<a href="#" id="recvCost" class="search_btn" onclick="javascript:fn_pCostCenterSearchPop('recv')">
		   <img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" />
		</a>
	</td>
</tr>
<tr>
	<th scope="row"><spring:message code="expense.Activity" /></th>
	<td>
		<input type="text" id="recvBudgetCode" name="recvBudgetCode" onchange="javascript:fn_getCodeName('RB', this.value);" title="" placeholder="" class="" />
		<input type="hidden" id="recvBudgetCodeName" name="recvBudgetCodeName" title="" placeholder="" class="" readonly="readonly"/>
		<a href="#" id="recvBudget" class="search_btn" onclick="javascript:fn_pBudgetCodePop('recv')">
		   <img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" />
	   </a>
   </td>
</tr>
<tr>
	<th scope="row"><spring:message code="expense.GLAccount" /></th>
	<td>
        <input type="text" id="recvGlAccCode" name="recvGlAccCode"  onchange="javascript:fn_getCodeName('RG', this.value);" title="" placeholder="" class="" />
		<input type="hidden"  id="recvGlAccCodeName" name="recvGlAccCodeName" title="" placeholder="" class="" readonly="readonly"/>
		<a href="#" id="recvGlAcc" class="search_btn" onclick="javascript:fn_pGlAccountSearchPop('recv')">
		   <img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" />
		</a>
	</td>
</tr>
<tr>
	<th scope="row"><spring:message code="budget.Receiver" /> <spring:message code="budget.Amount" /></th>
	<td><input type="text"  id="recvAmount" name="recvAmount" title="" placeholder="" class="readonly al_right" readonly="readonly" /></td>
</tr>
</tbody>
</table><!-- table end -->

</div>

</div><!-- divine_auto end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:130px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row"><spring:message code="budget.Remark" /></th>
	<td><input type="text" id="remark" name="remark" title="" placeholder="" class="w100p" /></td>
</tr>
</tbody>
</table><!-- table end -->

    <c:if test="${budgetStatus ==  'Y'}">
<ul class="center_btns">
		<li><p class="btn_blue2"><a href="#" id="btnAdd"><spring:message code="expense.Add" /></a></p></li>
		<li><p class="btn_blue2"><a href="#" id="btnDel"><spring:message code="budget.Delete" /></a></p></li>
		<li><p class="btn_blue2"><a href="#" onclick="javascript:fn_clearData();" id="btnClear"><spring:message code="budget.Clear" /></a></p></li>
</ul>
    </c:if>
<article class="grid_wrap mt10" style="height:170px"><!-- grid_wrap start -->
    <div id="adjPGridID" style="width:100%; height:150px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

<table class="type1 mt10"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:120px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="newWebInvoice.attachment" /></th>
    <td colspan="3">    
	      <c:forEach var="files" items="${fileList}" varStatus="st">
		    <div class="auto_file2"><!-- auto_file start -->
            <c:if test="${budgetStatus == 'Y'}">
			    <input type="file" title="file add" style="width:300px" />
			    <label>
				    <input type='text' class='input_text' readonly='readonly' value="${files.atchFileName}" />
				    <span class='label_text'><a href='#'><spring:message code="viewEditWebInvoice.file" /></a></span>
			    </label>
			    <span class='label_text'><a href='#' id="add_btn"><spring:message code="viewEditWebInvoice.add" /></a></span>
			    <span class='label_text'><a href='#' id="remove_btn"><spring:message code="viewEditWebInvoice.delete" /></a></span>
		    </c:if>               
            <c:if test="${budgetStatus == 'N'}">
                <input type='text' class='input_text' readonly='readonly' value="${files.atchFileName}" />
            </c:if>
          </div><!-- auto_file end -->	
	    </c:forEach>
	    <c:if test="${fn:length(fileList) <= 0 and budgetStatus ==  'Y'}">	    
		    <div class="auto_file2"><!-- auto_file start -->
		      <input type="file" title="file add" style="width:300px" />
		    </div><!-- auto_file end -->
	    </c:if>
    </td>
</tr>
</tbody>
</table><!-- table end -->

    <c:if test="${budgetStatus ==  'Y' }">
<ul class="center_btns mt10">
		<li><p class="btn_blue2"><a href="#" onclick="javascript:fn_uploadFile('temp');"><spring:message code="budget.TempSave" /></a></p></li>
		<li><p class="btn_blue2"><a href="#" onclick="javascript:fn_uploadFile('approval');"><spring:message code="budget.Submit" /></a></p></li>
</ul>
    </c:if> 

    <c:if test="${appv ==  'Y' }">
<ul class="center_btns mt10">
        <li><p class="btn_blue2"><a href="#" id="btnApp" onclick="javascript:fn_popBudgetApproval('appv');"><spring:message code="budget.Approval" /></a></p></li>
        <li><p class="btn_blue2"><a href="#" id="btnRej" onclick="javascript:fn_popBudgetApproval('reject');"><spring:message code="budget.Reject" /></a></p></li>
</ul>
    </c:if> 
</form>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->