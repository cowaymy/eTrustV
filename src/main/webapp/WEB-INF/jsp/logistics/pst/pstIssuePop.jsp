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

var popupObj;
var scanInfoGridId;

var scanInfoLayout = [
          {dataField:"reqstNo", visible:false, editable : false}
        , {dataField:"itmcd", headerText:"Item Code", width:120, editable : false}
        , {dataField:"itmnm", headerText:"Item Description", width:280, style:"aui-grid-user-custom-left", editable : false}
        , {dataField:"serialChk", headerText:"Serial Chk", width:120, editable : false}
        , {dataField:"balqty", headerText:"GI(GR) QTY", width:100, editable : false
            , style:"aui-grid-user-custom-right"
            , dataType:"numeric"
            , formatString:"#,##0"
        }
        , {dataField:"reqqty", headerText:"Scaned(Request) QTY", width:180
            , style:"aui-grid-user-custom-right"
            , dataType:"numeric"
            , formatString:"#,##0"
            , styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField){
                if(item.serialChk == "Y" && item.balqty != value){
                    return "my-row-style";
                } else if(item.serialChk == "Y" && item.balqty == value){
                	return "aui-grid-link-renderer1";
                }
            }
	        ,editRenderer : {
	            type : "InputEditRenderer",
	            onlyNumeric : true
	        }
        }
        ,{dataField:"invtype", visible:false, editable : false}
        ,{dataField:"psttypeid", visible:false, editable : false}
        ,{dataField:"psono", visible:false, editable : false}
        ,{dataField:"psoid", visible:false, editable : false}
        ,{dataField:"dealerid", visible:false, editable : false}
        ,{dataField:"itmid", visible:false, editable : false}
        ,{dataField:"itmprc", visible:false, editable : false}
        ,{dataField:"crtdt1", visible:false, editable : false}
        ,{dataField:"locid", visible:false, editable : false}
        ,{dataField:"uom", visible:false, editable : false}
        ,{dataField:"pcr", visible:false, editable : false}
        ,{dataField:"pcti", visible:false, editable : false}
        ,{dataField:"pctcd", visible:false, editable : false}
        ,{dataField:"cntname", visible:false, editable : false}
        ,{dataField:"pstpo", visible:false, editable : false}
        ,{dataField:"dealernm", visible:false, editable : false}
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
        softRemovePolicy : "exceptNew" //사용자추가한 행은 바로 삭제
};

$(document).ready(function(){

    // Moblie Popup Setting
    Common.setMobilePopup(true, false,'scanInfoGrid');

    doSysdate(0, 'zGiptdate');
    doSysdate(0, 'zGipfdate');

    scanInfoGridId = GridCommon.createAUIGrid("scanInfoGrid", scanInfoLayout, null, scanInfoPros);

    if(Common.checkPlatformType() == "mobile") {
    	$("#zRstNo").val("${param.zReqstno}");
    	$("#zFromLoc").val("${param.zRcvloc}");
    	$("#zIoType").val("${param.pStatus}");
    }else{
    	$("#zRstNo").val($("#zReqstno").val());
        $("#zFromLoc").val($("#zRcvloc").val());
        $("#zIoType").val($("#pStatus").val());
    }

    fn_pstIssueListAjax();

    $("#btnPopSearch").click(function(){

    	fn_pstIssueListAjax();
    });

    $("#btnClose").click(function(){
    	fn_ClosePop();
    });

    $("#btnPopIssueSave").click(function(){
        if(FormUtil.isEmpty($("#zGiptdate").val())) {
            Common.alert("Please select the GI/GR Posting Date.");
            return false;
        }

        if(FormUtil.isEmpty($("#zGipfdate").val())) {
            Common.alert("Please select the GI/GR Doc Date.");
            return false;
        }

    	var gridList = GridCommon.getGridData(scanInfoGridId);
        var reqQty = 0;

        for(var i = 0 ; i < gridList.all.length ; i++){
            /*if (gridList.all[i].serialChk != "Y"){
                Common.alert("Please check Serial Chk YN.")
               return false;
            }*/
            /*if (gridList.all[i].serialChk == "Y" && gridList.all[i].reqqty == 0){
                Common.alert("Scan Qty does not exist.")
               return false;
            }*/
            if (gridList.all[i].reqqty > gridList.all[i].balqty){
                Common.alert("Scaned(Request) Qty cannot be greater than GI/GR Qty.")
                return false;
            }

            reqQty = reqQty + gridList.all[i].reqqty;
        }

        if(reqQty == 0) {
        	Common.alert("Please input at least one of the item.<br/>Scaned(Request) Qty is all zero.")
            return false;
        }

        var data = {};
        data.form    = $("#pstIssueForm").serializeJSON();
        data.gridList = gridList;

        if(Common.confirm("Do you want to save?", function(){
            Common.ajax("POST", "/logistics/pst/pstMovementReqDeliverySerial.do", data, function(result) {
                Common.alert(result.message);

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

        var msg = "Do you want to All Delete PSO No ["+$("#zRstNo").val()+"]?";

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
        var reqqty = AUIGrid.getCellValue(scanInfoGridId, rowIndex, "reqqty");

        if(dataField == "reqqty"){
            var rowIndex = event.rowIndex;
            if(serialChk == "Y" && reqqty > 0){
                $('#pstIssueForm #pRequestNo').val( AUIGrid.getCellValue(scanInfoGridId, rowIndex, "reqstNo") );
                //$('#pstIssueForm #pRequestItem').val( AUIGrid.getCellValue(scanInfoGridId, rowIndex, "reqstNoItm") );
                $('#pstIssueForm #pStatus').val($("#zIoType").val());

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
        if (event.dataField == "reqqty")
        {
            var serialChk = AUIGrid.getCellValue(scanInfoGridId, event.rowIndex, "serialChk");
            if(serialChk == 'Y') {
                 return false;
            }
        }
    } else if(event.type == "cellEditEnd") {
        if (event.dataField == "reqqty")
        {
        	var balqty = AUIGrid.getCellValue(scanInfoGridId, event.rowIndex, "balqty");
            var reqQty = event.value;

            if(reqQty >  balqty) {
                Common.alert("Scaned(Request) Qty cannot be greater than GI/GR Qty.");
                AUIGrid.setCellValue(scanInfoGridId, event.rowIndex, "reqqty", balqty);
                return false;
            }
        }
    }
}

function fn_pstIssueListAjax() {

	var url = "/logistics/pst/selectPstIssuePop.do";

    if(FormUtil.isEmpty($("#zRstNo").val())) {
    	Common.alert("Please, check the mandatory value.[PSO No]");
        return false;
    }

    // 초기화
    $("#btnPopSerial").parent().addClass("btn_disabled");
    $("#btnAllDel").parent().addClass("btn_disabled");
    AUIGrid.setGridData(scanInfoGridId, []);

    var checkedItems = AUIGrid.getCheckedRowItems(listGrid); // Main Grid

    var rowList = [];
    for (var j = 0; j < checkedItems.length; j++) {
        rowList.push(checkedItems[j].item.itmid);
    }

  Common.ajax("POST" , url , {"psoNo":$("#zRstNo").val(), "ioType" : $("#zIoType").val(), "stkId":rowList} , function(data){

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
        opener.fn_PopPstIssueClose();
    } else {
    	$('#_divPstIssuePop').remove();
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
        popupObj = Common.popupWin("pstIssueForm", "/logistics/SerialMgmt/scanSearchPop.do", {width : "1000px", height : "1000px", height : "720", resizable: "no", scrollbars: "yes"});
    } else{
        Common.popupDiv("/logistics/SerialMgmt/scanSearchPop.do", $("#pstIssueForm").serializeJSON(), null, true, '_scanSearchPop');
    }
}

</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Serial Check</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a id="btnClose" >CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

    <form id="pstIssueForm" name="pstIssueForm" method="POST">
        <input type="hidden" name="zTrnscType" id="zTrnscType" value="PS" />
        <input type="hidden" name="zFromLoc" id="zFromLoc" />
        <input type="hidden" name="zToLoc" id="zToLoc" />
        <input type="hidden" name="zIoType" id="zIoType" value=""/>
        <input type="hidden" name="ztype" id="ztype" value=""/>
        <input type="hidden" name="pRequestNo" id="pRequestNo" />
	    <input type="hidden" name="pRequestItem" id="pRequestItem" />
	    <input type="hidden" name="pStatus" id="pStatus" />
        <table class="type1">
	        <caption>search table</caption>
	        <colgroup>
	            <col style="width:150px" />
	            <col style="width:*" />
	        </colgroup>
	        <tbody>
	                <tr>
	                   <th scope="row">PSO No.</th>
	                   <td ><input id="zRstNo" name="zRstNo" type="text" placeholder="" class="w100p readonly" readonly /></td>
                    </tr>
	                <tr>
	                    <th scope="row">GI/GR Posting Date<span class="must">*</span></th>
	                    <td ><input id="zGiptdate" name="zGiptdate" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" readonly/></td>
	                </tr>
	                <tr>
	                    <th scope="row">GI/GR Doc Date<span class="must">*</span></th>
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
            <div id="scanInfoGrid" class="autoGridHeight"></div>
        </article>
    </section>
    <div class="autoFixArea">
    &nbsp;
    <ul class="center_btns ">
        <li><p class="btn_blue2 big"><a id="btnPopIssueSave" >SAVE</a></p></li>
    </ul>
    </div>
</section>
</div>