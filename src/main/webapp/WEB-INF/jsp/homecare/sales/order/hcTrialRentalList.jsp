<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">

    //AUIGrid 생성 후 반환 ID
    var listMyGridID;
    var IS_3RD_PARTY = '${SESSION_INFO.userIsExternal}';
    var MEM_TYPE     = '${SESSION_INFO.userTypeId}';
    //var salesmanCode = '${SESSION_INFO.userName}';

    var _option = {
        width : "1200px", // 창 가로 크기
        height : "800px" // 창 세로 크기
    };

    var codeList_10 = [];
    <c:forEach var="obj" items="${codeList_10}">
    codeList_10.push({codeId:"${obj.codeId}", codeName:"${obj.codeName}", code:"${obj.code}"});
    </c:forEach>

    var branchCdList_1 = [];
    <c:forEach var="obj" items="${branchCdList_1}">
    branchCdList_1.push({codeId:"${obj.codeId}", codeName:"${obj.codeName}", code:"${obj.code}"});
    </c:forEach>

    // StatusCategory Code
    var categoryCdList = [];
    <c:forEach var="obj" items="${categoryCdList}">
    categoryCdList.push({codeId:"${obj.code}", codeName:"${obj.codeName}", code:"${obj.code}"});
    </c:forEach>

    var productList = [];
    <c:forEach var="obj" items="${productList_1}">
    productList.push({codeId:"${obj.code}", codeName:"${obj.codeName}", code:"${obj.code}"});
    </c:forEach>

    $(document).ready(function(){
        //AUIGrid 그리드를 생성합니다.
        createAUIGrid();
        if("${SESSION_INFO.userTypeId}" == "2" ){

            if("${SESSION_INFO.memberLevel}" =="3" || "${SESSION_INFO.memberLevel}" =="4"){
                $("#btnReq").hide();
            }
        }

        if("${SESSION_INFO.userTypeId}" != "4" && "${SESSION_INFO.userTypeId}" != "6") {
            $("#orgCode").attr("readonly", true);
            $("#orgCode").val("${orgCode}".trim());
            $("#grpCode").attr("readonly", true);
            $("#grpCode").val("${grpCode}".trim());
            $("#deptCode").attr("readonly", true);
            $("#deptCode").val("${deptCode}".trim());
        }

        // 셀 더블클릭 이벤트 바인딩
        AUIGrid.bind(listMyGridID, "cellDoubleClick", function(event) {
            if(IS_3RD_PARTY == '0') {
                fn_setDetail(listMyGridID, event.rowIndex);
            } else {
                Common.alert('<spring:message code="sal.alert.msg.accRights" />' + DEFAULT_DELIMITER + '<b><spring:message code="sal.alert.msg.noAccRights" /></b>');
            }
        });

        doDefCombo(productList, '' ,'listProductId', 'M', 'fn_multiCombo');
        doDefCombo(branchCdList_1, '' ,'listKeyinBrnchId', 'M', 'fn_multiCombo');


        doGetComboSepa('/homecare/selectHomecareDscBranchList.do',  '', ' - ', '',   'listDscBrnchId', 'M', 'fn_multiCombo'); //Branch Code

    });



    // 컬럼 선택시 상세정보 세팅.
    function fn_setDetail(gridID, rowIdx){
        //(_url, _jsonObj, _callback, _isManualClose, _divId, _initFunc)
        Common.popupDiv("/sales/order/orderDetailPop.do", { salesOrderId : AUIGrid.getCellValue(gridID, rowIdx, "ordId") }, null, true, "_divIdOrdDtl");
    }

    // 리스트 조회.
    function fn_selectListAjax() {
        // console.log($("#listSearchForm").serialize());

   	 Common.ajax("GET", "/homecare/sales/order/selectHcTrialRentalList", $("#listSearchForm").serialize(), function(result) {
            AUIGrid.setGridData(listMyGridID, result);
        });
    }


    $(function(){

        $('#btnSrch').click(function() {
            if(fn_validSearchList()) fn_selectListAjax();
        });
        $('#btnClear').click(function() {
            //$('#listSearchForm').clearForm();
            window.location.reload();
        });
        $('#btnConvrt').click(function() {
        	var selIdx = AUIGrid.getSelectedIndex(listMyGridID)[0];

            if(selIdx > -1) {
            	var ordId = AUIGrid.getCellValue(listMyGridID, selIdx, "ordId");
                var ordStusId = AUIGrid.getCellValue(listMyGridID, selIdx, "ordStusId");

                if(ordStusId == '4' ){
                	Common.popupDiv("/homecare/sales/order/hcTrialRentalConvertPop.do", {ordId : AUIGrid.getCellValue(listMyGridID, selIdx, "ordId")}, null , true);
                }
                else{
                	Common.alert('Failed to Convert Order' + DEFAULT_DELIMITER + '<b>This order is not in complete status.<br/>Convert order is disallowed.</b>');
                }
            }
            else {
                Common.alert('<spring:message code="sal.alert.msg.ordMiss" />' + DEFAULT_DELIMITER + '<b><spring:message code="sal.alert.msg.noOrdSel" /></b>');
            }

            //Common.popupDiv("/homecare/sales/order/hcTrialRentalConvertPop.do", {custId: "948884", productId : "2116", productName : "500001 - COWAY MASSAGE CHAIR (MC-ST01B)"}, null , true);
            });
        $('#btnExport').click(function() {

            var grdLength = "0";
            grdLength = AUIGrid.getGridData(listMyGridID).length;

            if(Number(grdLength) > 0){
                GridCommon.exportTo("#list_grid_wrap", "xlsx", "SalesSearchResultList");

            }else{
                Common.alert('* <spring:message code="sal.alert.msg.noExport" />');
            }

        });
        $('#btnEKeyIn').click(function() {
            Common.popupDiv("/sales/order/orderEKeyInListPop.do", null, null, true);
        });
        $('#btnRentalPaySet').click(function() {
            Common.popupDiv("/sales/order/orderRentalPaySettingUpdateListPop.do", null, null, true);
        });
        $('#btnSof').click(function() {
            Common.popupDiv("/sales/order/orderSOFListPop.do", null, null, true);
        });
        $('#btnMSof').click(function() {
            Common.popupDiv("/sales/order/orderMSOFListPop.do", null, null, true);
        });
        $('#btnDdCrc').click(function() {
            Common.popupDiv("/sales/order/orderDDCRCListPop.do", null, null, true);
        });
        $('#btnAsoSales').click(function() {
            Common.popupDiv("/sales/order/orderASOSalesReportPop.do", null, null, true);
        });
        $('#btnYsListing').click(function() {
            Common.popupDiv("/sales/order/orderSalesYSListingPop.do", null, null, true);
        });
        $('#_btnLedger1').click(function() {
            var selIdx = AUIGrid.getSelectedIndex(listMyGridID)[0];

            if(selIdx > -1) {
                $('#_ordId').val(AUIGrid.getCellValue(listMyGridID, selIdx, "ordId"));
                Common.popupWin("_frmLedger", "/sales/order/orderLedgerViewPop.do", {width : "1000px", height : "720", resizable: "no", scrollbars: "no"});
            }
            else {
                Common.alert('<spring:message code="sal.alert.msg.ordMiss" />' + DEFAULT_DELIMITER + '<b><spring:message code="sal.alert.msg.noOrdSel" /></b>');
            }
        });
        $('#_btnLedger2').click(function() {
            var selIdx = AUIGrid.getSelectedIndex(listMyGridID)[0];

            if(selIdx > -1) {
                $('#_ordId').val(AUIGrid.getCellValue(listMyGridID, selIdx, "ordId"));
                Common.popupWin("_frmLedger", "/sales/order/orderLedger2ViewPop.do", {width : "1000px", height : "720", resizable: "no", scrollbars: "no"});
            }
            else {
                Common.alert('<spring:message code="sal.alert.msg.ordMiss" />' + DEFAULT_DELIMITER + '<b><spring:message code="sal.alert.msg.noOrdSel" /></b>');
            }
        });
        $('#_btnTaxInvc').click(function() {
            fn_invoicePop();
        });
        $("#btnOrderOverview").click(function() {

            //Param Set
            var gridObj = AUIGrid.getSelectedItems(listMyGridID);


            if(gridObj == null || gridObj.length <= 0 ){
                Common.alert("* No Record Selected. ");
                return;
            }

            var orderid = gridObj[0].item.ordId;
            $("#_orderID").val(orderid);
            console.log("ordId : " + $("#_orderID").val());

            fn_report();
            //Common.alert('The program is under development.');
        });

        $('#btnAutoDebitMatrix').click(function(){
            var selIdx = AUIGrid.getSelectedIndex(listMyGridID)[0];

            if(selIdx > -1) {
// //                 var prodCat = AUIGrid.getCellValue(listMyGridID, selIdx, "homecare");

// //                 if(prodCat ==  1) {
// //                     Common.alert('* Please proceed to HC Module for this action');
// //                 }
// //                 else{

//                     $('#ordId').val(AUIGrid.getCellValue(listMyGridID, selIdx, "ordId"));
//                     Common.popupWin("_frmAutoDebit", "/sales/order/autoDebitMatrixPop.do" , {width : "1000px", height : "720", resizable: "no", scrollbars: "no"});
// //                 }

                var appTypeId = AUIGrid.getSelectedItems(listMyGridID)[0].item.appTypeId;

                  if(appTypeId == '66'){
                     $('#ordId').val(AUIGrid.getCellValue(listMyGridID, selIdx, "ordId"));
                     Common.popupWin("_frmAutoDebit", "/sales/order/autoDebitMatrixPop.do" , {width : "1000px", height : "720", resizable: "no", scrollbars: "no"});

                  }else {
                      Common.alert('* Not available for Auto Debit Matrix.');
                  }
            }
            else {
                Common.alert('<spring:message code="sal.alert.msg.ordMiss" />' + DEFAULT_DELIMITER + '<b><spring:message code="sal.alert.msg.noOrdSel" /></b>');
            }
      });
    });


    function fn_validSearchList() {
        var isValid = true, msg = "";

        if(FormUtil.isEmpty($('#listOrdNo').val())
        && FormUtil.isEmpty($('#listCustId').val())
//      && FormUtil.isEmpty($('#listCustName').val())
        && FormUtil.isEmpty($('#listCustIc').val())
        && FormUtil.isEmpty($('#listSalesmanCode').val())
        && FormUtil.isEmpty($('#listPromoCode').val())
        ) {

            if(FormUtil.isEmpty($('#listTrialStartDt').val()) || FormUtil.isEmpty($('#listTrialEndDt').val())) {
                isValid = false;
                msg += '* <spring:message code="sal.alert.msg.selTrialDt" /><br/>';
            }
        }

        if(!isValid) Common.alert('<spring:message code="sal.title.text.ordSrch" />' + DEFAULT_DELIMITER + "<b>"+msg+"</b>");

        return isValid;
    }

    function createAUIGrid() {

        //AUIGrid 칼럼 설정
        var columnLayout = [
            {headerText : "<spring:message code='sales.OrderNo'/>",           dataField : "ordNo",                editable : false, width : 150}
          , {headerText : "<spring:message code='sales.trialRenStus1'/>",       dataField : "ordStusCode",        editable : false, width : 150}
       //   , {headerText : "<spring:message code='sales.AppType'/>",           dataField : "appTypeCode",      editable : false, width : 130}
          , {headerText : "<spring:message code='sales.ordDt'/>",               dataField : "ordDt",                  editable : false, width : 150}
          , {headerText : "<spring:message code='sales.refNo2'/>",              dataField : "refNo",                 editable : false, width : 180}
          , {headerText : "<spring:message code='sales.prod'/>",                 dataField : "productName",      editable : false, width : 280}
          , {headerText : "<spring:message code='sales.cusName'/>",          dataField : "custName",           editable : false, width : 350}
          , {headerText : "<spring:message code='sal.text.salPersonCode'/>",   dataField : "salesmanCode",      editable : false, width : 180}
          , {headerText : "<spring:message code='sales.trialRenStrDt'/>",   dataField : "trialrenStartDt",      editable : false, width : 150}
          , {headerText : "<spring:message code='sales.trialRenEndDt'/>",   dataField : "trialrenEndDt",      editable : false, width : 150}
          , {headerText : "<spring:message code='sales.trialRenUsg'/>",   dataField : "trialrenUsage",      editable : false, width : 180}
          , {headerText : "<spring:message code='sal.text.lastUpdateAtByUsr'/>",   dataField : "lastUpdUsr",      editable : false, width : 180}
          , {headerText : "<spring:message code='sal.text.lastUpdateAtByDt'/>",   dataField : "lastUpdDt",      editable : false, width : 180}
          , {headerText : "ordId",                                                              dataField : "ordId",                  visible   : false}
          , {headerText : "ordStusId",                                                           dataField : "ordStusId",        visible   : false}
            ];

        //그리드 속성 설정
        var gridPros = {
            usePaging           : true,         //페이징 사용
            pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)
            editable            : false,
            fixedColumnCount    : 1,
            showStateColumn     : false,
            displayTreeOpen     : false,
          //selectionMode       : "singleRow",  //"multipleCells",
            headerHeight        : 30,
            useGroupingPanel    : false,        //그룹핑 패널 사용
            skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력
            noDataMessage       : "No order found.",
            groupingMessage     : "Here groupping"
        };

        listMyGridID = GridCommon.createAUIGrid("list_grid_wrap", columnLayout, "", gridPros);
    }

    function fn_multiCombo(){
        $('#listKeyinBrnchId').change(function() {
            //console.log($(this).val());
        }).multipleSelect({
            selectAll: true, // 전체선택
            width: '100%'
        });
        $('#listDscBrnchId').change(function() {
            //console.log($(this).val());
        }).multipleSelect({
            selectAll: true, // 전체선택
            width: '100%'
        });
        $('#listOrdStusId').multipleSelect("checkAll");
        $('#listOrdStusId').change(function() {
            //console.log($(this).val());
        }).multipleSelect({
            selectAll: true, // 전체선택
            width: '100%'
        });
        $('#listProductId').change(function() {
            //console.log($(this).val());
        }).multipleSelect({
            selectAll: true, // 전체선택
            width: '100%'
        });
        $("#listProductId").multipleSelect("checkAll");
    }

    function fn_multiCombo2(){
        $('#listAppType').change(function() {
            //console.log($(this).val());
        }).multipleSelect({
            selectAll: true, // 전체선택
            width: '100%'
        });
        $('#listAppType').multipleSelect("checkAll");
    }

    function fn_invoicePop() {
        Common.popupDiv("/payment/initTaxInvoiceRentalPop.do", '', null, true);
    }

    function fn_checkAccessModify(tabNm) {

        var isValid = true;

        if(tabNm == 'BSC' && '${PAGE_AUTH.funcUserDefine4}'  != 'Y') {
            isValid = false;
        } else if(tabNm == 'MAL' && '${PAGE_AUTH.funcUserDefine10}' != 'Y') {
            isValid = false;
        } else if(tabNm == 'CNT' && '${PAGE_AUTH.funcUserDefine5}'  != 'Y') {
            isValid = false;
        } else if(tabNm == 'NRC' && '${PAGE_AUTH.funcUserDefine6}'  != 'Y') {
            isValid = false;
        } else if(tabNm == 'INS' && '${PAGE_AUTH.funcUserDefine9}'  != 'Y') {
            isValid = false;
        } else if(tabNm == 'PAY' && '${PAGE_AUTH.funcUserDefine11}' != 'Y') {
            isValid = false;
        } else if(tabNm == 'DOC' && '${PAGE_AUTH.funcUserDefine7}'  != 'Y') {
            isValid = false;
        } else if(tabNm == 'RFR' && '${PAGE_AUTH.funcUserDefine13}' != 'Y') {
            isValid = false;
        } else if(tabNm == 'PRM' && '${PAGE_AUTH.funcUserDefine12}' != 'Y') {
            isValid = false;
        } else if(tabNm == 'GST' && '${PAGE_AUTH.funcUserDefine8}'  != 'Y') {
            isValid = false;
        }

        if (!isValid) {
            Common.alert('<spring:message code="sal.alert.msg.accRights" />' + DEFAULT_DELIMITER + '<b><spring:message code="sal.alert.msg.noAccRights" /></b>');
        }

        return isValid;
    }

    function fn_checkAccessRequest(tabNm) {

        var isValid = true, msg = "";

        if(tabNm == 'CANC' && '${PAGE_AUTH.funcUserDefine15}'  != 'Y') {
            isValid = false;
        } else if(tabNm == 'PEXC' && '${PAGE_AUTH.funcUserDefine17}' != 'Y') {
            isValid = false;
        } else if(tabNm == 'SCHM' && '${PAGE_AUTH.funcUserDefine18}' != 'Y') {
            isValid = false;
        } else if(tabNm == 'AEXC' && '${PAGE_AUTH.funcUserDefine14}' != 'Y') {
            isValid = false;
        } else if(tabNm == 'OTRN' && '${PAGE_AUTH.funcUserDefine16}' != 'Y') {
            isValid = false;
        }

        if (!isValid) {
            Common.alert('<spring:message code="sal.alert.msg.accRights" />' + DEFAULT_DELIMITER + '<b><spring:message code="sal.alert.msg.noAccRights" /></b>');
        }

        return isValid;
    }

    function fn_report() {
        var option = {
            isProcedure : false
        };
        Common.report("dataForm2", option);
    }


    $.fn.clearForm = function() {
        return this.each(function() {
            var type = this.type, tag = this.tagName.toLowerCase();
            if (tag === 'form'){
                return $(':input',this).clearForm();
            }
            if (type === 'text' || type === 'password' || type === 'hidden' || type === 'file' || tag === 'textarea'){
                this.value = '';
            }else if (type === 'checkbox' || type === 'radio'){
                this.checked = false;
            }else if (tag === 'select'){
                this.selectedIndex = 0;
            }
        });
    };

    function fn_excelDown(){
        // type : "xlsx", "csv", "txt", "xml", "json", "pdf", "object"
    	GridCommon.exportTo("list_grid_wrap", "xlsx", "Trial Rental (HC)");
    }

</script>

<section id="content">
    <!-- content start -->
    <ul class="path">
        <li><img
            src="${pageContext.request.contextPath}/resources/images/common/path_home.gif"
            alt="Home" /></li>
        <li><spring:message code='sales.path.sales' /></li>
        <li><spring:message code='sales.path.order' /></li>
    </ul>

    <aside class="title_line">
        <!-- title_line start -->
        <p class="fav">
            <a href="#" class="click_add_on">My menu</a>
        </p>
        <h2>
            <spring:message code='sales.title.trialRentalList' />
        </h2>
        <ul class="right_btns">

            <li><p class="btn_blue">
                    <a id="btnConvrt" href="#">
                    <spring:message code='sales.Convert' /></a>
                </p></li>
            <li><p class="btn_blue">
                    <a id="btnSrch" href="#"><span class="search"></span>
                    <spring:message code='sales.Search' /></a>
                </p></li>
            <li><p class="btn_blue">
                    <a id="btnClear" href="#"><span class="clear"></span>
                    <spring:message code='sales.Clear' /></a>
                </p></li>
        </ul>
    </aside>
    <!-- title_line end -->

    <section class="search_table">
        <!-- search_table start -->
        <!-- Ledger Form -->
        <form id="_frmLedger" name="frmLedger" action="#" method="post">
            <input id="_ordId" name="ordId" type="hidden" value="" />
        </form>
        <!-- report Form -->
        <form id="dataForm">
            <input type="hidden" id="fileName" name="reportFileName"
                value="/sales/CustVALetter.rpt" />
            <!-- Report Name  -->
            <input type="hidden" id="viewType" name="viewType" value="PDF" />
            <!-- View Type  -->
            <input type="hidden" id="downFileName" name="reportDownFileName"
                value="" />
            <!-- Download Name -->

            <!-- params -->
            <input type="hidden" id="_repCustId" name="@CustID" />
        </form>

        <!-- order overview report Form -->
        <form id="dataForm2">
            <input type="hidden" id="reportFileName" name="reportFileName"
                value="/sales/OrderOverview.rpt" />
            <!-- Report Name  -->
            <input type="hidden" id="viewType" name="viewType" value="PDF" />
            <input id="tabHcAutoDebitandEcash" name="tabHcAutoDebitandEcash" type="hidden" value='${PAGE_AUTH.funcUserDefine30}'/>
            <!-- View Type  -->
            <!-- <input type="hidden" id="reportDownFileName" name="reportDownFileName" value="1231236" /> -->
            <!-- Download Name -->

            <!-- params -->
            <input type="hidden" id="_orderID" name="@OrderID" />
        </form>


        <form id="listSearchForm" name="listSearchForm" action="#" method="post" autocomplete=off>
            <input id="listSalesOrderId" name="salesOrderId" type="hidden" />
            <input id="pdpaMonth" name="pdpaMonth" type="hidden" value='${PAGE_AUTH.pdpaMonth}'/>
            <!--  <input id="memId" name="memId" type="hidden" value="${memId}"/>-->
            <table class="type1">
                <!-- table start -->
                <caption>table</caption>
                <colgroup>
                    <col style="width: 130px" />
                    <col style="width: *" />
                    <col style="width: 160px" />
                    <col style="width: *" />
                    <col style="width: 190px" />
                    <col style="width: *" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row"><spring:message code='sales.OrderNo' /></th>
                        <td><input id="listOrdNo" name="ordNo" type="text" title="Order No" placeholder="<spring:message code='sales.OrderNo'/>" class="w100p" /></td>
                        <th scope="row"></th>
                        <td></td>
                        <th scope="row"><spring:message code='sales.trialDt' /></th>
                        <td>
                            <div class="date_set w100p">
                                <!-- date_set start -->
                                <p>
                               <%--      <input id="listOrdStartDt" name="ordStartDt" type="text" value="${bfDay}" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /> --%>
                                        <input id="listTrialStartDt" name="trialStartDt" type="text" value="" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" />
                                </p>
                                <span>To</span>
                                <p>
                             <%--        <input id="listOrdEndDt" name="ordEndDt" type="text" value="${toDay}" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" /> --%>
                                    <input id="listTrialEndDt" name="trialEndDt" type="text" value="" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" />
                                </p>
                            </div>
                            <!-- date_set end -->
                        </td>
                    </tr>
                    <tr>
                        <th scope="row"><spring:message code='sales.trialRenStus' /></th>
                        <td>
                             <select id="listOrdStusId" name="ordStusId" class="multy_select w100p" multiple="multiple">
                                 <option value="1">Active</option>
                                 <option value="4">Completed</option>
                                 <option value="10">Cancelled</option>
                             </select>
                        </td>
                        <th scope="row"><spring:message code='sales.keyInBranch' /></th>
                        <td><select id="listKeyinBrnchId" name="keyinBrnchId" class="multy_select w100p" multiple="multiple"></select></td>
                        <th scope="row">DT Branch</th>
                        <td><select id="listDscBrnchId" name="dscBrnchId" class="multy_select w100p" multiple="multiple"></select></td>
                    </tr>
                    <tr>
                        <th scope="row"><spring:message code='sales.custId2' /></th>
                        <td><input id="listCustId" name="custId" type="text" title="<spring:message code='sales.custId2'/>" placeholder="Customer ID (Number Only)" class="w100p" /></td>
                        <th scope="row"><spring:message code='sales.cusName' /></th>
                        <td><input id="listCustName" name="custName" type="text" title="Customer Name" placeholder="<spring:message code='sales.cusName'/>" class="w100p" /></td>
                        <th scope="row"><spring:message code='sales.NRIC2' /></th>
                        <td><input id="listCustIc" name="custIc" type="text" title="NRIC/Company No" placeholder="<spring:message code='sales.NRIC2'/>" class="w100p" />
                        </td>
                    </tr>
                    <tr>
                        <th scope="row"><spring:message code='sales.prod' /></th>
                        <td><select id="listProductId" name="productId" class="w100p"></select></td>
                        <th scope="row"><spring:message code='sales.salesman' /></th>
                        <td><input id="listSalesmanCode" name="salesmanCode" type="text" title="Salesman" placeholder="<spring:message code='sales.salesman'/>" class="w100p" /></td>
                       <th scope="row"><spring:message code='sales.promoCd' /></th>
                        <td><input id="listPromoCode" name="promoCode" type="text" title="Promotion Code" placeholder="<spring:message code='sales.promoCd'/>" class="w100p" /></td>
                    </tr>
                    <tr>
                        <th scope="row">Org Code</th>
                        <td><input type="text" title="orgCode" id="orgCode" name="orgCode" onkeyup="this.value = this.value.toUpperCase();" placeholder="Org Code" class="w100p" /></td>
                        <th scope="row">Grp Code</th>
                        <td><input type="text" title="grpCode" id="grpCode" name="grpCode"  onkeyup="this.value = this.value.toUpperCase();" placeholder="Grp Code" class="w100p" /></td>
                        <th scope="row">Dept Code</th>
                        <td><input type="text" title="deptCode" id="deptCode" name="deptCode"  onkeyup="this.value = this.value.toUpperCase();" placeholder="Dept Code" class="w100p" /></td>
                    </tr>
                </tbody>
            </table>
            <!-- table end -->
        </form>

        <aside class="link_btns_wrap">
            <!-- link_btns_wrap start -->
            <p class="show_btn">
                <a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a>
            </p>
            <dl class="link_list">
                <dt>Link</dt>
                <dd>
                    <ul class="btns">
                    </ul>
                    <p class="hide_btn">
                        <a href="#"><img
                            src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif"
                            alt="hide" /></a>
                    </p>
                </dd>
            </dl>
        </aside>
        <!-- link_btns_wrap end -->

    </section>
    <!-- search_table end -->
<ul class="right_btns">
    <li><p class="btn_grid"><a href="javascript:void(0);" onclick="fn_excelDown()">Generate</a></p></li>
</ul>
    <section class="search_result">
        <!-- search_result start -->

        <article class="grid_wrap">
            <!-- grid_wrap start -->
            <div id="list_grid_wrap"
                style="width: 100%; height: 480px; margin: 0 auto;"></div>
        </article>
        <!-- grid_wrap end -->

    </section>
    <!-- search_result end -->

</section>
<!-- content end -->

<!-- Auto Debit Matrix Form -->
<form id="_frmAutoDebit" name="_frmAutoDebit" action="#" method="post">
    <input id="ordId" name="ordId" type="hidden" value="" />
</form>
