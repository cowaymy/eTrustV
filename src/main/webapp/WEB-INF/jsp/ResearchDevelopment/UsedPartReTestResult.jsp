<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script>
    document.write('<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/homecare-js-1.0.js?v='
                    + new Date().getTime() + '"><\/script>');
</script>
<script type="text/javaScript">
    var option = {
        width : "1200px",
        height : "500px"
    };

    var emptyData = [];
    var myGridID;
    var gridPros = {
        usePaging : true,
        pageRowCount : 20,
        editable : true,
        fixedColumnCount : 1,
        showStateColumn : true,
        displayTreeOpen : true,
        selectionMode : "singleRow",
        headerHeight : 30,
        useGroupingPanel : true,
        skipReadonlyColumns : true,
        wrapSelectionMove : true,
        showRowNumColumn : false,
    };

    $(document).ready(
        function() {
            asManagementGrid();
            doGetCombo('/services/holiday/selectBranchWithNM', 43, '', 'cmbbranchId', 'S', ''); // DSC BRANCH
            /* doGetCombo('/services/holiday/selectBranchWithNM', 43, '','cmbbranchId', 'M', 'f_multiCombo'); // DSC BRANCH */
            CommonCombo.make('cmbCategory', '/common/selectCodeList.do', {groupCode : 11,codeIn : 'WP,AP,BT,SOF,POE'}, '', '');


            //doGetCombo('/services/holiday/selectBranchWithNM', 43, '', 'spareFilterName', 'S', '');

         // FILTER NAME & SPARE PART NAME
         //   doDefCombo(emptyData, '', 'asProduct', 'S', '');

            $("#asProduct").change(
                    function() {
                      $("#spareFilterName").find('option').each(
                        function() {
                          $(this).remove();
                        });

                        if ($(this).val().trim() == "") {
                         doDefCombo(emptyData, '', 'spareFilterName', 'S', '');
                         return;
                        }

                        doGetCombo('/ResearchDevelopment/getSpareFilterName.do', $(this).val(), '', 'spareFilterName', 'S', '');
                    });

        });

    function asManagementGrid() {
        var columnLayout = [
                {
                    dataField : "salesOrdNo",
                    headerText : "<spring:message code='pay.head.salesOrderNo'/>",
                    editable : false,
                    width : 100
                },
                {
                    dataField : "productCategory",
                    headerText : "<spring:message code='sal.title.text.productCategory'/>",
                    width : 100
                },
                {
                    dataField : "stkCode",
                    headerText : "<spring:message code='service.title.ProductCode'/>",
                    width : 100
                },
                {
                    dataField : "stkDesc",
                    headerText : "<spring:message code='service.title.ProductName'/>",
                    editable : false,
                    width : 100
                },
                {
                    dataField : "testStus",
                    headerText : "Status",
                    editable : false,
                    width : 100
                },
                {
                    dataField : "lastInstallSerialNo",
                    headerText : "<spring:message code='sales.SeriacNo'/>",
                    editable : false,
                    width : 80
                },
                {
                    dataField : "asSetlDt",
                    headerText : "<spring:message code='sal.title.settleDate'/>",
                    editable : false,
                    width : 100,
                    dataType : "date",
                    formatString : "dd/mm/yyyy"
                },
                {
                    dataField : "asAging",
                    headerText : "AS Aging",
                    editable : false,
                    width : 100
                },
                {
                    dataField : "lastInstallCtCode",
                    headerText : "<spring:message code='service.grid.CTCode'/>",
                    width : 100
                },
                {
                    dataField : "dscCode",
                    headerText : "<spring:message code='log.head.branchcode'/>",
                    editable : false,
                    width : 100
                },
                {
                    dataField : "solutionLarge",
                    headerText : "<spring:message code='service.text.defTyp'/>",
                    editable : false,
                    width : 200
                },
                {
                    dataField : "solutionSmall",
                    headerText : "<spring:message code='service.text.sltCde'/>",
                    editable : false,
                    width : 200
                },
                {
                    dataField : "problemSymptomLarge",
                    headerText : "<spring:message code='service.text.dtlDef'/>",
                    editable : false,
                    width : 200
                },
                {
                    dataField : "problemSymptomSmall",
                    headerText : "<spring:message code='service.text.defCde'/>",
                    editable : false,
                    width : 200
                },
                {
                    dataField : "defectPart",
                    headerText : "<spring:message code='service.text.defPrt'/>",
                    editable : false,
                    width : 200
                },
                {
                    dataField : "asErrorCode",
                    headerText : "<spring:message code='service.grid.ErrCde'/>",
                    editable : false,
                    width : 100
                },
                {
                    dataField : "asDescription",
                    headerText : "<spring:message code='service.grid.ErrDesc'/>",
                    width : 200
                },
                {
                    dataField : "asNo",
                    headerText : "<spring:message code='service.grid.ASNo'/>",
                    width : 100
                },
                {
                    dataField : "asResultNo",
                    headerText : "<spring:message code='service.grid.ASRNo'/>",
                    editable : false,
                    width : 100
                },
                {
                	dataField : "custName",
                    headerText : "<spring:message code='log.head.customername'/>",
                    editable : false,
                    width : 100
                },
                {
                	dataField : "testResultNo",
                    headerText : "Test Result No.",
                    editable : false,
                    width : 100
                },
                {
                    dataField : "testResultRemark",
                    headerText : "Test Result Remark",
                    width : 200,
                    visible : true
                },

                {
                    dataField : "testUpGne",
                    headerText : "Genuinity",
                    width : 80,
                    visible : true
                },

                {
                    dataField : "testUpSetlDt",
                    headerText : "Test Settle Date",
                    width : 100,
                    visible : true
                },
                {
                    dataField : "asrItmPartId",
                    headerText : "<spring:message code='log.head.materialcode'/>",
                    width : 100,
                    visible : true
                },
                {
                    dataField : "asrItmPartDesc",
                    headerText : "<spring:message code='log.head.materialname'/>",
                    width : 100,
                    visible : true
                }, {
                    dataField : "lpm",
                    headerText : "LPM",
                    width : 100,
                    visible : true
                }, {
                    dataField : "psi",
                    headerText : "PSI",
                    width : 100,
                    visible : true
                }, {
                    dataField : "instState",
                    headerText : "<spring:message code='sal.title.state'/>",
                    width : 100,
                    visible : true
                }, {
                    dataField : "instCity",
                    headerText : "<spring:message code='sal.text.city'/>",
                    width : 100,
                    visible : true
                }, {
                    dataField : "instArea",
                    headerText : "<spring:message code='service.title.Area'/>",
                    width : 100,
                    visible : true
                }, {
                    dataField : "testYn",
                    headerText : "Testable",
                    width : 100,
                    visible : true
                }, {
                    dataField : "rcdTms",
                    headerText : "",
                    width : 100,
                    visible : false
                } ];

        var gridPros = {
            showRowCheckColumn : true,
            usePaging : true,
            pageRowCount : 20,
            showRowAllCheckBox : true,
            editable : false,
            selectionMode : "multipleCells"
        };

        myGridID = AUIGrid.create("#grid_wrap_asList", columnLayout, gridPros);
    }

    function fn_searchUsedPart() { // SEARCH AS

        var valid = true;
        var msg = "";
/*
        console.log($("#asNum").val()); */

        if ($("#asNum").val() == '' && $("#resultNum").val() == ''
                && $("#orderNum").val() == '') {
            if (startDate == '' && endDate == '') {
                msg = "Request Date is required when AS No.,  Result No. and Order No. are empty.";
                valid = false;
            } else if (startDate != '' && endDate == '') {
                msg = "Request End Date is required.";
                valid = false;
            } else if (startDate == '' && endDate != '') {
                msg = "Request Start Date is required.";
                valid = false;
            } else if (startDate != '' && endDate != '') {
                console.log("here");
                if (!js.date.checkDateRange(startDate, endDate, "Request", "3"))
                    valid = false;
            }
        }

        if (valid) {
            Common.ajax("GET", "/ResearchDevelopment/selectUsedPartReturnList.do", $(
                    "#ASForm").serialize(), function(result) {
                AUIGrid.setGridData(myGridID, result);
            });
        } else {
            Common.alert(msg);
        }
    }

    function fn_viewASResultPop() { // VIEW RESULT
        var selectedItems = AUIGrid.getCheckedRowItems(myGridID);

        if (selectedItems.length <= 0) {
            Common.alert("<spring:message code='service.msg.NoRcd'/>");
            return;
        }

        if (selectedItems.length > 1) {
            Common.alert("<spring:message code='service.msg.onlyPlz'/>");
            return;
        }

        var AS_ID = selectedItems[0].item.asId;
        var AS_NO = selectedItems[0].item.asNo;
        var asStusId = selectedItems[0].item.code1;
        var ordno = selectedItems[0].item.salesOrdNo;
        var ordId = selectedItems[0].item.asSoId;

        if (asStusId != "ACT") {
            Common
                    .alert("AS Info Edit Restrict</br>"
                            + DEFAULT_DELIMITER
                            + "<b>["
                            + AS_NO
                            + "]  is not in active status.</br> AS information edit is disallowed.</b>");
            return;
        }

        Common.popupDiv(
                "/services/as/resultASReceiveEntryPop.do?mod=VIEW&salesOrderId="
                        + ordId + "&ordNo=" + ordno + "&AS_NO=" + AS_NO
                        + '&AS_ID=' + AS_ID, null, null, true,
                '_viewEntryPopDiv1');
    }

    function fn_newASResultPop() {
        var selectedItems = AUIGrid.getCheckedRowItems(myGridID);

        if (selectedItems.length <= 0) {
          Common.alert("<spring:message code='service.msg.NoRcd'/>");
          return;
        }

        if (selectedItems.length > 1) {
          Common.alert("<spring:message code='service.msg.onlyPlz'/>");
          return;
        }

        var asId = selectedItems[0].item.asId;
        var asNo = selectedItems[0].item.asNo;
        var asStusId = selectedItems[0].item.code1;
        var salesOrdNo = selectedItems[0].item.salesOrdNo;
        var salesOrdId = selectedItems[0].item.salesOrdId;
        //var refReqst = selectedItems[0].item.refReqst;
        var rcdTms = selectedItems[0].item.rcdTms;
        //var asRst = selectedItems[0].item.c3;

        var dscCode = selectedItems[0].item.dscCode;
        var ctCode = selectedItems[0].item.lastInstallCtCode;
        var stkCode = selectedItems[0].item.stkCode;

        console.log ("asId :"+ asId );
        console.log ("asNo :"+ asNo );
        console.log ("asStusId :"+ asStusId );
        console.log ("salesOrdNo :"+ salesOrdNo );
        console.log ("salesOrdId :"+ salesOrdId );
        console.log ("rcdTms :"+ rcdTms );
        console.log ("dscCode :"+ dscCode );
        console.log ("ctCode :"+ ctCode );
        console.log ("stkCode :"+ stkCode );




        //if (asRst != '-') {
          //Common.alert("<spring:message code='service.msg.asAddHvRst' arguments='<b>" + asNo + "</b>' htmlEscape='false' argumentSeparator=';' />");
          //return;
        //}

        /*  if (asStusId != "ACT") {
          Common.alert("<spring:message code='service.msg.asAddHvRst' arguments='<b>" + asNo + "</b>' htmlEscape='false' argumentSeparator=';' />");
          return;
        } */

      /*    Common.ajax("POST", "/services/as/selRcdTms.do", {
            asNo : asNo,
            asId : asId,
            salesOrdNo : salesOrdNo,
            salesOrderId : salesOrdId,
            rcdTms : rcdTms
        }, function(result) {
           if (result.code == "99") {
            Common.alert(result.message);
            return;
          } else { */
     //       var param = "?ord_Id=" + salesOrdId + "&ord_No=" + salesOrdNo + "&as_No=" + asNo + "&as_Id=" + asId + /* "&refReqst=" + refReqst +  "&as_Rst=" + asRst +*/ "&rcdTms=" + rcdTms;
     //       Common.popupDiv("/ResearchDevelopment/UsedPartReTestResultNewResultPop.do" + param, null, null, true, '_newASResultDiv1');
     //     }
     //   });

        var param = "?ord_Id=" + salesOrdId + "&ord_No=" + salesOrdNo + "&as_No=" + asNo + "&as_Id=" + asId  + "&dsc_Code=" + dscCode + "&ct_Code=" + ctCode + "&stk_Code=" + stkCode /* "&refReqst=" + refReqst +  "&as_Rst=" + asRst + "&rcdTms=" + rcdTms */;
        Common.popupDiv("/ResearchDevelopment/UsedPartReTestResultNewResultPop.do" + param, null, null, true, '_newASResultDiv1');
      }

    function fn_TestResultViewPop() {
        var selectedItems = AUIGrid.getCheckedRowItems(myGridID);

        if (selectedItems.length <= 0) {
            Common.alert("<spring:message code='service.msg.NoRcd'/>");
            return;
        }

        if (selectedItems.length > 1) {
            Common.alert("<spring:message code='service.msg.onlyPlz'/>");
            return;
        }

        var asid = selectedItems[0].item.asId;
        var asNo = selectedItems[0].item.asNo;
        var asStusId = selectedItems[0].item.code1;
        var salesOrdNo = selectedItems[0].item.salesOrdNo;
        var salesOrdId = selectedItems[0].item.salesOrdId;
        var asResultNo = selectedItems[0].item.asResultNo;
        var asResultNo2 = selectedItems[0].item.productCategory;
        var dscCode = selectedItems[0].item.dscCode;


        console.log ("asid : " + asid);
        console.log ("asNo : " + asNo);
        console.log ("asStusId : " + asStusId);
        console.log ("salesOrdNo : " + salesOrdNo);
        console.log ("salesOrdId : " + salesOrdId);
        console.log ("asResultNo : " + asResultNo);
        console.log ("productCategory : " + asResultNo2);
        console.log ("dscCode : " + dscCode);


        if (asStusId == "ACT") {
            Common.alert("<spring:message code='service.msg.asEdtNoRst' arguments='<b>"
                            + asNo + "</b>' htmlEscape='false' argumentSeparator=';' />");
            return;
        }

        if (asResultNo == "") {
            Common.alert("<spring:message code='service.msg.asEdtNoRst' arguments='<b>"
                            + asNo + "</b>' htmlEscape='false' argumentSeparator=';' />");
            return;
        }

        var param = "?ord_Id=" + salesOrdId + "&ord_No=" + salesOrdNo + "&as_No=" + asNo + "&as_Id=" + asid
                + "&mod=RESULTVIEW&as_Result_No=" + asResultNo  + "&dsc_Code=" + dscCode      ;

        Common.popupDiv("/ResearchDevelopment/UsedPartReTestResultEditViewPop.do" + param, null, null, true, '_newASResultDiv1');
    }

    function fn_asResultEditPop(ind) {
        var selectedItems = AUIGrid.getCheckedRowItems(myGridID);

        if (selectedItems.length <= 0) {
            Common.alert("<spring:message code='service.msg.NoRcd'/>");
            return;
        }

        if (selectedItems.length > 1) {
            Common.alert("<spring:message code='service.msg.onlyPlz'/>");
            return;
        }

        var asId = selectedItems[0].item.asId;
        var asNo = selectedItems[0].item.asNo;
        var asStusId = selectedItems[0].item.code1;
        var salesOrdNo = selectedItems[0].item.salesOrdNo;
        var salesOrdId = selectedItems[0].item.asSoId;
        var asResultNo = selectedItems[0].item.c3;
        var asResultId = selectedItems[0].item.asResultId;
        var rcdTms = selectedItems[0].item.rcdTms;
        var updDt = selectedItems[0].item.asSetlDt;
        var lstUpdDt = selectedItems[0].item.asResultCrtDt;

        if (asResultNo == "-") {
            Common.alert("<spring:message code='service.msg.asEdtNoRst' arguments='<b>"
                            + asNo + "</b>' htmlEscape='false' argumentSeparator=';' />");
            return;
        }

        if (ind == 0) {
            if (asStusId != "RCL") {
                if (updDt != "" && updDt != null) {
                    var stat = true;
                    var sDate = new Date(updDt);
                    var tDate = new Date();
                    tDate.setDate(tDate.getDate() - 7);

                    var tMth = tDate.getMonth();
                    var tYear = tDate.getFullYear();
                    var tDay = tDate.getDate();
                    var sMth = sDate.getMonth();
                    var sYear = sDate.getFullYear();
                    var sDay = sDate.getDate();

                    if (sYear > tYear) {
                        stat = true;
                    } else {
                        if (sMth > tMth) {
                            stat = true;
                        } else {
                            if (sDay > tDay) {
                                stat = true;
                            } else {
                                stat = false;
                            }
                        }
                    }

                    if (!stat) {
                        Common.alert("<b><spring:message code='service.alert.msg.AsEditPrdChk'/></b>");
                        return;
                    }
                } else if (lstUpdDt != "" && lstUpdDt != null) {
                    var stat = true;
                    var sDate = new Date(lstUpdDt);
                    var tDate = new Date();
                    tDate.setDate(tDate.getDate() - 7);

                    var tMth = tDate.getMonth();
                    var tYear = tDate.getFullYear();
                    var tDay = tDate.getDate();
                    var sMth = sDate.getMonth();
                    var sYear = sDate.getFullYear();
                    var sDay = sDate.getDate();

                    if (sYear > tYear) {
                        stat = true;
                    } else {
                        if (sMth > tMth) {
                            stat = true;
                        } else {
                            if (sDay > tDay) {
                                stat = true;
                            } else {
                                stat = false;
                            }
                        }
                    }

                    if (!stat) {
                        Common.alert("<b><spring:message code='service.alert.msg.AsEditPrdChk2'/></b>");
                        return;
                    }
                }
            }
        }

        if (asResultNo == "") {
            Common.alert("<spring:message code='service.msg.asEdtNoRst' arguments='<b>" + asNo + "</b>' htmlEscape='false' argumentSeparator=';' />");
            return;
        }

        Common.ajax("POST", "/services/as/selRcdTms.do", {
            asNo : asNo,
            asId : asId,
            salesOrdNo : salesOrdNo,
            salesOrderId : salesOrdId,
            rcdTms : rcdTms
        }, function(result) {
            if (result.code == "99") {
                Common.alert(result.message);
                return;
            } else {
                var param = "?ord_Id=" + salesOrdId + "&ord_No=" + salesOrdNo + "&as_No=" + asNo + "&as_Id=" + asId
                    + "&mod=RESULTEDIT&as_Result_No=" + asResultNo + "&as_Result_Id=" + asResultId;

                Common.popupDiv("/services/as/asResultEditViewPop.do" + param, null, null, true, '_newASResultDiv1');
            }
        });
    }

    function fn_excelDown() {
        // type : "xlsx", "csv", "txt", "xml", "json", "pdf", "object"
        GridCommon.exportTo("grid_wrap_asList", "xlsx", "AS Management");
    }

    function f_multiCombo() {
        $(function() {
            $('#cmbbranchId').change(function() {

            }).multipleSelect({
                selectAll : true, // 전체선택
                width : '80%'
            });
        });
    }
</script>
<section id="content">
    <!-- content start -->
    <ul class="path">
        <!-- <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
  <li>Sales</li>
  <li>Order list</li> -->
    </ul>
    <aside class="title_line">
        <!-- title_line start -->
        <p class="fav">
            <a href="#" class="click_add_on">My menu</a>
        </p>
        <h2>Used Part Return Test Result</h2>
        <ul class="right_btns">
            <%-- <c:if test="${PAGE_AUTH.funcUserDefine4 == 'Y'}"> --%>
                <li><p class="btn_blue">
                        <a href="#" onclick="fn_newASResultPop()"><spring:message
                                code='service.btn.addtAs' /></a>
                    </p></li>
            <%-- </c:if> --%>
            <!-- FUNCTION WHICH ALLOW EDIT RECORD WHICH MORE THAN 7 DAYS -->
            <c:if test="${PAGE_AUTH.funcUserDefine5 == 'Y'}">
                <li><p class="btn_blue">
                        <a href="#" onclick="fn_asResultEditBasicPop(0)"><spring:message
                                code='service.btn.edtBsAs' /></a>
                    </p></li>
            </c:if>
            <c:if test="${PAGE_AUTH.funcUserDefine9 == 'Y'}">
                <li><p class="btn_blue">
                        <a href="#" onclick="fn_asResultEditPop(0)"><spring:message
                                code='service.btn.edtAs' /></a>
                    </p></li>
            </c:if>
            <%-- <c:if test="${PAGE_AUTH.funcUserDefine3 == 'Y'}"> --%>
                <li><p class="btn_blue">
                        <a href="#" onclick="fn_asResultEditPop(1)"><spring:message
                                code='service.btn.edtAs' /></a>
                    </p></li>
            <%-- </c:if>  --%>
            <%-- <c:if test="${PAGE_AUTH.funcUserDefine6 == 'Y'}"> --%>
                <li><p class="btn_blue">
                        <a href="#" onclick="fn_TestResultViewPop()"><spring:message
                                code='service.btn.viewAS' /></a>
                    </p></li>
            <%-- </c:if> --%>
            <%-- <c:if test="${PAGE_AUTH.funcView == 'Y'}"> --%>
                <li><p class="btn_blue">
                        <a href="#" onClick="fn_searchUsedPart()">
                        <span class="search"></span> <spring:message code='sys.btn.search' /></a>
                    </p></li>
            <%-- </c:if> --%>
            <li><p class="btn_blue">
                    <a href="#"><span class="clear"></span> <spring:message
                            code='service.btn.Clear' /></a>
                </p></li>
        </ul>
    </aside>
    <!-- title_line end -->
    <section class="search_table">
        <!-- search_table start -->
        <form action="#" method="post" id="ASForm">
            <table class="type1">
                <!-- table start -->
                <caption>table</caption>
                <colgroup>
                    <col style="width: 150px" />
                    <col style="width: *" />
                    <col style="width: 140px" />
                    <col style="width: *" />
                    <col style="width: 170px" />
                    <col style="width: *" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row"><spring:message code='service.title.OrderNumber' /></th>
                        <td><input type="text" title="" placeholder="<spring:message code='service.title.OrderNumber'/>" class="w100p" id="orderNum" name="orderNum" /></td>

                        <th scope="row">DSC Code</th>
                        <!-- <td><select class="multy_select w100p" multiple="multiple" id="cmbbranchId" name="cmbbranchId"></select></td> -->
                        <td><select id="cmbbranchId" name="cmbbranchId" class="w100p"></select></td>
                        <!-- <td><input type="text" title="" placeholder="DSC Code" class="w100p" id="dscCode" name="dscCode" /></td> -->

                        <th scope="row"><spring:message code='service.title.Status' /></th>
                        <td><select id="trStatus" name="trStatus" class="w100p">
                                <option value="">--SELECT--</option>
                                <option value="1">Active</option>
                                <option value="4">Complete</option>
                        </select></td>
                    </tr>

                    <tr>
                        <th scope="row">Product Category</th>
                        <td><select class="w100p" id="cmbCategory" name="cmbCategory" ></select></td>

                        <th scope="row"><spring:message code='sal.text.productName' /></th>
                        <td><select class="w100p" id="asProduct" name="asProduct">
                                <option value="">--SELECT--</option>
                                <c:forEach var="list" items="${asProduct}" varStatus="status">
                                    <option value="${list.stkId}">${list.stkDesc}</option>
                                </c:forEach>
                           </select></td>

                        <th scope="row">Spare Part/Filter Name</th>

                        <td><select id="spareFilterName" name="spareFilterName" class="w100p"></select></td>
                        <!-- <td><input type="text" title=""placeholder="Spare Part/Filter Name" class="w100p" id="spareFilterName" name="spareFilterName" /></td> -->


                    </tr>

                    <tr>
                        <th scope="row">Genuinity</th>
                        <td><select id="Genuinity" name="Genuinity"
                            class="w100p">
                                <option value="">--SELECT--</option>
                                <option value="Genuine">Genuine</option>
                                <option value="Non-Genuine">Non-Genuine</option>
                        </select></td>

                        <th scope="row"><spring:message code='sal.text.type' /></th>
                        <td><select id="Type" name="Type"
                            class="w100p">
                                <option value="">--SELECT--</option>
                                <option value="62">Filter</option>
                                <option value="63">Spare Parts</option>
                                <option value="64">Miscellaneous</option>
                        </select></td>

                        <th scope="row">Test Result Number</th>
                        <td><input type="text" title="" placeholder="Test Result Number" class="w100p" id="TestResultNo" name="TestResultNo" /></td>

                    </tr>
                </tbody>
            </table>
            <!-- table end -->
            <ul class="right_btns">
                <%-- <c:if test="${PAGE_AUTH.funcUserDefine10 == 'Y'}"> --%>
                    <li><p class="btn_grid">
                            <a href="#" onClick="fn_excelDown()"><spring:message code='service.btn.Generate' /></a></p></li>
                <%-- </c:if> --%>
            </ul>
            <article class="grid_wrap">
                <!-- grid_wrap start -->
                <div id="grid_wrap_asList"
                    style="width: 100%; height: 500px; margin: 0 auto;"></div>
            </article>
            <!-- grid_wrap end -->
        </form>
        <form action="#" id="reportForm" method="post">
            <!--  <input type="hidden" id="V_RESULTID" name="V_RESULTID" /> -->
            <input type="hidden" id="v_serviceNo" name="v_serviceNo" /> <input
                type="hidden" id="v_invoiceType" name="v_invoiceType" /> <input
                type="hidden" id="reportFileName" name="reportFileName" /> <input
                type="hidden" id="viewType" name="viewType" /> <input type="hidden"
                id="reportDownFileName" name="reportDownFileName"
                value="DOWN_FILE_NAME" />
        </form>
        <form id='reportFormASLst' method="post" name='reportFormASLst'
            action="#">
            <input type='hidden' id='reportFileName' name='reportFileName' /> <input
                type='hidden' id='viewType' name='viewType' /> <input type='hidden'
                id='reportDownFileName' name='reportDownFileName' /> <input
                type='hidden' id='V_TEMP' name='V_TEMP' />
        </form>
    </section>
    <!-- search_table end -->
</section>
<!-- content end -->
