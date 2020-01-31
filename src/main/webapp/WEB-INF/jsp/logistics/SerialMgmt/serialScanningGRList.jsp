<!--=================================================================================================
* Task  : Logistics
* File Name : serialScanningGRList.jsp
* Description : GR Serial NO Scanning
* Author : KR-JUN
* Date : 2019-11-21
* Change History :
* ------------------------------------------------------------------------------------------------
* [No]  [Date]        [Modifier]     [Contents]
* ------------------------------------------------------------------------------------------------
*  1     2019-11-21  KR-JUN        Init
*=================================================================================================-->
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/homecare-js-1.0.js"></script>

<script type="text/javaScript" language="javascript">
    var mainGridID;

    var codeList = [];
    <c:forEach var="list" items="${codeList306}">
    codeList.push({
    	codeId : "${list.codeId}",
    	codeMasterId : "${list.codeMasterId}",
    	code : "${list.code}",
    	codeName : "${list.codeName}",
    	codeDesc : "${list.codeDesc}"
    });
    </c:forEach>

    <c:forEach var="list" items="${codeList308}">
    codeList.push({
    	codeId : "${list.codeId}",
        codeMasterId : "${list.codeMasterId}",
        code : "${list.code}",
        codeName : "${list.codeName}",
        codeDesc : "${list.codeDesc}"
    });
    </c:forEach>

    $(document).ready(function() {

    	 $("#wrap").css({"min-width":"100%"});
         $("#container").css({"min-width":"100%"});

    	createAUIGrid();

    	doGetComboData('/common/selectCodeList.do', { groupCode : 339 , orderValue : 'CODE'}, '${defLocType}', 'locType', 'M','f_multiCombo');
    	doGetComboData('/common/selectCodeList.do', { groupCode : 339 , orderValue : 'CODE'}, '', 'locTypeFrom', 'M','f_multiCombo');

    	 if(Common.checkPlatformType() == "mobile") {
    		 $(".path").css("display", "none");
             $("#btnMobileClose").attr("style", "");
         }

         $("#btnClose").click(function() {
             window.close();
         });

    	$("#search").click(function() {
        	getMainList();
        });

        $("#btnExcelDown").click(function() {
        	getMainListExcel();
        });
    });

    function createAUIGrid() {
    	var mainColumnLayout = [
            {dataField:"delno", headerText:"Delivery No", width:120, height:30, renderer:{type:"LinkRenderer", baseUrl:"javascript", jsCallback : function(rowIndex, columnIndex, value, item) {
            	getDeliveryPop(item.delno, item.reqstno, item.trnsctype, item.stktrans, item.reqsttype, item.frmlocid, item.tolocid);
            }}},
            {dataField:"deldate", headerText:"Delivery Date", width:100, editable:false, dataType:"date", dateInputFormat:"dd/mm/yyyy", formatString:"dd/mm/yyyy"},
            {dataField: "bndlNo",headerText :"Bundle No"        ,width:120    ,height:30                },
            {dataField: "ordno",headerText :"Order No."        ,width:100    ,height:30                },
            {
                dataField : "refDocNo",
                headerText : "<spring:message code='log.head.refdocno'/>",
                width : 120,
                height : 30
              },
            {dataField:"frmloc", headerText:"From Location", width:200, height:30, style:"aui-grid-user-custom-left"},
            {dataField:"delqty", headerText:"Qty", width:50, height:30, style:"aui-grid-user-custom-right"},
            {dataField:"trnsctype", headerText:"Transaction Type", width:130, height:30, labelFunction:function(rowIndex, columnIndex, value, headerText, item) {
            	return getCodeList("CODE", "", "306", item.trnsctype);
            }},
            {dataField:"trnsctypedtl", headerText:"Movement Type", width:220, height:30, labelFunction:function(rowIndex, columnIndex, value, headerText, item) {
                return getCodeList("CODE", "", "308", item.trnsctypedtl);
            }},
            {dataField:"reqsttype", headerText:"Req Type", width:80, height:30},
            //{dataField:"reqstno", headerText:"Request No", width:120, height:30},

        ];

    	var mainGridOptions = {
    	    // 페이지 설정
    	    usePaging : false,
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

    	mainGridID = GridCommon.createAUIGrid("mainGrid", mainColumnLayout, "", mainGridOptions);
    }

    function getMainList() {
    	if (FormUtil.isEmpty($("#searchDeliverySDate").val())) {
    		Common.alert('Please enter Required Date.');
            return;
    	}
        if (FormUtil.isEmpty($("#searchDeliveryEDate").val())) {
        	Common.alert('Please enter Required Date.');
            return;
        }

        var locCodeVal = $("#locCode option:selected").val();

        if( FormUtil.isEmpty(locCodeVal)) {
           Common.alert('Please enter Location Code.');
           return false;
        }

        Common.ajax("POST", "/logistics/SerialMgmt/serialScanningGRDataList.do", $("#searchForm").serializeJSON(), function (result) {
            AUIGrid.setGridData(mainGridID, result.data);
        });
    }

    function getCodeList(codeType, codeId, codeMasterId, code) {
        var searchData = codeList.filter(function(e) {
        	if (codeType == "ID") {
        		return e.code == code;
        	}
        	else if (codeType == "CODE") {
        		return e.codeMasterId == codeMasterId && e.code == code;
        	}
        	else {
        		return e.code == code;
        	}
        });

        if (searchData.length > 0) {
            return searchData[0].codeName;
        }
        else {
            return "";
        }
    }

    function getMainListExcel() {
        GridCommon.exportTo("mainGrid", "xlsx", "GR Serial No Scanning");
    }

    function getDeliveryPop(deliveryNo, reqstNo, transactionCode, transactionType, reqType, frmlocid, tolocid) {
    	if (transactionCode == "US") {
    		fn_goodReceiptPop(deliveryNo);
    	}
    	else if (transactionCode == "UM" && reqType == "PO") {
    		//alert("Inbound SMO 입고 팝업");
    		fn_InBoundIssuePop(deliveryNo, reqstNo, frmlocid, tolocid);
    	}
    	else if (transactionCode == "UM" && reqType != "PO") {
    		fn_smoIssueInPop(deliveryNo, reqstNo, frmlocid, tolocid);
    	}
    }

    // fn_InBound
    function fn_InBoundIssuePop(deliveryNo, reqstNo, frmlocid, tolocid){

        $("#zDelvryNo").val(deliveryNo);
        $("#zReqstno").val(reqstNo);
        $("#zReqloc").val(tolocid);
        $("#zRcvloc").val(frmlocid);

        if(Common.checkPlatformType() == "mobile") {
            popupObj = Common.popupWin("frmNew", "/logistics/inbound/inBoundIssueInPop.do", {width : "1000px", height : "720", resizable: "no", scrollbars: "yes"});
        } else{
            Common.popupDiv("/logistics/inbound/inBoundIssueInPop.do", null, null, true, '_divInBoundIssuePopMain');
        }
    }


    function fn_goodReceiptPop(deliveryNo, reqstNo, frmlocid, tolocid) {
        $("#zDelyno").val(deliveryNo);
        $("#zDelvryNo").val(deliveryNo);
        $("#zReqloc").val(tolocid);
        $("#zRcvloc").val(frmlocid);

        if(Common.checkPlatformType() == "mobile") {
            popupObj = Common.popupWin("frmNew", "/logistics/stocktransfer/goodReceiptPop.do", {width : "1000px", height : "720", resizable: "no", scrollbars: "yes"});
        } else{
            Common.popupDiv("/logistics/stocktransfer/goodReceiptPop.do", null, null, true, '_divStoIssuePop');
        }
    }

    function fn_smoIssueInPop(deliveryNo, reqstNo, frmlocid, tolocid){

        $("#zDelvryNo").val(deliveryNo);
        $("#zReqstno").val(reqstNo);
        $("#zReqloc").val(tolocid);
        $("#zRcvloc").val(frmlocid);

        if(Common.checkPlatformType() == "mobile") {
            popupObj = Common.popupWin("frmNew", "/logistics/stockMovement/smoIssueInPop.do", {width : "1000px", height : "720", resizable: "no", scrollbars: "yes"});
        } else{
            Common.popupDiv("/logistics/stockMovement/smoIssueInPop.do", null, null, true, '_divSmoIssuePop');
        }
    }

    function fn_PopSmoIssueClose(){
        if(popupObj!=null) popupObj.close();
        getMainList();
    }

    function SearchListAjax() {
    	getMainList();
    }

    function fn_PopInBoundIssueClose(){
        if(popupObj!=null) popupObj.close();
        getMainList();
    }

    function f_multiCombo() {
        $(function() {
            $('#locType').change(function() {
                if ($('#locType').val() != null && $('#locType').val() != "" ){
                    var searchlocgb = $('#locType').val();

                    var locgbparam = "";
                    for (var i = 0 ; i < searchlocgb.length ; i++){
                        if (locgbparam == ""){
                            locgbparam = searchlocgb[i];
                         }else{
                            locgbparam = locgbparam +"∈"+searchlocgb[i];
                         }
                     }

                     var param = {searchlocgb:locgbparam , grade:""}
                     CommonCombo.make('locCode', '/common/selectStockLocationList2.do', param , '${defLocCode}', {type: 'M', id:'codeId', name:'codeName', width:'50%', isCheckAll:false});
                  }
            }).multipleSelect({
                selectAll : true
            });

            $('#locTypeFrom').change(function() {
                if ($('#locTypeFrom').val() != null && $('#locTypeFrom').val() != "" ){
                    var searchlocgb = $('#locTypeFrom').val();

                    var locgbparam = "";
                    for (var i = 0 ; i < searchlocgb.length ; i++){
                        if (locgbparam == ""){
                            locgbparam = searchlocgb[i];
                         }else{
                            locgbparam = locgbparam +"∈"+searchlocgb[i];
                         }
                     }

                     var param = {searchlocgb:locgbparam , grade:""}
                     CommonCombo.make('locCodeFrom', '/common/selectStockLocationList2.do', param , '', {type: 'M', id:'codeId', name:'codeName', width:'50%', isCheckAll:false});
                  }
            }).multipleSelect({
                selectAll : true
            });
        });
    }

    function f_multiComboType() {
        $(function() {
            $('#locCode').change(function() {
            }).multipleSelect({
                selectAll : true
            });
        });
    }

    function fn_PopClose(){
        if(popupObj!=null) popupObj.close();
        $("#search").click();
    }
</script>

<section id="content"><!-- content start -->
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
        <li>Logistics</li>
        <li>S/N Management</li>
        <li>GR S/N Scanning</li>
    </ul>

    <aside class="title_line"><!-- title_line start -->
        <p class="fav"><a href="#" class="click_add_on">My menu</a></p>
        <h2>GR S/N Scanning</h2>

        <ul class="right_btns">
            <li><p class="btn_blue"><a id="search"><span class="search"></span>Search</a></p></li>
            <li id="btnMobileClose" style="display:none"><p class="btn_blue"><a id="btnClose" style="min-width:10px!important;width:10px!important"><span class="clear"></span></a></p></li>
        </ul>
    </aside><!-- title_line end -->

    <section class="search_table"><!-- search_table start -->
        <form id="searchForm" name="searchForm">
            <table class="type1"><!-- table start -->
                <caption>table</caption>
                <colgroup>
                    <col style="width:26%" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">Delivery Date<span class="must">*</span></th>
                        <td>
                            <div class="date_set w100p">
                                <!-- date_set start -->
                                <p>
                                    <input id="searchDeliverySDate" name="searchDeliverySDate" type="text" title="Delivery Start Date" placeholder="DD/MM/YYYY" class="j_date" value="${GR_FROM_DT}" readonly/>
                                </p>
                                <span> To </span>
                                <p>
                                    <input id="searchDeliveryEDate" name="searchDeliveryEDate" type="text" title="Delivery End Date" placeholder="DD/MM/YYYY" class="j_date" value="${GR_TO_DT}" readonly/>
                                </p>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">To Location<span class="must">*</span></th>
                        <td>
                            <select id="locType" name="locType[]" multiple="multiple" style="width:100px"></select>
                            <select id="locCode" name="locCode[]"><option value="">Choose One</option></select>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">From Location</th>
                        <td>
                            <select id="locTypeFrom" name="locTypeFrom[]" multiple="multiple" style="width:100px"></select>
                            <select id="locCodeFrom" name="locCodeFrom[]" multiple="multiple" style="width:350px"><option value="">Choose One</option></select>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Delivery No.<br />/ Request No</th>
                        <td>
                            <input type="text"  id="searchDeliveryOrRequestNo" name="searchDeliveryOrRequestNo"  class="w100p" />
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Bundle/Ord. /Ref.</th>
                        <td>
                            <input type="text"  id="searchRequestNo2" name="searchRequestNo2"  class="w100p" />
                        </td>
                    </tr>
                </tbody>
            </table><!-- table end -->
        </form>
    </section><!-- search_table end -->

    <section class="search_result"><!-- search_result start -->
        <ul class="right_btns">
            <li><p class="btn_grid"><a href="#" id="btnExcelDown">EXCEL DW</a></p></li>
        </ul>
		<article class="grid_wrap">
            <div id="mainGrid" class="autoGridHeight"></div>
        </article>
    </section><!-- search_result end -->
    <form id="frmNew" name="frmNew" action="#" method="post">
        <input type="hidden" name="zDelyno" id="zDelyno" />
        <input type="hidden" name="zReqloc" id="zReqloc" />
        <input type="hidden" name="zRcvloc" id="zRcvloc" />
        <input type="hidden" name="searchId" id="searchId" value="search" />
        <input type="hidden" name="zDelvryNo" id="zDelvryNo" />
        <input type="hidden" name="zReqstno" id="zReqstno" />
    </form>
</section><!-- content end -->