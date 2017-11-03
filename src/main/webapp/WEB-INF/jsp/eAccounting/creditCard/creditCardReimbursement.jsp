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
var clickType = "";
var clmNo = "";
var reimbursementColumnLayout = [ {
    dataField : "crditCardUserId",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "crditCardUserName",
    headerText : 'Card Holder',
    style : "aui-grid-user-custom-left"
}, {
    dataField : "crditCardNo",
    headerText : 'Card no.'
}, {
    dataField : "chrgUserId",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "chrgUserName",
    headerText : 'Charge Name',
    style : "aui-grid-user-custom-left"
}, {
    dataField : "costCentr",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "costCentrName",
    headerText : 'Cost Center',
    style : "aui-grid-user-custom-left"
}, {
    dataField : "clmMonth",
    headerText : 'Claim Month',
    dataType : "date",
    formatString : "mm/yyyy"
}, {
    dataField : "clmNo",
    headerText : 'Claim No'
}, {
    dataField : "reqstDt",
    headerText : 'Request Date',
    dataType : "date",
    formatString : "dd/mm/yyyy"
}, {
    dataField : "cur",
    headerText : '<spring:message code="newWebInvoice.cur" />'
}, {
    dataField : "allTotAmt",
    headerText : '<spring:message code="webInvoice.amount" />',
    style : "aui-grid-user-custom-right",
    dataType: "numeric",
    formatString : "#,##0.00"
},{
    dataField : "appvPrcssStusCode",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "appvPrcssStus",
    headerText : '<spring:message code="webInvoice.status" />',
    style : "aui-grid-user-custom-left"
}, {
    dataField : "appvPrcssDt",
    headerText : 'Approval Date',
    dataType : "date",
    formatString : "dd/mm/yyyy"
} 
];

//그리드 속성 설정
var reimbursementGridPros = {
    // 페이징 사용       
    usePaging : true,
    // 한 화면에 출력되는 행 개수 20(기본값:20)
    pageRowCount : 20
};

var reimbursementGridID;

$(document).ready(function () {
	reimbursementGridID = AUIGrid.create("#reimbursement_grid_wrap", reimbursementColumnLayout, reimbursementGridPros);
    
    $("#search_holder_btn").click(function() {
        clickType = "holder";
        fn_searchUserIdPop();
    });
    $("#search_charge_btn").click(function() {
        clickType = "charge";
        fn_searchUserIdPop();
    });
    $("#search_depart_btn").click(fn_costCenterSearchPop);
    $("#registration_btn").click(fn_newReimbursementPop);
    
    AUIGrid.bind(reimbursementGridID, "cellDoubleClick", function( event ) 
            {
                console.log("cellDoubleClick rowIndex : " + event.rowIndex + ", cellDoubleClick : " + event.columnIndex + " cellDoubleClick");
                console.log("cellDoubleClick clmNo : " + event.item.clmNo);
                clmNo = event.item.clmNo;
                fn_viewReimbursementPop();
            });
    
    $("#appvPrcssStus").multipleSelect("checkAll");
    
    fn_setToDay();
});

function fn_setToDay() {
    var today = new Date();
    
    var dd = today.getDate();
    var mm = today.getMonth() + 1;
    var yyyy = today.getFullYear();
    
    if(dd < 10) {
        dd = "0" + dd;
    }
    if(mm < 10){
        mm = "0" + mm
    }
    
    today = dd + "/" + mm + "/" + yyyy;
    $("#startDt").val(today)
    $("#endDt").val(today)
}

function fn_searchUserIdPop() {
    Common.popupDiv("/common/memberPop.do", null, null, true);
}

// 그리드에 set 하는 function
function fn_loadOrderSalesman(memId, memCode) {

    Common.ajax("GET", "/sales/order/selectMemberByMemberIDCode.do", {memId : memId, memCode : memCode}, function(memInfo) {

        if(memInfo == null) {
            Common.alert('<b>Member not found.</br>Your input member code : '+memCode+'</b>');
        }
        else {
            console.log(memInfo);
            console.log(memInfo.memCode);
            console.log(memInfo.name);
            console.log(clickType);
            if(clickType == "holder") {
                $("#crditCardUserId").val(memInfo.memCode);
                $("#crditCardUserName").val(memInfo.name);
            } else if(clickType == "charge") {
                $("#chrgUserId").val(memInfo.memCode);
                $("#chrgUserName").val(memInfo.name);
            }
        }
    });
}

function fn_costCenterSearchPop() {
    Common.popupDiv("/eAccounting/webInvoice/costCenterSearchPop.do", null, null, true, "costCenterSearchPop");
}

function fn_setCostCenter() {
    $("#costCenter").val($("#search_costCentr").val());
    $("#costCenterText").val($("#search_costCentrName").val());
}

function fn_selectReimbursementList() {
    Common.ajax("GET", "/eAccounting/creditCard/selectReimbursementList.do", $("#form_reimbursement").serialize(), function(result) {
        console.log(result);
        AUIGrid.setGridData(reimbursementGridID, result);
    });
}

function fn_newReimbursementPop() {
    Common.popupDiv("/eAccounting/creditCard/newReimbursementPop.do", {callType:"new"}, null, true, "newReimbursementPop");
}

function fn_clearData() {
    $("#form_newReimbursement").each(function() {
        this.reset();
    });
    
    $("#newCrditCardNo").val("");
    
    fn_ActionInvcTypeS();
    
    $("#attachTd").html("");
    $("#attachTd").append("<div class='auto_file2 auto_file3'><input type='file' title='file add' /><label><input type='text' class='input_text' readonly='readonly' /><span class='label_text'><a href='#'>File</a></span></label><span class='label_text'><a href='#'>Add</a></span><span class='label_text'><a href='#' id='remove_btn' onclick='javascript:fn_getRemoveFileList()'>Delete</a></span></div>");
    
    clmSeq = 0;
}

function fn_popCostCenterSearchPop() {
    Common.popupDiv("/eAccounting/webInvoice/costCenterSearchPop.do", {pop:"pop"}, null, true, "costCenterSearchPop");
}

function fn_setPopCostCenter() {
    $("#newCostCenter").val($("#search_costCentr").val());
    $("#newCostCenterText").val($("#search_costCentrName").val());
}

function fn_PopExpenseTypeSearchPop() {
    Common.popupDiv("/eAccounting/expense/expenseTypeSearchPop.do", {popClaimType:'J2'}, null, true, "expenseTypeSearchPop");
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

function fn_ActionInvcTypeS() {
    var invcType = $("#invcType").val();
    console.log(invcType);
    if(invcType == "S") {
        $("#newSupplyName").removeAttr("class");
        $("#supply_search_btn").show();
        $("#gstRgistNo").attr("class", "readonly w100p");
        $("#gstRgistNo").attr("readonly", "readonly");
    } else {
        $("#newSupplyName").attr("class", "w100p");
        $("#supply_search_btn").hide();
        $("#gstRgistNo").attr("class", "w100p");
        $("#gstRgistNo").removeAttr("readonly");
    }
}

function fn_supplierSearchPop() {
    Common.popupDiv("/eAccounting/webInvoice/supplierSearchPop.do", null, null, true, "supplierSearchPop");
}

function fn_setSupplier() {
    $("#newSupply").val($("#search_memAccId").val());
    $("#newSupplyName").val($("#search_memAccName").val());
    $("#gstRgistNo").val($("#search_gstRgistNo").val());
}

function fn_setEvent() {
	$("#maskingNo").change(function() {
        var crditCardNo = $("#maskingNo").val();
        if(crditCardNo.length == 16) {
            $("#newCrditCardNo").val(crditCardNo);
            var crditCardNo1 = crditCardNo.substr(0, 4);
            var crditCardNo4 = crditCardNo.substr(12);
            crditCardNo = crditCardNo1 + "********" + crditCardNo4;
            console.log(crditCardNo);
            $("#maskingNo").val(crditCardNo);
            Common.ajax("GET", "/eAccounting/creditCard/selectCrditCardInfoByNo.do", {crditCardNo:$("#newCrditCardNo").val()}, function(result) {
                console.log(result);
                if(result.data) {
                	$("#newCrditCardUserId").val(result.data.crditCardUserId);
                    $("#newCrditCardUserName").val(result.data.crditCardUserName);
                    $("#newChrgUserId").val(result.data.chrgUserId);
                    $("#newChrgUserName").val(result.data.chrgUserName);
                    $("#newCostCenter").val(result.data.costCentr);
                    $("#newCostCenterText").val(result.data.costCentrName);
                    $("#sCostCenterText").val(result.data.costCentrName);
                    $("#bankCode").val(result.data.bankCode);
                    $("#bankName").val(result.data.bankName);
                } else {
                	Common.alert("There is no registered data for the card number you entered.");
                	$("#maskingNo").val("");
                    $("#newCrditCardNo").val("");
                    $("#newCrditCardUserId").val("");
                    $("#newCrditCardUserName").val("");
                    $("#newChrgUserId").val("");
                    $("#newChrgUserName").val("");
                    $("#newCostCenter").val("");
                    $("#newCostCenterText").val("");
                    $("#sCostCenterText").val("");
                    $("#bankCode").val("");
                    $("#bankName").val("");
                }
            });
        } else {
        	if(crditCardNo.length == 0) {
        		$("#maskingNo").val("");
                $("#newCrditCardNo").val("");
        	} else {
        		Common.alert("The card number is 16 digits.");
                $("#maskingNo").val("");
                $("#newCrditCardNo").val("");
        	}
        }
    });
	
	$("#maskingNo").click(function() {
		console.log($("#newCrditCardNo").val());
		var crditCardNo = $("#newCrditCardNo").val();
		$("#maskingNo").val(crditCardNo);
	});
	
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
   
    $("#form_newReimbursement :text").change(function(){
        var id = $(this).attr("id");
        console.log(id);
        if(id == "netAmt" || id == "taxAmt") {
            var str =""+ Math.floor($(this).val() * 100)/100;
               
               var str2 = str.split(".");
              
               if(str2.length == 1){
                   str2[1] = "00";
               }
               
               if(str2[0].length > 11){
                   Common.alert("The amount can only be 13 digits, including 2 decimal point.");
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
        } else if(id == "clmMonth") {
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
                Common.alert("Only past dates can be selected.");
                $(this).val(mm + "/" + yyyy);
            }
        }
   }); 
}

function fn_checkEmpty() {
    var checkResult = true;
    if(FormUtil.isEmpty($("#newCrditCardNo").val())) {
        Common.alert("Please enter the Credit Card No.");
        checkResult = false;
        return checkResult;
    }
    if(FormUtil.isEmpty($("#clmMonth").val())) {
        Common.alert("Please enter the Claim Month.");
        checkResult = false;
        return checkResult;
    }
    if(FormUtil.isEmpty($("#invcDt").val())) {
        Common.alert("Please enter the Invoice Date.");
        checkResult = false;
        return checkResult;
    }
    if($("#invcType").val() == "F") {
        if(FormUtil.isEmpty($("#newSupply").val())) {
            Common.alert("Please enter the Supplier Name.");
            checkResult = false;
            return checkResult;
        }
        if(FormUtil.isEmpty($("#gstRgistNo").val())) {
            Common.alert("Please enter the GST Registration No.");
            checkResult = false;
            return checkResult;
        }
        if(FormUtil.isEmpty($("#invcNo").val())) {
            Common.alert("Please enter the invoice no.");
            checkResult = false;
            return checkResult;
        }
        if(FormUtil.isEmpty($("#expType").val())) {
            Common.alert("Please enter the Expense Type");
            checkResult = false;
            return checkResult;
        }
        if(FormUtil.isEmpty($("#taxCode").val())) {
            Common.alert("Please enter the Tax Code");
            checkResult = false;
            return checkResult;
        }
        if(Number($("#netAmt").val().replace(/,/gi, "")) <= 0) {
            Common.alert("Please enter the Approved cash amount");
            checkResult = false;
            return checkResult;
        }
    }
    return checkResult;
}

function fn_addRow() {
    // 파일 업로드 전에 필수 값 체크
    // 파일 업로드 후 그룹 아이디 값을 받아서 Add
    if(fn_checkEmpty()) {
        var formData = Common.getFormData("form_newReimbursement");
        if(clmSeq == 0) {
            var data = {
                    bankCode : $("#bankCode").val()
                    ,bankName : $("#bankName").val()
            		,crditCardUserId : $("#newCrditCardUserId").val()
                    ,crditCardUserName : $("#newCrditCardUserName").val()
                    ,crditCardNo : $("#newCrditCardNo").val()
                    ,chrgUserId : $("#newChrgUserId").val()
                    ,chrgUserName : $("#newChrgUserName").val()
                    ,costCentr : $("#newCostCenter").val()
                    ,clmMonth : $("#clmMonth").val()
                    ,invcDt : $("#invcDt").val()
                    ,costCentrName : $("#newCostCenterText").val()
                    ,expType : $("#expType").val()
                    ,expTypeName : $("#expTypeName").val()
                    ,glAccCode : $("#glAccCode").val()
                    ,glAccCodeName : $("#glAccCodeName").val()
                    ,budgetCode : $("#budgetCode").val()
                    ,budgetCodeName : $("#budgetCodeName").val()
                    ,supply : $("#newSupply").val()
                    ,supplyName : $("#newSupplyName").val()
                    ,taxCode : $("#taxCode").val()
                    ,taxName : $("#taxCode option:selected").text()
                    ,gstRgistNo : $("#gstRgistNo").val()
                    ,invcNo : $("#invcNo").val()
                    ,invcType : $("#invcType").val()
                    ,invcTypeName : $("#invcType option:selected").text()
                    ,cur : "MYR"
                    ,netAmt : Number($("#netAmt").val().replace(/,/gi, ""))
                    ,taxAmt : Number($("#taxAmt").val().replace(/,/gi, ""))
                    ,expDesc : $("#expDesc").val()
            };
            
            Common.ajaxFile("/eAccounting/creditCard/attachFileUpload.do", formData, function(result) {
                console.log(result);
                
                data.atchFileGrpId = result.data.fileGroupKey
                console.log(data);
                AUIGrid.addRow(newGridID, data, "last");
                
                fn_getAllTotAmt();
            });
        } else {
            var data = {
            		bankCode : $("#bankCode").val()
                    ,bankName : $("#bankName").val()
                    ,crditCardUserId : $("#newCrditCardUserId").val()
                    ,crditCardUserName : $("#newCrditCardUserName").val()
                    ,crditCardNo : $("#newCrditCardNo").val()
                    ,chrgUserId : $("#newChrgUserId").val()
                    ,chrgUserName : $("#newChrgUserName").val()
                    ,costCentr : $("#newCostCenter").val()
                    ,clmMonth : $("#clmMonth").val()
                    ,invcDt : $("#invcDt").val()
                    ,costCentrName : $("#newCostCenterText").val()
                    ,expType : $("#expType").val()
                    ,expTypeName : $("#expTypeName").val()
                    ,glAccCode : $("#glAccCode").val()
                    ,glAccCodeName : $("#glAccCodeName").val()
                    ,budgetCode : $("#budgetCode").val()
                    ,budgetCodeName : $("#budgetCodeName").val()
                    ,supply : $("#newSupply").val()
                    ,supplyName : $("#newSupplyName").val()
                    ,taxCode : $("#taxCode").val()
                    ,taxName : $("#taxCode option:selected").text()
                    ,gstRgistNo : $("#gstRgistNo").val()
                    ,invcNo : $("#invcNo").val()
                    ,invcType : $("#invcType").val()
                    ,invcTypeName : $("#invcType option:selected").text()
                    ,cur : "MYR"
                    ,netAmt : Number($("#netAmt").val().replace(/,/gi, ""))
                    ,taxAmt : Number($("#taxAmt").val().replace(/,/gi, ""))
                    ,expDesc : $("#expDesc").val()
            };
            
            $("#attachTd").html("");
            $("#attachTd").append("<div class='auto_file2 auto_file3'><input type='file' title='file add' /><label><input type='text' class='input_text' readonly='readonly' /><span class='label_text'><a href='#'>File</a></span></label><span class='label_text'><a href='#'>Add</a></span><span class='label_text'><a href='#' id='remove_btn' onclick='javascript:fn_getRemoveFileList()'>Delete</a></span></div>");
            
            formData.append("atchFileGrpId", atchFileGrpId);
            formData.append("update", JSON.stringify(update).replace(/[\[\]\"]/gi, ''));
            console.log(JSON.stringify(update).replace(/[\[\]\"]/gi, ''));
            formData.append("remove", JSON.stringify(remove).replace(/[\[\]\"]/gi, ''));
            console.log(JSON.stringify(remove).replace(/[\[\]\"]/gi, ''));
            Common.ajaxFile("/eAccounting/creditCard/attachFileUpdate.do", formData, function(result) {
                console.log(result);
                
                console.log(data);
                AUIGrid.updateRow(newGridID, data, selectRowIdx);
                
                fn_getAllTotAmt();
                
                clmSeq = 0;
            });
        }
        
        fn_clearData();
        fn_ActionInvcTypeS();
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

function fn_insertReimbursement(st) {
    // row의 수가 0개 이상일때만 insert
    var gridDataList = AUIGrid.getOrgGridData(newGridID);
    if(gridDataList.length > 0){
        var data = {
                gridDataList : gridDataList
                ,allTotAmt : Number($("#allTotAmt_text").text().replace(/,/gi, ""))
        }
        console.log(data);
        Common.ajax("POST", "/eAccounting/creditCard/insertReimbursement.do", data, function(result) {
            console.log(result);
            clmNo = result.data.clmNo;
            fn_selectReimbursementItemList();
            if(st == "new"){
                Common.alert("Temporary save succeeded.");
                $("#newReimbursementPop").remove();
            }
            fn_selectReimbursementList();
        });
    } else {
        Common.alert("There is no data to save. Please add.");
    }
}

function fn_selectReimbursementItemList() {
    var obj = {
            clmNo : clmNo
    };
    Common.ajax("GET", "/eAccounting/creditCard/selectReimbursementItemList.do", obj, function(result) {
        console.log(result);
        AUIGrid.setGridData(newGridID, result);
    });
}

function fn_viewReimbursementPop() {
    var data = {
            clmNo : clmNo,
            callType : "view"
    };
    Common.popupDiv("/eAccounting/creditCard/viewReimbursementPop.do", data, null, true, "viewExpensePop");
}

function fn_selectReimbursementInfo() {
    var obj = {
            clmNo : clmNo
            ,clmSeq : clmSeq
    };
    Common.ajax("GET", "/eAccounting/creditCard/selectReimburesementInfo.do", obj, function(result) {
        console.log(result);
        var crditCardNo = result.crditCardNo;
        $("#newCrditCardNo").val(crditCardNo);
        var crditCardNo1 = crditCardNo.substr(0, 4);
        var crditCardNo4 = crditCardNo.substr(12);
        crditCardNo = crditCardNo1 + "********" + crditCardNo4;
        console.log(crditCardNo);
        $("#maskingNo").val(crditCardNo);
        $("#newCrditCardUserId").val(result.crditCardUserId);
        $("#newCrditCardUserName").val(result.crditCardUserName);
        $("#newChrgUserId").val(result.chrgUserId);
        $("#newChrgUserName").val(result.chrgUserName);
        $("#newCostCenter").val(result.costCentr);
        $("#newCostCenterText").val(result.costCentrName);
        $("#bankCode").val(result.bankCode);
        $("#bankName").val(result.bankName);
        $("#clmMonth").val(result.clmMonth);
        var allTotAmt = "" + result.allTotAmt;
        $("#allTotAmt_text").val(allTotAmt.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,'));
        $("#invcType").val(result.invcType);
        fn_ActionInvcTypeS();
        $("#invcNo").val(result.invcNo);
        $("#invcDt").val(result.invcDt);
        $("#supply").val(result.supply);
        $("#supplyName").val(result.supplyName);
        $("#expType").val(result.expType);
        $("#expTypeName").val(result.expTypeName);
        $("#glAccCode").val(result.glAccCode);
        $("#glAccCodeName").val(result.glAccCodeName);
        $("#budgetCode").val(result.budgetCode);
        $("#budgetCodeName").val(result.budgetCodeName);
        //$("#gstRgistNo").val(result.gstRgistNo);
        $("#taxCode").val(result.taxCode);
        var netAmt = "" + result.netAmt;
        $("#netAmt").val(netAmt.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,'));
        var taxAmt = "" + result.taxAmt;
        $("#taxAmt").val(taxAmt.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,'));
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
            $("#form_newReimbursement :file").change(function() {
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
        if(result.fileExtsn == "jpg") {
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
</script>

<section id="content"><!-- content start -->
<ul class="path">
	<li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
	<li>Sales</li>
	<li>Order list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Credit Card Reimbursement</h2>
<ul class="right_btns">
	<li><p class="btn_blue"><a href="#" onclick="javascript:fn_selectReimbursementList()"><span class="search"></span>Search</a></p></li>
	<!-- <li><p class="btn_blue"><a href="#"><span class="clear"></span>Clear</a></p></li> -->
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="form_reimbursement">
<input type="hidden" id="crditCardUserId" name="crditCardUserId">
<input type="hidden" id="chrgUserId" name="chrgUserId">
<input type="hidden" id="costCenter" name="costCentr">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:170px" />
	<col style="width:*" />
	<col style="width:210px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Credit cardholder name</th>
	<td><input type="text" title="" placeholder="" class="" id="crditCardUserName" name="crditCardUserName"/><a href="#" class="search_btn" id="search_holder_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
	<th scope="row">Credit card no.</th>
	<td><input type="text" title="" placeholder="Credit card No" class="" id="crditCardNo" name="crditCardNo" autocomplete=off/></td>
</tr>
<tr>
	<th scope="row">Person-in-charge name</th>
	<td><input type="text" title="" placeholder="" class="" id="chrgUserName" name="chrgUserName"/><a href="#" class="search_btn" id="search_charge_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
	<th scope="row">Person-in-charge department</th>
	<td><input type="text" title="" placeholder="" class="" id="costCenterText" name="costCentrName"/><a href="#" class="search_btn" id="search_depart_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
</tr>
	<th scope="row">Request Date</th>
	<td>

	<div class="date_set"><!-- date_set start -->
	<p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date"  id="startDt" name="startDt"/></p>
	<span>To</span>
	<p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="endDt" name="endDt"/></p>
	</div><!-- date_set end -->

	</td>
	<th scope="row">Status</th>
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
	<li><p class="btn_grid"><a href="#" id="registration_btn">New Expense Claim</a></p></li>
</ul>

<article class="grid_wrap" id="reimbursement_grid_wrap"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->