<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<style type="text/css">
/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-left {
    text-align:left;
}
/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-right {
    text-align:right;
}
</style>
<script type="text/javascript">
var pettyCashExpColumnLayout = [ {
    dataField : "costCentr",
    headerText : '<spring:message code="webInvoice.costCenter" />'
}, {
    dataField : "costCentrName",
    headerText : '<spring:message code="pettyCashCustdn.costCentrName" />',
    style : "aui-grid-user-custom-left"
}, {
    dataField : "memAccId",
    headerText : '<spring:message code="pettyCashCustdn.custdn" />'
}, {
    dataField : "memAccName",
    headerText : '<spring:message code="pettyCashCustdn.custdnName" />',
    style : "aui-grid-user-custom-left"
}, {
    dataField : "clmMonth",
    headerText : '<spring:message code="pettyCashExp.clmMonth" />',
    dataType : "date",
    formatString : "mm/yyyy"
}, {
    dataField : "clmNo",
    headerText : '<spring:message code="invoiceApprove.clmNo" />'
}, {
    dataField : "reqstDt",
    headerText : '<spring:message code="pettyCashRqst.rqstDt" />',
    dataType : "date",
    formatString : "dd/mm/yyyy"
}, {
    dataField : "cur",
    headerText : '<spring:message code="newWebInvoice.cur" />'
}, {
    dataField : "totAmt",
    headerText : '<spring:message code="webInvoice.amount" />',
    style : "aui-grid-user-custom-right",
    dataType: "numeric",
    formatString : "#,##0.00"
}, {
    dataField : "appvPrcssStusCode",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "appvPrcssStus",
    headerText : '<spring:message code="webInvoice.status" />',
    style : "aui-grid-user-custom-left"
}, {
    dataField : "appvPrcssDt",
    headerText : '<spring:message code="pettyCashRqst.appvalDt" />',
    dataType : "date",
    formatString : "dd/mm/yyyy"
}
];

//그리드 속성 설정
var pettyCashExpGridPros = {
    // 페이징 사용       
    usePaging : true,
    // 한 화면에 출력되는 행 개수 20(기본값:20)
    pageRowCount : 20,
 // 헤더 높이 지정
    headerHeight : 40
};

var pettyCashExpGridID;

$(document).ready(function () {
	pettyCashExpGridID = AUIGrid.create("#expenseMgmt_grid_wrap", pettyCashExpColumnLayout, pettyCashExpGridPros);
    
    $("#search_supplier_btn").click(fn_supplierSearchPop);
    $("#search_costCenter_btn").click(fn_costCenterSearchPop);
    $("#registration_btn").click(fn_newExpensePop);
    
    AUIGrid.bind(pettyCashExpGridID, "cellDoubleClick", function( event ) 
            {
                console.log("CellDoubleClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");
                console.log("CellDoubleClick clmNo : " + event.item.clmNo);
                
                fn_viewExpensePop(event.item.clmNo);
            });
    
    $("#appvPrcssStus").multipleSelect("checkAll");
    
    fn_setToMonth();
});

function fn_setToMonth() {
    var month = new Date();
    
    var mm = month.getMonth() + 1;
    var yyyy = month.getFullYear();
    
    if(mm < 10){
        mm = "0" + mm
    }
    
    month = mm + "/" + yyyy;
    $("#clmMonth").val(month)
}


function fn_clearData() {
    $("#form_newExpense").each(function() {
        this.reset();
    });
    
    $("#attachTd").html("");
    $("#attachTd").append("<div class='auto_file2 auto_file3'><input type='file' title='file add' /><label><input type='text' class='input_text' readonly='readonly' /><span class='label_text'><a href='#'>File</a></span></label><span class='label_text'><a href='#'>Add</a></span><span class='label_text'><a href='#' id='remove_btn' onclick='javascript:fn_getRemoveFileList()'>Delete</a></span></div>");
    
    clmSeq = 0;
}

function fn_setEvent() {
$("#amt :text").keydown(function (event) { 
        
        var code = window.event.keyCode;
        
        if ((code > 34 && code < 41) || (code > 47 && code < 58) || (code > 95 && code < 106) ||code==110 ||code==190 ||code == 8 || code == 9 || code == 13 || code == 46)
        {
         window.event.returnValue = true;
         return;
        }
        window.event.returnValue = false;
        
   });
   
   $("#amt :text").click(function () { 
       var str = $(this).val().replace(/,/gi, "");
       $(this).val(str);      
  });
   $("#amt :text").blur(function () { 
       var str = $(this).val().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
       $(this).val(str);      
  });
   
    $("#form_newExpense :text").change(function(){
        var id = $(this).attr("id");
        console.log(id);
        if(id == "gstBeforAmt" || id == "gstAmt") {
            var str =""+ Math.floor($(this).val() * 100)/100;
               
               var str2 = str.split(".");
              
               if(str2.length == 1){
                   str2[1] = "00";
               }
               
               if(str2[0].length > 11){
                   Common.alert('<spring:message code="pettyCashNewCustdn.Amt.msg" />');
                   str = "";
               }else{
                   str = str2[0].substr(0, 11)+"."+str2[1];
               }
               str = str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
               
               
               $(this).val(str);
               
               var totAmt = 0;
               $.each($("#amt :text"), function(i, obj) {
                   if(obj.value != null && obj.value != ""){
                       console.log(i);
                       console.log(obj.value);
                       totAmt += Number(obj.value.replace(/,/gi, ""));
                       console.log(obj.value.replace(/,/gi, ""));
                   }
               });
               console.log(totAmt);
               totAmt = "" + totAmt;
               $("#totAmt").val(totAmt.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,'));
               console.log(totAmt.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,'));
        } else if(id == "newClmMonth") {
            var clmMonth = $(this).val();
            console.log(clmMonth);
            var month = clmMonth.substring(0, 2);
            var year = clmMonth.substring(3);
            console.log("year : " + year + " month : " + month);
            clmMonth = year + month;
            
            var now = new Date;
            var mm = now.getMonth() + 1;
            var yyyy = now.getFullYear();
            if(mm < 10){
                mm = "0" + mm
            }
            now = yyyy + "" + mm;
            console.log("yyyy : " + yyyy + " mm : " + mm);
            
            console.log(clmMonth);
            console.log(now);
            if(Number(clmMonth) > Number(now)) {
                Common.alert('<spring:message code="pettyCashExp.onlyPastDt.msg" />');
                $(this).val(mm + "/" + yyyy);
            }
        }
   }); 
}

function fn_supplierSearchPop() {
    Common.popupDiv("/eAccounting/webInvoice/supplierSearchPop.do", null, null, true, "supplierSearchPop");
}

function fn_costCenterSearchPop() {
    Common.popupDiv("/eAccounting/webInvoice/costCenterSearchPop.do", null, null, true, "costCenterSearchPop");
}

function fn_popSupplierSearchPop() {
    Common.popupDiv("/eAccounting/webInvoice/supplierSearchPop.do", {pop:"pop"}, null, true, "supplierSearchPop");
}

function fn_popSubSupplierSearchPop() {
    Common.popupDiv("/eAccounting/webInvoice/supplierSearchPop.do", {pop:"sPop"}, null, true, "supplierSearchPop");
}

function fn_popCostCenterSearchPop() {
    Common.popupDiv("/eAccounting/webInvoice/costCenterSearchPop.do", {pop:"pop"}, null, true, "costCenterSearchPop");
}

function fn_PopExpenseTypeSearchPop() {
    Common.popupDiv("/eAccounting/expense/expenseTypeSearchPop.do", {popClaimType:'J2'}, null, true, "expenseTypeSearchPop");
}

function fn_setSupplier() {
    $("#memAccId").val($("#search_memAccId").val());
    $("#memAccName").val($("#search_memAccName").val());
}

function fn_setCostCenter() {
    $("#costCenter").val($("#search_costCentr").val());
    $("#costCenterText").val($("#search_costCentrName").val());
}

function fn_setPopCostCenter() {
    $("#newCostCenter").val($("#search_costCentr").val());
    $("#newCostCenterText").val($("#search_costCentrName").val());
    
    if(fn_checkForCustdnNric()){
        // Approved Cash Amount GET and CUSTDN_NRIC GET
        var data = {
                memAccId : $("#newMemAccId").val(),
                costCentr : $("#newCostCenter").val()
        };
        console.log(data);
        Common.ajax("POST", "/eAccounting/pettyCash/selectCustodianInfo.do", data, function(result) {
            console.log("fn_setPopCostCenter Action");
            console.log(result);
            console.log(FormUtil.isEmpty(result.data));
            if(FormUtil.isEmpty(result.data)) {
                Common.alert('<spring:message code="pettyCashRqst.custdnNric.msg" />');
            } else {
            	if(!FormUtil.isEmpty(result.data.custdnNric)) {
                    var custdnNric = result.data.custdnNric;
                    $("#custdnNric").val(custdnNric.replace(/(\d{6})(\d{2})(\d{4})/, '$1-$2-$3'));
                }
            }
        });
    }
}

function fn_setPopSupplier() {
    $("#newMemAccId").val($("#search_memAccId").val());
    $("#newMemAccName").val($("#search_memAccName").val());
    $("#bankCode").val($("#search_bankCode").val());
    $("#bankName").val($("#search_bankName").val());
    $("#bankAccNo").val($("#search_bankAccNo").val());
    
    if(fn_checkForCustdnNric()){
        // Approved Cash Amount GET and CUSTDN_NRIC GET
        var data = {
                memAccId : $("#newMemAccId").val(),
                costCentr : $("#newCostCenter").val()
        };
        console.log(data);
        Common.ajax("POST", "/eAccounting/pettyCash/selectCustodianInfo.do", data, function(result) {
            console.log("fn_setPopSupplier Action");
            console.log(result);
            console.log(FormUtil.isEmpty(result.data));
            if(FormUtil.isEmpty(result.data)) {
                Common.alert('<spring:message code="pettyCashRqst.custdnNric.msg" />');
            } else {
            	if(!FormUtil.isEmpty(result.data.custdnNric)) {
                    var custdnNric = result.data.custdnNric;
                    $("#custdnNric").val(custdnNric.replace(/(\d{6})(\d{2})(\d{4})/, '$1-$2-$3'));
                }
            }
        });
    }
}

function fn_setPopSubSupplier() {
    $("#sMemAccId").val($("#search_memAccId").val());
    $("#sMemAccName").val($("#search_memAccName").val());
    $("#gstRgistNo").val($("#search_gstRgistNo").val());
}

function fn_setPopExpType() {
    console.log("Action");
    $("#budgetCode").val($("#search_budgetCode").val());
    $("#budgetCodeName").val($("#search_budgetCodeName").val());
    
    $("#expType").val($("#search_expType").val());
    $("#expTypeName").val($("#search_expTypeName").val());
    
    $("#glAccCode").val($("#search_glAccCode").val());
    $("#glAccCodeName").val($("#search_glAccCodeName").val());
}

function fn_checkForCustdnNric() {
    var checkResult = true;
    if(FormUtil.isEmpty($("#newCostCenterText").val())) {
        Common.alert('<spring:message code="pettyCashCustdn.costCentr.msg" />');
        checkResult = false;
        return checkResult;
    }
    if(FormUtil.isEmpty($("#newMemAccName").val())) {
        Common.alert('<spring:message code="pettyCashCustdn.custdn.msg" />');
        checkResult = false;
        return checkResult;
    }
    return checkResult;
}

function fn_checkEmpty() {
    var checkResult = true;
    if(FormUtil.isEmpty($("#newCostCenterText").val())) {
    	Common.alert('<spring:message code="pettyCashCustdn.costCentr.msg" />');
        checkResult = false;
        return checkResult;
    }
    if(FormUtil.isEmpty($("#newMemAccName").val())) {
    	Common.alert('<spring:message code="pettyCashCustdn.custdn.msg" />');
        checkResult = false;
        return checkResult;
    }
    if(FormUtil.isEmpty($("#newClmMonth").val())) {
        Common.alert('<spring:message code="pettyCashExp.clmMonth.msg" />');
        checkResult = false;
        return checkResult;
    }
    if(FormUtil.isEmpty($("#invcDt").val())) {
        Common.alert('<spring:message code="webInvoice.invcDt.msg" />');
        checkResult = false;
        return checkResult;
    }
    if($("#invcType").val() == "F") {
        if(FormUtil.isEmpty($("#sMemAccName").val())) {
            Common.alert('<spring:message code="webInvoice.supplier.msg" />');
            checkResult = false;
            return checkResult;
        }
        if(FormUtil.isEmpty($("#invcNo").val())) {
        	Common.alert('<spring:message code="webInvoice.invcNo.msg" />');
            checkResult = false;
            return checkResult;
        }
        if(FormUtil.isEmpty($("#expType").val())) {
        	Common.alert('<spring:message code="webInvoice.expType.msg" />');
            checkResult = false;
            return checkResult;
        }
        if(FormUtil.isEmpty($("#taxCode").val())) {
        	Common.alert('<spring:message code="webInvoice.taxCode.msg" />');
            checkResult = false;
            return checkResult;
        }
        if(FormUtil.isEmpty($("#gstBeforAmt").val())) {
            Common.alert('<spring:message code="pettyCashExp.amtBeforeGst.msg" />');
            checkResult = false;
            return checkResult;
        }
    }
    return checkResult;
}

function fn_selectExpenseList() {
    Common.ajax("GET", "/eAccounting/pettyCash/selectExpenseList.do", $("#form_pettyCashExp").serialize(), function(result) {
        console.log(result);
        AUIGrid.setGridData(pettyCashExpGridID, result);
    });
}

function fn_newExpensePop() {
    Common.popupDiv("/eAccounting/pettyCash/newExpensePop.do", {callType:"new"}, null, true, "newExpensePop");
}

function fn_addRow() {
    // 파일 업로드 전에 필수 값 체크
    // 파일 업로드 후 그룹 아이디 값을 받아서 Add
    if(fn_checkEmpty()) {
        var formData = Common.getFormData("form_newExpense");
        if(clmSeq == 0) {
        	var data = {
                    costCentr : $("#newCostCenter").val()
                    ,costCentrName : $("#newCostCenterText").val()
                    ,memAccId : $("#newMemAccId").val()
                    ,custdnNric : $("#custdnNric").val()
                    ,bankCode : $("#bankCode").val()
                    ,bankAccNo : $("#bankAccNo").val()
                    ,clmMonth : $("#newClmMonth").val()
                    ,expType : $("#expType").val()
                    ,expTypeName : $("#expTypeName").val()
                    ,glAccCode : $("#glAccCode").val()
                    ,glAccCodeName : $("#glAccCodeName").val()
                    ,budgetCode : $("#budgetCode").val()
                    ,budgetCodeName : $("#budgetCodeName").val()
                    ,sMemAccId : $("#sMemAccId").val()
                    ,sMemAccName : $("#sMemAccName").val()
                    ,invcType : $("#invcType").val()
                    ,invcTypeName : $("#invcType option:selected").text()
                    ,invcNo : $("#invcNo").val()
                    ,invcDt : $("#invcDt").val()
                    ,gstRgistNo : $("#gstRgistNo").val()
                    ,taxCode : $("#taxCode").val()
                    ,taxName : $("#taxCode option:selected").text()
                    ,cur : "MYR"
                    ,gstBeforAmt : Number($("#gstBeforAmt").val().replace(/,/gi, ""))
                    ,gstAmt : Number($("#gstAmt").val().replace(/,/gi, ""))
                    ,expDesc : $("#expDesc").val()
            };
            
        	Common.ajaxFile("/eAccounting/pettyCash/attachFileUpload.do", formData, function(result) {
                console.log(result);
                
                data.atchFileGrpId = result.data.fileGroupKey
                console.log(data);
                AUIGrid.addRow(newGridID, data, "last");
                
                fn_getAllTotAmt();
            });
        } else {
        	var data = {
                    costCentr : $("#newCostCenter").val()
                    ,costCentrName : $("#newCostCenterText").val()
                    ,memAccId : $("#newMemAccId").val()
                    ,custdnNric : $("#custdnNric").val()
                    ,bankCode : $("#bankCode").val()
                    ,bankAccNo : $("#bankAccNo").val()
                    ,clmMonth : $("#newClmMonth").val()
                    ,expType : $("#expType").val()
                    ,expTypeName : $("#expTypeName").val()
                    ,glAccCode : $("#glAccCode").val()
                    ,glAccCodeName : $("#glAccCodeName").val()
                    ,budgetCode : $("#budgetCode").val()
                    ,budgetCodeName : $("#budgetCodeName").val()
                    ,sMemAccId : $("#sMemAccId").val()
                    ,sMemAccName : $("#sMemAccName").val()
                    ,invcType : $("#invcType").val()
                    ,invcTypeName : $("#invcType option:selected").text()
                    ,invcNo : $("#invcNo").val()
                    ,invcDt : $("#invcDt").val()
                    ,gstRgistNo : $("#gstRgistNo").val()
                    ,taxCode : $("#taxCode").val()
                    ,taxName : $("#taxCode option:selected").text()
                    ,cur : "MYR"
                    ,gstBeforAmt : Number($("#gstBeforAmt").val().replace(/,/gi, ""))
                    ,gstAmt : Number($("#gstAmt").val().replace(/,/gi, ""))
                    ,expDesc : $("#expDesc").val()
            };
            
            $("#attachTd").html("");
            $("#attachTd").append("<div class='auto_file2 auto_file3'><input type='file' title='file add' /><label><input type='text' class='input_text' readonly='readonly' /><span class='label_text'><a href='#'>File</a></span></label><span class='label_text'><a href='#'>Add</a></span><span class='label_text'><a href='#' id='remove_btn' onclick='javascript:fn_getRemoveFileList()'>Delete</a></span></div>");
            
        	formData.append("atchFileGrpId", atchFileGrpId);
        	formData.append("update", JSON.stringify(update).replace(/[\[\]\"]/gi, ''));
            console.log(JSON.stringify(update).replace(/[\[\]\"]/gi, ''));
            formData.append("remove", JSON.stringify(remove).replace(/[\[\]\"]/gi, ''));
            console.log(JSON.stringify(remove).replace(/[\[\]\"]/gi, ''));
        	Common.ajaxFile("/eAccounting/pettyCash/attachFileUpdate.do", formData, function(result) {
                console.log(result);
                
                console.log(data);
                AUIGrid.updateRow(newGridID, data, selectRowIdx);
                
                fn_getAllTotAmt();
                
                clmSeq = 0;
            });
        }
        
        fn_clearData();
    }
}

function fn_getAllTotAmt() {
	// allTotAmt GET, SET
    var allTotAmt = 0.00;
    var totAmtList = AUIGrid.getColumnValues (newGridID, "totAmt", true);
    console.log(totAmtList.length);
    for(var i = 0; i < totAmtList.length; i++) {
        allTotAmt += totAmtList[i];
    }
    allTotAmt += "";
    console.log(allTotAmt);
    $("#allTotAmt_text").text(allTotAmt.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,'));
}

function fn_insertPettyCashExp(st) {
    // row의 수가 0개 이상일때만 insert
    var gridDataList = AUIGrid.getOrgGridData(newGridID);
    if(gridDataList.length > 0){
        var data = {
                gridDataList : gridDataList
                ,allTotAmt : Number($("#allTotAmt_text").text().replace(/,/gi, ""))
        }
        console.log(data);
        Common.ajax("POST", "/eAccounting/pettyCash/insertPettyCashExp.do", data, function(result) {
            console.log(result);
            clmNo = result.data.clmNo;
            fn_selectExpenseItemList();
            if(st == "new"){
                Common.alert('<spring:message code="newWebInvoice.tempSave.msg" />');
                $("#newExpensePop").remove();
            }
            fn_selectExpenseList();
        });
    } else {
        Common.alert('<spring:message code="pettyCashExp.noData.msg" />');
    }
}

function fn_selectExpenseItemList() {
    var obj = {
            clmNo : clmNo
    };
    Common.ajax("GET", "/eAccounting/pettyCash/selectExpenseItemList.do", obj, function(result) {
        console.log(result);
        AUIGrid.setGridData(newGridID, result);
    });
}

function fn_selectExpenseInfo() {
    var obj = {
            clmNo : clmNo
            ,clmSeq : clmSeq
    };
    Common.ajax("GET", "/eAccounting/pettyCash/selectExpenseInfo.do", obj, function(result) {
        console.log(result);
        $("#newCostCenter").val(result.costCentr);
        $("#newCostCenterText").val(result.costCentrName);
        $("#newMemAccId").val(result.memAccId);
        $("#newMemAccName").val(result.memAccName);
        $("#custdnNric").val(result.custdnNric);
        $("#bankCode").val(result.bankCode);
        $("#bankName").val(result.bankName);
        $("#bankAccNo").val(result.bankAccNo);
        $("#newClmMonth").val(result.clmMonth);
        $("#expType").val(result.expType);
        $("#expTypeName").val(result.expTypeName);
        $("#glAccCode").val(result.glAccCode);
        $("#glAccCodeName").val(result.glAccCodeName);
        $("#budgetCode").val(result.budgetCode);
        $("#budgetCodeName").val(result.budgetCodeName);
        $("#sMemAccId").val(result.sMemAccId);
        $("#sMemAccName").val(result.sMemAccName);
        $("#invcType").val(result.invcType);
        $("#invcNo").val(result.invcNo);
        $("#invcDt").val(result.invcDt);
        $("#gstRgistNo").val(result.gstRgistNo);
        $("#taxCode").val(result.taxCode);
        var gstBeforAmt = "" + result.gstBeforAmt;
        $("#gstBeforAmt").val(gstBeforAmt.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,'));
        var gstAmt = "" + result.gstAmt;
        $("#gstAmt").val(gstAmt.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,'));
        var totAmt = "" + result.totAmt;
        $("#totAmt").val(totAmt.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,'));
        $("#expDesc").val(result.expDesc);
        
        // TODO attachFile
        attachList = result.attachList;
        console.log(attachList);
        console.log(attachList.length);
        if(attachList.length > 0) {
        	$("#attachTd").html("");
        	for(var i = 0; i < attachList.length; i++) {
        		if(result.appvPrcssNo == null || result.appvPrcssNo == "") {
        			$("#attachTd").append("<div class='auto_file2 auto_file3'><input type='file' title='file add' /><label><input type='text' class='input_text' readonly='readonly' value='" + attachList[i].atchFileName + "'/><span class='label_text'><a href='#'>File</a></span></label><span class='label_text'><a href='#'>Add</a></span><span class='label_text'><a href='#'>Delete</a></span></div>");
        		} else {
        			$("#attachTd").append("<div class='auto_file2 auto_file3'><input type='text' class='input_text' readonly='readonly' value='" + attachList[i].atchFileName + "'/></div>");
        		}
            }
        	
        	// 파일 다운
            $(".input_text").dblclick(function() {
                var oriFileName = $(this).val();
                var fileGrpId;
                var fileId;
                for(var i = 0; i < attachList.length; i++) {
                    if(attachList[i].atchFileName == oriFileName) {
                        fileGrpId = attachList[i].atchFileGrpId;
                        fileId = attachList[i].atchFileId;
                    }
                }
                fn_atchViewDown(fileGrpId, fileId);
            });
            // 파일 수정
            $("#form_newExpense :file").change(function() {
                var div = $(this).parents(".auto_file2");
                var oriFileName = div.find(":text").val();
                console.log(oriFileName);
                for(var i = 0; i < attachList.length; i++) {
                    if(attachList[i].atchFileName == oriFileName) {
                        update.push(attachList[i].atchFileId);
                        console.log(JSON.stringify(update));
                    }
                }
            });
            // 파일 삭제
            $(".auto_file2 a:contains('Delete')").click(function() {
            	var div = $(this).parents(".auto_file2");
                var oriFileName = div.find(":text").val();
                console.log(oriFileName);   
                for(var i = 0; i < attachList.length; i++) {
                    if(attachList[i].atchFileName == oriFileName) {
                        remove.push(attachList[i].atchFileId);
                        console.log(JSON.stringify(remove));
                    }
                }
            });
        }
    });
}

function fn_atchViewDown(fileGrpId, fileId) {
    var data = {
            atchFileGrpId : fileGrpId,
            atchFileId : fileId
    };
    Common.ajax("GET", "/eAccounting/webInvoice/getAttachmentInfo.do", data, function(result) {
        console.log(result);
        if(result.fileExtsn == "jpg" || event.item.fileExtsn == "png") {
            // TODO View
            var fileSubPath = result.fileSubPath;
            fileSubPath = fileSubPath.replace('\', '/'');
            console.log(DEFAULT_RESOURCE_FILE + fileSubPath + '/' + result.physiclFileName);
            window.open(DEFAULT_RESOURCE_FILE + fileSubPath + '/' + result.physiclFileName);
        } else {
            var fileSubPath = result.fileSubPath;
            fileSubPath = fileSubPath.replace('\', '/'');
            console.log("/file/fileDown.do?subPath=" + fileSubPath
                    + "&fileName=" + result.physiclFileName + "&orignlFileNm=" + result.atchFileName);
            window.open("/file/fileDown.do?subPath=" + fileSubPath
                + "&fileName=" + result.physiclFileName + "&orignlFileNm=" + result.atchFileName);
        }
    });
}

function fn_viewExpensePop(clmNo) {
    var data = {
            clmNo : clmNo,
            callType : "view"
    };
    Common.popupDiv("/eAccounting/pettyCash/viewExpensePop.do", data, null, true, "viewExpensePop");
}

function fn_updatePettyCashExp(st) {
    // row의 수가 0개 이상일때만 insert
    var gridDataList = AUIGrid.getOrgGridData(newGridID);
    if(gridDataList.length > 0){
    	var gridDataObj = GridCommon.getEditData(newGridID);
    	gridDataObj.clmNo = clmNo;
        gridDataObj.allTotAmt = Number($("#allTotAmt_text").text().replace(/,/gi, ""));
        console.log(gridDataObj);
        Common.ajax("POST", "/eAccounting/pettyCash/updatePettyCashExp.do", gridDataObj, function(result) {
            console.log(result);
            clmNo = result.data.clmNo;
            fn_selectExpenseItemList();
            if(st == "view"){
                Common.alert('<spring:message code="newWebInvoice.tempSave.msg" />');
                $("#viewExpensePop").remove();
            }
            fn_selectExpenseList();
        });
    } else {
        Common.alert('<spring:message code="pettyCashExp.noData.msg" />');
    }
}

function fn_expApproveLinePop() {
    // tempSave를 하지 않고 바로 submit인 경우
    if(FormUtil.isEmpty(clmNo)) {
        fn_insertPettyCashExp("");
    } else {
        // 바로 submit 후에 appvLinePop을 닫고 재수정 대비
    	fn_updatePettyCashExp("");
    }
    
    Common.popupDiv("/eAccounting/pettyCash/expApproveLinePop.do", null, null, true, "approveLineSearchPop");
}
</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on"><spring:message code="webInvoice.fav" /></a></p>
<h2><spring:message code="pettyCashExp.title" /></h2>
<ul class="right_btns">
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_selectExpenseList()"><span class="search"></span><spring:message code="webInvoice.btn.search" /></a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="form_pettyCashExp">
<input type="hidden" id="memAccId" name="memAccId">
<input type="hidden" id="costCenter" name="costCentr">

<table class="type1"><!-- table start -->
<caption><spring:message code="webInvoice.table" /></caption>
<colgroup>
    <col style="width:110px" />
    <col style="width:*" />
    <col style="width:110px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="webInvoice.costCenter" /></th>
    <td><input type="text" title="" placeholder="" class="" id="costCenterText" name="costCentrName"/><a href="#" class="search_btn" id="search_costCenter_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
    <th scope="row"><spring:message code="pettyCashCustdn.custdn" /></th>
    <td><input type="text" title="" placeholder="" class="" id="memAccName" name="memAccName"/><a href="#" class="search_btn" id="search_supplier_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
</tr>
<tr>
    <th scope="row"><spring:message code="pettyCashExp.clmMonth" /></th>
    <td><input type="text" title="Reference Month" placeholder="MM/YYYY" class="j_date2 w100p" id="clmMonth" name="clmMonth"/></td>
    <th scope="row"><spring:message code="webInvoice.status" /></th>
    <td>
    <select class="multy_select" multiple="multiple" id="appvPrcssStus" name="appvPrcssStus">
        <option value="T"><spring:message code="webInvoice.select.save" /></option>
        <option value="R"><spring:message code="webInvoice.select.request" /></option>
        <option value="P"><spring:message code="webInvoice.select.progress" /></option>
        <option value="A"><spring:message code="webInvoice.select.approved" /></option>
        <option value="J"><spring:message code="webInvoice.select.reject" /></option>
    </select>
    </td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">
    <li><p class="btn_grid"><a href="#" id="registration_btn"><spring:message code="pettyCashExp.newExpClm" /></a></p></li>
</ul>

<article class="grid_wrap" id="expenseMgmt_grid_wrap"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->