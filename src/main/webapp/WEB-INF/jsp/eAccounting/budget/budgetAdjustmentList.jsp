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
.aui-grid-pointer {
    cursor:pointer;
}
/* 커스텀 행 스타일 */
.my-row-style {
    background:#9FC93C;
    font-weight:bold;
    color:#22741C;
}
</style>
<script  type="text/javascript">
var adjMGridID;
var rowIndex = 0;

$(document).ready(function(){

    CommonCombo.make("budgetAdjType", "/common/selectCodeList.do", {groupCode:'347', orderValue:'CODE'}, "", {
        id: "code",
        name: "codeName",
        type:"M"
    });

    $("#stYearMonth").val("${stYearMonth}");
    $("#edYearMonth").val("${edYearMonth}");

    $("#btnSearch").click(fn_selectListAjax);


    var adjLayout = [ {
        dataField : "checkId",
        headerText : '<input type="checkbox" id="allCheckbox" style="width:15px;height:15px;">',
        cellMerge : true ,
        mergeRef : "budgetDocNo", // 이전 칼럼(대분류) 셀머지의 값을 비교해서 실행함. (mergePolicy : "restrict" 설정 필수)
        mergePolicy : "restrict",
        width : 50,
        renderer : {
        	type : "CheckBoxEditRenderer",
            showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
            editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
            checkValue : "Y", // true, false 인 경우가 기본
            unCheckValue : "N",
            disabledFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField) {
                if(item.status == "Close" || item.status == "Open")
                    return true; // true 반환하면 disabled 시킴
                return false;
            }
      }
    },{
        dataField : "status",
        headerText : '<spring:message code="budget.Status" />',
        cellMerge : true ,
        mergeRef : "budgetDocNo", // 이전 칼럼(대분류) 셀머지의 값을 비교해서 실행함. (mergePolicy : "restrict" 설정 필수)
        mergePolicy : "restrict",
        width : 70
    },{
        dataField : "budgetDocNo",
        headerText : '<spring:message code="budget.BudgetDoc" />',
        cellMerge : true ,
        style :"aui-grid-pointer",
        width : 95
    },{
        dataField : "costCenterText",
        headerText : '<spring:message code="budget.CostCenter" />',
        cellMerge : true ,
        mergeRef : "budgetDocNo", // 이전 칼럼(대분류) 셀머지의 값을 비교해서 실행함. (mergePolicy : "restrict" 설정 필수)
        mergePolicy : "restrict",
        width : 130
    },{
        dataField : "adjYearMonth",
        headerText : '<spring:message code="budget.Month" />/<spring:message code="budget.Year" />',
        cellMerge : true ,
        mergeRef : "budgetDocNo", // 이전 칼럼(대분류) 셀머지의 값을 비교해서 실행함. (mergePolicy : "restrict" 설정 필수)
        mergePolicy : "restrict",
        width : 100
    },{
        dataField : "budgetCode",
        headerText : '<spring:message code="expense.Activity" />',
        cellMerge : true ,
        mergeRef : "budgetDocNo", // 이전 칼럼(대분류) 셀머지의 값을 비교해서 실행함. (mergePolicy : "restrict" 설정 필수)
        mergePolicy : "restrict",
        width : 100,
        visible : false
    },{
        dataField : "budgetCodeText",
        headerText : '<spring:message code="expense.ActivityName" />',
        cellMerge : true ,
        mergeRef : "budgetDocNo", // 이전 칼럼(대분류) 셀머지의 값을 비교해서 실행함. (mergePolicy : "restrict" 설정 필수)
        mergePolicy : "restrict",
        width : 220
    }, {
        dataField : "glAccCode",
        headerText : '<spring:message code="expense.GLAccount" />',
        cellMerge : true ,
        mergeRef : "budgetDocNo", // 이전 칼럼(대분류) 셀머지의 값을 비교해서 실행함. (mergePolicy : "restrict" 설정 필수)
        mergePolicy : "restrict",
        width : 100,
        visible : false
    },{
        dataField : "glAccDesc",
        headerText : '<spring:message code="expense.GLAccountName" />',
        cellMerge : true ,
        mergeRef : "budgetDocNo", // 이전 칼럼(대분류) 셀머지의 값을 비교해서 실행함. (mergePolicy : "restrict" 설정 필수)
        mergePolicy : "restrict",
        width : 220
    },{
        dataField : "budgetAdjType",
        headerText : '<spring:message code="budget.AdjustmentType" />',
        visible : false,
        cellMerge : true ,
        width : 150
    },{
        dataField : "budgetAdjTypeName",
        headerText : '<spring:message code="budget.AdjustmentType" />',
        width : 150
    },{
        dataField : "signal",
        headerText : '<spring:message code="budget.Amount" />',
        width : 25,
        colSpan : 2
    },{
        dataField : "adjAmt",
        //headerText : '<spring:message code="budget.Amount" />',
        dataType : "numeric",
        formatString : "#,##0.00",
        style : "my-right-style",
        width : 100,
        colSpan : -1
    },{
        dataField : "adjRem",
        headerText : '<spring:message code="budget.Remark" />',
        style : "aui-grid-user-custom-left ",
        cellMerge : true ,
        mergeRef : "budgetDocNo", // 이전 칼럼(대분류) 셀머지의 값을 비교해서 실행함. (mergePolicy : "restrict" 설정 필수)
        mergePolicy : "restrict",
        width : 150,
        visible : false
    },{
        dataField : "reqstName",
        headerText : "Requester",
        cellMerge : true,
        mergeRef : "budgetDocNo",
        mergePolicy : "restrict",
        width : 80
    },{
        dataField : "appvPrcssStus",
        headerText : "Approval Status",
        cellMerge : true,
        mergeRef : "budgetDocNo",
        mergePolicy : "restrict",
        width : 100
    },{
        dataField : "fileSubPath",
        headerText : '<spring:message code="budget.View" />',
        cellMerge : true ,
        mergeRef : "budgetDocNo", // 이전 칼럼(대분류) 셀머지의 값을 비교해서 실행함. (mergePolicy : "restrict" 설정 필수)
        mergePolicy : "restrict",
        style :"aui-grid-pointer",
        width : 150,
        visible : false
    },{
        dataField : "filePath",
        headerText : '',
        cellMerge : true ,
        mergeRef : "budgetDocNo", // 이전 칼럼(대분류) 셀머지의 값을 비교해서 실행함. (mergePolicy : "restrict" 설정 필수)
        mergePolicy : "restrict",
        visible :false
    },{
        dataField : "atchFileGrpId",
        headerText : '',
        cellMerge : true ,
        mergeRef : "budgetDocNo", // 이전 칼럼(대분류) 셀머지의 값을 비교해서 실행함. (mergePolicy : "restrict" 설정 필수)
        mergePolicy : "restrict",
        visible :false
    },{
        dataField : "availableAmt",
        headerText : '',
        dataType : "numeric",
        formatString : "#,##0.00",
        style : "my-right-style",
        width : 100,
        visible :false
    },{
        dataField : "seq",
        headerText : '',
        visible : false
    },{
        dataField : "overBudgetFlag",
        headerText : '',
        visible : false,
    }];

    var adjOptions = {
            enableCellMerge : true,
            showStateColumn:false,
//            selectionMode       : "singleRow",
            selectionMode       : "singleCell",
            showRowNumColumn    : false,
            usePaging : false,
            editable :false
      };


    var uploadGridLayout = [
                            {dataField : "0", headerText : "Number of Adjustment", editable : true ,width : 120 },
                            {dataField : "1", headerText : "Cost Centre", editable : true, width : 120},
                            {dataField : "2", headerText : "Month/Year", editable : true, width : 120},
                            {dataField : "3", headerText : "Budget Code", editable : true, width : 120},
                            {dataField : "4", headerText : "GL Account", editable : true, width : 180},
                            {dataField : "5", headerText : "Adjustment Type", editable : true, width : 180},
                            {dataField : "6", headerText : "Signal", editable : true, width : 180},
                            {dataField : "7", headerText : "Adjustment Amount", editable : true, width : 180},
                            {dataField : "8", headerText : "Remark", editable : true, width : 180},
                            {dataField : "9", headerText : "Group of Seq", editable : true, width : 180},
                            {
                                dataField : "overBudgetFlag",
                                headerText : '',
                                visible : false,
                            },{
                                dataField : "atchFileGrpId",
                                headerText : '',
                                visible : false,
                            }
                            ];

    var gridPros2 = {

            // 편집 가능 여부 (기본값 : false)
      //editable : false,
      // 상태 칼럼 사용
      showStateColumn : false,
      // 기본 헤더 높이 지정
      headerHeight : 35,

      softRemoveRowMode:false

    }

    myUploadGridID = GridCommon.createAUIGrid("grid_upload_wrap", uploadGridLayout,null,gridPros2);

    $('#fileSelector').on('change', function(evt) {
        if (!checkHTML5Brower()) {
            // 브라우저가 FileReader 를 지원하지 않으므로 Ajax 로 서버로 보내서
            // 파일 내용 읽어 반환시켜 그리드에 적용.
            commitFormSubmit();

            //alert("브라우저가 HTML5 를 지원하지 않습니다.");
        } else {
            var data = null;
            var file = evt.target.files[0];
            if (typeof file == "undefined") {
                return;
            }

            var reader = new FileReader();
            //reader.readAsText(file); // 파일 내용 읽기
            reader.readAsText(file, "EUC-KR"); // 한글 엑셀은 기본적으로 CSV 포맷인 EUC-KR 임. 한글 깨지지 않게 EUC-KR 로 읽음
            reader.onload = function(event) {
                if (typeof event.target.result != "undefined") {
                    // 그리드 CSV 데이터 적용시킴
                    AUIGrid.setCsvGridData(myUploadGridID, event.target.result, false);

                    //csv 파일이 header가 있는 파일이면 첫번째 행(header)은 삭제한다.
                    AUIGrid.removeRow(myUploadGridID,0);
                } else {
                    Common.alert("<spring:message code='000030'/>");
                }
            };

            reader.onerror = function() {
                Common.alert("<spring:message code='000031' arguments='"+file.fileName+"' htmlEscape='false'/>");
            };

        }

    });

    adjMGridID = GridCommon.createAUIGrid("#adjMGridID", adjLayout, "seq", adjOptions);

    // 헤더 클릭 핸들러 바인딩
    AUIGrid.bind(adjMGridID, "headerClick", headerClickHandler);

    //셀 클릭 핸들러 바인딩
    AUIGrid.bind(adjMGridID, "cellClick", auiCellClikcHandler);

    $("#appvStus").multipleSelect("checkAll");
    //$("#appvPrcssStus").multipleSelect("checkAll");

});

function fn_uploadFile2() {

	//Remove fileselector value to avoid getting uploaded as well. Only the attachmemt should be upload
    $("#fileSelector").val("");

    var formData = Common.getFormData("uploadForm");

    var idx = AUIGrid.getRowCount(myUploadGridID);

    if(idx == 0){
        Common.alert("<spring:message code='budget.msg.noData' />");
        return;
    }



    if(Common.confirm("<spring:message code='sys.common.alert.save'/>", function(){

            if(AUIGrid.getCellValue(myUploadGridID, 1, "atchFileGrpId") != "" &&AUIGrid.getCellValue(myUploadGridID, 1, "atchFileGrpId") != null ){
                formData.append("pAtchFileGrpIdUpload", AUIGrid.getCellValue(myUploadGridID, 1, "atchFileGrpId") );
            }

            Common.ajaxFile("/eAccounting/budget/uploadFile.do", formData, function(result) {//  첨부파일 정보를 공통 첨부파일 테이블 이용 : 웹 호출 테스트

                console.log(result);

                if(result.data) {
                    $("#pAtchFileGrpIdUpload").val(result.data);
                }

                if($("#pAtchFileGrpIdUpload").val() == ""){
                     Common.alert("<spring:message code="budget.msg.fileRequir" />");
                     return;
                }

                fn_uploadAdjustment();

            });
      }));
}


function checkHTML5Brower() {
    var isCompatible = false;
    if (window.File && window.FileReader && window.FileList && window.Blob) {
        isCompatible = true;
    }
  console.log("isCompatible " +isCompatible);
    return isCompatible;
  };

function commitFormSubmit() {

    AUIGrid.showAjaxLoader(myUploadGridID);
    console.log("Here:" + $("#fileSelector").val());

    // Submit 을 AJax 로 보내고 받음.
    // ajaxSubmit 을 사용하려면 jQuery Plug-in 인 jquery.form.js 필요함
    // 링크 : http://malsup.com/jquery/form/

    $('#uploadForm').ajaxSubmit({
        type : "json",
        success : function(responseText, statusText) {
            if(responseText != "error") {
                var csvText = responseText;

                // 기본 개행은 \r\n 으로 구분합니다.
                // Linux 계열 서버에서 \n 으로 구분하는 경우가 발생함.
                // 따라서 \n 을 \r\n 으로 바꿔서 그리드에 삽입
                // 만약 서버 사이드에서 \r\n 으로 바꿨다면 해당 코드는 불필요함.
                csvText = csvText.replace(/\r?\n/g, "\r\n")

                // 그리드 CSV 데이터 적용시킴
                AUIGrid.setCsvGridData(myUploadGridID, csvText);
                AUIGrid.removeAjaxLoader(myUploadGridID);

                //csv 파일이 header가 있는 파일이면 첫번째 행(header)은 삭제한다.
                AUIGrid.removeRow(myUploadGridID,0);
            }
        },
        error : function(e) {
            Common.alert("ajaxSubmit Error : " + e);
        }
    });
  }

function fn_uploadAdjustment(){
    var gridData = GridCommon.getGridData(myUploadGridID);
    gridData.form = $("#uploadForm").serializeJSON();

    console.log("gridData: " + gridData);

    Common.ajax("POST", "/eAccounting/budget/uploadBudgetAdjustment", gridData , function(result){
        console.log("Result: " + JSON.stringify(result));

         if(result.code == '99'){
        	 if(result.dataList.length > 0){
        		 var overbudget = "";
                 var rtnBudgetCodeNo = "";
                 console.log(result.dataList);
                 var length = result.dataList.length;
                 if(length > 0){
                	 for(var i = 0; i < length; i++){
                         rtnBudgetCodeNo += result.dataList[i].budgetDocNo + ",";
                     }
                 }
                 console.log(" rtnBudgetCodeNo : "+ rtnBudgetCodeNo );
                 rtnBudgetCodeNo = rtnBudgetCodeNo.slice(0, rtnBudgetCodeNo.length - 1);
                 Common.alert("Upload Success: " + rtnBudgetCodeNo + "<br/>"+ result.message);
                 hideViewPopup();
        	 }else{
        		 var msg = result.message;
                 Common.alert("Error: " + result.message);
        	 }


        }else{
            var rtnBudgetCodeNo = "";
            console.log("Size: " + result.dataList.length);
            var length = result.dataList.length;
            if(length > 0){
                for(var i = 0; i < length; i++){
                    rtnBudgetCodeNo += result.dataList[i].budgetDocNo + ",";
                }
            }

            rtnBudgetCodeNo = rtnBudgetCodeNo.slice(0, rtnBudgetCodeNo.length - 1);
            Common.alert("<spring:message code="budget.BudgetAdjustment" />"+ DEFAULT_DELIMITER +"<spring:message code="budget.msg.budgetDocNo" />" + rtnBudgetCodeNo);
            hideViewPopup();
        }

    },
    function(jqXHR, textStatus, errorThrown){
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
               //console.log("Error: " + result.dataList);
               Common.alert("Fail : " + jqXHR.responseJSON.message);
         });
}


function auiCellClikcHandler(event){
    console.log("dataField : " +event.dataField + " rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");

    var str = AUIGrid.getCellValue(adjMGridID, event.rowIndex, "budgetDocNo");
    var check = AUIGrid.getCellValue(adjMGridID, event.rowIndex, "checkId");

    var idx = AUIGrid.getRowCount(adjMGridID);

    if(event.columnIndex == 0){
        for(var i = 0; i < idx; i++){
            if(AUIGrid.getCellValue(adjMGridID, i, "budgetDocNo") == str){
                AUIGrid.setCellValue(adjMGridID, i, "checkId", check);
            }
        }
    }else if(event.columnIndex == 2){
    	$("#atchFileGrpId").val(AUIGrid.getCellValue(adjMGridID, event.rowIndex, "atchFileGrpId"));
    	$("#gridBudgetDocNo").val(AUIGrid.getCellValue(adjMGridID, event.rowIndex, "budgetDocNo"));
    	fn_budgetAdjustmentPop('grid') ;
    }else if(event.columnIndex == 13){
    	if(AUIGrid.getCellValue(adjMGridID, event.rowIndex, "fileSubPath")== "view"){
            window.open(DEFAULT_RESOURCE_FILE + AUIGrid.getCellValue(adjMGridID, event.rowIndex, "filePath"));
    	}
    }

}


//리스트 조회.
function fn_selectListAjax() {
    Common.ajax("GET", "/eAccounting/budget/selectAdjustmentList", $("#listSForm").serialize(), function(result) {

         console.log("성공.");
         console.log( result);

        AUIGrid.setGridData(adjMGridID, result);

    });
}


//Budget Code Pop 호출
function fn_budgetCodePop(){
    $("#budgetCode").val("");
    $("#budgetCodeName").val("");
    $("#pBudgetCode").val("");
    $("#pBudgetCodeName").val("");
    Common.popupDiv("/eAccounting/expense/budgetCodeSearchPop.do",null, null, true, "budgetCodeSearchPop");
}

function  fn_setBudgetData(){
	$("#budgetCode").val($("#pBudgetCode").val());
	$("#budgetCodeName").val( $("#pBudgetCodeName").val());
}

//Gl Account Pop 호출
function fn_glAccountSearchPop(){
    $("#glAccCode").val("");
    $("#glAccCodeName").val("");
    $("#pGlAccCode").val("");
    $("#pGlAccCodeName").val("");
    Common.popupDiv("/eAccounting/expense/glAccountSearchPop.do", null, null, true, "glAccountSearchPop");
}

function fn_setGlData (){
	$("#glAccCode").val($("#pGlAccCode").val());
	$("#glAccCodeName").val( $("#pGlAccCodeName").val());
}

//Cost Center
function fn_costCenterSearchPop() {
    $("#costCentr").val("");
    $("#search_costCentr").val("");
    $("#costCentrName").val("");
    $("#search_costCentrName").val("");
    Common.popupDiv("/eAccounting/webInvoice/costCenterSearchPop.do", null, null, true, "costCenterSearchPop");
}

function fn_setCostCenter (){
	$("#costCentr").val($("#search_costCentr").val());
	$("#costCentrName").val( $("#search_costCentrName").val());
}

//adjustment Pop
function fn_budgetAdjustmentPop(value) {

	if(value == 'pop'){
        $("#gridBudgetDocNo").val("");
        $("#atchFileGrpId").val("");
	}
    Common.popupDiv("/eAccounting/budget/budgetAdjustmentPop.do", $("#listSForm").serializeJSON(), null, true, "budgetAdjustmentPop");
}

//그리드 헤더 클릭 핸들러
function headerClickHandler(event) {

    // isActive 칼럼 클릭 한 경우
    if(event.dataField == "checkId") {
        if(event.orgEvent.target.id == "allCheckbox") { // 정확히 체크박스 클릭 한 경우만 적용 시킴.
            var  isChecked = document.getElementById("allCheckbox").checked;

            checkAll(isChecked);
        }
        return false;
    }
}

//전체 체크 설정, 전체 체크 해제 하기
function checkAll(isChecked) {


	 var idx = AUIGrid.getRowCount(adjMGridID);

    // 그리드의 전체 데이터를 대상으로 isActive 필드를 "Active" 또는 "Inactive" 로 바꿈.
    if(isChecked) {
    	for(var i = 0; i < idx; i++){
            if(AUIGrid.getCellValue(adjMGridID, i, "status") != 'Close' && AUIGrid.getCellValue(adjMGridID, i, "status") != 'Request'){
                AUIGrid.setCellValue(adjMGridID, i, "checkId", "Y")
            }
        }
    } else {
        AUIGrid.updateAllToValue(adjMGridID, "checkId", "N");
    }

    // 헤더 체크 박스 일치시킴.
    document.getElementById("allCheckbox").checked = isChecked;
}

function fn_budgetApproval(){

    // 그리드 데이터에서 checkId 필드의 값이 Y 인 행 아이템 모두 반환
    var activeItems = AUIGrid.getItemsByValue(adjMGridID, "checkId", "Y");

    if(activeItems.length == 0){
    	Common.alert("<spring:message code='budget.msg.select' />");
        return;
    }

    if(Common.confirm("<spring:message code='sys.common.alert.save'/>", function(){

    	$("#appvStus").val("O"); // adjustment
        $("#appvPrcssStus").val("R"); //Approval

    	 var obj = $("#listSForm").serializeJSON();
    	 var gridData = GridCommon.getEditData(adjMGridID);
    	 obj.gridData = gridData;

    Common.ajax("POST", "/eAccounting/budget/saveBudgetApprovalReq", obj , function(result)    {
    	  console.log("성공." + JSON.stringify(result));
          console.log("data : " + result.data);

          var arryList = result.data.resultAmtList;
          var idx = arryList.length;

          if(idx > 0){

        	  for(var i = 0; i < idx; i++){

                  var budgetDocNo = arryList[i].budgetDocNo;
                  var costCentr = arryList[i].costCentr;
                  var budgetCode = arryList[i].budgetCode;
                  var glAccCode = arryList[i].glAccCode;
                  var adjYearMonth = arryList[i].budgetAdjMonth + "/"+ arryList[i].budgetAdjYear;

                  for(var j=0; j < AUIGrid.getRowCount(adjMGridID); j++){

                     var gridBudgetDoc = AUIGrid.getCellValue(adjMGridID, j, "budgetDocNo");
                     var gridCostCentr = AUIGrid.getCellValue(adjMGridID, j, "costCentr");
                     var gridBudgetCode = AUIGrid.getCellValue(adjMGridID, j, "budgetCode");
                     var gridGlAccCode = AUIGrid.getCellValue(adjMGridID, j, "glAccCode");
                     var gridAdjYearMonth = AUIGrid.getCellValue(adjMGridID, j, "adjYearMonth");
                     var gridBudgetAdjType = AUIGrid.getCellValue(adjMGridID, j, "budgetAdjType");

                      if(budgetDocNo == gridBudgetDoc && gridCostCentr == costCentr && gridBudgetCode == budgetCode
                                 && gridGlAccCode == glAccCode && gridAdjYearMonth == adjYearMonth && gridBudgetAdjType !='01') {
                          AUIGrid.setCellValue(adjMGridID, j, "overBudgetFlag","Y");
                      }
                  }
              }
          }else{
        	  fn_selectListAjax();
          }

          AUIGrid.setProp(adjMGridID, "rowStyleFunction", function(rowIndex, item) {
              if(item.overBudgetFlag == "Y") {
                     return "my-row-style";
                 }
                 return "";

             });

             // 변경된 rowStyleFunction 이 적용되도록 그리드 업데이트
             AUIGrid.update(adjMGridID);
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

function fn_goBudgetPlan(){
	location.replace("/eAccounting/budget/monthlyBudgetList.do");
}

function fn_budgetDelete() {

    // 그리드 데이터에서 checkId 필드의 값이 Y 인 행 아이템 모두 반환
    var activeItems = AUIGrid.getItemsByValue(adjMGridID, "checkId", "Y");

    if(activeItems.length == 0){
    	Common.alert('<spring:message code="budget.msg.delete" />');
        return;
    }

    if(Common.confirm("<spring:message code='sys.common.alert.delete'/>", function(){

         var gridData = GridCommon.getEditData(adjMGridID);

    Common.ajax("POST", "/eAccounting/budget/deleteBudgetAdjustment", {gridData:gridData} , function(result)    {
          console.log("성공." + JSON.stringify(result));
          console.log("data : " + result.data);

          fn_selectListAjax();
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

function fn_budgetAdjustmentUpload(){
    $("#uploadAdj_wrap").show();
    AUIGrid.resize(myUploadGridID);

	//Common.popupDiv("/eAccounting/budget/budAdj.do",null, null, true, "budgetCodeSearchPop");
}

hideViewPopup=function(val){
    $(val).hide();

    //업로드창이 닫히면 upload 화면도 reset한다.
   /*  if(val == '#upload_wrap'){
        fn_uploadClear();
    } */

    fn_uploadClear();
}

function fn_uploadClear(){
    //화면내 모든 form 객체 초기화
    $("#uploadForm")[0].reset();

    //그리드 초기화
    //$("#fileSelector").val("");

    AUIGrid.clearGridData(myUploadGridID);
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
<h2><spring:message code="budget.BudgetAdjustmentList" /> 1</h2>
<ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcView == 'Y'}">
	<li><p class="btn_blue"><a href="#" id="btnSearch" ><span class="search"></span><spring:message code="expense.btn.Search" /></a></p></li>
	</c:if>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="listSForm" name="listSForm">
    <input type="hidden" id = "pBudgetCode" name="pBudgetCode" />
    <input type="hidden" id = "pBudgetCodeName" name="pBudgetCodeName" />
    <input type="hidden" id = "pGlAccCode" name="pGlAccCode" />
    <input type="hidden" id = "pGlAccCodeName" name="pGlAccCodeName" />

    <input type="hidden" id = "search_costCentr" name="search_costCentr" />
    <input type="hidden" id = "search_costCentrName" name="search_costCentrName" />

    <input type="hidden" id = "gridBudgetDocNo" name="gridBudgetDocNo" />
    <input type="hidden" id = "atchFileGrpId" name="atchFileGrpId" />
    <input type="hidden" id = "budgetStatus" name="budgetStatus" />

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:140px" />
	<col style="width:*" />
	<col style="width:160px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row"><spring:message code="budget.Month" />/<spring:message code="budget.Year" /></th>
	<td>
	<div class="date_set"><!-- date_set start -->
	<p><input type="text" id="stYearMonth" name="stYearMonth" title="Create start Date" placeholder="MM/YYYY" class="j_date2"/></p>
	<span><spring:message code="budget.To" /></span>
	<p><input type="text" id="edYearMonth" name="edYearMonth" title="Create end Date" placeholder="MM/YYYY" class="j_date2" /></p>
	</div><!-- date_set end -->
	</td>
	<th scope="row"><spring:message code="budget.CostCenter" /></th>
	<td>
	<input type="text" id="costCentr" name="costCentr" title="" placeholder="" class="" />
	<input type="hidden" id="costCentrName" name="costCentrName" title="" placeholder="" class="" readonly="readonly" />
	<a href="#" class="search_btn" onclick="javascript:fn_costCenterSearchPop();"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
	</td>
</tr>
<tr>
	<th scope="row"><spring:message code="expense.GLAccount" /></th>
	<td>
	      <input type="text" id="glAccCode" name="glAccCode" title="" placeholder="" class="" />
	      <input type="hidden" id="glAccCodeName" name="glAccCodeName" title="" placeholder="" class=""  readonly="readonly" />
	      <a href="#" class="search_btn" onclick="javascript:fn_glAccountSearchPop();"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
	</td>
	<th scope="row"><spring:message code="expense.Activity" /></th>
	<td>
		<input type="text" id="budgetCode" name="budgetCode" title="" placeholder="" class="" />
		<input type="hidden" id="budgetCodeName" name="budgetCodeName" title="" placeholder="" class=""  readonly="readonly" />
		<a href="#" class="search_btn" onclick="javascript:fn_budgetCodePop();"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
	</td>
</tr>
<tr>
	<th scope="row"><spring:message code="budget.AdjustmentType" /></th>
	<td><select class="multy_select w100p" id="budgetAdjType" name="budgetAdjType" multiple="multiple"></select></td>
	<th scope="row"><spring:message code="budget.BudgetDocumentNo" /></th>
	<td><input type="text" id="budgetDocNo" name ="budgetDocNo" title="" placeholder="" class="" /></td>
</tr>
<tr>
	<th scope="row"><spring:message code="budget.Status" /></th>
	<td>
	<select id="appvStus" name="appvStus" class="multy_select w100p" multiple="multiple">
		<option value="T"><spring:message code="budget.Draft" /></option>
		<option value="O"><spring:message code="budget.Open" /></option>
        <option value="C"><spring:message code="budget.Close" /></option>
	</select>
	</td>
	<th scope="row">Approval Status</th>
	<td>
	   <select class="multy_select w100p" multiple="multiple" id="appvPrcssStus" name="appvPrcssStus">
            <option value="A"><spring:message code="webInvoice.select.approved" /></option>
            <option value="R"><spring:message code="webInvoice.select.request" /></option>
            <option value="J"><spring:message code="pettyCashRqst.rejected" /></option>
        </select>
	</td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
<dl class="link_list">
	<dt><spring:message code="budget.Link" /></dt>
	<dd>
	<ul class="btns">
		<li><p class="link_btn type2"><a href="#" onclick="javascript:fn_goBudgetPlan();"><spring:message code="budget.BudgetPlan" /></a></p></li>
	</ul>
	<p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
	</dd>
</dl>
</aside><!-- link_btns_wrap end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
    <c:if test="${PAGE_AUTH.funcUserDefine26 == 'Y'}">
     <li><p class="btn_grid"><a href="${pageContext.request.contextPath}/resources/download/eAccounting/AdjustmentBulkUpload_Format.csv">Template</a></p></li>
	<li><p class="btn_grid"><a href="#" onclick="javascript:fn_budgetAdjustmentUpload();">Upload</a></p></li>
	 </c:if>
	<li><p class="btn_grid"><a href="#" onclick="javascript:fn_budgetDelete();"><spring:message code="budget.Delete" /></a></p></li>
	<li><p class="btn_grid"><a href="#" onclick="javascript:fn_budgetAdjustmentPop('pop');"><spring:message code="budget.NewAdjustment" /></a></p></li>
	<li><p class="btn_grid"><a href="#" onclick="javascript:fn_budgetApproval();"><spring:message code="budget.Submit" /></a></p></li>
	</c:if>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="adjMGridID" style="width:100%; height:360px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->
<div class="popup_wrap" id="uploadAdj_wrap" style="display: none;">
 <!-- pop_header start -->
 <header class="pop_header" id="updResult_pop_header">
  <h1>
   Upload Budget Adjustment
  </h1>
  <ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" onclick="hideViewPopup('#uploadAdj_wrap')"><spring:message code="expense.CLOSE" /></a></p></li>
</ul>
 </header>
 <!-- pop_header end -->
 <!-- pop_body start -->
 <form name="uploadForm" id="uploadForm" method="post">
 <input type="hidden" id = "pAtchFileGrpIdUpload" name="pAtchFileGrpIdUpload" />
  <section class="pop_body">
   <!-- search_table start -->
   <section class="search_table">
    <!-- table start -->
    <table class="type1">
     <caption>table</caption>
     <colgroup>
      <col style="width: 165px" />
      <col style="width: *" />
     </colgroup>
     <tbody>
      <tr>
       <th scope="row">Choose File</th>
       <td>
        <div class="auto_file">
         <!-- auto_file start -->
         <input type="file" title="file add" id="fileSelector" name="fileSelector" accept=".csv" />
        </div> <!-- auto_file end -->
       </td>
      </tr>
     </tbody>
    </table>
   </section>
   <section class="search_result">
    <!-- search_result start -->
    <article class="grid_wrap" id="grid_upload_wrap"></article>
    <div id="uploadAdj" style="display: none;">
    <!-- grid_wrap end -->
   </section>
<table class="type1 mt10"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:120px" />
    <col style="width:*" />
</colgroup>
<tbody>

<tr>
    <th scope="row" rowspan="2"><spring:message code="sal.text.attachment" /></th>
    <td>
     <div class="auto_file2"><!-- auto_file start -->
        <input type="file" title="file add" style="width:300px" id="_fileName"/>
    </div><!-- auto_file end -->
    </td>
</tr>
</tbody>
</table><!-- table end -->

   <!-- search_result end -->
   <!-- search_table end -->
   <ul class="center_btns">
   <li><p class="btn_blue2"><a href="javascript:fn_uploadFile2();">Save</a></p></li>
   </ul>
  </section>
 </form>

 <!-- pop_body end -->
</div>
