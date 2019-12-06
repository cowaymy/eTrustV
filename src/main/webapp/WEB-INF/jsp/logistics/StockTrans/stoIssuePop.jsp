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

   .my-row-style { background:#FF5733; font-weight:bold; color:#22741C; }

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

var toDay = "${toDay}";

var popupObj;
var scanInfoGridId;

var scanInfoLayout = [
          {dataField:"delvryNo", visible:false}
        , {dataField:"delvryNoItm", visible:false}
        , {dataField:"itmCode", headerText:"Item Code", width:120}
        , {dataField:"itmName", headerText:"Item Description", width:400, style:"aui-grid-user-custom-left"}
        , {dataField:"delGiCmplt", visible:false}
        , {dataField:"serialChk", headerText:"Serial Chk", width:120}
        , {dataField:"delvryQty", headerText:"DELVRY QTY", width:110
            , style:"aui-grid-user-custom-right"
            , dataType:"numeric"
            , formatString:"#,##0"
        }
        , {dataField:"scanQty", headerText:"Scaned QTY", width:110
            , style:"aui-grid-user-custom-right"
            , dataType:"numeric"
            , formatString:"#,##0"
            , styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField){
                if(item.delvryQty != value){
                	return "my-row-style";
                }
                return "";
            }
        }
        , {dataField:"serialRequireChkYn", visible:false}

];

var scanInfoPros = {
		usePaging : false,
        editable : false,
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
    Common.setMobilePopup(true, false, 'scanInfoGrid');

    scanInfoGridId = GridCommon.createAUIGrid("scanInfoGrid", scanInfoLayout, null, scanInfoPros);

    if(Common.checkPlatformType() == "mobile") {
    	$("#zDelvryNo").val("${url.zDelyno}");    // delivery No
    	$("#zFromLoc").val("${url.zReqloc}");
    	$("#zToLoc").val("${url.zRcvloc}");
    	$("#zPrgName").val("${url.zPrgnm}");
    	$("#zIoType").val("O");
    	$("#zGtype").val("GI");
    }else{
    	$("#zDelvryNo").val($("#zDelyno").val());
        $("#zFromLoc").val($("#zReqloc").val());
        $("#zToLoc").val($("#zRcvloc").val());
        $("#zPrgName").val($("#zPrgnm").val());
        $("#zIoType").val("O");
        $("#zGtype").val("GI");
    }

    doSysdate(0 , 'sGiptdate');
    doSysdate(0 , 'sGipfdate');

    $("#btnPopSearch").click(function(){
        var url = "/logistics/stocktransfer/selectStoIssuePop.do";
        var arrDelvryNo = ($("#zDelvryNo").val()).split(',');

        if(arrDelvryNo.length == 0){
        	Common.alert("Please, check the mandatory value.");
        	return false;
        }

        // 초기화
        $("#btnPopSerial").parent().addClass("btn_disabled");
        AUIGrid.setGridData(scanInfoGridId, []);

        Common.ajax("POST" , url , {"delyList":arrDelvryNo} , function(data){
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
	        		}
	        	}
	        	AUIGrid.setGridData(scanInfoGridId, data.dataList);
        	}

        });
    });

    $("#btnClose").click(function(){
    	fn_ClosePop();
    });

    $("#btnPopIssueSave").click(function(){

    	if($("#btnPopSerial").parent().hasClass("btn_disabled") == false){
    	    // 바코드 체크
            var items = AUIGrid.getGridData(scanInfoGridId);

    	    var isComplete = true;
            $.each(items, function(i, row){
                if(row.serialChk == "Y" && Number(row.delvryQty) != Number(row.scanQty)){
                	isComplete = false;
                }
             });

            if(!isComplete){
            	Common.alert("Please, check the Serial Qty.");
            	return false;
            }
    	}

        if ($("#sGiptdate").val() == "") {
            Common.alert("Please select the GI Posting Date.");
            $("#sGiptdate").focus();
            return false;
          }

          if ($("#sGiptdate").val() < toDay) {
              Common.alert("Cannot select back date.");
              $("#sGiptdate").focus();
              return false;
            }

          if ($("#sGiptdate").val() > toDay) {
              Common.alert("Cannot select future date.");
              $("#sGiptdate").focus();
              return false;
            }

          if ($("#sGipfdate").val() == "") {
            Common.alert("Please select the GI Doc Date.");
            $("#sGipfdate").focus();
            return false;
          }

          if ($("#sGipfdate").val() < toDay) {
              Common.alert("Cannot select back date.");
              $("#sGipfdate").focus();
              return false;
            }

          if ($("#sGipfdate").val() > toDay) {
              Common.alert("Cannot select future date.");
              $("#sGipfdate").focus();
              return false;
            }


          var data = $("#stoIssueForm").serializeJSON();

          Common.ajax("POST"
        	 , "/logistics/stocktransfer/StocktransferGoodIssueNew.do"
        	 , data
        	 , function(result) {

        	     var message = result.message;
		         if("Already processed." == message){
		               Common.alert(result.message);
		         }else{
		               Common.alert(result.message + " <br/>"+ "MaterialDocumentNo : " + result.data);
		         }
		         if(result.code == "00"){
		             $("#btnClose").click();
		         }
            }
        	, function(jqXHR, textStatus, errorThrown) {
              Common.alert("Fail : " + jqXHR.responseJSON.message);
          });



    });

    $("#btnPopSerial").click(function(){
    	if($(this).parent().hasClass("btn_disabled") == true){
            return false;
        }

    	if(Common.checkPlatformType() == "mobile") {
            popupObj = Common.popupWin("stoIssueForm", "/logistics/serialMgmtNew/serialScanCommonPop.do", {width : "1000px", height : "720", resizable: "no", scrollbars: "yes"});
        } else{
            Common.popupDiv("/logistics/serialMgmtNew/serialScanCommonPop.do", null, null, true, '_serialScanPop');
        }
    });

    $("#btnPopSearch").click();
});

function fn_ClosePop(){
	// Moblie Popup Setting
    if(Common.checkPlatformType() == "mobile") {
        opener.fn_PopStoIssueClose();
    } else {
    	$('#_divStoIssuePop').remove();
    	$("#search").click();
    }
}

function fn_PopSerialClose(){
	if(popupObj!=null) popupObj.close();
	$("#btnPopSearch").click();
}

</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Good Issue Posting Data</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a id="btnClose" >CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

    <form id="stoIssueForm" name="giForm" method="POST">
        <input type="hidden" name="zTrnscType" id="zTrnscType" value="US" />
        <input type="hidden" name="zRstNo" id="zRstNo" />
        <input type="hidden" name="zFromLoc" id="zFromLoc" />
        <input type="hidden" name="zToLoc" id="zToLoc" />
        <input type="hidden" name="zIoType" id="zIoType" />
        <input type="hidden" name="zGtype" id="zGtype" />
        <input type="hidden" name="zPrgName" id="zPrgName" />

        <table class="type1">
	        <caption>search table</caption>
	        <colgroup>
	            <col style="width:150px" />
	            <col style="width:*" />
	        </colgroup>
	        <tbody>
	                <tr>
	                   <th scope="row">Delivery No</th>
	                   <td ><input id="zDelvryNo" name="zDelvryNo" type="text" placeholder="" class="w100p readonly" readonly /></td>
                    </tr>
	                <tr>
	                    <th scope="row">GI Posting Date</th>
	                    <td ><input id="sGiptdate" name="sGiptdate" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" /></td>
	                </tr>
	                <tr>
	                    <th scope="row">GI Doc Date</th>
	                    <td ><input id="sGipfdate" name="sGipfdate" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" /></td>
	                </tr>
	                <tr>
	                    <th scope="row">Header Text</th>
	                    <td><input type="text" name="doctext" id="doctext" maxlength="50" class="w100p"/></td>
	                </tr>
	        </tbody>
        </table>
    </form>

    <aside class="title_line">
       <h3>Serial Scan</h3>
	   <ul class="right_btns">
            <li style="display:none;"><p class="btn_grid"><a id="btnPopSearch">Search</a></p></li>
            <li><p class="btn_grid"><a id="btnPopSerial">Serial Scan</a></p></li>
	   </ul>
    </aside>

    <section class="search_result">
        <article class="grid_wrap">
            <div id="scanInfoGrid" style="height:350px;"></div>
        </article>
    </section>
    &nbsp;
    <ul class="center_btns">
        <li><p class="btn_blue2 big"><a id="btnPopIssueSave" >SAVE</a></p></li>
    </ul>

</section>
</div>