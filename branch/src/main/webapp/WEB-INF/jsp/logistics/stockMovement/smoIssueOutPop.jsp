<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/homecare-js-1.0.js"></script>

<style type="text/css">


   /* 커스텀 칼럼 스타일 정의 */
   .my-column {
	    text-align: center;
	    margin-top: -20px;
	}

   .my-row-style { background:#FF5733; font-weight:bold; color:#22741C; text-decoration:underline;}
   .aui-grid-link-renderer1 {
      text-decoration:underline;
      color: #4374D9 !important;
      cursor: pointer;
      text-align: right;
    }
</style>
<script type="text/javaScript">

/*
var uomDs = [];
var uomObj = {};
<c:forEach var="obj" items="${uomList}">
  uomDs.push({codeId:"${obj.codeId}", codeName:"${obj.codeName}", code:"${obj.code}"});
  uomObj["${obj.codeId}"] = "${obj.codeName}";
</c:forEach>
*/

var popupObj;
var scanInfoGridId;

var scanInfoLayout = [
          {dataField:"reqstNoItm", visible:false, editable : false}
        , {dataField:"itmCode", headerText:"Item Code", width:100, editable : false}
        , {dataField:"itmName", headerText:"Item Description", width:280, style:"aui-grid-user-custom-left", editable : false}
        , {dataField:"delGiCmplt", visible:false, editable : false}
        , {dataField:"serialChk", headerText:"Serial", width:70, editable : false}
        , {dataField:"giQty", headerText:"GI QTY", width:70, editable : false
            , style:"aui-grid-user-custom-right"
            , dataType:"numeric"
            , formatString:"#,##0"
        }
        , {dataField:"scanQty", headerText:"Scaned(Request) QTY", width:180
            , style:"aui-grid-user-custom-right"
            , dataType:"numeric"
            , formatString:"#,##0"
            , headerStyle : "aui-grid-header-input-icon aui-grid-header-input-essen"
            , styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField){
                if(item.serialChk == "Y" && item.giQty != value){
                    return "my-row-style";
                } else if(item.serialChk == "Y" && item.giQty == value){
                	return "aui-grid-link-renderer1";
                }
            }
	        ,editRenderer : {
	            type : "InputEditRenderer",
	            onlyNumeric : true
	        }
        }
        , {dataField:"trnscType", visible:false, editable : false}
        , {dataField:"trnscTypeDtl", visible:false, editable : false}
        , {dataField:"reqstNo", headerText:"SMO No.", width:140, editable : false}

];

var scanInfoPros = {
		usePaging : false,
        editable : true,
        selectionMode : "singleCell",
        showRowNumColumn : true,
        enableFilter : true,
        showRowCheckColumn : false,
        showRowAllCheckBox : false,
        showStateColumn : false,
        showBranchOnGrouping : false,
        enableRestore: true,
        showFooter : true,
        softRemovePolicy : "exceptNew" //사용자추가한 행은 바로 삭제
};

var subFooterLayout = [{labelText : "Total", positionField : "serialChk"}
, {dataField : "giQty"
    , positionField : "giQty"
    , operation : "SUM"
    , formatString : "#,##0"
    , style:"aui-grid-user-custom-right"
}
, {dataField : "scanQty"
    , positionField : "scanQty"
    , operation : "SUM"
    , formatString : "#,##0"
    , style:"aui-grid-user-custom-right"
}
];

$(document).ready(function(){

    // Moblie Popup Setting
    Common.setMobilePopup(true, false,'scanInfoGrid');

    doSysdate(0, 'zGiptdate');
    doSysdate(0, 'zGipfdate');

    scanInfoGridId = GridCommon.createAUIGrid("scanInfoGrid", scanInfoLayout, null, scanInfoPros);
    // 푸터 레이아웃 세팅
    AUIGrid.setFooter(scanInfoGridId, subFooterLayout);

    if(Common.checkPlatformType() == "mobile") {
    	$("#zRstNo").val("${param.zReqstno}");
    	$("#zFromLoc").val("${param.zRcvloc}");
    	$("#zToLoc").val("${param.zReqloc}");
    }else{
    	$("#zRstNo").val($("#zReqstno").val());
        $("#zFromLoc").val($("#zRcvloc").val());
        $("#zToLoc").val($("#zReqloc").val());
    }

    fn_smoIssueOutListAjax();

    $("#btnPopSearch").click(function(){

    	fn_smoIssueOutListAjax();
    });

    $("#btnClose").click(function(){
    	fn_ClosePop();
    });

    $("#btnPopIssueSave").click(function(){

        var arrReqstNo = ($("#zRstNo").val()).split(',');

    	if(FormUtil.isEmpty($("#zGiptdate").val())) {
            Common.alert("Please select the GI Posting Date.");
            return false;
        }

        if(FormUtil.isEmpty($("#zGipfdate").val())) {
            Common.alert("Please select the GI Doc Date.");
            return false;
        }

        var gridList = GridCommon.getGridData(scanInfoGridId);
        var reqQty = 0;

        for(var i = 0 ; i < gridList.all.length ; i++){
            /*if (gridList.all[i].serialChk != "Y"){
                Common.alert("Please check Serial Chk YN.")
               return false;
            }*/
            /*if (gridList.all[i].serialChk == "Y" && gridList.all[i].scanQty == 0){
                Common.alert("Scan Qty does not exist.")
               return false;
            }*/
            if (gridList.all[i].scanQty > gridList.all[i].giQty){
                Common.alert("Scaned(Request) Qty cannot be greater than GI Qty.")
                return false;
            }

            if(arrReqstNo.length > 1){
	            if (gridList.all[i].scanQty != gridList.all[i].giQty){
	                Common.alert("GI Qty and Scaned(Request) Qty must be the same quantity.")
	                return false;
	            }
            }

            reqQty = reqQty + gridList.all[i].scanQty;
        }

        if(reqQty == 0) {
        	Common.alert("Please input at least one of the item.<br/>Scaned(Request) Qty is all zero.")
            return false;
        }

        var obj = $("#smoIssueOutForm").serializeJSON();
        obj.gridList = gridList;

        if(Common.confirm("Do you want to save?", function(){
            Common.ajax("POST", "/logistics/stockMovement/StockMovementReqDeliverySerial.do", obj, function(result) {

            	 if ("dup" == result.data[1]) {
                     Common.alert(" Not enough Qty, Please search again. ");
            	 } else {
                     var msg = result.message + "<br>MDN NO : " + result.data[1];
                     Common.alert(msg);
                 }

            	 if(result.code == "00"){
                     $("#btnClose").click();
                 }
            });
        }));
    });

    $("#btnAllDel").click(function(){
        if($(this).parent().hasClass("btn_disabled") == true){
            return false;
        }

        var msg = "";
        if($("#zTrnscType").val() == "UM"){
            msg = "Do you want to All Delete SMO No ["+$("#zRstNo").val()+"]?";
        }else{
            msg = "Do you want to All Delete Delivery No ["+$("#zDelvryNo").val()+"]?";
        }

        Common
            .confirm(msg,
                function(){
                    var itemDs = {"allYn":"Y"
                            , "rstNo":$("#zRstNo").val()
                            , "dryNo":$("#zDelvryNo").val()
                            , "fromLocCode":$("#zFromLoc").val()
                            , "toLocCode":$("#zToLoc").val()
                            , "ioType":$("#zIoType").val()
                            , "transactionType":$("#zTrnscType").val()};

                        Common.ajax("POST", "/logistics/serialMgmtNew/deleteSerial.do"
                                , itemDs
                                , function(result){
                                    $("#btnPopSearch").click();
                                }
                                , function(jqXHR, textStatus, errorThrown){
                                    try{
                                        if (FormUtil.isNotEmpty(jqXHR.responseJSON)) {
                                            console.log("code : "  + jqXHR.responseJSON.code);
                                            Common.alert("Fail : " + jqXHR.responseJSON.message);
                                        }else{
                                            console.log("Fail Status : " + jqXHR.status);
                                            console.log("code : "        + jqXHR.responseJSON.code);
                                            console.log("message : "     + jqXHR.responseJSON.message);
                                            console.log("detailMessage : "  + jqXHR.responseJSON.detailMessage);
                                        }
                                    }catch (e){
                                        console.log(e);
                                    }
                       });
                }
        );
    });

    $("#btnPopSerial").click(function(){
    	if($(this).parent().hasClass("btn_disabled") == true){
            return false;
        }

    	if(Common.checkPlatformType() == "mobile") {
            popupObj = Common.popupWin("smoIssueOutForm", "/logistics/serialMgmtNew/serialScanCommonPop.do", {width : "1000px", height : "720", resizable: "no", scrollbars: "yes"});
        } else{
            Common.popupDiv("/logistics/serialMgmtNew/serialScanCommonPop.do", null, null, true, '_serialScanPop');
        }
    });

    AUIGrid.bind(scanInfoGridId, "cellClick", function( event ) {
        var rowIndex = event.rowIndex;
        var dataField = AUIGrid.getDataFieldByColumnIndex(scanInfoGridId, event.columnIndex);
        var serialChk = AUIGrid.getCellValue(scanInfoGridId, rowIndex, "serialChk");
        var scanQty = AUIGrid.getCellValue(scanInfoGridId, rowIndex, "scanQty");

        if(dataField == "scanQty"){
            var rowIndex = event.rowIndex;
            if(serialChk == "Y" && scanQty > 0){
                $('#smoIssueOutForm #pRequestNo').val( AUIGrid.getCellValue(scanInfoGridId, rowIndex, "reqstNo") );
                $('#smoIssueOutForm #pRequestItem').val( AUIGrid.getCellValue(scanInfoGridId, rowIndex, "reqstNoItm") );

                fn_scanSearchPop();
            }
        }
   });

   AUIGrid.bind(scanInfoGridId, "cellEditBegin", auiCellEditignHandler);
   AUIGrid.bind(scanInfoGridId, "cellEditEnd", auiCellEditignHandler);

});

function auiCellEditignHandler(event)
{
    if(event.type == "cellEditBegin") {
        if (event.dataField == "scanQty")
        {
            var serialChk = AUIGrid.getCellValue(scanInfoGridId, event.rowIndex, "serialChk");
            if(serialChk == 'Y') {
                 return false;
            }
        }
    } else if(event.type == "cellEditEnd") {
        if (event.dataField == "scanQty")
        {
        	var giQty = AUIGrid.getCellValue(scanInfoGridId, event.rowIndex, "giQty");
            var reqQty = event.value;

            if(reqQty >  giQty) {
                Common.alert("Scaned(Request) Qty cannot be greater than GI Qty.");
                AUIGrid.setCellValue(scanInfoGridId, event.rowIndex, "scanQty", giQty);
                return false;
            }
        }
    }
}

function fn_smoIssueOutListAjax() {

	var url = "/logistics/stockMovement/selectSmoIssueOutPop.do";
    var arrReqstNo = ($("#zRstNo").val()).split(',');

    if(arrReqstNo.length == 0){
        Common.alert("Please, check the mandatory value.");
        return false;
    }

    // 초기화
    $("#btnPopSerial").parent().addClass("btn_disabled");
    $("#btnAllDel").parent().addClass("btn_disabled");
    AUIGrid.setGridData(scanInfoGridId, []);

    Common.ajax("POST" , url , {"reqstList":arrReqstNo} , function(data){

        if(data.total > 0){
            if(data.dataList[0].serialRequireChkYn == "Y"){
                var isSerial = false;
                $.each(data.dataList, function(i, row){
                    if(row.serialChk == "Y"){
                        isSerial = true;
                    }
                });
                if(isSerial){
                    $("#btnPopSerial").parent().removeClass("btn_disabled");
                    $("#btnAllDel").parent().removeClass("btn_disabled");
                }
            }
            AUIGrid.setGridData(scanInfoGridId, data.dataList);
        }
    });
}


function fn_ClosePop(){
	// Moblie Popup Setting
    if(Common.checkPlatformType() == "mobile") {
        opener.fn_PopSmoIssueClose();
    } else {
    	$('#_divSmoIssuePop').remove();
    	SearchListAjax();
    }
}

function fn_PopSerialClose(){
    if(popupObj!=null) popupObj.close();
    $("#btnPopSearch").click();
}

//Serial Search Pop
function fn_scanSearchPop(){
    if(Common.checkPlatformType() == "mobile") {
        popupObj = Common.popupWin("smoIssueOutForm", "/logistics/SerialMgmt/scanSearchPop.do", {width : "1000px", height : "1000px", height : "720", resizable: "no", scrollbars: "yes"});
    } else{
        Common.popupDiv("/logistics/SerialMgmt/scanSearchPop.do", $("#smoIssueOutForm").serializeJSON(), null, true, '_scanSearchPop');
    }
}

</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Good Issue</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a id="btnPopIssueSave" >SAVE</a></p></li>
    <li><p class="btn_blue2"><a id="btnClose" >CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

    <form id="smoIssueOutForm" name="smoIssueOutForm" method="POST">
        <input type="hidden" name="zTrnscType" id="zTrnscType" value="UM" />
        <input type="hidden" name="zFromLoc" id="zFromLoc" />
        <input type="hidden" name="zToLoc" id="zToLoc" />
        <input type="hidden" name="zIoType" id="zIoType" value="O"/>
        <input type="hidden" name="ztype" id="ztype" value="GI"/>
        <input type="hidden" name="pRequestNo" id="pRequestNo" />
	    <input type="hidden" name="pRequestItem" id="pRequestItem" />
	    <input type="hidden" name="pStatus" id="pStatus" />
	    <input type="hidden" name="zDelvryNo" id="zDelvryNo" />
        <table class="type1">
	        <caption>search table</caption>
	        <colgroup>
	            <col style="width:150px" />
	            <col style="width:*" />
	        </colgroup>
	        <tbody>
	                <tr>
	                   <th scope="row">SMO No.</th>
	                   <td ><input id="zRstNo" name="zRstNo" type="text" placeholder="" class="w100p readonly" readonly /></td>
                    </tr>
	                <tr>
	                    <th scope="row">GI Posting Date<span class="must">*</span></th>
	                    <td ><input id="zGiptdate" name="zGiptdate" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" readonly/></td>
	                </tr>
	                <tr>
	                    <th scope="row">GI Doc Date<span class="must">*</span></th>
	                    <td ><input id="zGipfdate" name="zGipfdate" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" readonly/></td>
	                </tr>
	                <tr>
	                    <th scope="row">Header Text</th>
	                    <td><input type="text" name="zDoctext" id="zDoctext" maxlength="50" class="w100p"/></td>
	                </tr>
	        </tbody>
        </table>
    </form>

    <aside class="title_line">
       <h3>Serial Scan</h3>
	   <ul class="right_btns">
            <li style="display:none;"><p class="btn_grid"><a id="btnPopSearch">Search</a></p></li>
            <li><p class="btn_grid"><a id="btnAllDel">Clear Serial</a></p></li>
            <li><p class="btn_grid"><a id="btnPopSerial">Serial Scan</a></p></li>
	   </ul>
    </aside>

    <section class="search_result">
        <article class="grid_wrap">
            <div id="scanInfoGrid" style="height:320px"></div>
        </article>
    </section>
    <div class="autoFixArea">

    </div>
</section>
</div>