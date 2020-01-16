<!--=================================================================================================
* Task  : Logistics
* File Name : scanSearchPop.jsp
* Description : Scan Search
* Author : KR-JUN
* Date : 2019-11-26
* Change History :
* ------------------------------------------------------------------------------------------------
* [No]  [Date]        [Modifier]     [Contents]
* ------------------------------------------------------------------------------------------------
*  1     2019-11-26  KR-JUN        Init
*=================================================================================================-->
<!--=================================================================================================
  Common.popupWin("frmSearchScan", "/logistics/SerialMgmt/scanSearchPop.do", {width : "1000px", height : "720", resizable: "no", scrollbars: "yes"});

  if(Common.checkPlatformType() == "mobile") {
      popupObj = Common.popupWin("frmSearchScan", "/logistics/SerialMgmt/scanSearchPop.do", {width : "1000px", height : "1000px", height : "720", resizable: "no", scrollbars: "yes"});
  } else{
      Common.popupDiv("/logistics/SerialMgmt/scanSearchPop.do", null, null, true, '_scanSearchPop');
  }

function fnScanSearchResult(serialNo) {
    alert(serialNo);
}

<form id="frmSearchScan" name="frmSearchScan" method="post">
    <input id="pDeliveryNo" name="pDeliveryNo" type="hidden" value="" />
    <input id="pDeliveryItem" name="pDeliveryItem" type="hidden" value="" />
    <input id="pRequestNo" name="pRequestNo" type="hidden" value="SMO19112700002" />
    <input id="pRequestItem" name="pRequestItem" type="hidden" value="1" />
    <input id="pStatus" name="pStatus" type="hidden" value="I" />
    <input id="pSerialNo" name="pSerialNo" type="hidden" value="" />
</form>
*=================================================================================================-->
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/homecare-js-1.0.js"></script>

<script type="text/javaScript" language="javascript">
    var mainGridID;

    var codeList = [];
    <c:forEach var="list" items="${codeList446}">
    codeList.push({
        codeId : "${list.codeId}",
        codeMasterId : "${list.codeMasterId}",
        code : "${list.code}",
        codeName : "${list.codeName}",
        codeDesc : "${list.codeDesc}"
    });
    </c:forEach>

    $(document).ready(function() {

    	// Moblie Popup Setting
        Common.setMobilePopup(true, true, 'mainPopGrid');

        createAUIGrid();

        //doDefComboCode(getCodeList("MASTER", "", "446", "", "all"), '${pStatus}', 'searchStatus', 'S', '');
        doDefComboCode(codeList, '${pStatus}', 'searchStatus', 'S', '');

        $("#btnScanSearch").click(function() {
        	getScanPopList();
        });

        $("#btnScanClose").click(function() {
        	if(Common.checkPlatformType() == "mobile") {
        	    window.close();
        	}else{
        		$('#_scanSearchPop').remove();
        	}
        });

        if(  js.String.isNotEmpty($("#searchDeliveryNo").val())
          || js.String.isNotEmpty($("#searchRequestNo1").val())){
        	getScanPopList();
        }

    });

    function createAUIGrid() {
        var mainColumnLayout = [
            {dataField:"serialNo", headerText:"Serial No", width:180, height:30},
            {dataField:"itmCode", headerText:"Item Code", width:120, height:30},
            {dataField:"stkDesc", headerText:"Item Description Location", width:280, height:30, style:"aui-grid-user-custom-left"},
            {dataField:"stkTypeNm", headerText:"Item Type", width:100, height:30},
            {dataField:"fromWhLocDesc", headerText:"From Location", width:150, height:30, style:"aui-grid-user-custom-left"},
            {dataField:"toWhLocDesc", headerText:"To Location", width:150, height:30, style:"aui-grid-user-custom-left"}
        ];

        var mainGridOptions = {
            // 페이지 설정
            usePaging : true,
            // 한 화면에 출력되는 행 개수 10
            pageRowCount : 10,
            // 편집 가능 여부 (기본값 : false)
            editable : false,
            // 상태 칼럼 사용
            showStateColumn : false,
            displayTreeOpen: true,
            // 셀 선택모드 (기본값: singleCell)
            selectionMode : "multipleCells",
            headerHeight: 30,
            // 그룹핑 패널 사용
            useGroupingPanel : false,
            // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            skipReadonlyColumns: true,
            // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            wrapSelectionMove: true,
            // 줄번호 칼럼 렌더러 출력
            showRowNumColumn: true,
            noDataMessage : "<spring:message code='sys.info.grid.noDataMessage' />",
            groupingMessage : "<spring:message code='sys.info.grid.groupingMessage' />"
        };

        mainGridID = GridCommon.createAUIGrid("mainPopGrid", mainColumnLayout, "", mainGridOptions);

        AUIGrid.bind(mainGridID, "cellDoubleClick", function(event) {
            if (event.rowIndex > -1) {

            	if(Common.checkPlatformType() == "mobile") {
            		opener.fnScanSearchResult(AUIGrid.getCellValue(mainGridID, event.rowIndex, "serialNo"));
            		window.close();
            	}else{
            		fnScanSearchResult(AUIGrid.getCellValue(mainGridID, event.rowIndex, "serialNo"));
            		$('#_serialScanPop').remove();
            	}

            }
        });
    }

    function getScanPopList() {
    	/*
        if (!js.String.isEmpty($("#searchDeliveryNo").val()) || !js.String.isEmpty($("#searchDeliveryItem").val())) {
        	if (js.String.isEmpty($("#searchDeliveryNo").val()) || js.String.isEmpty($("#searchDeliveryItem").val())) {
        		Common.alert('Please Enter Delivery NO And Delivery Item.');
                return;
        	}
        }
        if (!js.String.isEmpty($("#searchRequestNo1").val()) || !js.String.isEmpty($("#searchRequestItem").val())) {
            if (js.String.isEmpty($("#searchRequestNo1").val()) || js.String.isEmpty($("#searchRequestItem").val())) {
                Common.alert('Please Enter Request NO And Request Item.');
                return;
            }
        }
        */

        if( js.String.isEmpty($("#searchDeliveryNo").val()) && js.String.isEmpty($("#searchRequestNo1").val() )){
        	Common.alert('Please Enter Delivery Info Or Request Info.');
            return;
        }

        var data = {searchDeliveryNo : $("#searchDeliveryNo").val(), searchDeliveryItem : $("#searchDeliveryItem").val(), searchRequestNo : $("#searchRequestNo1").val(), searchRequestItem : $("#searchRequestItem").val(), searchStatus : $("#searchStatus").val(), searchSerialNo : $("#searchSerialNo").val(), searchTrnscType : $("#searchTrnscType").val(), searchFromLoc : $("#searchFromLoc").val()};

        /*
        Common.ajaxSync("GET", "/logistics/SerialMgmt/scanSearchDataList.do", data, function(result) {
            var gridData = result;
            AUIGrid.setGridData(mainGridID, gridData.data);
        }, function (jqXHR, textStatus, errorThrown) {
            try { }
            catch (e) { }
            Common.alert("Fail : " + jqXHR.responseJSON.message);
        });
        */

        Common.ajax("GET" , "/logistics/SerialMgmt/scanSearchDataList.do", data, function(data){
            AUIGrid.setGridData(mainGridID, data.data);
        }, function (jqXHR, textStatus, errorThrown) {
            try { }
            catch (e) { }
            Common.alert("Fail : " + jqXHR.responseJSON.message);
        });

    }

    function getCodeList(codeType, codeId, codeMasterId, code, returnType) {
        var searchData = codeList.filter(function(e) {
            if (codeType == "ID") {
                return e.codeId == codeId;
            }
            else if (codeType == "CODE") {
                return e.codeMasterId == codeMasterId && e.code == code;
            }
            else if (codeType == "MASTER") {
                return e.codeMasterId == codeMasterId;
            }
            else {
                return e.code == code;
            }
        });

        if (searchData.length > 0) {
            if (returnType == "all") {
            	return searchData;
            }
            else {
            	return searchData[0].codeName;
            }
        }
        else {
            return "";
        }
    }
</script>

<section id="popup_wrap1" class="popup_wrap"><!-- content start -->
    <header class="pop_header"><!-- pop_header start -->
        <h1>Serial No. Scanning List</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a id="btnScanSearch"><span class="search"></span>Search</a></p></li>
            <li><p class="btn_blue2"><a id="btnScanClose"><span class="clear"></span>Close</a></p></li>
        </ul>
    </header><!-- pop_header end -->

    <section class="pop_body">
        <section class="search_table"><!-- search_table start -->
	        <form id="searchForm" name="searchForm">
	            <input type="hidden"  id="searchTrnscType" name="searchTrnscType" value="${pTrnscType}" />
	            <input type="hidden"  id="searchFromLoc" name="searchFromLoc" value="${pFromLoc}" />
	            <table class="type1"><!-- table start -->
	                <caption>table</caption>
	                <colgroup>
	                    <col style="width:35%" />
	                    <col style="width:*" />
	                </colgroup>
	                <tbody>
	                    <tr>
	                        <th scope="row"><span style="color:red">*</span> Delivery No / Item</th>
	                        <td>
	                            <div class="w100p">
	                                <input type="text"  id="searchDeliveryNo" name="searchDeliveryNo" style="width:50%;" value="${pDeliveryNo}" readonly class="readonly"/>
	                                <input type="text"  id="searchDeliveryItem" name="searchDeliveryItem" style="width:20%;" value="${pDeliveryItem}" readonly class="readonly"/>
	                            </div>
	                        </td>
	                    </tr>
	                    <tr>
	                        <th scope="row"><span style="color:red">*</span> Request No / Item</th>
	                        <td>
	                            <div class="w100p">
	                                <input type="text"  id="searchRequestNo1" name="searchRequestNo1" style="width:50%;" value="${pRequestNo}" readonly class="readonly"/>
	                                <input type="text"  id="searchRequestItem" name="searchRequestItem" style="width:20%;" value="${pRequestItem}" readonly class="readonly"/>
	                            </div>
	                        </td>
	                    </tr>
	                    <tr>
	                        <th scope="row"> Status</th>
	                        <td>
	                            <select class="w100p" id="searchStatus" name="searchStatus"><option value=''>Choose One</option></select>
	                        </td>
	                    </tr>
	                    <tr>
	                        <th scope="row"> Serial No</th>
	                        <td>
	                            <input type="text"  id="searchSerialNo" name="searchSerialNo"  class="w100p" value="${pSerialNo}" />
	                        </td>
	                    </tr>
	                </tbody>
	            </table><!-- table end -->
	        </form>
	        &nbsp;
	        &nbsp;
	    </section><!-- search_table end -->

	    <section class="search_result"><!-- search_result start -->
	        <article class="grid_wrap">
	            <div id="mainPopGrid" class="autoGridHeight"></div>
	        </article>
	    </section><!-- search_result end -->
    </section>
</section><!-- content end -->
