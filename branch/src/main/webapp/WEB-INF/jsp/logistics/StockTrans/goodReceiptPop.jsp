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
	var popupObj;
	var listPopGrid;
	var gipDate = '${gipDate}';

	var scanInfoLayout = [
          {dataField:"delvryNo", visible:false}
        , {dataField:"delvryNoItm", visible:false}
        , {dataField:"delGiCmplt", visible:false}
        , {dataField:"itmCode", headerText:"Item Code", width:120}
        , {dataField:"itmName", headerText:"Item Description", width:280, style:"aui-grid-user-custom-left"}
        , {dataField:"serialChk", headerText:"Serial Chk", width:100}
        , {dataField:"delvryQty", headerText:"DELVRY QTY", width:100
            , style:"aui-grid-user-custom-right"
            , dataType:"numeric"
            , formatString:"#,##0"
        }
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
	    Common.setMobilePopup(true, false,'');
	    listPopGrid = GridCommon.createAUIGrid("listPopGrid", scanInfoLayout, null, scanInfoPros);

	    if(Common.checkPlatformType() == "mobile") {
	    	$("#zDelyNo").val("${param.zDelyno}");    // delivery No
	    	$("#zFromLoc").val("${param.zReqloc}");
	    	$("#zToLoc").val("${param.zRcvloc}");
	    	//$("#zIoType").val("O");

	    } else {
	    	$("#zDelyNo").val($("#zDelyno").val());
	        $("#zFromLoc").val($("#zReqloc").val());
	        $("#zToLoc").val($("#zRcvloc").val());
	        //$("#zIoType").val("O");
	    }
	    // 조회
	    fn_search();

	    // Close 버튼 이벤트
	    $("#btnClose").click(function() {
	    	fn_ClosePop();
	    });
	    // Save 버튼 이벤트
	    $("#btnSave").click(function() {
	    	if(!fn_saveVaild()) return;
	    	// 저장
	    	fn_grFuncSerial();
	    });
	});

    // 유효성 체크
    function fn_saveVaild() {
        if ($("#sGiptdate").val() == "") {
            Common.alert("Please select the GI Posting Date.");
            return false;
        }
        if ($("#sGiptdate").val() < gipDate) {
            Common.alert("Cannot select back date.");
            return false;
        }
        if ($("#sGiptdate").val() > gipDate) {
            Common.alert("Cannot select future date.");
            return false;
        }

        if ($("#sGipfdate").val() == "") {
          Common.alert("Please select the GI Doc Date.");
          return false;
        }
        if ($("#sGipfdate").val() < gipDate) {
            Common.alert("Cannot select back date.");
            return false;
        }
        if ($("#sGipfdate").val() > gipDate) {
            Common.alert("Cannot select future date.");
            return false;
        }

        return true;
    }

    // 저장
    function fn_grFuncSerial() {
        Common.ajax("POST", "/logistics/stocktransfer/StockTransferDeliveryIssueSerial.do", $("#stoIssueForm").serializeJSON(), function(result) {
            var message =result.message;

            if("00" != result.code) { // 성공이 아닌경우.
                Common.alert(message);
            } else {  // SUCCESS
                Common.alert(message + "<br/>MDN NO : " + result.data);
                fn_ClosePop();
                // 재조회 한다.
                if($('#searchId') != null) $('#'+$('#searchId').val()).click();
            }

        }, function(jqXHR, textStatus, errorThrown) {
            Common.alert("Fail : " + jqXHR.responseJSON.message);
        });
    }

    // 조회
    function fn_search() {
        var arrDelvryNo = ($("#zDelyNo").val()).split(',');

        if(arrDelvryNo.length == 0){
            Common.alert("Please, check the mandatory value.");
            return false;
        }
        // 초기화
        AUIGrid.setGridData(listPopGrid, []);
        $("#delyno").val(arrDelvryNo);
        $("#sGiptdate").val(gipDate);
        $("#sGipfdate").val(gipDate);

        Common.ajax("GET", "/logistics/stocktransfer/goodReceiptPopList.do", $("#stoIssueForm").serialize(), function(data){
            AUIGrid.setGridData(listPopGrid, data);
        });
    }

	function fn_ClosePop() {
		// Moblie Popup Setting
	    if(Common.checkPlatformType() == "mobile") {
	    	opener.fn_PopClose();
	    } else {
	    	if($('#_divStoIssuePop') != null) $('#_divStoIssuePop').remove();
	    	$("#search").click();
	    }
	}

</script>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
<header class="pop_header"><!-- pop_header start -->
<h1>Good Receipt</h1>
<ul class="right_opt">
    <li><p class="btn_blue2 big"><a id="btnSave" >SAVE</a></p></li>
    <li><p class="btn_blue2"><a id="btnClose" >CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
    <form id="stoIssueForm" name="giForm" method="POST">
        <input type="hidden" name="zTrnscType" id="zTrnscType" value="US" />
        <input type="hidden" name="gtype" id="gtype" value="GR" />
        <input type="hidden" name="zIoType" id="zIoType" value="I" />
        <input type="hidden" name="delyno" id="delyno" />
        <table class="type1">
	        <caption>search table</caption>
	        <colgroup>
	            <col style="width:150px" />
	            <col style="width:*" />
	        </colgroup>
	        <tbody>
                <tr>
                   <th scope="row">Delivery No</th>
                   <td ><input id="zDelyNo" name="zDelyNo" type="text" placeholder="" class="w100p readonly" readonly /></td>
                   </tr>
                <tr>
                    <th scope="row"><span class="must">*</span>GR Posting Date</th>
                    <td ><input id="sGiptdate" name="giptdate" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" /></td>
                </tr>
                <tr>
                    <th scope="row"><span class="must">*</span>GR Doc Date</th>
                    <td ><input id="sGipfdate" name="gipfdate" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" /></td>
                </tr>
                <tr>
                    <th scope="row">Header Text</th>
                    <td><input type="text" name="doctext" id="doctext" maxlength="50" class="w100p"/></td>
                </tr>
	        </tbody>
        </table>
    </form>
    <section class="search_result">
        <article class="grid_wrap">
            <div id="listPopGrid" class="autoGridHeight"></div>
        </article>
    </section>
    &nbsp;
    <ul class="center_btns autoFixArea">

    </ul>

</section>
</div>